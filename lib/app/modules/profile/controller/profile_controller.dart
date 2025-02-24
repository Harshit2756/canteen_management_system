import 'package:canteen_app/app/data/models/network/auth/user_model.dart';
import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService.instance;

  // Observable user model
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Method to check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn;

  // Method to get user role
  String get userRole => _authService.role;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  // Load user details from AuthService
  Future<void> _loadUser() async {
    user.value = _authService.currentUser;
  }
}
