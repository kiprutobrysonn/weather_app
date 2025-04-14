part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitEvent extends HomeEvent {}

class ShowSearchSheetEvent extends HomeEvent {}

class SearchLocationsEvent extends HomeEvent {
  final String query;

  const SearchLocationsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class UpdateWeatherByLocationEvent extends HomeEvent {
  final SavedLocation location;

  const UpdateWeatherByLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class GetForecastEvent extends HomeEvent {}

// New events for location management
class SaveLocationEvent extends HomeEvent {
  final SavedLocation location;

  const SaveLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class DeleteSavedLocationEvent extends HomeEvent {
  final SavedLocation location;

  const DeleteSavedLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class ShowSavedLocationsEvent extends HomeEvent {}

// Event for reloading weather when units change
class ReloadWeatherEvent extends HomeEvent {}
