import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/src/constants/hive_box_names.dart';
import 'package:weather_app/src/constants/hive_storage_keys.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/services/local_storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<InitSettingsEvent>(_onInitSettings);
    on<UpdateTemperatureUnitEvent>(_onUpdateTemperatureUnit);
    on<UpdatePrecipitationUnitEvent>(_onUpdatePrecipitationUnit);
    on<UpdateWindSpeedUnitEvent>(_onUpdateWindSpeedUnit);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  final _storageService = locator<IlocalStorageService>();
  final _settingsController = locator<SettingsController>();

  FutureOr<void> _onInitSettings(
    InitSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      emit(
        SettingsLoaded(
          temperatureUnit: _settingsController.temperatureUnit,
          precipitationUnit: _settingsController.precipitationUnit,
          windSpeedUnit: _settingsController.windSpeedUnit,
        ),
      );
    } catch (e) {
      emit(SettingsError('Failed to load settings: ${e.toString()}'));
    }
  }

  FutureOr<void> _onUpdateTemperatureUnit(
    UpdateTemperatureUnitEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(temperatureUnit: event.unit));
    }
  }

  FutureOr<void> _onUpdatePrecipitationUnit(
    UpdatePrecipitationUnitEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(precipitationUnit: event.unit));
    }
  }

  FutureOr<void> _onUpdateWindSpeedUnit(
    UpdateWindSpeedUnitEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(currentState.copyWith(windSpeedUnit: event.unit));
    }
  }

  FutureOr<void> _onSaveSettings(
    SaveSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await _storageService.write(
          boxName: HiveBoxNames.generalAppBox,
          key: HiveStorageKeys.keyTemperatureUnit,
          value: currentState.temperatureUnit,
        );
        _settingsController.settemperatureUnit(currentState.temperatureUnit);
        _settingsController.setPrecipitationUnit(
          currentState.precipitationUnit,
        );
        _settingsController.setWindSpeedUnit(currentState.windSpeedUnit);
        await _storageService.write(
          boxName: HiveBoxNames.generalAppBox,
          key: HiveStorageKeys.keyPrecipitationUnit,
          value: currentState.precipitationUnit,
        );
        await _storageService.write(
          boxName: HiveBoxNames.generalAppBox,
          key: HiveStorageKeys.keyWindSpeedUnit,
          value: currentState.windSpeedUnit,
        );
      } catch (e) {
        emit(SettingsError('Failed to save settings: ${e.toString()}'));
      }
    }
  }
}
