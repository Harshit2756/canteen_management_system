import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:canteen_app/core/routes/role_permissions.dart';
import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RoleMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = AuthService.instance;
    final userRole = authService.userRole;

    // Check if the route is allowed for the user's role
    if (RolePermissions.roleBasedViews[userRole]?.contains(route) ?? false) {
      return null; // Allow access
    } else {
      return const RouteSettings(
          name: HRoutesName.accessDenied); // Redirect to access denied
    }
  }
}
