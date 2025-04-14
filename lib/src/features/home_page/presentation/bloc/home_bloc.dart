import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/src/constants/hive_box_names.dart';
import 'package:weather_app/src/constants/hive_storage_keys.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/domain/params/current_weather_params.dart';
import 'package:weather_app/src/features/home_page/domain/params/get_location_params.dart';
import 'package:weather_app/src/features/home_page/domain/usecase/current_weather_usecase.dart';
import 'package:weather_app/src/features/home_page/domain/usecase/get_forecast_usecase.dart';
import 'package:weather_app/src/features/home_page/domain/usecase/get_location_usecase.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/save_locations.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/search_sheet.dart';
import 'package:weather_app/src/services/dialog_and_sheet_service.dart';
import 'package:weather_app/src/services/local_storage.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitEvent>(init);
    on<ShowSearchSheetEvent>(showSearchSheet);
    on<UpdateWeatherByLocationEvent>(updateWeatherByLocation);
    on<SearchLocationsEvent>(searchLocations);
    on<GetForecastEvent>(getForecast);
    on<SaveLocationEvent>(saveLocation);
    on<DeleteSavedLocationEvent>(deleteSavedLocation);
    on<ShowSavedLocationsEvent>(showSavedLocations);
    on<ReloadWeatherEvent>(reloadWeather);
  }

  final _sheetService = locator<IDialogAndSheetService>();
  final _storageService = locator<IlocalStorageService>();

  Future<SavedLocation> _performReverseGeocoding(
    double latitude,
    double longitude, {
    bool isSaved = false,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      String name = 'Unknown Location';
      if (placemarks.isNotEmpty) {
        name =
            placemarks[0].locality?.isNotEmpty == true
                ? placemarks[0].locality!
                : (placemarks[0].administrativeArea?.isNotEmpty == true
                    ? placemarks[0].administrativeArea ??
                        placemarks[0].name ??
                        placemarks[0].subLocality!
                    : 'Unknown Location');
      }

      return SavedLocation(
        latitude: latitude,
        longitude: longitude,
        name: name,
        country: placemarks.isNotEmpty ? placemarks[0].country : null,
        isSaved: isSaved,
      );
    } catch (e) {
      print('Error in reverse geocoding: ${e.toString()}');
      return SavedLocation(
        latitude: latitude,
        longitude: longitude,
        name: 'Unknown Location',
        country: null,
        isSaved: isSaved,
      );
    }
  }

  FutureOr<void> init(HomeInitEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final lastLocationData = await _storageService.read(
        boxName: HiveBoxNames.generalAppBox,
        key: HiveStorageKeys.keyLastViewedLocation,
      );

      if (lastLocationData != null) {
        final location = SavedLocation(
          latitude: lastLocationData['latitude'],
          longitude: lastLocationData['longitude'],
          name: lastLocationData['name'],
          country: lastLocationData['country'],
          isSaved: lastLocationData['isSaved'] ?? false,
        );

        add(UpdateWeatherByLocationEvent(location));
        return;
      }
    } catch (e) {
      print('Error loading last location: ${e.toString()}');
    }

    final position = await _determinePosition();

    await position.fold(
      (failure) async {
        emit(HomeError(failure.message));
      },
      (position) async {
        if (emit.isDone) return;

        emit(HomeLoading());

        final locationInfo = await _performReverseGeocoding(
          position.latitude,
          position.longitude,
        );

        final res = await CurrentWeatherUsecase().call(
          CurrentWeatherParams(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );

        if (emit.isDone) return;

        await res.fold(
          (failure) {
            emit(HomeError(failure.message));
          },
          (weather) async {
            final weatherData = weather.current.toJson();
            weatherData['name'] = locationInfo.name;
            weatherData['country'] = locationInfo.country;

            final forecastResult = await GetForecastUsecase().call(
              CurrentWeatherParams(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );

            if (emit.isDone) return;

            await forecastResult.fold(
              (failure) {
                emit(HomeLoaded(position, weatherData, null));
              },
              (forecast) {
                emit(HomeLoaded(position, weatherData, forecast));
              },
            );

            await _saveLastViewedLocation(locationInfo);
          },
        );
      },
    );
  }

  FutureOr<void> showSearchSheet(
    ShowSearchSheetEvent event,
    Emitter<HomeState> emit,
  ) async {
    final location = await _sheetService.showAppBottomSheet(
      BlocProvider.value(value: this, child: const SearchSheet()),
    );

    if (location != null && location is SavedLocation) {
      add(UpdateWeatherByLocationEvent(location));
    }
  }

  FutureOr<void> searchLocations(
    SearchLocationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await GetLocationUsecase().call(
      GetLocationParams(locationId: event.query),
    );

    return result.fold(
      (failure) => emit(LocationSearchError(failure.message)),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  FutureOr<void> updateWeatherByLocation(
    UpdateWeatherByLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final locationInfo = await _performReverseGeocoding(
        event.location.latitude,
        event.location.longitude,
        isSaved: event.location.isSaved,
      );

      await _saveLastViewedLocation(locationInfo);

      final res = await CurrentWeatherUsecase().call(
        CurrentWeatherParams(
          latitude: locationInfo.latitude,
          longitude: locationInfo.longitude,
        ),
      );

      if (emit.isDone) return;

      res.fold((failure) => emit(HomeError(failure.message)), (weather) async {
        final position = _createPositionFromLocation(locationInfo);

        final weatherData = weather.current.toJson();
        weatherData['name'] = locationInfo.name;
        weatherData['country'] = locationInfo.country;

        emit(
          HomeLoaded(
            position,
            weatherData,
            null,
            locationDetails: locationInfo,
          ),
        );
        add(GetForecastEvent());
      });
    } catch (e) {
      emit(HomeError('Failed to update weather: ${e.toString()}'));
    }
  }

  FutureOr<void> getForecast(
    GetForecastEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(ForecastLoading(currentState.position, currentState.weatherData));

      try {
        final forecastResult = await GetForecastUsecase().call(
          CurrentWeatherParams(
            latitude: currentState.position.latitude,
            longitude: currentState.position.longitude,
          ),
        );

        forecastResult.fold(
          (failure) => emit(
            ForecastError(
              currentState.position,
              currentState.weatherData,
              failure.message,
            ),
          ),
          (forecast) => emit(
            HomeLoaded(
              currentState.position,
              currentState.weatherData,
              forecast,
              locationDetails: currentState.locationDetails,
              savedLocations: currentState.savedLocations,
            ),
          ),
        );
      } catch (e) {
        emit(
          ForecastError(
            currentState.position,
            currentState.weatherData,
            e.toString(),
          ),
        );
      }
    }
  }

  FutureOr<void> saveLocation(
    SaveLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final savedLocations = await _getSavedLocations() ?? [];

      final exists = savedLocations.any(
        (loc) =>
            loc.latitude == event.location.latitude &&
            loc.longitude == event.location.longitude,
      );

      if (!exists) {
        final locationToSave = await _performReverseGeocoding(
          event.location.latitude,
          event.location.longitude,
          isSaved: true,
        );

        savedLocations.add(locationToSave);

        await _saveSavedLocations(savedLocations);

        if (state is HomeLoaded) {
          emit(
            (state as HomeLoaded).copyWith(
              savedLocations: savedLocations,
              locationdetails: locationToSave,
            ),
          );
        }
      }
    } catch (e) {
      print('Error saving location: ${e.toString()}');
    }
  }

  FutureOr<void> deleteSavedLocation(
    DeleteSavedLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final savedLocations = await _getSavedLocations() ?? [];

      savedLocations.removeWhere(
        (loc) =>
            loc.latitude == event.location.latitude &&
            loc.longitude == event.location.longitude,
      );

      await _saveSavedLocations(savedLocations);

      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(savedLocations: savedLocations));
      }
    } catch (e) {
      print('Error deleting saved location: ${e.toString()}');
    }
  }

  FutureOr<void> showSavedLocations(
    ShowSavedLocationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final savedLocations = await _getSavedLocations() ?? [];

      final selectedLocation = await _sheetService.showAppBottomSheet(
        BlocProvider.value(
          value: this,
          child: SavedLocationsSheet(locations: savedLocations),
        ),
      );

      if (selectedLocation != null && selectedLocation is SavedLocation) {
        add(UpdateWeatherByLocationEvent(selectedLocation));
      }
    } catch (e) {
      print('Error showing saved locations: ${e.toString()}');
    }
  }

  FutureOr<void> reloadWeather(
    ReloadWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final location = SavedLocation(
        latitude: currentState.position.latitude,
        longitude: currentState.position.longitude,
        name: currentState.weatherData['name'] ?? 'Current Location',
        country: currentState.weatherData['country'],
      );

      add(UpdateWeatherByLocationEvent(location));
    } else {
      add(HomeInitEvent());
    }
  }

  Position _createPositionFromLocation(SavedLocation location) {
    return Position(
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  Future<void> _saveLastViewedLocation(SavedLocation location) async {
    try {
      await _storageService.write(
        boxName: HiveBoxNames.generalAppBox,
        key: HiveStorageKeys.keyLastViewedLocation,
        value: {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'name': location.name,
          'country': location.country,
          'isSaved': location.isSaved,
        },
      );
    } catch (e) {
      print('Error saving last viewed location: ${e.toString()}');
    }
  }

  Future<List<SavedLocation>?> _getSavedLocations() async {
    try {
      final savedLocationsData = await _storageService.read(
        boxName: HiveBoxNames.generalAppBox,
        key: HiveStorageKeys.keySavedLocations,
      );

      if (savedLocationsData != null && savedLocationsData is List) {
        return savedLocationsData
            .map(
              (locData) => SavedLocation(
                latitude: locData['latitude'],
                longitude: locData['longitude'],
                name: locData['name'],
                country: locData['country'],
                isSaved: true,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error getting saved locations: ${e.toString()}');
    }
    return [];
  }

  Future<void> _saveSavedLocations(List<SavedLocation> locations) async {
    try {
      final locationsData =
          locations
              .map(
                (loc) => {
                  'latitude': loc.latitude,
                  'longitude': loc.longitude,
                  'name': loc.name,
                  'country': loc.country,
                  'isSaved': true,
                },
              )
              .toList();

      await _storageService.write(
        boxName: HiveBoxNames.generalAppBox,
        key: HiveStorageKeys.keySavedLocations,
        value: locationsData,
      );
    } catch (e) {
      print('Error saving locations: ${e.toString()}');
    }
  }
}

Future<Either<Failure, Position>> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return left(Failure('Location services are disabled'));
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return left(Failure('Location permissions are denied'));
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return left(
      Failure(
        'Location permissions are permanently denied, we cannot request permissions.',
      ),
    );
  }

  try {
    final position = await Geolocator.getCurrentPosition();
    return Right(position);
  } catch (e) {
    return left(Failure('Error getting location: ${e.toString()}'));
  }
}
