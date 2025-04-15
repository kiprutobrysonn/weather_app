import 'package:flutter/material.dart';

class WeatherUtils {
  static String getTemperatureUnit(String tempUnit) {
    if (tempUnit.toLowerCase() == 'fahrenheit') {
      return 'F';
    } else if (tempUnit.toLowerCase() == 'kelvin') {
      return 'K';
    }
    return 'C';
  }

  static String getPrecipitationUnit(String precipUnit) {
    if (precipUnit.toLowerCase() == 'inch') {
      return 'inch';
    } else if (precipUnit.toLowerCase() == 'cm') {
      return 'cm';
    }
    return 'Millimeter';
  }

  static String getWindSpeedUnit(String windSpeedUnit) {
    if (windSpeedUnit.toLowerCase() == 'ms') {
      return 'm/s';
    } else if (windSpeedUnit.toLowerCase() == 'km/h') {
      return 'km/h';
    } else if (windSpeedUnit.toLowerCase() == 'mph') {
      return 'mph';
    }
    return 'knots';
  }

  static Color getBackgroundColor(bool isDay) {
    return isDay ? const Color(0xFF4A90E2) : const Color(0xFF1A237E);
  }

  static Color getTextColor(bool isDay) {
    return isDay ? Colors.black87 : Colors.white;
  }

  static String getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return "Clear sky";
      case 1:
        return "Mainly clear";
      case 2:
        return "Partly cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Foggy conditions";
      case 51:
      case 53:
      case 55:
        return "Light drizzle";
      case 56:
      case 57:
        return "Freezing drizzle";
      case 61:
      case 63:
      case 65:
        return "Rainfall";
      case 66:
      case 67:
        return "Freezing rain";
      case 71:
      case 73:
      case 75:
        return "Snowfall";
      case 77:
        return "Snow grains";
      case 80:
      case 81:
      case 82:
        return "Rain showers";
      case 85:
      case 86:
        return "Snow showers";
      case 95:
        return "Thunderstorm";
      case 96:
      case 99:
        return "Thunderstorm with hail";
      default:
        return "Weather information";
    }
  }

  static String getUVIndexDescription(dynamic uvIndex) {
    if (uvIndex == null) return "N/A";

    int uv = int.tryParse(uvIndex.toString()) ?? 0;
    String level;

    if (uv <= 2) {
      level = "Low";
    } else if (uv <= 5) {
      level = "Moderate";
    } else if (uv <= 7) {
      level = "High";
    } else if (uv <= 10) {
      level = "Very High";
    } else {
      level = "Extreme";
    }

    return "$uvIndex ($level)";
  }

  static String getAirQualityDescription(dynamic aqi) {
    if (aqi == null) return "N/A";

    int index = int.tryParse(aqi.toString()) ?? -1;

    if (index <= 0) {
      return "N/A";
    } else if (index <= 20) {
      return "Very Good";
    } else if (index <= 40) {
      return "Good";
    } else if (index <= 60) {
      return "Moderate";
    } else if (index <= 80) {
      return "Poor";
    } else if (index <= 100) {
      return "Very Poor";
    } else {
      return "Extremely Poor";
    }
  }
}
