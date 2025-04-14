part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeLoaded extends HomeState {
  final Position position;
  final Map<String, dynamic> weatherData;
  final ForecastDto? forecast;
  final SavedLocation? locationDetails;
  final List<SavedLocation>? savedLocations;

  const HomeLoaded(
    this.position,
    this.weatherData,
    this.forecast, {
    this.locationDetails,
    this.savedLocations,
  });

  HomeLoaded copyWith({
    Position? position,
    Map<String, dynamic>? weatherData,
    ForecastDto? forecast,
    List<SavedLocation>? savedLocations,
    SavedLocation? locationdetails,
  }) {
    return HomeLoaded(
      position ?? this.position,
      weatherData ?? this.weatherData,
      forecast ?? this.forecast,
      savedLocations: savedLocations ?? this.savedLocations,
      locationDetails: locationdetails,
    );
  }

  @override
  List<Object?> get props => [position, weatherData, forecast, savedLocations];
}

class LocationsLoaded extends HomeState {
  final List<SavedLocation> locations;

  const LocationsLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}

class LocationSearchError extends HomeState {
  final String message;

  const LocationSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class ForecastLoading extends HomeState {
  final Position position;
  final Map<String, dynamic> weatherData;

  const ForecastLoading(this.position, this.weatherData);

  @override
  List<Object> get props => [position, weatherData];
}

class ForecastError extends HomeState {
  final Position position;
  final Map<String, dynamic> weatherData;
  final String message;

  const ForecastError(this.position, this.weatherData, this.message);

  @override
  List<Object> get props => [position, weatherData, message];
}
