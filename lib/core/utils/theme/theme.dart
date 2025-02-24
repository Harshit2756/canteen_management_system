import 'package:canteen_app/core/utils/theme/widget_themes/floating_action_button.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'widget_themes/appbar_theme.dart';
import 'widget_themes/bottom_sheet_theme.dart';
import 'widget_themes/checkbox_theme.dart';
import 'widget_themes/chip_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/list_tile_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/segmented_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

class HAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: HColors.primary,
      secondary: HColors.secondary,
    ),
    disabledColor: HColors.grey,
    brightness: Brightness.light,
    primaryColor: HColors.primary,
    textTheme: HTextTheme.lightTextTheme,
    chipTheme: HChipTheme.lightChipTheme,
    scaffoldBackgroundColor: HColors.grey,
    appBarTheme: HAppBarTheme.lightAppBarTheme,
    checkboxTheme: HCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: HBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: HElevatedButtonTheme.lightElevatedButtonTheme,
    segmentedButtonTheme: HSegmentedButtonTheme.lightSegmentedButtonTheme,
    // filledButtonTheme: const FilledButtonThemeData(),
    outlinedButtonTheme: HOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: HTextFormFieldTheme.lightInputDecorationTheme,
    floatingActionButtonTheme:
        HFloatingActionButtonTheme.lightFloatingActionButtonTheme,
    listTileTheme: HListTileTheme.lightListTileTheme,
  );

  HAppTheme._();
}
