import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../colors.dart';

class HTextFormFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: HColors.darkGrey,
    suffixIconColor: HColors.darkGrey,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: HSizes.md16,
      vertical: HSizes.xs4 * 3,
    ),
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: HSizes.fontSizeMd16, color: HColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: HSizes.fontSizeSm14, color: HColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: HColors.black.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(width: 1, color: HColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(width: 1, color: HColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(width: 1, color: HColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(width: 1, color: HColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(width: 2, color: HColors.warning),
    ),
  );
  HTextFormFieldTheme._();
}
