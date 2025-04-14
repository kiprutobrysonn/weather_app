import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/src/services/navigation_service.dart';

class DialogAndSheetService extends IDialogAndSheetService {
  final key = NavigationService.navigatorKey;

  @override
  Future<T?> showAppBottomSheet<T>(Widget child) async {
    return showModalBottomSheet<T>(
      context: key.currentContext!,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      isDismissible: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) => child,
          ),
    );
  }

  @override
  Future<T?> showAppDialog<T>(Widget child) async {
    return showDialog(
      context: key.currentContext!,
      useSafeArea: true,
      builder: (context) => child,
    );
  }
}

abstract class IDialogAndSheetService {
  Future<T?> showAppBottomSheet<T>(Widget child);
  Future<T?> showAppDialog<T>(Widget child);
}
