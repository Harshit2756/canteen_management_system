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
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/employee/employee_model.dart';
import '../../../data/models/network/plants/plants_model.dart';

typedef EmployeeResponse = ({
  List<EmployeeModel> employees,
  List<ColumnModel> columns,
});

class EmployeeRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add User
  Future<ResponseModel> addEmployee(Map<String, dynamic> employee) async {
    final ResponseModel response = await _apiService.post(ApiEndpoints.addEmployee, employee);
    if (response.success) {
      HLoggerHelper.debug("response.data : ${response.data}]");
      return response;
    }

    return ResponseModel.error(response.message ?? 'Failed to add User');
  }

  /// Get all Visitors
  Future<ResponseModel<EmployeeResponse>> getAllEmployees({bool isFromApi = false, String userType = 'EMPLOYEE'}) async {
    if (isFromApi) {
      return await _getUserFromApi(userType: userType);
    }
    try {
      final List<EmployeeModel>? employees = _storageService.read<List<EmployeeModel>?>(StorageKeys.employeeList);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.employeeColumns);
      if (employees != null && employees.isNotEmpty && columns != null && columns.isNotEmpty) {
        HLoggerHelper.info('Users: $employees');
        return ResponseModel.success((employees: employees, columns: columns), 'Users retrieved from storage');
      } else {
        return await _getUserFromApi(userType: userType);
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Visitors: $e');

      return ResponseModel.error('Failed to get Visitors');
    }
  }

  /// Get Visitors from api
  Future<ResponseModel<EmployeeResponse>> _getUserFromApi({String? userType}) async {
    try {
      final queryParams = {if (userType != null && userType.isNotEmpty) 'user_type': userType};

      final ResponseModel response = await _apiService.get(ApiEndpoints.getAllEmployee, queryParams: queryParams);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final List<EmployeeModel> employees = transformList(responseData['data'], EmployeeModel.fromJson);
        final List<ColumnModel> columns = transformList(responseData['headers'], ColumnModel.fromJson);

        _storageService.write(StorageKeys.employeeList, employees);
        _storageService.write(StorageKeys.employeeColumns, columns);

        return ResponseModel<EmployeeResponse>(
          success: true,
          message: response.message ?? 'Users retrieved from api',
          data: (employees: employees, columns: columns),
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get Users');
    } catch (e) {
      HLoggerHelper.error('Error getting Users: $e');
      return ResponseModel.error('Failed to get Users');
    }
  }

  /// Get Contactor id List
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

  /// Get Contactor id List from API
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

  // /// Delete User
  // Future<ResponseModel> deleteUser(String username) async {
  //   try {
  //     final ResponseModel response = await _apiService.delete<Map<String, dynamic>>(
  //       '${ApiEndpoints.deleteUser}/$username',
  //     );
  //     if (response.success) {
  //       HLoggerHelper.debug("User deleted successfully");
  //       return response;
  //     }
  //     return ResponseModel.error(response.message ?? 'Failed to delete User');
  //   } catch (e) {
  //     HLoggerHelper.error('Error deleting User: $e');
  //     return ResponseModel.error('Failed to delete User');
  //   }
  // }
  // /// Update Visitor
  // Future<ResponseModel> updateUser(String username, Map<String, dynamic> user) async {
  //   try {
  //     final ResponseModel response = await _apiService.put<Map<String, dynamic>>(
  //       '${ApiEndpoints.updateUser}/$username',
  //       user,
  //     );
  //     if (response.success) {
  //       HLoggerHelper.debug("User updated successfully");
  //       return response;
  //     }
  //     return ResponseModel.error(response.message ?? 'Failed to update User');
  //   } catch (e) {
  //     HLoggerHelper.error('Error updating User: $e');
  //     return ResponseModel.error('Failed to update User');
  //   }
  // }
}
