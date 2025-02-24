import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/media/icons_strings.dart';
import '../../utils/theme/colors.dart';

class DatePickerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DatePickerButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HSizes.textFieldRadius8),
          border: Border.all(width: 1, color: HColors.grey),
        ),
        child: Row(
          children: [
            const Icon(
              HIcons.pickDate,
              color: HColors.darkGrey,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
