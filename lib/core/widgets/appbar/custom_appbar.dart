import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleWidget;
  final bool showBackButton;
  final List<Widget>? actions;
  final double bottom;
  final double bottomSpace;
  final Widget? bottomWidget;
  final Widget? leadingWidget;
  final double? scrolledUnderElevation;

  const CustomAppBar({
    super.key,
    required this.titleWidget,
    this.showBackButton = true,
    this.actions,
    this.bottom = 0.0,
    this.bottomSpace = 0.0,
    this.bottomWidget,
    this.leadingWidget,
    this.scrolledUnderElevation,
  });

  CustomAppBar.withText({
    super.key,
    String title = '',
    this.showBackButton = true,
    this.actions,
    this.bottom = 0.0,
    this.bottomSpace = 0.0,
    this.bottomWidget,
    this.leadingWidget,
    this.scrolledUnderElevation,
  }) : titleWidget = Text(title);

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottomWidget != null ? bottom : 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget,
      centerTitle: true,
      elevation: HSizes.appBarElevation0,
      scrolledUnderElevation: scrolledUnderElevation ?? 0.0,
      leading: leadingWidget ??
          (showBackButton ? const BackButton() : const SizedBox()),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottom),
        child: Column(
          children: [
            if (bottomWidget != null) ...[
              bottomWidget!,
              SizedBox(height: bottomSpace),
            ],
          ],
        ),
      ),
    );
  }
}
