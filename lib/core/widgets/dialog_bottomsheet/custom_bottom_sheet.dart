import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.maxWidth = 500,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Container(
      padding: padding,
      width: maxWidth != null
          ? (screenWidth > 600 ? maxWidth : double.infinity)
          : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: child,
    );
  }
}
