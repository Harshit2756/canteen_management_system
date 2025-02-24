import 'package:canteen_app/core/utils/constants/enums/enums.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../core/interfaces/dropdown_data_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/employee/employee_model.dart';
import '../repositories/employee_repository.dart';

class EmployeesController extends GetxController implements PlantDataProvider {
  final EmployeeRepository _employeeRepository = Get.isRegistered<EmployeeRepository>() ? Get.find<EmployeeRepository>() : Get.put(EmployeeRepository());

  /// Variables
  final hidePassword = false.obs;
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final allEmployeeList = <EmployeeModel>[].obs;
  final filteredEmployeeList = <EmployeeModel>[].obs;
  final formKey = GlobalKey<FormState>();
  final columns = <ColumnModel>[].obs;
  final _plantsList = <Map<String, PlantsIdModel>>[].obs;
  final _selectedPlantId = ''.obs;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final departmentController = TextEditingController();
  final designationController = TextEditingController();
  final passwordController = TextEditingController();
  // * Searching and Sorting
  final searchController = SearchController();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 0.obs;

  /// FocusNodes
  final nameFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();
  final departmentFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final designationFocusNode = FocusNode();

  // * Functions

  /// Register Employee
  Future<void> registerEmployee() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> employee = {
        "name": nameController.text.trim(),
        "username": mobileController.text.trim(),
        "mobile_number": mobileController.text.trim(),
        "password": passwordController.text.trim(),
        "plant_id": int.parse(selectedPlantId.value),
        "department": departmentController.text.trim(),
        "designation": designationController.text.trim(),
        "user_type": UserRole.EMPLOYEE.name,
      };

      final response = await _employeeRepository.addEmployee(employee);

      if (response.success) {
        clearForm();
        Get.back();
        await getAllEmployee(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Employee registered successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error registering employee: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to register employee');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Visitor
  // Future<void> deleteVisitor(String username) async {
  //   try {
  //     final response = await _employeeRepository.deleteEmployee(username);
  //     if (response.success) {
  //       await getAllEmployee(isFromApi: true);
  //       HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Employee deleted successfully');
  //     }
  //   } catch (e) {
  //     HLoggerHelper.error('Error deleting employee: $e');
  //     HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to delete employee');
  //   }
  // }

  /// Get All Employee
  Future<void> getAllEmployee({bool isFromApi = false}) async {
    isLoadingList.value = true;
    try {
      final response = await _employeeRepository.getAllEmployees(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Employees: ${response.data}');
        allEmployeeList.value = response.data?.employees ?? [];
        columns.value = response.data?.columns ?? [];
        // Apply initial filter
        searchEmployee('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting employees: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load employees');
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
      final response = await _employeeRepository.getPlantsIdList(isFromApi: isFromApi);
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
  void addEmployeeView() {
    getPlantsIdList();
    Get.toNamed(HRoutesName.addEmployee);
  }

  //* Utility Functions
  void clearForm() {
    nameController.clear();
    mobileController.clear();
    departmentController.clear();
    designationController.clear();
    passwordController.clear();
    selectedPlantId.value = '';
  }

  void searchListener() {
    searchEmployee(searchController.text);
  }

  /// Filter Managers based on search query
  void searchEmployee(String query) {
    HLoggerHelper.info(query);
    List<EmployeeModel> filteredList = allEmployeeList;

    if (query.isNotEmpty) {
      filteredList = filteredList.where((employee) {
        return employee.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filteredEmployeeList.value = filteredList;
  }

  void sortEmployees(String field, bool ascending) {
    filteredEmployeeList.sort((a, b) {
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
    departmentController.dispose();
    designationController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    designationFocusNode.dispose();
    mobileFocusNode.dispose();
    departmentFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
