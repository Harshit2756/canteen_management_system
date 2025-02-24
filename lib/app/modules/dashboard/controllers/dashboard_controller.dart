import 'package:canteen_app/app/data/models/network/auth/user_model.dart';
import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/snackbar/snackbars.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/network/dashboard/dashboard_summary_model.dart';
import '../../../data/models/network/dashboard/visitor_dashboard_model.dart';
import '../repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  static DashboardController get instance =>
      Get.find<DashboardController>(tag: 'dashboard_controller');

  /// dashboard repo
  final _dashboardRepository = Get.isRegistered<DashboardRepository>()
      ? Get.find<DashboardRepository>()
      : Get.put(DashboardRepository());

  /// Variables
  final isLoading = false.obs;
  late final AuthService _authService;
  late final UserModel? user;
  final columns = <ColumnModel>[].obs;
  final searchController = SearchController();

  final summary = DashboardSummaryModel(
          todayVisitCount: 0,
          pendingRequestCount: 0,
          monthlyVisitsCount: 0,
          approvedVisitsCount: 0)
      .obs;
  final allVisitorList = <VisitorDashboardModel>[].obs;
  final filteredVisitorList = <VisitorDashboardModel>[].obs;
  final RxInt sortColumnIndex = 0.obs;
  final RxBool sortAscending = true.obs;

  AuthService get authService => _authService;

  /// Get All Dashboard Data
  Future<void> getDashboardData({bool isFromApi = true}) async {
    isLoading.value = true;
    try {
      final response =
          await _dashboardRepository.getAllDashboardData(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Visitors: ${response.data}');
        columns.value = response.data?.columns ?? [];
        summary.value = response.data?.summary ??
            DashboardSummaryModel(
                todayVisitCount: 0,
                pendingRequestCount: 0,
                monthlyVisitsCount: 0,
                approvedVisitsCount: 0);
        allVisitorList.value = response.data?.visitors ?? [];

        searchVisitor('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting visitors: $e');
      HSnackbars.showSnackbar(
          type: SnackbarType.error, message: 'Failed to load visitors');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  void logout() async {
    try {
      await _authService.logout();
      Get.offAllNamed(HRoutesName.login);
    } catch (e) {
      HLoggerHelper.error("Logout failed: $e");
    }
  }

  @override
  void onClose() {
    if (searchController.hasListeners) {
      searchController.removeListener(searchListener);
    }
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    user = _authService.currentUser;
    searchController.addListener(searchListener);
    getDashboardData();
  }

  void searchListener() {
    searchVisitor(searchController.text);
  }

  /// Filter Visitors based on search query
  void searchVisitor(String query) {
    if (query.isEmpty) {
      filteredVisitorList.value = allVisitorList;
    } else {
      filteredVisitorList.value = allVisitorList.where((visitor) {
        return visitor.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  /// Sort labours by column
  void sortVisitors(String? field, bool ascending) {
    if (field == null) return;
    allVisitorList.sort((a, b) {
      final aValue = a.toJson()[field];

      final bValue = b.toJson()[field];
      if (aValue == null || bValue == null) return 0;
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
  }
}
