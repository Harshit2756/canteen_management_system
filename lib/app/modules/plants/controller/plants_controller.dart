import 'package:canteen_app/core/utils/helpers/data_transform.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:get/get.dart';

import '../../../../core/interfaces/dropdown_data_provider.dart';
import '../../../../core/routes/arguments.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/media/text_strings.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/dialog_bottomsheet/custom_dialog.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/local/member_id_model.dart';
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/plants/plants_model.dart';
import '../repositories/plants_repository.dart';

class PlantsController extends GetxController implements MemberDataProvider, PlantDataProvider {
  static PlantsController get instance => Get.find();
  final PlantsRepository _plantsRepository = Get.isRegistered<PlantsRepository>() ? Get.find<PlantsRepository>() : Get.put(PlantsRepository());

  /// Variables
  final isLoadingAdd = false.obs;
  final isLoadingMember = false.obs;
  final isLoadingList = false.obs;
  final allPlantsList = <PlantsModel>[].obs;
  final filteredPlantsList = <PlantsModel>[].obs;
  final allMembersList = <Member>[].obs;
  final filteredMembersList = <Member>[].obs;
  final formKeyAdd = GlobalKey<FormState>();
  final formKeyToPlant = GlobalKey<FormState>();
  final columns = <ColumnModel>[].obs;
  final selectedPlantName = ''.obs;
  final _selectedMemberId = ''.obs;
  final _selectedPlantId = ''.obs;
  final _memberList = <Map<String, MemberIdModel>>[].obs;

  final nameController = TextEditingController();
  final searchController = SearchController();
  final searchMembersController = SearchController();
  final RxInt sortColumnIndex = 0.obs;
  final RxBool sortAscending = true.obs;

