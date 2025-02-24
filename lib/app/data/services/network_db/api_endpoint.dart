class ApiEndpoints {
  // static const String baseUrl ='http://ec2-15-207-115-92.ap-south-1.compute.amazonaws.com:3000/api/v1';
  static const String baseUrl = 'https://15.207.115.92.nip.io/api/v1';
  //* Auth Endpoints
  static const String login = '$baseUrl/auth/login';

  //* Dashboard
  static const String getDashboardData = '$baseUrl/dashboard/summary';

  //* Curd User
  static const String addMember = '$baseUrl/users';
  static const String getAllMember = '$baseUrl/users';
  static const String getMemberWithPassword = '$baseUrl/users/with-password';

  //* Crud Employee
  static const String addEmployee = '$baseUrl/users';
  static const String getAllEmployee = '$baseUrl/users';

  //* crud plant
  static const String addPlants = '$baseUrl/plants';
  static const String getAllPlants = '$baseUrl/plants';
  static const String deleteMeals = '$baseUrl/manager/mealss';

  /// {url}/plantId/members
  static String addMemberToPlant(String plantId) {
    return '$baseUrl/plants/$plantId/members';
  }

  /// {url}/id for specific plant
  static String deletePlants(String id) {
    return '$baseUrl/plants/$id';
  }

  /// {url}/plantId/members/{memberId}
  static String removeMemberFromPlant(String plantId, String memberId) {
    return '$baseUrl/plants/$plantId/members/$memberId';
  }

  /// {url}/id for specific plant
  static String updatePlants(String id) {
    return '$baseUrl/plants/$id';
  }

  /// {url}/username for specific user
  static String getMember(String username) {
    return '$baseUrl/user/$username';
  }

  //* crud Meals
  static const String addMealRequest = '$baseUrl/meals/request';
  static const String getAllMealsRequest = '$baseUrl/meals/request';
  static const String updateMeals = '$baseUrl/meals/';
  static const String getAllMeals = '$baseUrl/meals';
  static const String addMeals = '$baseUrl/meals';

  /// {url}/ticketId/entry
  static String processMealsEntry(String mealId) {
    return '$baseUrl/meals/request/$mealId/entry';
  }

  /// {url}/ticketId/process
  static String updateMealStatus(String mealId) {
    return '$baseUrl/meals/request/$mealId/process';
  }

  //* Reports
  static const String getMealsReports = '$baseUrl/meals/records';
}
