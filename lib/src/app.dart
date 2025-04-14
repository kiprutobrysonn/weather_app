import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/src/core/app_theme.dart';
import 'package:weather_app/src/core/routes.dart';
import 'package:weather_app/src/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/home_page.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings_controller.dart';
import 'package:weather_app/src/services/navigation_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (context, child) {
        return ScreenUtilInit(
          designSize: Size(430, 932),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: NavigationService.snackbarkey,
            navigatorKey: NavigationService.navigatorKey,
            title: 'Weather App',
            restorationScopeId: 'app',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],

            theme: AppTheme.themeData(Brightness.light),
            darkTheme: AppTheme.themeData(Brightness.dark),
            themeMode: ThemeMode.light,
            onGenerateRoute: (settings) => Routes.generateRoute(settings),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<SettingsBloc>(
                  create: (context) => SettingsBloc()..add(InitSettingsEvent()),
                ),
                BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc()..add(HomeInitEvent()),
                ),
              ],
              child: HomePage(),
            ),
          ),
        );
      },
    );
  }
}
