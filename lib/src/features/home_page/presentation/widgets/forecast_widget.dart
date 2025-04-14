import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_icon.dart';

class ForecastWidget extends StatelessWidget {
  final ForecastDto forecast;
  final bool isDay;

  const ForecastWidget({Key? key, required this.forecast, required this.isDay})
    : super(key: key);

  String _getTemperatureUnit(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is SettingsLoaded) {
      return settingsState.temperatureUnit;
    }
    return 'Celcius';
  }

  String _getWindSpeedUnit(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is SettingsLoaded) {
      return settingsState.windSpeedUnit;
    }
    return 'km/h';
  }

  String _getPrecipitationUnit(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is SettingsLoaded) {
      return settingsState.precipitationUnit;
    }
    return 'Millimeter';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDay ? Colors.black87 : Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                forecast.daily.time.length > 7 ? 7 : forecast.daily.time.length,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemBuilder: (context, index) {
              // Parse the date
              final date = DateTime.parse(forecast.daily.time[index]);
              final dayName = DateFormat(
                'EEE',
              ).format(date); // Get day name (Mon, Tue, etc.)
              final dayMonth = DateFormat(
                'd MMM',
              ).format(date); // Get day and month (24 Jun)

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color:
                        isDay
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDay
                                ? Colors.black.withOpacity(0.05)
                                : Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDay
                              ? [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ]
                              : [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.05),
                              ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDay ? Colors.black87 : Colors.white,
                        ),
                      ),
                      Text(
                        dayMonth,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDay ? Colors.black87 : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      WeatherIcon(
                        weatherCode: forecast.daily.weathercode[index],
                        isDay: true,
                        size: 40,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${forecast.daily.temperature2mMax[index].round()}°',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDay ? Colors.black87 : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${forecast.daily.temperature2mMin[index].round()}°',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDay ? Colors.black45 : Colors.white60,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Precipitation row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 12,
                            color: isDay ? Colors.blue : Colors.lightBlue,
                          ),
                          Text(
                            ' ${forecast.daily.precipitationProbabilityMax[index]}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDay ? Colors.black54 : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Wind row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.air,
                            size: 12,
                            color:
                                isDay
                                    ? Colors.blueGrey
                                    : Colors.blueGrey.shade300,
                          ),
                          Text(
                            ' ${forecast.daily.windSpeed10mMax[index].round()} ${_getWindSpeedUnit(context)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDay ? Colors.black54 : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDay ? Colors.black87 : Colors.white,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          icon: Icons.thermostat,
          title: 'Temperature',
          value:
              'High ${forecast.daily.temperature2mMax[0].round()}° / Low ${forecast.daily.temperature2mMin[0].round()}° ${_getTemperatureUnit(context)}',
          iconColor: Colors.orange,
        ),
        _buildDetailRow(
          icon: Icons.umbrella,
          title: 'Precipitation',
          value:
              '${forecast.daily.precipitationSum[0]} ${_getPrecipitationUnit(context)}',
          iconColor: Colors.blue,
        ),
        _buildDetailRow(
          icon: Icons.wb_sunny,
          title: 'UV Index',
          value: _getUVIndexText(forecast.daily.uvIndexMax[0]),
          iconColor: Colors.amber,
        ),
        _buildDetailRow(
          icon: Icons.cloud,
          title: 'Cloud Cover',
          value: '${forecast.daily.cloudCoverMean[0]}%',
          iconColor: Colors.blueGrey,
        ),
        _buildDetailRow(
          icon: Icons.air,
          title: 'Wind Speed',
          value:
              '${forecast.daily.windSpeed10mMax[0].round()} ${_getWindSpeedUnit(context)}',
          iconColor: isDay ? Colors.teal : Colors.tealAccent,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDay ? Colors.black54 : Colors.white70,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDay ? Colors.black87 : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUVIndexText(double uvIndex) {
    if (uvIndex < 3) return '${uvIndex.toStringAsFixed(1)} (Low)';
    if (uvIndex < 6) return '${uvIndex.toStringAsFixed(1)} (Moderate)';
    if (uvIndex < 8) return '${uvIndex.toStringAsFixed(1)} (High)';
    if (uvIndex < 11) return '${uvIndex.toStringAsFixed(1)} (Very High)';
    return '${uvIndex.toStringAsFixed(1)} (Extreme)';
  }
}
