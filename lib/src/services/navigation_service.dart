import 'package:flutter/material.dart';

class NavigationService extends INavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> snackbarkey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void back<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  @override
  Future<T>? navigateToNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments)
        as Future<T>?;
  }

  @override
  Future<T?>? navigateToOffAllNamed<T extends Object?>(
    String routeName,
    bool Function(Route p1) predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  @override
  Future<T?>? navigateToOffNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
      result: result,
    );
  }
}

/// Navigation service interface that handles routing and navigation within the app.
///
/// This interface defines the contract for navigation operations including:
/// - Navigating to named routes
/// - Replacing current route
/// - Removing routes from stack
/// - Going back
///
/// Example:
/// ```dart
/// navigationService.navigateToNamed('/home', arguments: someData);
/// ```
///
/// All navigation methods return a [Future] that completes with the value passed
/// back when the pushed route is popped off the navigator.
abstract class INavigationService {
  Future<T?>? navigateToNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  });
  Future<T?>? navigateToOffNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  });
  Future<T?>? navigateToOffAllNamed<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  });

  void back<T extends Object?>([T? result]);
}
