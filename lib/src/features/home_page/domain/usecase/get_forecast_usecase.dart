import 'package:dartz/dartz.dart';
import 'package:weather_app/src/core/entities/failure.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/core/usecase.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/data/repository/weather_repo.dart';
import 'package:weather_app/src/features/home_page/domain/params/current_weather_params.dart';

class GetForecastUsecase with UseCase<ForecastDto, CurrentWeatherParams> {
  final _weatherRepo = locator<IWeatherRepo>();
  @override
  Future<Either<Failure, ForecastDto>> call(CurrentWeatherParams params) async {
    // TODO: implement call
    return await _weatherRepo.getForecastWeather(params);
  }
}
