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

  const HomeLoaded(
    this.position,
    this.weatherData,
    this.forecast, {
    this.locationDetails,
  });

  HomeLoaded copyWith({
    Position? position,
    Map<String, dynamic>? weatherData,
    ForecastDto? forecast,
    SavedLocation? locationDetails,
  }) {
    return HomeLoaded(
      position ?? this.position,
      weatherData ?? this.weatherData,
      forecast ?? this.forecast,
      locationDetails: locationDetails ?? this.locationDetails,
    );
  }

  @override
  List<Object?> get props => [position, weatherData, forecast, locationDetails];
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
