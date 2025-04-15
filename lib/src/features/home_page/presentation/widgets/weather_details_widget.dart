import 'package:flutter/material.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/features/home_page/utils/weather_utils.dart';

class WeatherDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final bool isDay;
  final SettingsController settingsController;

  const WeatherDetailsWidget({
    Key? key,
    required this.weatherData,
    required this.isDay,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: WeatherUtils.getTextColor(isDay)),
              const SizedBox(width: 8),
              Text(
                'Weather Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WeatherUtils.getTextColor(isDay),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              _buildDetailItem(
                Icons.water_drop,
                'Rainfall',
                '${weatherData['precipitation']} ${WeatherUtils.getPrecipitationUnit(settingsController.precipitationUnit)}',
                isDay,
              ),
              _buildDetailItem(
                Icons.wb_sunny,
                'UV Index',
                WeatherUtils.getUVIndexDescription(weatherData['uv_index']),
                isDay,
              ),
              _buildDetailItem(
                Icons.grain,
                'Air Quality',
                '${weatherData['airQuality']} (${WeatherUtils.getAirQualityDescription(weatherData['airQuality'])})',
                isDay,
              ),
              _buildDetailItem(
                Icons.air,
                'Wind Speed',
                '${weatherData['wind_speed_10m'] ?? "N/A"} ${WeatherUtils.getWindSpeedUnit(settingsController.windSpeedUnit)}',
                isDay,
              ),
              if (weatherData['humidity'] != null)
                _buildDetailItem(
                  Icons.water_outlined,
                  'Humidity',
                  '${weatherData['humidity']}%',
                  isDay,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    bool isDay,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: WeatherUtils.getTextColor(isDay).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: WeatherUtils.getTextColor(isDay), size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: WeatherUtils.getTextColor(isDay).withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: WeatherUtils.getTextColor(isDay),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
