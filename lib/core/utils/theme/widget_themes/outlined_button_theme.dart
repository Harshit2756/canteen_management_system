import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../colors.dart';

/* -- Light & Dark Outlined Button Themes -- */
class HOutlinedButtonTheme {
  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: HColors.dark,
      side: const BorderSide(color: HColors.borderPrimary),
      textStyle: const TextStyle(
          fontSize: 16, color: HColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(
          vertical: HSizes.buttonPadding16, horizontal: HSizes.buttonPadding12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HSizes.buttonRadius8)),
    ),
  );

  HOutlinedButtonTheme._(); //To avoid creating instances
}
