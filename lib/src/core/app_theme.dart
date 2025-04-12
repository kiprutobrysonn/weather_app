import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/src/constants/app_colors.dart';

class AppTheme {
  AppTheme._();
  static ThemeData themeData(Brightness? brightness) => ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.appGreen,
      brightness: brightness ?? Brightness.light,
    ),
    brightness: brightness,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      toolbarHeight: 0.0,
      backgroundColor:
          brightness == Brightness.light
              ? AppColors.appWhite
              : AppColors.appDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor:
          brightness == Brightness.light
              ? AppColors.appWhite
              : AppColors.appPurple,
      shadowColor:
          brightness == Brightness.light
              ? AppColors.appWhite
              : AppColors.appPurple,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            brightness == Brightness.light
                ? AppColors.appWhite
                : AppColors.appDark,
        statusBarIconBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            brightness == Brightness.light ? Brightness.light : Brightness.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      actionsIconTheme: IconThemeData(
        color:
            brightness == Brightness.light ? Colors.black : AppColors.appWhite,
      ),
    ),
  );
}
