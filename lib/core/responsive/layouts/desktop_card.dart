import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/theme/colors.dart';

class DesktopCard extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final Color backgroundColor;
  const DesktopCard({
    super.key,
    required this.child,
    this.width = 0.4,
    this.padding = const EdgeInsets.all(HSizes.md16),
    this.margin = const EdgeInsets.all(HSizes.md16),
    this.borderRadius = HSizes.md16,
    this.backgroundColor = HColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: HColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * width,
        padding: padding,
        child: child,
      ),
    );
  }
}
