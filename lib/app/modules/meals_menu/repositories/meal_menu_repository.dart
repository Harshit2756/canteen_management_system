import 'package:canteen_app/app/data/models/response_model.dart';
import 'package:canteen_app/app/data/repositories/base_repository.dart';
import 'package:canteen_app/app/data/services/local_db/storage_keys.dart';
import 'package:canteen_app/app/data/services/local_db/storage_service.dart';
import 'package:canteen_app/app/data/services/network_db/api_endpoint.dart';
import 'package:canteen_app/app/data/services/network_db/api_service.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../core/utils/helpers/data_transform.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/local/meals_id_mode.dart';
import '../../../data/models/network/meals/meals_menu_model.dart';

typedef MealsMenuResponse = ({
  List<MealsMenuModel> meals,
  List<ColumnModel> columns,
});

class MealsMenuRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add Meal Menu
  Future<ResponseModel> addMealMenu(Map<String, dynamic> mealMenu) async {
    final ResponseModel response = await _apiService.post(ApiEndpoints.addMeals, mealMenu);
    if (response.success) {
      HLoggerHelper.debug("response.data : ${response.data}]");
      return response;
    }

    return ResponseModel.error(response.message ?? 'Login failed');
  }

  /// Get all Meal Menu
  Future<ResponseModel<MealsMenuResponse>> getAllMealsMenu({bool isFromApi = false}) async {
    if (isFromApi) {
      return await _getMealsMenuFromApi();
    }
    try {
      final List<MealsMenuModel>? meals = _storageService.read<List<MealsMenuModel>?>(StorageKeys.mealsList);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.mealsColumns);
      if (meals != null && meals.isNotEmpty && columns != null && columns.isNotEmpty) {
        HLoggerHelper.info('Meals: $meals');
        return ResponseModel.success((meals: meals, columns: columns), 'Meals retrieved from storage');
      } else {
        return await _getMealsMenuFromApi();
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Meals: $e');

      return ResponseModel.error('Failed to get Meals');
    }
  }

  /// Get Meals Menu from api
  Future<ResponseModel<MealsMenuResponse>> _getMealsMenuFromApi() async {
    try {
      final ResponseModel response = await _apiService.get(ApiEndpoints.getAllMeals);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final List<MealsMenuModel> meals = transformList(responseData['data'], MealsMenuModel.fromJson);

        final List<ColumnModel> columns = transformList(responseData['headers'], ColumnModel.fromJson);

        _storageService.write(StorageKeys.mealsList, meals);
        _storageService.write(StorageKeys.mealsColumns, columns);

        if (meals.isNotEmpty) {
          List<Map<String, MealsIdModel>> idList = DataTransform.transformMealsList(meals);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, MealsIdModel>>>(StorageKeys.mealIdList, idList);
        }
        return ResponseModel<MealsMenuResponse>(
          success: true,
          message: response.message ?? 'Meals retrieved from api',
          data: (meals: meals, columns: columns),
          // pagination: paginationData,
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get Meals');
    } catch (e) {
      HLoggerHelper.error('Error getting Meals: $e');
      return ResponseModel.error('Failed to get Meals');
    }
  }
}
