import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/bloc/settings_bloc.dart';
import 'package:weather_app/src/features/home_page/presentation/screens/settings.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SettingsPage.routeName:
        return _registerBlocView(
          view: const SettingsPage(),
          bloc: SettingsBloc()..add(InitSettingsEvent()),
          settings: settings,
        );
      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('No route defined for $routeName')),
          ),
    );
  }

  static MaterialPageRoute _registerBlocView<T extends Bloc>({
    required Widget view,
    required T bloc,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider<T>(create: (context) => bloc, child: view),
    );
  }
}
