import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/src/core/locator.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';

import 'src/app.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsFlutterBinding =
          WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) async {
        if (kDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        } else {
          Zone.current.handleUncaughtError(details.exception, details.stack!);
        }
      };

      await setupLocator();
      await ScreenUtil.ensureScreenSize();

      if (!kIsWeb) {
        final appDocumentDirectory = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDirectory.path);
      }

      SystemChannels.textInput.invokeMapMethod('TextInput.hide');
      final settingsController = locator<SettingsController>();
      await settingsController.loadSettings();
      runApp(MyApp(settingsController: settingsController));
    },
    (error, stack) {
      // Implement proper error reporting here
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stack');
    },
  );
}
