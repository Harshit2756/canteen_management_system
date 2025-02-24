/// Application pages configuration
///
/// Purpose:
/// - Define all application routes
/// - Configure route bindings
/// - Set up route middleware
///
/// Usage:
/// ```dart
/// GetMaterialApp(
///   initialRoute: AppPages.INITIAL,
///   getPages: AppPages.routes,
/// )
/// ```
library;

import 'package:canteen_app/app/modules/auth/view/splash_view.dart';
import 'package:canteen_app/app/modules/employee/view/add_employee_view.dart';
import 'package:canteen_app/app/modules/employee/view/employee_list_view.dart';
import 'package:canteen_app/app/modules/meal/view/meals_request_list_view.dart';
import 'package:canteen_app/app/modules/meals_menu/view/meal_menu_list_view.dart';
import 'package:canteen_app/core/middleware/role_middleware.dart';
import 'package:canteen_app/core/widgets/error/access_denied_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/auth/view/login_view.dart';
import '../../app/modules/dashboard/view/dashboard_view.dart';
import '../../app/modules/meal/view/add_meals_request_view.dart';
import '../../app/modules/meals_menu/view/add_meal_menu_view.dart';
import '../../app/modules/members/view/add_members_view.dart';
import '../../app/modules/members/view/members_list_view.dart';
import '../../app/modules/plants/view/plant_list_view.dart';
import '../../app/modules/plants/view/plant_members_list_view.dart';
import '../../app/modules/profile/view/profile_view.dart';
import '../../app/modules/reports/meals/view/meals_reports_views.dart';
import 'routes_name.dart';

class HAppRoutes {
  // This is the initial route of your app
  static const initial = HRoutesName.splash;

  // App pages configuration
  static final routes = [
    // Auth Pages
    GetPage(name: HRoutesName.splash, page: () => const SplashView()),
    GetPage(name: HRoutesName.login, page: () => const LoginView()),
    GetPage(name: HRoutesName.profile, page: () => const ProfileView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.dashboard, page: () => const DashboardView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.plantList, page: () => const PlantListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.addMeals, page: () => const AddMealMenuView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.addMembers, page: () => const AddMembersView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.membersList, page: () => const MembersListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.mealsList, page: () => const MealsMenuListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.mealsReports, page: () => const MealsReportsView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.addMealsRequest, page: () => const AddMealRequestView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.plantsMembersList, page: () => const PlantMembersListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.mealsRequestList, page: () => const MealsRequestListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.employeeList, page: () => const EmployeesListView(), middlewares: [RoleMiddleware()]),
    GetPage(name: HRoutesName.addEmployee, page: () => const AddEmployeesView(), middlewares: [RoleMiddleware()]),

    // Access Denied Route
    GetPage(name: HRoutesName.accessDenied, page: () => const AccessDeniedView()),

    // Default route for undefined routes
    GetPage(
      name: HRoutesName.notFound,
      page: () => Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Screen does not exist: ${Get.currentRoute}', style: const TextStyle(fontSize: 18))),
      ),
    ),
  ];
}
