import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class HListTileTheme {
  static ListTileThemeData lightListTileTheme = ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
    iconColor: HColors.primary,
    textColor: HColors.primary,
    titleTextStyle: const TextStyle(
      fontSize: HSizes.fontSizeMd16,
      color: HColors.primary,
      fontWeight: FontWeight.bold,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: HSizes.fontSizeSm14,
      color: HColors.primary.withValues(alpha: 0.5),
    ),
    tileColor: HColors.white,
    selectedColor: HColors.primary,
    minLeadingWidth: HSizes.sm8,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: HColors.primary.withValues(alpha: 0.5),
        width: 1,
      ),
    ),
  );

  HListTileTheme._();
}
