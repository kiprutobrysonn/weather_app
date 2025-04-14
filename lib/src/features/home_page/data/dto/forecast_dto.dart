import 'dart:convert';

class ForecastDto {
  final DailyUnits dailyUnits;
  final Daily daily;

  ForecastDto({required this.dailyUnits, required this.daily});

  factory ForecastDto.fromJson(Map<String, dynamic> json) {
    return ForecastDto(
      dailyUnits: DailyUnits.fromJson(json['daily_units'] ?? {}),
      daily: Daily.fromJson(json['daily'] ?? {}),
    );
  }

  static ForecastDto fromJsonString(String jsonString) {
    return ForecastDto.fromJson(json.decode(jsonString));
  }

  Map<String, dynamic> toJson() {
    return {'daily_units': dailyUnits.toJson(), 'daily': daily.toJson()};
  }
}

class DailyUnits {
  final String time;
  final String temperature2mMax;
  final String temperature2mMin;
  final String precipitationSum;
  final String precipitationProbabilityMax;
  final String windSpeed10mMax;
  final String uvIndexMax;
  final String cloudCoverMean;
  final String weathercode;

  DailyUnits({
    required this.time,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeed10mMax,
    required this.uvIndexMax,
    required this.cloudCoverMean,
    required this.weathercode,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) {
    return DailyUnits(
      time: json['time'] ?? '',
      temperature2mMax: json['temperature_2m_max'] ?? '',
      temperature2mMin: json['temperature_2m_min'] ?? '',
      precipitationSum: json['precipitation_sum'] ?? '',
      precipitationProbabilityMax: json['precipitation_probability_max'] ?? '',
      windSpeed10mMax: json['wind_speed_10m_max'] ?? '',
      uvIndexMax: json['uv_index_max'] ?? '',
      cloudCoverMean: json['cloud_cover_mean'] ?? '',
      weathercode: json['weathercode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'precipitation_sum': precipitationSum,
      'precipitation_probability_max': precipitationProbabilityMax,
      'wind_speed_10m_max': windSpeed10mMax,
      'uv_index_max': uvIndexMax,
      'cloud_cover_mean': cloudCoverMean,
      'weathercode': weathercode,
    };
  }
}

class Daily {
  final List<String> time;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<double> precipitationSum;
  final List<int> precipitationProbabilityMax;
  final List<double> windSpeed10mMax;
  final List<double> uvIndexMax;
  final List<int> cloudCoverMean;
  final List<int> weathercode;

  Daily({
    required this.time,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeed10mMax,
    required this.uvIndexMax,
    required this.cloudCoverMean,
    required this.weathercode,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      time: List<String>.from(json['time'] ?? []),
      temperature2mMax: List<double>.from(
        (json['temperature_2m_max'] ?? []).map((x) => x?.toDouble() ?? 0.0),
      ),
      temperature2mMin: List<double>.from(
        (json['temperature_2m_min'] ?? []).map((x) => x?.toDouble() ?? 0.0),
      ),
      precipitationSum: List<double>.from(
        (json['precipitation_sum'] ?? []).map((x) => x?.toDouble() ?? 0.0),
      ),
      precipitationProbabilityMax: List<int>.from(
        json['precipitation_probability_max'] ?? [],
      ),
      windSpeed10mMax: List<double>.from(
        (json['wind_speed_10m_max'] ?? []).map((x) => x?.toDouble() ?? 0.0),
      ),
      uvIndexMax: List<double>.from(
        (json['uv_index_max'] ?? []).map((x) => x?.toDouble() ?? 0.0),
      ),
      cloudCoverMean: List<int>.from(json['cloud_cover_mean'] ?? []),
      weathercode: List<int>.from(json['weathercode'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'precipitation_sum': precipitationSum,
      'precipitation_probability_max': precipitationProbabilityMax,
      'wind_speed_10m_max': windSpeed10mMax,
      'uv_index_max': uvIndexMax,
      'cloud_cover_mean': cloudCoverMean,
      'weathercode': weathercode,
    };
  }
}
