import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final int weatherCode;
  final bool isDay;
  final double size;

  const WeatherIcon({
    Key? key,
    required this.weatherCode,
    required this.isDay,
    this.size = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(_mapWeatherCodeToIcon(), size: size, color: _getIconColor());
  }

  IconData _mapWeatherCodeToIcon() {
    switch (weatherCode) {
      case 0: // Clear sky
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
      case 1: // Mainly clear
      case 2: // Partly cloudy
      case 3: // Overcast
        return isDay ? Icons.wb_cloudy : Icons.nights_stay;
      case 45: // Fog
      case 48: // Depositing rime fog
        return Icons.cloud;
      case 51: // Light drizzle
      case 53: // Moderate drizzle
      case 55: // Dense drizzle
        return Icons.grain;
      case 56: // Light freezing drizzle
      case 57: // Dense freezing drizzle
        return Icons.ac_unit;
      case 61: // Slight rain
      case 63: // Moderate rain
      case 65: // Heavy rain
        return Icons.water_drop;
      case 66: // Light freezing rain
      case 67: // Heavy freezing rain
        return Icons.snowing;
      case 71: // Slight snow fall
      case 73: // Moderate snow fall
      case 75: // Heavy snow fall
        return Icons.cloudy_snowing;
      case 77: // Snow grains
        return Icons.cloudy_snowing;
      case 80: // Slight rain showers
      case 81: // Moderate rain showers
      case 82: // Violent rain showers
        return Icons.thunderstorm;
      case 85: // Slight snow showers
      case 86: // Heavy snow showers
        return Icons.cloudy_snowing;
      case 95: // Thunderstorm
      case 96: // Thunderstorm with slight hail
      case 99: // Thunderstorm with heavy hail
        return Icons.thunderstorm;
      default:
        return Icons.question_mark;
    }
  }

  Color _getIconColor() {
    switch (weatherCode) {
      case 0:
        return isDay ? Colors.amber : Colors.indigo;
      case 61:
      case 63:
      case 65:
        return Colors.blue;
      default:
        return isDay ? Colors.blueGrey : Colors.blueGrey;
    }
  }
}
