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
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/member/member_model.dart';
import '../../../data/models/network/plants/plants_model.dart';

typedef MemberResponse = ({
  List<MemberModel> members,
  List<ColumnModel> columns,
});

class MemberRepository extends BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  /// Add User
  Future<ResponseModel> addMember(Map<String, dynamic> member) async {
    final ResponseModel response = await _apiService.post(ApiEndpoints.addMember, member);
    if (response.success) {
      HLoggerHelper.debug("response.data : ${response.data}]");
      return response;
    }

    return ResponseModel.error(response.message ?? 'Failed to add User');
  }

  /// Get all Visitors
  Future<ResponseModel<MemberResponse>> getAllMembers({bool isFromApi = false, String userType = 'MANAGER'}) async {
    if (isFromApi) {
      return await _getUserFromApi(userType: userType);
    }
    try {
      final List<MemberModel>? members = _storageService.read<List<MemberModel>?>(StorageKeys.memberList);
      final List<ColumnModel>? columns = _storageService.read<List<ColumnModel>?>(StorageKeys.memberColumns);
      if (members != null && members.isNotEmpty && columns != null && columns.isNotEmpty) {
        HLoggerHelper.info('Users: $members');
        return ResponseModel.success(
          (members: members, columns: columns),
          'Users retrieved from storage',
        );
      } else {
        return await _getUserFromApi(userType: userType);
      }
    } catch (e) {
      HLoggerHelper.error('Error getting Visitors: $e');

      return ResponseModel.error('Failed to get Visitors');
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

  /// Get Visitors from api
  Future<ResponseModel<MemberResponse>> _getUserFromApi({
    String? userType,
  }) async {
    try {
      final queryParams = {
        if (userType != null && userType.isNotEmpty) 'user_type': userType,
      };

      final ResponseModel response = await _apiService.get(
        ApiEndpoints.getAllMember,
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final List<MemberModel> members = transformList(
          responseData['data'],
          MemberModel.fromJson,
        );
        final List<ColumnModel> columns = transformList(
          responseData['headers'],
          ColumnModel.fromJson,
        );

        _storageService.write(StorageKeys.memberList, members);
        _storageService.write(StorageKeys.memberColumns, columns);

        // Save the contractor id list to local storage
        List<Map<String, MemberIdModel>> memberIdList = [];
        if (members.isNotEmpty) {
          List<Map<String, MemberIdModel>> idList = DataTransform.transformMemberIdList(members);
          HLoggerHelper.info(' idList: ${idList[0]}');
          await _storageService.write<List<Map<String, dynamic>>>(StorageKeys.memberIdList, idList);
          memberIdList = idList;
          HLoggerHelper.debug('idList: ${memberIdList[0]}');
        }

        return ResponseModel<MemberResponse>(
          success: true,
          message: response.message ?? 'Users retrieved from api',
          data: (members: members, columns: columns),
        );
      }

      return ResponseModel.error(response.message ?? 'Failed to get Users');
    } catch (e) {
      HLoggerHelper.error('Error getting Users: $e');
      return ResponseModel.error('Failed to get Users');
    }
  }
}
