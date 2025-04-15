import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/domain/params/get_location_params.dart';
import 'package:weather_app/src/features/home_page/domain/usecase/get_location_usecase.dart';

part 'location_search_state.dart';

class LocationSearchCubit extends Cubit<LocationSearchState> {
  LocationSearchCubit() : super(LocationSearchInitial());

  final _locationUsecase = GetLocationUsecase();

  Future<void> searchLocations(String query) async {
    emit(LocationSearchLoading());

    final result = await _locationUsecase.call(
      GetLocationParams(locationId: query),
    );

    result.fold(
      (failure) => emit(LocationSearchError(failure.message)),
      (locations) => emit(LocationSearchLoaded(locations)),
    );
  }

  void clearSearch() {
    emit(LocationSearchInitial());
  }
}
