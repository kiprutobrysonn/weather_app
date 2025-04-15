// Current weather data transfer object
class CurrentWeatherDto {
  final double latitude;
  final double longitude;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final CurrentDto current;

  CurrentWeatherDto({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.current,
  });

  factory CurrentWeatherDto.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherDto(
      latitude: json['latitude'],
      longitude: json['longitude'],
      generationtimeMs: json['generationtime_ms'],
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: json['elevation'],
      current: CurrentDto.fromJson(json['current']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'generationtime_ms': generationtimeMs,
      'utc_offset_seconds': utcOffsetSeconds,
      'timezone': timezone,
      'timezone_abbreviation': timezoneAbbreviation,
      'elevation': elevation,
      'current': current.toJson(),
    };
  }
}

class CurrentDto {
  final String time;
  final int interval;
  final double temperature2m;
  final double precipitation;
  final int weathercode;
  final bool isDay;
  final double uvIndex;
  final double windSpeed10m;
  final double apparentTemperature;

  CurrentDto({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.precipitation,
    required this.weathercode,
    required this.isDay,
    required this.uvIndex,
    this.windSpeed10m = 0.0,
    required this.apparentTemperature,
  });

  factory CurrentDto.fromJson(Map<String, dynamic> json) {
    return CurrentDto(
      time: json['time'],
      interval: json['interval'],
      temperature2m: json['temperature_2m'],
      precipitation: json['precipitation'],
      weathercode: json['weathercode'],
      isDay: json['is_day'] == 1 ? true : false,
      uvIndex: json['uv_index'],
      windSpeed10m: json['wind_speed_10m']?.toDouble() ?? 0.0,
      apparentTemperature: json['apparent_temperature']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'interval': interval,
      'temperature_2m': temperature2m,
      'precipitation': precipitation,
      'weathercode': weathercode,
      'is_day': isDay,
      'uv_index': uvIndex,
      'wind_speed_10m': windSpeed10m,
      'feels_like': apparentTemperature,
    };
  }
}
