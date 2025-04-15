part of 'location_search_cubit.dart';

abstract class LocationSearchState extends Equatable {
  const LocationSearchState();

  @override
  List<Object?> get props => [];
}

class LocationSearchInitial extends LocationSearchState {}

class LocationSearchLoading extends LocationSearchState {}

class LocationSearchLoaded extends LocationSearchState {
  final List<SavedLocation> locations;

  const LocationSearchLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}

class LocationSearchError extends LocationSearchState {
  final String message;

  const LocationSearchError(this.message);

  @override
  List<Object> get props => [message];
}
