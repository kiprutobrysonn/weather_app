import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/core/routes.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/forecast_widget.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_icon.dart';
import 'package:weather_app/src/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _navigator = locator<INavigationService>();
  final _setingsCOntroller = locator<SettingsController>();

  @override
  void initState() {
    // TODO: implement initState
    context.read<HomeBloc>().add(HomeInitEvent());

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(bool isDay) {
    return isDay ? const Color(0xFF4A90E2) : const Color(0xFF1A237E);
  }

  Color _getTextColor(bool isDay) {
    return isDay ? Colors.black87 : Colors.white;
  }

  String _getTemperatureUnit(String tempUnit) {
    if (tempUnit.toLowerCase() == 'fahrenheit') {
      return 'F';
    } else if (tempUnit.toLowerCase() == 'kelvin') {
      return 'K';
    }

    return 'C';
  }

  String _getPrecipitationUnit(String precipUnit) {
    if (precipUnit.toLowerCase() == 'inch') {
      return 'inch';
    } else if (precipUnit.toLowerCase() == 'cm') {
      return 'cm';
    }

    return 'Millimeter';
  }

  String _getWindSpeedUnit(String windSpeedUnit) {
    if (windSpeedUnit.toLowerCase() == 'ms') {
      return 'm/s';
    } else if (windSpeedUnit.toLowerCase() == 'km/h') {
      return 'km/h';
    }

    return 'knots';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            // Save current location button
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "saveLocation",
                  onPressed: () {
                    final location = SavedLocation(
                      latitude: state.position.latitude,
                      longitude: state.position.longitude,
                      name: state.weatherData['name'] ?? "",
                      country: state.weatherData['country'] ?? "",
                    );

                    context.read<HomeBloc>().add(SaveLocationEvent(location));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location saved'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.save), Text('Add')],
                  ),
                  backgroundColor: Colors.amber,
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: "showSavedLocations",
                  onPressed: () {
                    context.read<HomeBloc>().add(ShowSavedLocationsEvent());
                  },
                  child: const Icon(Icons.list),
                ),
              ],
            );
          }

          return FloatingActionButton(
            onPressed: () {
              context.read<HomeBloc>().add(ShowSavedLocationsEvent());
            },
            child: const Icon(Icons.list),
          );
        },
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final isDay =
                  state is HomeLoaded
                      ? state.weatherData['is_day'] ?? false
                      : true;

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getBackgroundColor(isDay),
                      _getBackgroundColor(isDay).withOpacity(0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(isDay),
                      _buildCurrentWeatherSection(),
                      _buildWeatherDetails(state, isDay),
                      _buildForecastSection(state, isDay),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(bool isDay) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.search, color: _getTextColor(isDay)),
          onPressed: () {
            context.read<HomeBloc>().add(ShowSearchSheetEvent());
          },
        ),
        Expanded(
          child: Text(
            "Weather App",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getTextColor(isDay),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings, color: _getTextColor(isDay)),
          onPressed: () {
            _navigateToSettings();
          },
        ),
      ],
    );
  }

  void _navigateToSettings() async {
    // final results = await _navigator.navigateToNamed(SettingsPage.routeName);
    // if (results == true) {
    //   context.read<HomeBloc>().add(HomeInitEvent());
    // }
    // print("Results: $results");
  }

  Widget _buildCurrentWeatherSection() {
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
          return Center(child: _buildErrorWidget(state.message));
        } else if (state is HomeLoaded) {
          return _buildCurrentWeather(
            state.weatherData,
            state.locationDetails,
            state.weatherData['is_day'],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error loading weather data',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<HomeBloc>().add(HomeInitEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(
    Map<String, dynamic> weatherData,
    SavedLocation? loc,
    bool isDay,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc?.name ?? "Current Location",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(isDay),
                    ),
                  ),
                  Text(
                    weatherData['time'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getTextColor(isDay).withOpacity(0.8),
                    ),
                  ),
                  Text(
                    weatherData['is_day'] ? 'Day time' : 'Night time',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getTextColor(isDay).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              WeatherIcon(
                isDay: isDay,
                weatherCode: weatherData["weathercode"],
                size: 64,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${weatherData['temperature_2m']}° ${_getTemperatureUnit(_setingsCOntroller.temperatureUnit)}',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: _getTextColor(isDay),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(HomeState state, bool isDay) {
    if (state is! HomeLoaded) {
      return const SizedBox.shrink();
    }

    final weatherData = state.weatherData;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getTextColor(isDay),
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.water_drop,
            'Rainfall',
            '${weatherData['precipitation']} ${_getPrecipitationUnit(_setingsCOntroller.precipitationUnit)}',
            isDay,
          ),
          _buildDetailRow(
            Icons.wb_sunny,
            'UV Index',
            weatherData['uv_index'].toString(),
            isDay,
          ),
          _buildDetailRow(
            Icons.grass,
            'Pollen Count',
            weatherData['time'],
            isDay,
          ),
          _buildDetailRow(
            Icons.air,
            'Wind Speed',
            '${weatherData['windspeed_10m'] ?? "N/A"} ${_getWindSpeedUnit(_setingsCOntroller.windSpeedUnit)}',
            isDay,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDay,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: _getTextColor(isDay)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: _getTextColor(isDay).withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: _getTextColor(isDay),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection(HomeState state, bool isDay) {
    if (state is HomeLoaded && state.forecast != null) {
      return Expanded(
        child: ForecastWidget(forecast: state.forecast!, isDay: isDay),
      );
    } else if (state is ForecastLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(color: _getTextColor(isDay)),
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
                Icon(Icons.cloud_off, color: _getTextColor(isDay), size: 48),
                const SizedBox(height: 16),
                Text(
                  'Could not load forecast',
                  style: TextStyle(color: _getTextColor(isDay)),
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
