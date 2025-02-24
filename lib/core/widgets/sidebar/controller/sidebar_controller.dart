import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/auth/auth_service.dart';
import '../../../utils/constants/extension/platform_extensions.dart';
import '../../../utils/helpers/logger.dart';

class SidebarController extends GetxController {
  static SidebarController get instance => Get.find<SidebarController>();
  final AuthService _authService = Get.find<AuthService>();

  final activeMenu = HRoutesName.dashboard.obs;
  final hoverMenu = ''.obs;

  bool isActive(String menu) {
    return activeMenu.value == menu;
  }

  void logout() async {
    try {
      await _authService.logout();
      Get.offAllNamed(HRoutesName.login);
    } catch (e) {
      HLoggerHelper.error("Logout failed: $e");
    }
  }

  bool isHovering(String menu) => hoverMenu.value == menu;

  void onMenuHover(String menu) => hoverMenu.value = menu;

  void onMenuTap(String menu) {
    if (menu == HRoutesName.logout) {
      logout();
      return;
    }
    if (!isActive(menu)) {
      activeMenu.value = menu;
      if (PlatformHelper.isMobile) {
        Get.back();
        Get.toNamed(menu);
      } else {
        Get.offAndToNamed(menu);
      }
    }
  }

  void toggleSidebar() {
    if (PlatformHelper.isMobile) Get.back();
  }
}
