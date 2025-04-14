class CurrentWeather {
  final double temperature;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final double uvIndex;

  CurrentWeather({
    required this.temperature,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.uvIndex,
  });
}
