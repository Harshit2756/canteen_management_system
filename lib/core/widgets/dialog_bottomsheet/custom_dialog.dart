import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;
  final double? maxHeight;

  const CustomDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.maxWidth = 500,
    this.maxHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: padding,
        height: maxHeight != null ? (screenWidth > 600 ? maxHeight : null) : double.infinity,
        width: maxWidth != null ? (screenWidth > 600 ? maxWidth : double.infinity) : double.infinity,
        child: child,
      ),
    );
  }
}
