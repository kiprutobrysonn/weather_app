import 'package:dartz/dartz.dart';
import 'package:weather_app/src/constants/api_constants.dart';
import 'package:weather_app/src/constants/hive_box_names.dart';
import 'package:weather_app/src/constants/hive_storage_keys.dart';
import 'package:weather_app/src/core/entities/api_response.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/data/dto/current_weather_dto.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/data/dto/location_dto.dart';
import 'package:weather_app/src/features/home_page/domain/params/current_weather_params.dart';
import 'package:weather_app/src/services/local_storage.dart';
import 'package:weather_app/src/services/network_service/network_service.dart';

class WeatherRemote implements IWeatherRemote {
  final _networkService = locator<INetworkService>();
  final _storageService = locator<IlocalStorageService>();

  String temperatureUnit = "Celcius";
  String precipitationUnit = "Millimeter";
  String windSpeedUnit = "km/h";

  @override
  Future<Either<Failure, ApiResponse<CurrentWeatherDto>>> getCurrentWeather(
    CurrentWeatherParams params,
  ) async {
    temperatureUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyTemperatureUnit,
      defaultValue: "Celcius",
    );
    precipitationUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyPrecipitationUnit,
      defaultValue: "Millimeter",
    );
    windSpeedUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyWindSpeedUnit,
      defaultValue: "km/h",
    );
    try {
      final queryParams = {
        'latitude': params.latitude,
        'longitude': params.longitude,
        'current': "temperature_2m,precipitation,weathercode,is_day,uv_index",
      };

      if (!temperatureUnit.toLowerCase().contains("celcius")) {
        queryParams["temperature_unit"] = temperatureUnit.toLowerCase();
      }

      if (!precipitationUnit.toLowerCase().contains("millimeter")) {
        queryParams["precipitation_unit"] = precipitationUnit.toLowerCase();
      }

      if (!windSpeedUnit.toLowerCase().contains("km/h")) {
        queryParams["wind_speed_unit"] = windSpeedUnit.toLowerCase();
      }

      final res = await _networkService.getWithQuery(
        ApiConstants.baseUrl,
        queryParameters: queryParams,
      );

      if (res.status == true) {
        return right(ApiResponse(data: CurrentWeatherDto.fromJson(res.data!)));
      } else {
        return left(Failure('Failed to fetch weather data'));
      }
    } catch (e) {
      return left(Failure("Sorry a network error occurred: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<ForecastDto>>> getForecastWeather(
    CurrentWeatherParams params,
  ) async {
    try {
      final res = await _networkService.getWithQuery(
        ApiConstants.baseUrl,
        queryParameters: {
          'latitude': params.latitude,
          'longitude': params.longitude,
          'daily':
              "temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,uv_index_max,cloud_cover_mean,weathercode",
        },
      );

      if (res.status == true) {
        return right(ApiResponse(data: ForecastDto.fromJson(res.data!)));
      } else {
        return left(Failure('Failed to fetch forecast data'));
      }
    } catch (e) {
      return left(Failure("Sorry a network error occurred: ${e.toString()}"));
    }
  }
}

abstract class IWeatherRemote {
  Future<Either<Failure, ApiResponse<CurrentWeatherDto>>> getCurrentWeather(
    CurrentWeatherParams params,
  );

  Future<Either<Failure, ApiResponse<ForecastDto>>> getForecastWeather(
    CurrentWeatherParams params,
  );
}
