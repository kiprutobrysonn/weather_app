import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/src/services/navigation_service.dart';

class DialogAndSheetService extends IDialogAndSheetService {
  final key = NavigationService.navigatorKey;

  @override
  Future<T?> showAppBottomSheet<T>(Widget child) async {
    return showModalBottomSheet(
      context: key.currentContext!,
      enableDrag: true,
      isScrollControlled: true,
      elevation: 0,
      isDismissible: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => child,
    );
  }

  @override
  Future<T?> showAppDialog<T>(Widget child) async {
    // TODO: implement showAppDialog
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
