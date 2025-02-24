import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:canteen_app/core/utils/constants/enums/enums.dart';

class RolePermissions {
  static const List<String> routes = [
    HRoutesName.splash,
    HRoutesName.login,
    HRoutesName.dashboard,
    HRoutesName.mealsRequestList,
    HRoutesName.addMeals,
    HRoutesName.addMealsRequest,
    HRoutesName.mealsList,
    HRoutesName.mealsReports,
    HRoutesName.profile,
    HRoutesName.plantList,
    HRoutesName.plantsMembersList,
    HRoutesName.addMembers,
    HRoutesName.membersList,
    HRoutesName.employeeList,
    HRoutesName.addEmployee,
  ];
  static const Map<UserRole, List<String>> roleBasedViews = {
    UserRole.ADMIN: routes,
    UserRole.MANAGER: routes,
    UserRole.CONTRACTOR: routes,
    UserRole.EMPLOYEE: [
      HRoutesName.splash,
      HRoutesName.login,
      HRoutesName.dashboard,
      HRoutesName.mealsRequestList,
      HRoutesName.addMealsRequest,
    ],
  };
}
