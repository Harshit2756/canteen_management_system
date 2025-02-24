import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HSnackbars {
  static void showSnackbar({
    required SnackbarType type,
    required String message,
    String title = '',
    String buttonText = 'Dismiss',
    VoidCallback? onPressed,
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration? duration,
  }) {
    Color backgroundColor;
    String defaultTitle;

    switch (type) {
      case SnackbarType.error:
        backgroundColor = HColors.error;
        defaultTitle = 'Error';
        break;
      case SnackbarType.info:
        backgroundColor = HColors.info;
        defaultTitle = 'Information';
        break;
      case SnackbarType.success:
        backgroundColor = HColors.success;
        defaultTitle = 'Success';
        break;
      case SnackbarType.warning:
        backgroundColor = HColors.warning;
        defaultTitle = 'Warning';
        break;
    }

    Get.snackbar(
      title.isEmpty ? defaultTitle : title,
      maxWidth: 400,
      margin: const EdgeInsets.only(top: 12),
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      mainButton: onPressed != null
          ? TextButton(
              child: Text(buttonText),
              onPressed: () => onPressed,
            )
          : null,
    );
  }
}

enum SnackbarType { error, info, success, warning }
