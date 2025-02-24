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
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/meals/meals_menu_model.dart';
import '../../../data/models/network/meals/meals_request_model.dart';
import '../../../data/models/network/plants/plants_model.dart';

typedef MealsRequestResponse = ({
  List<MealsRequestModel> meals,
  List<ColumnModel> columns,
});

class MealsRequestRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add Meal Request
  Future<ResponseModel> addMealRequest(Map<String, dynamic> mealRequest) async {
    final ResponseModel response = await _apiService.post<Map<String, dynamic>>(ApiEndpoints.addMealRequest, mealRequest);
    if (response.success) {
      HLoggerHelper.debug("response.data : ${response.data}]");
      return response;
    }

    return ResponseModel.error(response.message ?? 'Login failed');
  }

  /// Get all Meal Request
  Future<ResponseModel<MealsRequestResponse>> getAllMealsRequest({bool isFromApi = false, String? status}) async {
    if (isFromApi) {
      return await _getMealsRequestFromApi(status: status);
    }
    try {
      final List<MealsRequestModel>? meals = _storageService.read<List<MealsRequestModel>?>(StorageKeys.mealsRequestList);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.mealsRequestColumns);
      if (meals != null && meals.isNotEmpty && columns != null && columns.isNotEmpty) {
        HLoggerHelper.info('Meals: $meals');
        return ResponseModel.success(
          (meals: meals, columns: columns),
          'Meals retrieved from storage',
        );
      } else {
        return await _getMealsRequestFromApi(status: status);
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Meals: $e');

      return ResponseModel.error('Failed to get Meals');
    }
  }

  /// Get Meals Request from api
  Future<ResponseModel<MealsRequestResponse>> _getMealsRequestFromApi({String? status}) async {
    try {
      final queryParams = {
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final ResponseModel response = await _apiService.get(ApiEndpoints.getAllMealsRequest, queryParams: queryParams);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final List<MealsRequestModel> meals = transformList(responseData['data'], MealsRequestModel.fromJson);
        final List<ColumnModel> columns = responseData['headers'] != null ? transformList(responseData['headers'], ColumnModel.fromJson) : [];

        _storageService.write(StorageKeys.mealsRequestList, meals);
        _storageService.write(StorageKeys.mealsRequestColumns, columns);
        // Save the list of Meals to storage

        return ResponseModel<MealsRequestResponse>(success: true, message: response.message ?? 'Meals retrieved from api', data: (meals: meals, columns: columns));
      }

      return ResponseModel.error(response.message ?? 'Failed to get Meals');
    } catch (e) {
      HLoggerHelper.error('Error getting Meals: $e');
      return ResponseModel.error('Failed to get Meals');
    }
  }

  /// Get Plants Id Listv
  Future<ResponseModel<List<Map<String, PlantsIdModel>>>> getPlantsIdList({String? search, bool isFromApi = false}) async {
    try {
      if (isFromApi) {
        return await _getPlantsIdListFromApi();
      }
      final List<Map<String, PlantsIdModel>>? plantsIdList = _storageService.read(StorageKeys.plantIdList);

      if (plantsIdList != null) {
        return ResponseModel.success(plantsIdList, 'Plants ID list retrieved from storage');
      } else {
        return await _getPlantsIdListFromApi();
      }
    } catch (e) {
      HLoggerHelper.error('Error getting plants: $e');
      return ResponseModel.error('Failed to get plants: $e');
    }
  }

  /// Get Plants Id List from API
  Future<ResponseModel<List<Map<String, PlantsIdModel>>>> _getPlantsIdListFromApi() async {
    try {
      final ResponseModel response = await _apiService.get(ApiEndpoints.getAllPlants);

      if (response.success && response.data != null) {
        final responseData = response.data as List<dynamic>;

        final List<PlantsModel> plants = transformList(responseData, PlantsModel.fromJson);
        List<Map<String, PlantsIdModel>> plantsIdList = [];
        if (plants.isNotEmpty) {
          List<Map<String, PlantsIdModel>> idList = DataTransform.transformPlantsList(plants);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, dynamic>>>(StorageKeys.plantIdList, idList);
          plantsIdList = idList;
          HLoggerHelper.debug('idList: ${plantsIdList[0]}');
        }

        return ResponseModel<List<Map<String, PlantsIdModel>>>(
          success: true,
          message: response.message ?? 'Plants retrieved from api',
          data: plantsIdList,
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get contractors');
    } catch (e) {
      HLoggerHelper.error('Error getting contractors from api: $e');

      return ResponseModel.error('Failed to get contractors from api: $e');
    }
  }

  /// Get Meals Id List
  Future<ResponseModel<List<Map<String, MealsIdModel>>>> getMealsIdList({bool isFromApi = false}) async {
    try {
      if (isFromApi) {
        return await _getMealsIdListFromApi();
      }
      final List<Map<String, MealsIdModel>>? mealIdList = _storageService.read(StorageKeys.mealIdList);

      if (mealIdList != null) {
        return ResponseModel.success(mealIdList, 'Plants ID list retrieved from storage');
      } else {
        return await _getMealsIdListFromApi();
      }
    } catch (e) {
      HLoggerHelper.error('Error getting meals: $e');
      return ResponseModel.error('Failed to get meals: $e');
    }
  }

  /// Get Meals Id List from API
  Future<ResponseModel<List<Map<String, MealsIdModel>>>> _getMealsIdListFromApi() async {
    try {
      final ResponseModel response = await _apiService.get(ApiEndpoints.getAllMeals);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final List<MealsMenuModel> meals = transformList(responseData['data'], MealsMenuModel.fromJson);
        List<Map<String, MealsIdModel>> mealsIdList = [];
        if (meals.isNotEmpty) {
          List<Map<String, MealsIdModel>> idList = DataTransform.transformMealsList(meals);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, dynamic>>>(StorageKeys.mealIdList, idList);
          mealsIdList = idList;
          HLoggerHelper.debug('idList: ${mealsIdList[0]}');
        }

        return ResponseModel<List<Map<String, MealsIdModel>>>(
          success: true,
          message: response.message ?? 'Plants retrieved from api',
          data: mealsIdList,
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get contractors');
    } catch (e) {
      HLoggerHelper.error('Error getting contractors from api: $e');

      return ResponseModel.error('Failed to get contractors from api: $e');
    }
  }

  /// Process Meals Entry
  Future<ResponseModel> processMealsEntry(String mealId) async {
    try {
      final ResponseModel response = await _apiService.post(ApiEndpoints.processMealsEntry(mealId), null);

      if (response.success) {
        HLoggerHelper.debug("Visitor entry updated successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to update Visitor entry');
    } catch (e) {
      HLoggerHelper.error('Error updating Visitor entry: $e');

      return ResponseModel.error('Failed to update Visitor entry');
    }
  }

  /// process Meals status
  Future<ResponseModel> processMealstatus(String mealId, Map<String, dynamic> meal) async {
    try {
      final ResponseModel response = await _apiService.put<Map<String, dynamic>>(ApiEndpoints.updateMealStatus(mealId), meal);

      if (response.success) {
        HLoggerHelper.debug("Visitor status updated successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to update Visitor status');
    } catch (e) {
      HLoggerHelper.error('Error updating Visitor status: $e');

      return ResponseModel.error('Failed to update Visitor status');
    }
  }
}
