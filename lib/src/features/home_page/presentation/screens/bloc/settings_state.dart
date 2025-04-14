part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String temperatureUnit;
  final String precipitationUnit;
  final String windSpeedUnit;

  const SettingsLoaded({
    required this.temperatureUnit,
    required this.precipitationUnit,
    required this.windSpeedUnit,
  });

  @override
  List<Object> get props => [temperatureUnit, precipitationUnit, windSpeedUnit];

  SettingsLoaded copyWith({
    String? temperatureUnit,
    String? precipitationUnit,
    String? windSpeedUnit,
  }) {
    return SettingsLoaded(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      precipitationUnit: precipitationUnit ?? this.precipitationUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
