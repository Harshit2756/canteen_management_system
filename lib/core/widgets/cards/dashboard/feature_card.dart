import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/theme/colors.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconString;
  final VoidCallback onTap;

  const FeatureCard({
    required this.title,
    this.icon,
    required this.onTap,
    this.iconString,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HSizes.xs4 * 3),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    offset: Offset(-5, -5),
                  ),
                ],
              ),
              child: iconString != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        iconString!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Icon(
                      icon,
                      size: HSizes.iconLg40,
                      color: HColors.primary.withValues(alpha: 0.8),
                    ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: HColors.primary,
                ),
                // overflow: TextOverflow.ellipsis,
                // maxLines: 2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HColors.primary,
                    HColors.primary.withValues(alpha: 0.5)
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // const SizedBox(height: 8),
            // Icon(icon, size: HSizes.iconLg40),
          ],
        ),
      ),
    );
  }
}
