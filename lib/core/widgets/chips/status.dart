import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/theme/colors.dart';

class HStatus extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? textColor;

  const HStatus({
    super.key,
    required this.text,
    this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.sm8, vertical: HSizes.xxs2),
      decoration: BoxDecoration(
        color: bgColor ?? HColors.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: bgColor ?? HColors.primary.withValues(alpha: 0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor ?? HColors.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
