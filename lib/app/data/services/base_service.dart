/// Base service with common functionality
///
/// Purpose:
/// - Define common service methods
/// - Handle service initialization
/// - Manage service state
library;

import 'package:get/get.dart';

abstract class BaseService extends GetxService {
  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  @override
  void onClose() {
    _isInitialized.value = false;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _isInitialized.value = true;
  }
}
