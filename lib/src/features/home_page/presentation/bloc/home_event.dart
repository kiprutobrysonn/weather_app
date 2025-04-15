part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitEvent extends HomeEvent {}

class UpdateWeatherByLocationEvent extends HomeEvent {
  final SavedLocation location;
  const UpdateWeatherByLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class GetForecastEvent extends HomeEvent {}

// Event for reloading weather when units change
class ReloadWeatherEvent extends HomeEvent {}
