import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../core/interfaces/dropdown_data_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/member/member_model.dart';
import '../repositories/members_repository.dart';

class MembersController extends GetxController implements PlantDataProvider {
  final MemberRepository _memberRepository = Get.isRegistered<MemberRepository>() ? Get.find<MemberRepository>() : Get.put(MemberRepository());

  /// Variables
  final hidePassword = false.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final allMemberList = <MemberModel>[].obs;
  final filteredMemberList = <MemberModel>[].obs;
  final formKey = GlobalKey<FormState>();
  final columns = <ColumnModel>[].obs;
  final _plantsList = <Map<String, PlantsIdModel>>[].obs;
  final _selectedPlantId = ''.obs;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // * Searching and Sorting
  final searchController = SearchController();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 0.obs;

  /// FocusNodes
  final nameFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // * Functions

  /// Register Member
  Future<void> registerMember() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> member = {
        "name": nameController.text.trim(),
        "username": usernameController.text.trim(),
        "mobile_number": mobileController.text.trim(),
        "password": passwordController.text.trim(),
        "user_type": "MANAGER",
        // "plantName": selectedPlantId.value.toString(),
      };

      final response = await _memberRepository.addMember(member);

      if (response.success) {
        clearForm();
        Get.back();
        await getAllMember(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Member registered successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error registering member: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to register member');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Visitor
  // Future<void> deleteVisitor(String username) async {
  //   try {
  //     final response = await _memberRepository.deleteMember(username);
  //     if (response.success) {
  //       await getAllMember(isFromApi: true);
  //       HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Member deleted successfully');
  //     }
  //   } catch (e) {
  //     HLoggerHelper.error('Error deleting member: $e');
  //     HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to delete member');
  //   }
  // }

  /// Get All Member
  Future<void> getAllMember({bool isFromApi = false}) async {
    isLoadingList.value = true;
    try {
      final response = await _memberRepository.getAllMembers(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Members: ${response.data}');
        allMemberList.value = response.data?.members ?? [];
        columns.value = response.data?.columns ?? [];
        // Apply initial filter
        searchMember('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting members: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load members');
    } finally {
      isLoadingList.value = false;
    }
  }

  /// Implementing PlantDataProvider
  @override
  Future<void> getPlantsIdList({bool isFromApi = false}) async {
    HLoggerHelper.info('getPlantsIdList');
    try {
      isLoadingList.value = true;
      final response = await _memberRepository.getPlantsIdList(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Plants: ${response.data}');
        _plantsList.value = response.data ?? [];
      }
    } catch (e) {
      HLoggerHelper.error('Error getting plants: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to get plants');
    } finally {
      isLoadingList.value = false;
    }
  }

  @override
  RxString get selectedPlantId => _selectedPlantId;

  @override
  List<Map<String, PlantsIdModel>> get plantsList => _plantsList;

  // * Navigation Functions
  /// add visitor view
  void addMemberView() {
    Get.toNamed(HRoutesName.addMembers);
  }

  //* Utility Functions
  void clearForm() {
    nameController.clear();
    mobileController.clear();
    usernameController.clear();
    passwordController.clear();
    selectedPlantId.value = '';
  }

  void searchListener() {
    searchMember(searchController.text);
  }

  /// Filter Managers based on search query
  void searchMember(String query) {
    HLoggerHelper.info(query);
    List<MemberModel> filteredList = allMemberList;

    if (query.isNotEmpty) {
      filteredList = filteredList.where((member) {
        return member.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filteredMemberList.value = filteredList;
  }

  void sortMembers(String field, bool ascending) {
    filteredMemberList.sort((a, b) {
      final valueA = a.toJson()[field];
      final valueB = b.toJson()[field];
      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
  }

  /// Toggle Password Visibility
  void togglePasswordVisibility() => hidePassword.toggle();

  bool _validateInputs() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  // * Lifecycle Functions
  @override
  void onClose() {
    searchController.removeListener(searchListener);
    nameController.dispose();
    searchController.dispose();
    mobileController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    mobileFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
