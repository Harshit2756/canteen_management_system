import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class FeatureHorizontalCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height, width;
  final Widget? child;
  final EdgeInsetsGeometry? margin, padding;

  const FeatureHorizontalCard({
    this.title,
    this.icon,
    this.onTap,
    super.key,
    this.height = HSizes.cardHeight80,
    this.width = double.infinity,
    this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: HColors.primary.withValues(alpha: 0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(HSizes.cardRadiusLg16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(10, 10),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 20,
              offset: Offset(-10, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: HSizes.md16, vertical: HSizes.sm8),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, size: HSizes.iconLg40),
                const SizedBox(width: HSizes.spaceBtwItems8),
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
      ),
    );
  }
}
