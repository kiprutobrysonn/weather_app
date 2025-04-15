part of 'saved_locations_cubit.dart';

abstract class SavedLocationsState extends Equatable {
  const SavedLocationsState();

  @override
  List<Object?> get props => [];
}

class SavedLocationsInitial extends SavedLocationsState {}

class SavedLocationsLoading extends SavedLocationsState {}

class SavedLocationsLoaded extends SavedLocationsState {
  final List<SavedLocation> locations;

  const SavedLocationsLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}

class SavedLocationsError extends SavedLocationsState {
  final String message;

  const SavedLocationsError(this.message);

  @override
  List<Object> get props => [message];
}
