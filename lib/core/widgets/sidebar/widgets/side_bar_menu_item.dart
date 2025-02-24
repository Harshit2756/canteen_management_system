import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme/colors.dart';
import '../controller/sidebar_controller.dart';

class SideBarMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const SideBarMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = SidebarController.instance;
    return InkWell(
      hoverColor: HColors.transparent,
      focusColor: HColors.transparent,
      splashColor: HColors.transparent,
      highlightColor: HColors.transparent,
      onTap: () => sidebarController.onMenuTap(route),
      onHover: (hovering) => hovering ? sidebarController.onMenuHover(route) : sidebarController.onMenuHover(''),
      borderRadius: BorderRadius.circular(8),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            // only show left border if the menu is active or hovering
            border: Border(
              left: BorderSide(
                color: sidebarController.isActive(route) || sidebarController.isHovering(route) ? HColors.secondary : Colors.transparent,
                width: 4,
              ),
            ),
            color: sidebarController.isActive(route) || sidebarController.isHovering(route) ? HColors.black.withValues(alpha: 0.6) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 12),
              Icon(
                icon,
                color: sidebarController.isActive(route) || sidebarController.isHovering(route) ? HColors.white : HColors.grey,
                size: 24,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: sidebarController.isActive(route) || sidebarController.isHovering(route) ? HColors.white : HColors.grey,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
