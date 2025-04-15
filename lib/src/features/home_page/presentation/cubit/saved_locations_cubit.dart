import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/src/constants/hive_box_names.dart';
import 'package:weather_app/src/constants/hive_storage_keys.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/services/local_storage.dart';
import 'package:geocoding/geocoding.dart';

part 'saved_locations_state.dart';

class SavedLocationsCubit extends Cubit<SavedLocationsState> {
  SavedLocationsCubit() : super(SavedLocationsInitial()) {
    loadSavedLocations();
  }

  final _storageService = locator<IlocalStorageService>();

  Future<void> loadSavedLocations() async {
    emit(SavedLocationsLoading());

    try {
      final locations = await _getSavedLocations() ?? [];
      emit(SavedLocationsLoaded(locations));
    } catch (e) {
      emit(
        SavedLocationsError('Failed to load saved locations: ${e.toString()}'),
      );
    }
  }

  Future<void> saveLocation(SavedLocation location) async {
    try {
      if (state is SavedLocationsLoaded) {
        final currentLocations = (state as SavedLocationsLoaded).locations;

        // Check if location already exists
        final exists = currentLocations.any(
          (loc) =>
              loc.latitude == location.latitude &&
              loc.longitude == location.longitude,
        );

        if (!exists) {
          // Get full location details with geocoding
          final locationToSave = await _performReverseGeocoding(
            location.latitude,
            location.longitude,
            isSaved: true,
          );

          final updatedLocations = List<SavedLocation>.from(currentLocations)
            ..add(locationToSave);
          await _saveSavedLocations(updatedLocations);

          emit(SavedLocationsLoaded(updatedLocations));
        }
      }
    } catch (e) {
      emit(SavedLocationsError('Failed to save location: ${e.toString()}'));
    }
  }

  Future<void> deleteLocation(SavedLocation location) async {
    try {
      if (state is SavedLocationsLoaded) {
        final currentLocations = (state as SavedLocationsLoaded).locations;

        final updatedLocations = List<SavedLocation>.from(currentLocations)
          ..removeWhere(
            (loc) =>
                loc.latitude == location.latitude &&
                loc.longitude == location.longitude,
          );

        await _saveSavedLocations(updatedLocations);
        emit(SavedLocationsLoaded(updatedLocations));
      }
    } catch (e) {
      emit(SavedLocationsError('Failed to delete location: ${e.toString()}'));
    }
  }

  // Helper methods
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
