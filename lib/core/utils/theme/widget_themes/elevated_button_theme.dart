import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../colors.dart';

/* -- Light & Dark Elevated Button Themes -- */
class HElevatedButtonTheme {
  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: HSizes.buttonElevation4,
      iconColor: HColors.light,
      foregroundColor: HColors.light,
      backgroundColor: HColors.primary,
      disabledForegroundColor: HColors.darkGrey,
      disabledBackgroundColor: HColors.buttonDisabled,
      side: const BorderSide(color: HColors.primary),
      padding: const EdgeInsets.symmetric(vertical: HSizes.buttonPadding12, horizontal: HSizes.buttonPadding12),
      textStyle: const TextStyle(fontSize: 16, color: HColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(),
      shadowColor: HColors.primary.withValues(alpha: 0.5),
    ),
  );

  HElevatedButtonTheme._(); //To avoid creating instances
}
