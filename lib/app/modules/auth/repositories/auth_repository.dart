/// Authentication repository
///
/// Purpose:
/// - handle api requests
/// - Handle auth business logic
/// - Transform auth data
/// - Cache auth state
/// Repositories add a layer of abstraction between services and controllers. They handle business logic and data transformation.

import 'package:get/get.dart';

import '../../../../core/utils/helpers/logger.dart';
import '../../../data/models/network/auth/user_model.dart';
import '../../../data/models/response_model.dart';
import '../../../data/services/local_db/storage_keys.dart';
import '../../../data/services/local_db/storage_service.dart';
import '../../../data/services/network_db/api_endpoint.dart';
import '../../../data/services/network_db/api_service.dart';
import '../../../data/repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = Get.find<ApiService>();

  UserModel? getCurrentUser() {
    final value =
        _storageService.read<Map<String, dynamic>>(StorageKeys.currentUser);
    UserModel? user = value != null ? UserModel.fromJson(value) : null;
    HLoggerHelper.debug("Retrieved current user: ${user?.toJson()}");
    return user;
  }

  String? getUserToken() {
    final token = _storageService.read<String>(StorageKeys.userToken);
    HLoggerHelper.debug("Retrieved user token: $token");
    return token;
  }

  Future<ResponseModel<UserModel>> login(
      String username, String password) async {
    HLoggerHelper.info("Attempting to log in user: $username");
    final ResponseModel response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.login, {"username": username, "password": password});

    HLoggerHelper.debug("response: $response]");
    if (response.success && response.data != null) {
      final Map<String, dynamic> userData = response.data!['user'];
      final UserModel user = UserModel.fromJson(userData);
      await _storageService.write<Map<String, dynamic>>(
          StorageKeys.currentUser, user.toJson());

      await setUserToken(response.data!['accessToken']);

      HLoggerHelper.info("User logged in successfully: ${user.username}");
      return ResponseModel.success(
          user, response.data!['message'] ?? 'Login successful');
    }

    HLoggerHelper.error("Login failed: ${response.message ?? 'Unknown error'}");
    return ResponseModel.error(response.message ?? 'Login failed');
  }

  Future<ResponseModel<bool>> logout() async {
    await _storageService.clear();
    HLoggerHelper.info("User logged out successfully.");
    return ResponseModel.success(true, 'Logout successful');
  }

  Future<void> setUserToken(String token) async {
    await _storageService.write<String>(StorageKeys.userToken, token);
    _apiService.setAuthToken(token);
    HLoggerHelper.debug("Retrieved user token: $token");
  }

  void updateHeader() {
    final String? token = getUserToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      HLoggerHelper.debug("Updated API header with token: $token");
    } else {
      HLoggerHelper.info("No token found to update API header.");
    }
  }
}
