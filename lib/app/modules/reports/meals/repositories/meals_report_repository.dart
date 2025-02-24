import 'package:canteen_app/app/data/models/column_model.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/helpers/logger.dart';
import '../../../../data/models/network/reports/meals_reports_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/base_repository.dart';
import '../../../../data/services/network_db/api_endpoint.dart';
import '../../../../data/services/network_db/api_service.dart';

typedef MealsReportRecord = ({List<MealsReportsModel> mealss, List<ColumnModel> columns});

class MealsReportRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Get Daily Meals Report
  Future<ResponseModel<MealsReportRecord>> getDailyMealsReport({String? endDate, String? startDate, bool isDaily = true}) async {
    try {
      final queryParams = {
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
      };
      final ResponseModel response = await _apiService.get(ApiEndpoints.getMealsReports, queryParams: queryParams);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final reportRecord = (mealss: transformList(responseData['data'], MealsReportsModel.fromJson), columns: transformList(responseData['headers'], ColumnModel.fromJson));

        return ResponseModel<MealsReportRecord>(success: true, message: response.message ?? 'Mealss retrieved from api', data: reportRecord);
      }

      return ResponseModel.error(response.message ?? 'Failed to get mealss');
    } catch (e) {
      HLoggerHelper.error('Error getting mealss: $e');
      return ResponseModel.error('Failed to get mealss: $e');
    }
  }
}
