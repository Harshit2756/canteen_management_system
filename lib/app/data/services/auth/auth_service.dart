/// Authentication service
///
/// Purpose:
/// - Manage auth state
/// - Handle user session
/// - Provide auth utilities
library;

import 'package:canteen_app/app/data/models/response_model.dart';
import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:canteen_app/core/utils/constants/enums/enums.dart';
import 'package:canteen_app/core/utils/constants/extension/formatter.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../models/network/auth/user_model.dart';
import '../../../modules/auth/repositories/auth_repository.dart';
import '../base_service.dart';

class AuthService extends BaseService {
  static AuthService get instance => Get.find();

  final AuthRepository _repository = Get.find<AuthRepository>();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final Rx<String?> _token = Rx<String?>(null);

  UserModel? get currentUser => _currentUser.value;

  bool get isLoggedIn => _currentUser.value != null;
  bool get isTokenExpired =>
      token.isNotEmpty ? JwtDecoder.isExpired(token) : false;
  String get role => _currentUser.value?.role ?? '';
  String get token => _token.value ?? '';
  UserRole? get userRole => role.toUserRoleEnum();

  /// Method to handle route redirection
  String handleRouteRedirection() {
    if (isLoggedIn && !isTokenExpired) {
      return HRoutesName.dashboard;
    } else {
      if (isTokenExpired) {
        HSnackbars.showSnackbar(
            type: SnackbarType.warning,
            message: "The Session Was Expired ,login again");
      }
      return HRoutesName.login;
    }
  }

  Future<ResponseModel> login(String username, String password) async {
    final response = await _repository.login(username, password);
    if (response.success && response.data != null) {
      _currentUser.value = response.data;
      _token.value = _repository.getUserToken();
      return response;
    }
    return ResponseModel.error(response.message!);
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(HRoutesName.login);
    });
  }

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _currentUser.value = _repository.getCurrentUser();
    _token.value = _repository.getUserToken();
    _repository.updateHeader();
  }
}
