/// Application route constants
///
/// Purpose:
/// - Define all route names
/// - Provide type-safe route access
/// - Centralize route naming
library;

abstract class HRoutesName {
  // -- notFound
  static const notFound = "/not-found";

  // -- Auth Routes
  static const splash = '/';
  static const login = '/login';
  static const profile = '/profile';
  static const logout = '/logout';

  // -- Role Routes
  static const dashboard = '/dashboard';

  // -- Dashboard Routes
  static const mealsRequestList = '/meals-request-list';
  static const addMealsRequest = '/add-meals-request';
  static const mealsList = '/meals-list';
  static const addMeals = '/add-meals';

  // -- Members Routes
  static const addMembers = '/add-members';
  static const membersList = '/members-list';

  // -- Employees Routes
  static const employeeList = '/employee-list';
  static const addEmployee = '/add-employee';

  // -- Plants Routes
  static const plantList = '/plant-list';
  static const plantsMembersList = '/plants-members-list';

  // -- Access Denied
  static const accessDenied = '/access-denied';

  // -- Report Routes
  static const mealsReports = '/visitor-report-details';
}
