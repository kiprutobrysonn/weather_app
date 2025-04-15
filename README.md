# Weather App

A modern weather application built with Flutter that provides real-time weather information and forecasts.

![Flutter Version](https://img.shields.io/badge/Flutter-3.7+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

- 🌦️ Real-time weather updates
- 📍 Location-based weather information
- 🔍 Search for weather by location
- 📊 Detailed weather forecasts
- 💾 Save favorite locations

## Architecture

This app follows a clean architecture approach with:

- BLoC pattern for state management
- Repository pattern for data handling
- Use case pattern for business logic
- Dependency injection with GetIt

## Technologies Used

- **State Management**: Flutter BLoC
- **API Client**: Dio
- **Local Storage**: Hive
- **Dependency Injection**: GetIt
- **Responsive UI**: Flutter ScreenUtil
- **Location Services**: Geolocator, Geocoding
- **Functional Programming**: Dartz

## Getting Started

### Prerequisites

- Flutter SDK (version ^3.7.0)
- Dart SDK
- Android Studio / VS Code / IntelliJ
- A device or emulator running iOS or Android

### Installation

1. Clone the repository

   ```bash
   git clone https://github.com/yourusername/weather_app.git
   cd weather_app
   ```

2. Install dependencies

   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

## API Integration

This app uses a free weather API to fetch weather data.
