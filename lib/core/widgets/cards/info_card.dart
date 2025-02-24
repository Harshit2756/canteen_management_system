import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class InfoCard extends StatelessWidget {
  final String? message;
  final Widget? widget;
  final Color color;
  final IconData icon;

  const InfoCard({
    super.key,
    this.color = HColors.primary,
    this.icon = Iconsax.info_circle_bold,
    this.message,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: widget ??
                Text(
                  message ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  softWrap: true,
                ),
          ),
        ],
      ),
    );
  }
}
