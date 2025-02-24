import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/theme/colors.dart';
import 'shimmer_container.dart';

class ShimmerListItem extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? margin;

  const ShimmerListItem({
    super.key,
    this.height = 90,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: HSizes.buttonElevation4,
      shadowColor: HColors.primary.withValues(alpha: 0.3),
      margin: margin ??
          const EdgeInsets.symmetric(
            vertical: HSizes.sm8,
            horizontal: HSizes.md16,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(HSizes.buttonPadding12),
        child: Row(
          children: [
            // Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: HColors.primary.withValues(alpha: 0.2),
                    blurRadius: HSizes.sm8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const ShimmerContainer.circular(size: 50),
            ),
            const SizedBox(width: HSizes.buttonPadding12),
            // Content
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerContainer.rectangular(
                    height: 20,
                    width: 150,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  SizedBox(height: HSizes.sm8),
                  ShimmerContainer.rectangular(
                    height: 24,
                    width: 100,
                    borderRadius: BorderRadius.all(
                        Radius.circular(HSizes.cardRadiusMd12)),
                  ),
                ],
              ),
            ),
            // Menu Icon
            const ShimmerContainer.rectangular(
              height: HSizes.iconMd24,
              width: HSizes.iconMd24,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
