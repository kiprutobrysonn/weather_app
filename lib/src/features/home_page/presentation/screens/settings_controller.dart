import 'package:flutter/widgets.dart';
import 'package:weather_app/src/constants/hive_box_names.dart';
import 'package:weather_app/src/constants/hive_storage_keys.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/services/local_storage.dart';

class SettingsController with ChangeNotifier {
  final _storageService = locator<IlocalStorageService>();
  String _temperatureUnit = "Celcius";
  String _precipitationUnit = "Millimeter";
  String _windSpeedUnit = "km/h";

  String get precipitationUnit => _precipitationUnit;
  String get windSpeedUnit => _windSpeedUnit;
  String get temperatureUnit => _temperatureUnit;

  void setPrecipitationUnit(String value) {
    _precipitationUnit = value;
    notifyListeners();
  }

  void setWindSpeedUnit(String value) {
    _windSpeedUnit = value;

    notifyListeners();
  }

  void settemperatureUnit(String value) {
    _temperatureUnit = value;
    notifyListeners();
  }

  Future<void> loadSettings() async {
    _temperatureUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyTemperatureUnit,
      defaultValue: "Celcius",
    );
    _precipitationUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyPrecipitationUnit,
      defaultValue: "Millimeter",
    );
    _windSpeedUnit = await _storageService.read(
      boxName: HiveBoxNames.generalAppBox,
      key: HiveStorageKeys.keyWindSpeedUnit,
      defaultValue: "km/h",
    );
  }
}
