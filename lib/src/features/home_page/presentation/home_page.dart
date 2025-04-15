import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/cubit/location_search_cubit.dart';
import 'package:weather_app/src/features/home_page/presentation/cubit/saved_locations_cubit.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/current_weather_widget.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/forecast_widget.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/saved_locations.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/search_sheet.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_details_widget.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_error_widget.dart';
import 'package:weather_app/src/features/home_page/utils/weather_utils.dart';
import 'package:weather_app/src/services/dialog_and_sheet_service.dart';
import 'package:weather_app/src/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _navigator = locator<INavigationService>();
  final _sheetService = locator<IDialogAndSheetService>();
  final _settingsController = locator<SettingsController>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SavedLocationsCubit())],
      child: Scaffold(
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "saveLocation",
                    onPressed: () {
                      if (state.locationDetails == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No location to save'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final savedLocationsCubit =
                          context.read<SavedLocationsCubit>();

                      if (state.locationDetails?.isSaved ?? false) {
                        savedLocationsCubit.deleteLocation(
                          state.locationDetails!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location removed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final location = SavedLocation(
                        latitude: state.position.latitude,
                        longitude: state.position.longitude,
                        name: state.weatherData['name'] ?? "",
                        country: state.weatherData['country'] ?? "",
                      );
                      savedLocationsCubit.saveLocation(location);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Location saved'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    backgroundColor: Colors.amber,
                    child:
                        state.locationDetails?.isSaved ?? false
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.delete),
                                Text('Remove'),
                              ],
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Icon(Icons.save), Text('Add')],
                            ),
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton(
                    heroTag: "showSavedLocations",
                    onPressed: () {
                      _showSavedLocations(context);
                    },
                    child: const Icon(Icons.list),
                  ),
                ],
              );
            }

            return FloatingActionButton(
              onPressed: () {
                _showSavedLocations(context);
              },
              child: const Icon(Icons.list),
            );
          },
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                final isDay =
                    state is HomeLoaded
                        ? state.weatherData['is_day'] ?? false
                        : true;

                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        WeatherUtils.getBackgroundColor(isDay),
                        WeatherUtils.getBackgroundColor(isDay).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: ListView(
                      children: [
                        _buildSearchBar(isDay),
                        _currentWeatherSection(),
                        _weatherDetails(state, isDay),
                        _foreCastSection(state, isDay),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showSearchSheet(BuildContext context) async {
    final LocationSearchCubit searchCubit = context.read<LocationSearchCubit>();
    final location = await _sheetService.showAppBottomSheet(
      BlocProvider.value(value: searchCubit, child: const SearchSheet()),
    );

    if (location != null && location is SavedLocation && mounted) {
      context.read<HomeBloc>().add(UpdateWeatherByLocationEvent(location));
    }
  }

  Future<void> _showSavedLocations(BuildContext context) async {
    final SavedLocationsCubit savedLocationsCubit =
        context.read<SavedLocationsCubit>();
    await savedLocationsCubit.loadSavedLocations();

    final location = await _sheetService.showAppBottomSheet(
      BlocProvider.value(
        value: savedLocationsCubit,
        child: const SavedLocationsSheet(),
      ),
    );

    if (location != null && location is SavedLocation && mounted) {
      context.read<HomeBloc>().add(UpdateWeatherByLocationEvent(location));
    }
  }

  Widget _buildSearchBar(bool isDay) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Weather App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: WeatherUtils.getTextColor(isDay),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search, color: WeatherUtils.getTextColor(isDay)),
          onPressed: () {
            _showSearchSheet(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: WeatherUtils.getTextColor(isDay)),
          onPressed: () {
            _navigateToSettings();
          },
        ),
      ],
    );
  }

  void _navigateToSettings() async {
    if (mounted) {
      final results = await _navigator.navigateToNamed(SettingsPage.routeName);
      if (results == true) {
        context.read<HomeBloc>().add(ReloadWeatherEvent());
      }
    }
  }

  Widget _currentWeatherSection() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (state is HomeError) {
          return WeatherErrorWidget(message: state.message, isDay: true);
        } else if (state is HomeLoaded) {
          return CurrentWeatherWidget(
            weatherData: state.weatherData,
            locationDetails: state.locationDetails,
            isDay: state.weatherData['is_day'],
            settingsController: _settingsController,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _weatherDetails(HomeState state, bool isDay) {
    if (state is! HomeLoaded) {
      return const SizedBox.shrink();
    }

    return WeatherDetailsWidget(
      weatherData: state.weatherData,
      isDay: isDay,
      settingsController: _settingsController,
    );
  }

  Widget _foreCastSection(HomeState state, bool isDay) {
    if (state is HomeLoaded && state.forecast != null) {
      return Expanded(
        child: ForecastWidget(forecast: state.forecast!, isDay: isDay),
      );
    } else if (state is ForecastLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: WeatherUtils.getTextColor(isDay),
          ),
        ),
      );
    } else if (state is ForecastError) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  color: WeatherUtils.getTextColor(isDay),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Could not load forecast',
                  style: TextStyle(color: WeatherUtils.getTextColor(isDay)),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(GetForecastEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
