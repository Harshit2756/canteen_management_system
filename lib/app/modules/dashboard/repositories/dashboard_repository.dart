import 'package:canteen_app/app/data/models/response_model.dart';
import 'package:canteen_app/app/data/repositories/base_repository.dart';
import 'package:canteen_app/app/data/services/local_db/storage_keys.dart';
import 'package:canteen_app/app/data/services/local_db/storage_service.dart';
import 'package:canteen_app/app/data/services/network_db/api_endpoint.dart';
import 'package:canteen_app/app/data/services/network_db/api_service.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../data/models/column_model.dart';
import '../../../data/models/network/dashboard/dashboard_summary_model.dart';
import '../../../data/models/network/dashboard/visitor_dashboard_model.dart';

typedef DashboardData = ({
  List<VisitorDashboardModel> visitors,
  List<ColumnModel> columns,
  DashboardSummaryModel summary,
});

class DashboardRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Get all Dashboard Data
  Future<ResponseModel<DashboardData>> getAllDashboardData({
    bool isFromApi = false,
    String? status,
  }) async {
    if (isFromApi) {
      return await _getDashboardDataFromApi();
    }
    try {
      final List<VisitorDashboardModel>? visitors = _storageService.read<List<VisitorDashboardModel>?>(StorageKeys.visitorDashboardList);
      final DashboardSummaryModel? summary = _storageService.read<DashboardSummaryModel?>(StorageKeys.dashboardSummary);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.columnDashboardList);
      if (visitors != null && visitors.isNotEmpty && summary != null && columns != null) {
        HLoggerHelper.info('Visitors: $visitors');
        return ResponseModel.success(
          (summary: summary, visitors: visitors, columns: columns),
          'Dashboard data retrieved from storage',
        );
      } else {
        return await _getDashboardDataFromApi();
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Visitors: $e');
      return ResponseModel.error('Failed to get Visitors');
    }
  }

  /// Get Visitors from api
  Future<ResponseModel<DashboardData>> _getDashboardDataFromApi() async {
    try {
      final ResponseModel<Map<String, dynamic>> response = await _apiService.get<Map<String, dynamic>>(ApiEndpoints.getDashboardData);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        HLoggerHelper.info('Response Data: $responseData');

        final DashboardSummaryModel summary = DashboardSummaryModel.fromJson(responseData['summary']);
        final List<ColumnModel> columns = responseData['columnModel'] != null ? transformList(responseData['columnModel'], ColumnModel.fromJson) : [];
        final List<VisitorDashboardModel> visitors = responseData['todayVisits'] != null ? transformList(responseData['todayVisits'], VisitorDashboardModel.fromJson) : [];

        _storageService.write(StorageKeys.visitorDashboardList, visitors);
        _storageService.write(StorageKeys.dashboardSummary, summary);
        _storageService.write(StorageKeys.columnDashboardList, columns);

        return ResponseModel.success(
          (summary: summary, visitors: visitors, columns: columns),
          'Dashboard data retrieved from api',
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get Visitors');
    } catch (e) {
      HLoggerHelper.error('Error getting Visitors from api: $e');
      return ResponseModel.error('Failed to get Visitors');
    }
  }
}
