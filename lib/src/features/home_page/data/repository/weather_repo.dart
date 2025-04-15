import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/data/dto/current_weather_dto.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/data/dto/location_dto.dart';
import 'package:weather_app/src/features/home_page/data/remote_data/weather_remote.dart';
import 'package:weather_app/src/features/home_page/domain/params/current_weather_params.dart';

class WeatherRepo implements IWeatherRepo {
  final _weatherRemote = locator<IWeatherRemote>();

  @override
  Future<Either<Failure, CurrentWeatherDto>> getCurrentWeather(params) async {
    final res = await _weatherRemote.getCurrentWeather(params);
    return res.fold((l) => left(Failure(l.message)), (r) => right(r.data!));
  }

  @override
  Future<Either<Failure, List<LocationDto>>> getLocations(String query) async {
    if (query.isEmpty) {
      return right([]);
    }

    try {
      final locations = await locationFromAddress(query);

      final locationDtos = await Future.wait(
        locations.map((location) async {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          final placemark = placemarks.isNotEmpty ? placemarks.first : null;

          return LocationDto(
            latitude: location.latitude,
            longitude: location.longitude,
            name: placemark?.locality ?? placemark?.name ?? query,
            country: placemark?.country,
          );
        }),
      );

      return right(locationDtos);
    } catch (e) {
      return left(Failure("Location search failed: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ForecastDto>> getForecastWeather(
    CurrentWeatherParams params,
  ) async {
    // TODO: implement getForecastWeather
    final res = await _weatherRemote.getForecastWeather(params);
    return res.fold((l) => left(Failure(l.message)), (r) => right(r.data!));
  }

  @override
  Future<Either<Failure, String>> getAirQuality(
    CurrentWeatherParams params,
  ) async {
    // TODO: implement getAirQuality
    final res = await _weatherRemote.getAirQuality(params);
    return res.fold((l) => left(Failure(l.message)), (r) => right(r));
  }
}

abstract class IWeatherRepo {
  Future<Either<Failure, CurrentWeatherDto>> getCurrentWeather(
    CurrentWeatherParams params,
  );
  Future<Either<Failure, List<LocationDto>>> getLocations(String query);
  Future<Either<Failure, ForecastDto>> getForecastWeather(
    CurrentWeatherParams params,
  );
  Future<Either<Failure, String>> getAirQuality(CurrentWeatherParams params);
}
