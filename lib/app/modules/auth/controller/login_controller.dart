import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// Focus Nodes
  late final usernameFocusNode = FocusNode();
  late final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      final response = await _authService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.success) {
        Get.offAllNamed(_authService.handleRouteRedirection());
        HSnackbars.showSnackbar(
            type: SnackbarType.success, message: response.message!);
      }
    } catch (e) {
      HLoggerHelper.error("Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() => hidePassword.toggle();

  bool _validateInputs() {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }
    return true;
  }
}
