import 'package:get_it/get_it.dart';
import 'package:weather_app/src/features/home_page/data/remote_data/weather_remote.dart';
import 'package:weather_app/src/features/home_page/data/repository/weather_repo.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/services/dialog_and_sheet_service.dart';
import 'package:weather_app/src/services/local_storage.dart';
import 'package:weather_app/src/services/logger_service.dart';
import 'package:weather_app/src/services/navigation_service.dart';
import 'package:weather_app/src/services/network_service/network_service.dart';

final locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton<INavigationService>(() => NavigationService());
  locator.registerLazySingleton<IlocalStorageService>(() => LocalStorage());
  locator.registerLazySingleton<IDialogAndSheetService>(
    () => DialogAndSheetService(),
  );
  locator.registerLazySingleton<ILoggerService>(() => LoggerService());
  locator.registerLazySingleton<INetworkService>(() => NetworkService());
  locator.registerLazySingleton<SettingsController>(() => SettingsController());

  //Remote data sources

  locator.registerLazySingleton<IWeatherRemote>(() => WeatherRemote());
  locator.registerLazySingleton<IWeatherRepo>(() => WeatherRepo());
}
