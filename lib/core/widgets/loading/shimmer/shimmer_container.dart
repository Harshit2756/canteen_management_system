import 'package:flutter/material.dart';

import '../../../utils/theme/colors.dart';
import 'base_shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const ShimmerContainer.circular({
    super.key,
    required double size,
    this.margin,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle;

  const ShimmerContainer.rectangular({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  }) : shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: HColors.white,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        ),
      ),
    );
  }
}