  //* Plant List Functions
  /// Get All Visitor
  Future<void> getAllPlants({bool isFromApi = false}) async {
    isLoadingList.value = true;
    try {
      final response = await _plantsRepository.getAllPlants(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Plants: ${response.data}');
        allPlantsList.value = response.data?.plants ?? [];
        HLoggerHelper.info('Columns: ${response.data?.columns.length}');
        columns.value = response.data?.columns ?? [];

        if (selectedPlantName.value.isNotEmpty) {
          allMembersList.value = response.data?.plants.firstWhere((element) => element.name == selectedPlantName.value).members ?? [];
        }
        // Apply initial filter
        searchPlants('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting plant $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load plant');
    } finally {
      isLoadingList.value = false;
    }
  }

  /// Register plant
  void registerPlantDoalog() {
    // show edit dialog
    Get.dialog(
      CustomDialog(
        child: Form(
          key: formKeyAdd,
          child: ListView(
            children: [
              Text(HTexts.editPlant, style: Theme.of(Get.context!).textTheme.titleMedium),
              const SizedBox(height: HSizes.spaceBtwItems24),
              CustomTextField(
                controller: nameController,
                type: TextFieldType.name,
              ),
              const SizedBox(height: HSizes.spaceBtwInputFields16),
              CustomButton(
                text: HTexts.addPlant,
                onPressed: () => registerPlants(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Register Plants
  Future<void> registerPlants() async {
    if (!_validateResgiterForm()) return;

    isLoadingAdd.value = true;
    try {
      final Map<String, dynamic> plant = {
        "name": nameController.text.trim(),
      };

      final response = await _plantsRepository.addPlants(plant);

      if (response.success) {
        await getAllPlants(isFromApi: true);
        Get.back();
        clearRegisterForm();
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Plant registered successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error registering plant: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to register plant');
    } finally {
      isLoadingAdd.value = false;
    }
  }

  /// Delete Plant
  Future<void> deletePlants(String username) async {
    try {
      final response = await _plantsRepository.deletePlants(username);
      if (response.success) {
        await getAllPlants(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Plants deleted successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error deleting visitor: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to delete visitor');
    }
  }

  // * Member List Functions
  /// Add Member To Plant
  Future<void> addMemberToPlant() async {
    if (!formKeyToPlant.currentState!.validate()) return;
    isLoadingMember.value = true;
    try {
      final member = {
        "userId": selectedMemberId.value,
        'hasAllAccess': true,
      };

      final response = await _plantsRepository.addMemberToPlant(selectedPlantId.value, member);
      if (response.success) {
        await getAllPlants(isFromApi: true);
        selectedMemberId.value = '';
        selectedPlantId.value = '';

        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Member added to plant successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error adding member to plant: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to add member to plant');
    } finally {
      isLoadingMember.value = false;
    }
  }

  void clearRegisterForm() {
    nameController.clear();
  }

  void sortPlants(String field, bool ascending) {
    filteredPlantsList.sort((a, b) {
      final valueA = a.toJson()[field];
      final valueB = b.toJson()[field];
      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
  }

  /// Filter Plants based on search query
  void searchPlants(String query) {
    HLoggerHelper.info(query);
    List<PlantsModel> filteredList = allPlantsList;

    if (query.isNotEmpty) {
      filteredList = filteredList.where((plant) {
        return plant.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filteredPlantsList.value = filteredList;
  }

  void searchListener() {
    searchPlants(searchController.text);
  }

  /// Get Member List
  @override
  Future<void> getMemberList({bool isFromApi = false}) async {
    isLoadingMember.value = true;
    try {
      final response = await _plantsRepository.getMemberIdList(isFromApi: isFromApi);
      if (response.success) {
        _memberList.value = response.data ?? [];
      }
    } catch (e) {
      HLoggerHelper.error('Error getting member list: $e');
    } finally {
      isLoadingMember.value = false;
    }
  }

  @override
  RxString get selectedMemberId => _selectedMemberId;

  @override
  List<Map<String, MemberIdModel>> get membersList => _memberList;

  @override
  RxString get selectedPlantId => _selectedPlantId;

  @override
  List<Map<String, PlantsIdModel>> get plantsList => DataTransform.transformPlantsList(allPlantsList);

  @override
  Future<void> getPlantsIdList({bool isFromApi = false}) => getAllPlants(isFromApi: isFromApi);

  @override
  void onClose() {
    searchController.removeListener(searchListener);
    searchMembersController.removeListener(searchMembersListener);
    nameController.dispose();
    searchController.dispose();
    searchMembersController.dispose();
    super.onClose();
  }

  /// Delete Member From Plant
  Future<void> removeMemberFromPlant(String userId) async {
    final response = await _plantsRepository.removeMemberFromPlant(userId, selectedPlantId.value);
    if (response.success) {
      await getAllPlants(isFromApi: true);
    }
  }

  /// Filter Members based on search query
  void searchMembers(String query) {
    List<Member> filteredList = allMembersList;

    if (query.isNotEmpty) {
      filteredList = filteredList.where((member) {
        return member.user?.name.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }

    filteredMembersList.value = filteredList;
  }

  void searchMembersListener() {
    searchMembers(searchMembersController.text);
  }

  void showEmployeeListView(List<Member> members, String plantId, String plantName) {
    allMembersList.value = members;
    searchMembers('');
    selectedPlantName.value = plantName;
    nameController.text = plantName;

    Get.toNamed(HRoutesName.plantsMembersList, arguments: MembersListViewArguments(members: members, plantId: plantId));
  }

  /// update plant
  Future<void> updatePlants(String plantId) async {
    if (!_validateResgiterForm()) return;

    isLoadingAdd.value = true;
    try {
      final plant = {
        "name": nameController.text.trim(),
      };

      final response = await _plantsRepository.updatePlants(plantId, plant);

      if (response.success) {
        // clearRegisterForm();
        Get.back();
        await getAllPlants(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Plant updated successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error updating plant: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to update plant');
    } finally {
      isLoadingAdd.value = false;
    }
  }

  bool _validateResgiterForm() {
    if (!formKeyAdd.currentState!.validate()) {
      return false;
    }
    return true;
  }
}
