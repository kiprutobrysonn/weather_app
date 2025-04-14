import 'package:dartz/dartz.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/core/usecase.dart';
import 'package:weather_app/src/features/home_page/data/repository/weather_repo.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/domain/params/get_location_params.dart';

class GetLocationUsecase with UseCase<List<SavedLocation>, GetLocationParams> {
  final _weatherRepo = locator<IWeatherRepo>();

  @override
  Future<Either<Failure, List<SavedLocation>>> call(
    GetLocationParams params,
  ) async {
    // Call the repository method that now uses the geocoding package
    return await _weatherRepo.getLocations(params.locationId);
  }
}
