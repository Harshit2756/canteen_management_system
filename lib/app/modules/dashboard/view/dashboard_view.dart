import 'package:canteen_app/core/utils/constants/extension/platform_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/utils/media/icons_strings.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/sidebar/widgets/sidebar.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/dashboard_body.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController(), tag: 'dashboard_controller');
    return ResponsiveLayout(
      appBar: CustomAppBar.withText(
        showBackButton: PlatformHelper.isMobileOs,
        leadingWidget: PlatformHelper.isMobileOs
            ? Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(HIcons.drawer),
                  );
                },
              )
            : null,
        actions: [
          IconButton(
            onPressed: () => controller.logout(),
            icon: const Icon(HIcons.logout),
          ),
        ],
      ),
      mobile: DashboardBody(),
      drawer: const SideBar(),
      desktop: DashboardBody(isDesktop: true),
    );
  }
}
