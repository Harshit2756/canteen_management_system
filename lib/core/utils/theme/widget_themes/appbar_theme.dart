import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../colors.dart';

class HAppBarTheme {
  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: HColors.primary,
    iconTheme: IconThemeData(color: HColors.white, size: HSizes.iconMd24),
    actionsIconTheme: IconThemeData(color: HColors.white, size: HSizes.iconMd24),
    titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: HColors.white),
  );
  HAppBarTheme._();
}
