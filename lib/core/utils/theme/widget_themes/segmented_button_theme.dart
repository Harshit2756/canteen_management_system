import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../colors.dart';

/* -- Light & Dark Elevated Button Themes -- */
class HSegmentedButtonTheme {
  /* -- Light Theme -- */
  static final lightSegmentedButtonTheme = SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      elevation: HSizes.buttonElevation4,
      iconColor: HColors.white,
      foregroundColor: HColors.primary,
      backgroundColor: HColors.white,
      selectedForegroundColor: HColors.white,
      selectedBackgroundColor: HColors.primary,
      side: const BorderSide(color: HColors.primary),
      padding: const EdgeInsets.symmetric(
          vertical: HSizes.buttonPadding12, horizontal: HSizes.buttonPadding12),
      disabledForegroundColor: HColors.darkGrey,
      disabledBackgroundColor: HColors.buttonDisabled,
    ),
  );

  HSegmentedButtonTheme._(); //To avoid creating instances
}
