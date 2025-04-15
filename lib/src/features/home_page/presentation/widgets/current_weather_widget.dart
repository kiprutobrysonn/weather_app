import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_icon.dart';
import 'package:weather_app/src/features/home_page/utils/weather_utils.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final SavedLocation? locationDetails;
  final bool isDay;
  final SettingsController settingsController;

  const CurrentWeatherWidget({
    Key? key,
    required this.weatherData,
    this.locationDetails,
    required this.isDay,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(weatherData['time']);
    final dayName = DateFormat('EEE').format(date);
    final dayMonth = DateFormat('d MMM').format(date);

    final String weatherDescription = WeatherUtils.getWeatherDescription(
      weatherData["weathercode"],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: WeatherUtils.getTextColor(
                          isDay,
                        ).withOpacity(0.8),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        locationDetails?.name ?? "Current Location",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: WeatherUtils.getTextColor(isDay),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      locationDetails?.country ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: WeatherUtils.getTextColor(
                          isDay,
                        ).withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: WeatherUtils.getTextColor(
                          isDay,
                        ).withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$dayName, $dayMonth • ${DateFormat('HH:mm').format(date)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: WeatherUtils.getTextColor(
                            isDay,
                          ).withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        weatherData['is_day']
                            ? Icons.wb_sunny_outlined
                            : Icons.nights_stay_outlined,
                        color: WeatherUtils.getTextColor(
                          isDay,
                        ).withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        weatherData['is_day'] ? 'Day time' : 'Night time',
                        style: TextStyle(
                          fontSize: 16,
                          color: WeatherUtils.getTextColor(
                            isDay,
                          ).withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WeatherIcon(
                isDay: isDay,
                weatherCode: weatherData["weathercode"],
                size: 80,
              ),
            ],
          ),

          const SizedBox(height: 24),

          Center(
            child: Column(
              children: [
                Text(
                  '${weatherData['temperature_2m']}° ${WeatherUtils.getTemperatureUnit(settingsController.temperatureUnit)}',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: WeatherUtils.getTextColor(isDay),
                  ),
                ),
                Text(
                  weatherDescription,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: WeatherUtils.getTextColor(isDay),
                  ),
                ),
                if (weatherData['feels_like'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Feels like ${weatherData['feels_like']}° ${WeatherUtils.getTemperatureUnit(settingsController.temperatureUnit)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: WeatherUtils.getTextColor(
                          isDay,
                        ).withOpacity(0.9),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
