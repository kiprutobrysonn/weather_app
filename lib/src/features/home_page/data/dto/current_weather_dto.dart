// Current weather data transfer object
class CurrentWeatherDto {
  final double latitude;
  final double longitude;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final CurrentUnitsDto currentUnits;
  final CurrentDto current;

  CurrentWeatherDto({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.currentUnits,
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
      currentUnits: CurrentUnitsDto.fromJson(json['current_units']),
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
      'current_units': currentUnits.toJson(),
      'current': current.toJson(),
    };
  }
}

class CurrentUnitsDto {
  final String time;
  final String interval;
  final String temperature2m;
  final String precipitation;
  final String weathercode;
  final String isDay;
  final String uvIndex;

  CurrentUnitsDto({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.precipitation,
    required this.weathercode,
    required this.isDay,
    required this.uvIndex,
  });

  factory CurrentUnitsDto.fromJson(Map<String, dynamic> json) {
    return CurrentUnitsDto(
      time: json['time'],
      interval: json['interval'],
      temperature2m: json['temperature_2m'],
      precipitation: json['precipitation'],
      weathercode: json['weathercode'],
      isDay: json['is_day'],
      uvIndex: json['uv_index'],
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

  CurrentDto({
    required this.time,
    required this.interval,
    required this.temperature2m,
    required this.precipitation,
    required this.weathercode,
    required this.isDay,
    required this.uvIndex,
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
    };
  }
}
