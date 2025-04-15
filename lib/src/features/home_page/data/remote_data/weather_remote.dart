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

abstract class IWeatherRemote {
  Future<Either<Failure, String>> getAirQuality(CurrentWeatherParams params);

  Future<Either<Failure, ApiResponse<CurrentWeatherDto>>> getCurrentWeather(
    CurrentWeatherParams params,
  );

  Future<Either<Failure, ApiResponse<ForecastDto>>> getForecastWeather(
    CurrentWeatherParams params,
  );
}

class WeatherRemote implements IWeatherRemote {
  final _networkService = locator<INetworkService>();
  final _storageService = locator<IlocalStorageService>();

  String _temperatureUnit = "Celcius";
  String _precipitationUnit = "Millimeter";
  String _windSpeedUnit = "km/h";

  @override
  Future<Either<Failure, String>> getAirQuality(
    CurrentWeatherParams params,
  ) async {
    try {
      final res = await _networkService.getWithQuery(
        ApiConstants.airQualityUrl,
        queryParameters: {
          'latitude': params.latitude,
          'longitude': params.longitude,
          'current': "european_aqi",
        },
      );

      if (res.status == true) {
        return right(res.data!['current']['european_aqi'].toString());
      } else {
        return left(Failure("Failed to fetch air quality data"));
      }
    } catch (e) {
      return left(Failure("Sorry a network error occurred: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<CurrentWeatherDto>>> getCurrentWeather(
    CurrentWeatherParams params,
  ) async {
    return _makeApiRequest<CurrentWeatherDto>(
      params: params,
      specificParams: {
        'current':
            "temperature_2m,precipitation,weathercode,is_day,uv_index,wind_speed_10m,apparent_temperature",
      },
      fromJson: (data) => CurrentWeatherDto.fromJson(data),
      errorMessage: 'Failed to fetch weather data',
    );
  }

  @override
  Future<Either<Failure, ApiResponse<ForecastDto>>> getForecastWeather(
    CurrentWeatherParams params,
  ) async {
    return _makeApiRequest<ForecastDto>(
      params: params,
      specificParams: {
        'daily':
            "temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,uv_index_max,cloud_cover_mean,weathercode",
      },
      fromJson: (data) => ForecastDto.fromJson(data),
      errorMessage: 'Failed to fetch forecast data',
    );
  }

  Map<String, dynamic> _buildQueryParams(
    CurrentWeatherParams params,
    Map<String, dynamic> specificParams,
  ) {
    final queryParams = {
      'latitude': params.latitude,
      'longitude': params.longitude,
      ...specificParams,
    };

    if (!_temperatureUnit.toLowerCase().contains("celcius")) {
      queryParams["temperature_unit"] = _temperatureUnit.toLowerCase();
    }

    if (!_precipitationUnit.toLowerCase().contains("millimeter")) {
      queryParams["precipitation_unit"] = _precipitationUnit.toLowerCase();
    }

    if (!_windSpeedUnit.toLowerCase().contains("km/h")) {
      queryParams["wind_speed_unit"] = _windSpeedUnit.toLowerCase();
    }
    if (_windSpeedUnit.toLowerCase().contains("knots")) {
      queryParams["wind_speed_unit"] = 'kn';
    }

    return queryParams;
  }

  Future<void> _loadUserPreferences() async {
    _temperatureUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyTemperatureUnit,
      defaultValue: "Celcius",
    );
    _precipitationUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyPrecipitationUnit,
      defaultValue: "Millimeter",
    );
    _windSpeedUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyWindSpeedUnit,
      defaultValue: "km/h",
    );
  }

  Future<Either<Failure, ApiResponse<T>>> _makeApiRequest<T>({
    required CurrentWeatherParams params,
    required Map<String, dynamic> specificParams,
    required T Function(Map<String, dynamic>) fromJson,
    required String errorMessage,
  }) async {
    try {
      await _loadUserPreferences();

      final queryParams = _buildQueryParams(params, specificParams);

      final res = await _networkService.getWithQuery(
        ApiConstants.baseUrl,
        queryParameters: queryParams,
      );

      if (res.status == true) {
        return right(ApiResponse(data: fromJson(res.data!)));
      } else {
        return left(Failure(errorMessage));
      }
    } catch (e) {
      return left(Failure("Sorry a network error occurred: ${e.toString()}"));
    }
  }
}
