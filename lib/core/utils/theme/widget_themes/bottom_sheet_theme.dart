import 'package:flutter/material.dart';

import '../colors.dart';

class HBottomSheetTheme {
  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: HColors.white,
    modalBackgroundColor: HColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  HBottomSheetTheme._();
}
