import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/data/dto/forecast_dto.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/features/home_page/presentation/widgets/weather_icon.dart';

class ForecastWidget extends StatelessWidget {
  final controller = locator<SettingsController>();
  final ForecastDto forecast;
  final bool isDay;

  ForecastWidget({Key? key, required this.forecast, required this.isDay})
    : super(key: key);

  String _getTemperatureUnit(String tempUnit) {
    switch (tempUnit.toLowerCase()) {
      case 'fahrenheit':
        return '°F';
      case 'kelvin':
        return 'K';
      default:
        return '°C';
    }
  }

  String _getWindSpeedUnit(String windSpeedUnit) {
    switch (windSpeedUnit.toLowerCase()) {
      case 'ms':
        return 'm/s';
      case 'km/h':
        return 'km/h';
      case 'mph':
        return 'mph';
      default:
        return 'knots';
    }
  }

  String _getUVIndexText(double uvIndex) {
    if (uvIndex < 3) return '${uvIndex.toStringAsFixed(1)} (Low)';
    if (uvIndex < 6) return '${uvIndex.toStringAsFixed(1)} (Moderate)';
    if (uvIndex < 8) return '${uvIndex.toStringAsFixed(1)} (High)';
    if (uvIndex < 11) return '${uvIndex.toStringAsFixed(1)} (Very High)';
    return '${uvIndex.toStringAsFixed(1)} (Extreme)';
  }

  Color _getPrecipitationColor(int percentage) {
    if (percentage < 20) return Colors.lightBlue.shade100;
    if (percentage < 40) return Colors.lightBlue.shade300;
    if (percentage < 60) return Colors.blue;
    if (percentage < 80) return Colors.blue.shade700;
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDay ? Colors.black87 : Colors.white;
    final secondaryTextColor = isDay ? Colors.black54 : Colors.white70;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Column(
          children: [
            _buildHeader(textColor),
            _buildForecastList(textColor, secondaryTextColor),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Spacer(),
          Icon(
            Icons.calendar_today,
            size: 18,
            color: textColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastList(Color textColor, Color secondaryTextColor) {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            forecast.daily.time.length > 7 ? 7 : forecast.daily.time.length,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, index) {
          // Parse the date
          final date = DateTime.parse(forecast.daily.time[index]);
          final dayName = DateFormat('EEE').format(date);
          final dayMonth = DateFormat('d MMM').format(date);
          final isToday =
              DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(DateTime.now());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _buildDayCard(
              textColor,
              secondaryTextColor,
              dayName,
              dayMonth,
              index,
              isToday,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayCard(
    Color textColor,
    Color secondaryTextColor,
    String dayName,
    String dayMonth,
    int index,
    bool isToday,
  ) {
    final precipProbability = forecast.daily.precipitationProbabilityMax[index];
    final tempUnit = _getTemperatureUnit(controller.temperatureUnit);
    final windUnit = _getWindSpeedUnit(controller.windSpeedUnit);

    return Container(
      width: 150.h,
      decoration: BoxDecoration(
        color:
            isDay
                ? (isToday
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.2))
                : (isToday
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(20),
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
        border:
            isToday
                ? Border.all(
                  color:
                      isDay
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.blue.withOpacity(0.5),
                  width: 1.5,
                )
                : null,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDay
                  ? [
                    isToday
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.3),
                    isToday
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                  ]
                  : [
                    isToday
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.15),
                    isToday
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.05),
                  ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isToday)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        isDay
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color:
                          isDay ? Colors.blue.shade700 : Colors.blue.shade200,
                    ),
                  ),
                ),
              if (!isToday)
                Text(
                  dayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
            ],
          ),
          Text(
            dayMonth,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
          const SizedBox(height: 10),

          // Weather icon
          WeatherIcon(
            weatherCode: forecast.daily.weathercode[index],
            isDay: true,
            size: 46,
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${forecast.daily.temperature2mMax[index].round()}$tempUnit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${forecast.daily.temperature2mMin[index].round()}$tempUnit',
                style: TextStyle(fontSize: 16, color: secondaryTextColor),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloudy_snowing,
                size: 14,
                color: _getPrecipitationColor(precipProbability),
              ),
              Text(
                ' ${precipProbability}%',
                style: TextStyle(fontSize: 13, color: secondaryTextColor),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sunny,
                size: 14,
                color: isDay ? Colors.blueGrey : Colors.blueGrey.shade300,
              ),
              Text(
                '${_getUVIndexText(forecast.daily.uvIndexMax[index])}',
                style: TextStyle(fontSize: 13, color: secondaryTextColor),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.air,
                size: 14,
                color: isDay ? Colors.blueGrey : Colors.blueGrey.shade300,
              ),
              Text(
                ' ${forecast.daily.windSpeed10mMax[index].round()} $windUnit',
                style: TextStyle(fontSize: 13, color: secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
