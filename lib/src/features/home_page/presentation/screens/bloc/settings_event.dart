part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class InitSettingsEvent extends SettingsEvent {}

class UpdateTemperatureUnitEvent extends SettingsEvent {
  final String unit;

  const UpdateTemperatureUnitEvent(this.unit);

  @override
  List<Object> get props => [unit];
}

class UpdatePrecipitationUnitEvent extends SettingsEvent {
  final String unit;

  const UpdatePrecipitationUnitEvent(this.unit);

  @override
  List<Object> get props => [unit];
}

class UpdateWindSpeedUnitEvent extends SettingsEvent {
  final String unit;

  const UpdateWindSpeedUnitEvent(this.unit);

  @override
  List<Object> get props => [unit];
}

class SaveSettingsEvent extends SettingsEvent {}
