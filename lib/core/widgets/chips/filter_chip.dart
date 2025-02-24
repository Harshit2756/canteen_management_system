import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/theme/colors.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedTextColor = HColors.white,
    this.unselectedTextColor = HColors.primary,
    this.selectedBackgroundColor = HColors.primary,
    this.unselectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? selectedTextColor : unselectedTextColor,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor:
          unselectedBackgroundColor ?? HColors.primary.withValues(alpha: 0.1),
      selectedColor: selectedBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.buttonRadius8),
      ),
    );
  }
}
