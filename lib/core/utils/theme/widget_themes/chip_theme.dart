import 'package:flutter/material.dart';

import '../colors.dart';

class HChipTheme {
  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: HColors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: HColors.black),
    selectedColor: HColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: HColors.white,
  );

  HChipTheme._();
}
