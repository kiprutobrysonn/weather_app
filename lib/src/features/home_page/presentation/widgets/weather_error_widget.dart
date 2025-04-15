import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/features/home_page/utils/weather_utils.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String message;
  final bool isDay;

  const WeatherErrorWidget({
    Key? key,
    required this.message,
    required this.isDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error loading weather data',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<HomeBloc>().add(HomeInitEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
