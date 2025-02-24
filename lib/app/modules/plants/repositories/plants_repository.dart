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
import '../../../data/models/local/member_id_model.dart';
import '../../../data/models/network/member/member_model.dart';
import '../../../data/models/network/plants/plants_model.dart';

typedef PlantsResponse = ({
  List<PlantsModel> plants,
  List<ColumnModel> columns,
});

class PlantsRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add Member to Plant
  Future<ResponseModel> addMemberToPlant(String id, Map<String, dynamic> member) async {
    try {
      final ResponseModel response = await _apiService.post(ApiEndpoints.addMemberToPlant(id), member);
      if (response.success) {
        HLoggerHelper.debug("Member added to Plant successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to add Member to Plant');
    } catch (e) {
      HLoggerHelper.error('Error adding Member to Plant: $e');
      return ResponseModel.error('Failed to add Member to Plant');
    }
  }

  /// Add Plant
  Future<ResponseModel> addPlants(Map<String, dynamic> plant) async {
    final ResponseModel response = await _apiService.post(ApiEndpoints.addPlants, plant);
    if (response.success) {
      HLoggerHelper.debug("response.data : ${response.data}]");
      return response;
    }

    return ResponseModel.error(response.message ?? 'Failed to add Plant');
  }

  /// Delete Plant
  Future<ResponseModel> deletePlants(String id) async {
    try {
      final ResponseModel response = await _apiService.delete<Map<String, dynamic>>(
        ApiEndpoints.deletePlants(id),
      );

      if (response.success) {
        HLoggerHelper.debug("Plant deleted successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to delete Plant');
    } catch (e) {
      HLoggerHelper.error('Error deleting Plant: $e');

      return ResponseModel.error('Failed to delete Plant');
    }
  }

  // Get all Plants
  Future<ResponseModel<PlantsResponse>> getAllPlants({bool isFromApi = false}) async {
    if (isFromApi) {
      return await _getPlantsFromApi();
    }
    try {
      final List<PlantsModel>? plants = _storageService.read<List<PlantsModel>?>(StorageKeys.plantList);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.plantColumns);

      if (plants != null && plants.isNotEmpty && columns != null && columns.isNotEmpty) {
        HLoggerHelper.info('Plants: $plants');
        return ResponseModel<PlantsResponse>(
          success: true,
          message: 'Plants retrieved from storage',
          data: (plants: plants, columns: columns),
        );
      } else {
        return await _getPlantsFromApi();
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Plants: $e');

      return ResponseModel.error('Failed to get Plants');
    }
  }

  Future<ResponseModel<List<Map<String, MemberIdModel>>>> getMemberIdList({String userType = 'MANAGER', String? search, bool isFromApi = false}) async {
    try {
      if (isFromApi) {
        return await _getMemberIdListFromApi(userType: userType, search: search);
      }
      final List<Map<String, MemberIdModel>>? memberIdList = _storageService.read(StorageKeys.memberIdList);

      if (memberIdList != null) {
        return ResponseModel.success(memberIdList, 'Member ID list retrieved from storage');
      } else {
        return await _getMemberIdListFromApi(userType: userType, search: search);
      }
    } catch (e) {
      HLoggerHelper.error('Error getting users: $e');
      return ResponseModel.error('Failed to get users: $e');
    }
  }

  /// Remove Member from Plant
  Future<ResponseModel> removeMemberFromPlant(String id, String memberId) async {
    try {
      final ResponseModel response = await _apiService.delete(ApiEndpoints.removeMemberFromPlant(id, memberId));
      if (response.success) {
        HLoggerHelper.debug("Member removed from Plant successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to remove Member from Plant');
    } catch (e) {
      HLoggerHelper.error('Error removing Member from Plant: $e');
      return ResponseModel.error('Failed to remove Member from Plant');
    }
  }

  /// Update Plant
  Future<ResponseModel> updatePlants(String id, Map<String, dynamic> plant) async {
    try {
      final ResponseModel response = await _apiService.put(ApiEndpoints.updatePlants(id), plant);
      if (response.success) {
        HLoggerHelper.debug("Plant updated successfully");
        return response;
      }

      return ResponseModel.error(response.message ?? 'Failed to update Plant');
    } catch (e) {
      HLoggerHelper.error('Error updating Plant: $e');
      return ResponseModel.error('Failed to update Plant');
    }
  }

  /// Get Contactor id List from API
  Future<ResponseModel<List<Map<String, MemberIdModel>>>> _getMemberIdListFromApi({required String userType, String? search}) async {
    try {
      final ResponseModel response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.getAllMember,
        queryParams: {
          'user_type': userType,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final List<MemberModel> users = transformList(
          responseData['data'],
          MemberModel.fromJson,
        );
        // Save the contractor id list to local storage
        List<Map<String, MemberIdModel>> memberIdList = [];
        if (users.isNotEmpty) {
          List<Map<String, MemberIdModel>> idList = DataTransform.transformMemberIdList(users);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, dynamic>>>(StorageKeys.memberIdList, idList);
          memberIdList = idList;
          HLoggerHelper.debug('idList: ${memberIdList[0]}');
        }

        return ResponseModel<List<Map<String, MemberIdModel>>>(
          success: true,
          message: response.message ?? 'Users retrieved from api',
          data: memberIdList,
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get contractors');
    } catch (e) {
      HLoggerHelper.error('Error getting contractors from api: $e');

      return ResponseModel.error('Failed to get contractors from api: $e');
    }
  }

  /// Get Plants from api
  Future<ResponseModel<PlantsResponse>> _getPlantsFromApi() async {
    try {
      final ResponseModel response = await _apiService.get(
        ApiEndpoints.getAllPlants,
      );

      if (response.success && response.data != null) {
        final responseData = response.data as List<dynamic>;

        final List<PlantsModel> plants = transformList(
          responseData,
          PlantsModel.fromJson,
        );
        final List<ColumnModel> columns = [
          ColumnModel(field: 'name', headerName: 'Name'),
          ColumnModel(field: 'code', headerName: 'Code'),
          ColumnModel(field: 'plantHead', headerName: 'Plant Head'),
          ColumnModel(field: 'plantHeadId', headerName: 'Plant Head ID'),
          ColumnModel(field: '_count', headerName: 'Total Members'),
          ColumnModel(field: 'Button', headerName: 'Edit/Delete'),
        ];
        _storageService.write(StorageKeys.plantColumns, columns);
        _storageService.write(StorageKeys.plantList, plants);

        // Store Plant Ids
        if (plants.isNotEmpty) {
          List<Map<String, dynamic>> idList = DataTransform.transformPlantsList(plants);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, dynamic>>>(StorageKeys.plantIdList, idList);
        }
        return ResponseModel<PlantsResponse>(
          success: true,
          message: response.message ?? 'Plants retrieved from api',
          data: (plants: plants, columns: columns),
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get Plants');
    } catch (e) {
      HLoggerHelper.error('Error getting Plants: $e');
      return ResponseModel.error('Failed to get Plants');
    }
  }
}
