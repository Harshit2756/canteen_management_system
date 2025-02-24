import 'package:canteen_app/app/data/models/local/meals_id_mode.dart';
import 'package:canteen_app/app/modules/meal/repositories/meal_request_repository.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../core/interfaces/dropdown_data_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../../core/utils/constants/enums/enums.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/local/plants_id_model.dart';
import '../../../data/models/network/meals/meals_request_model.dart';

class MealRequestController extends GetxController implements PlantDataProvider, MealDataProvider {
  static MealRequestController get instance => Get.find();
  final MealsRequestRepository _mealsRequestRepository = Get.isRegistered<MealsRequestRepository>() ? Get.find<MealsRequestRepository>() : Get.put(MealsRequestRepository());

  /// Variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final allMealsRequestList = <MealsRequestModel>[].obs;
  final filteredMealsResquestList = <MealsRequestModel>[].obs;
  final formKey = GlobalKey<FormState>();
  final columns = <ColumnModel>[].obs;
  final _plantsList = <Map<String, PlantsIdModel>>[].obs;
  final _selectedPlantId = ''.obs;
  final _mealsList = <Map<String, MealsIdModel>>[].obs;
  final _selectedMealId = ''.obs;
  final quantityController = TextEditingController();
  final remarksController = TextEditingController();

  // * Searching and Sorting
  final searchController = SearchController();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 0.obs;
  final Rx<Status?> selectedFilter = Status.PENDING.obs;

  // * Functions
  ///  add Meal Request
  Future<void> addMealRequest() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> meals = {
        "mealId": int.parse(selectedMealId.value),
        "quantity": int.parse(quantityController.text.trim()),
        "plantId": int.parse(selectedPlantId.value),
      };
      final response = await _mealsRequestRepository.addMealRequest(meals);

      if (response.success) {
        clearForm();
        Get.back();
        await getAllMealsRequest(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Meals registered successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error registering meals: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to register meals');
    } finally {
      isLoading.value = false;
    }
  }

  /// Process Status
  Future<void> processStatus(Status status, String mealId) async {
    try {
      final response = await _mealsRequestRepository.processMealstatus(
        mealId,
        {
          'status': status.name,
          'remarks': remarksController.text.trim(),
        },
      );

      if (response.success) {
        await getAllMealsRequest(isFromApi: true);
        HSnackbars.showSnackbar(
          type: SnackbarType.success,
          message: 'Meals ${status.name.toLowerCase()} successfully',
        );
      }
    } catch (e) {
      HLoggerHelper.error('Error updating meals status: $e');
      HSnackbars.showSnackbar(
        type: SnackbarType.error,
        message: 'Failed to update meals status',
      );
    }
  }

  /// Mark Entry
  Future<void> markEntry(String mealId) async {
    try {
      final response = await _mealsRequestRepository.processMealsEntry(mealId);
      if (response.success) {
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Entry marked successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error updating meals status: $e');
      HSnackbars.showSnackbar(
        type: SnackbarType.error,
        message: 'Failed to update meals status',
      );
    }
  }

  /// Get All Meals
  Future<void> getAllMealsRequest({bool isFromApi = false}) async {
    isLoadingList.value = true;
    try {
      final response = await _mealsRequestRepository.getAllMealsRequest(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('meals: ${response.data}');
        allMealsRequestList.value = response.data?.meals ?? [];
        columns.value = response.data?.columns ?? [];
        HLoggerHelper.info('columns: ${columns.length}');

        // Apply initial filter
        searchMealsRequest('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting meals: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load meals');
    } finally {
      isLoadingList.value = false;
    }
  }

  //* Utility Functions
  /// Filter Managers based on search query
  void searchMealsRequest(String query) {
    List<MealsRequestModel> filteredList = allMealsRequestList;

    if (selectedFilter.value != Status.ALL) {
      filteredList = filteredList.where((meals) {
        return meals.status.toUpperCase() == selectedFilter.value?.name;
      }).toList();
    }

    if (query.isNotEmpty) {
      filteredList = filteredList.where((meals) {
        return meals.mealName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filteredMealsResquestList.value = filteredList;
    HLoggerHelper.info('filteredMealsResquestList: ${filteredMealsResquestList.length}');
  }

  void sortMealsRequest(String field, bool ascending) {
    filteredMealsResquestList.sort((a, b) {
      final valueA = a.toJson()[field];
      final valueB = b.toJson()[field];
      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
  }

  bool _validateInputs() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  void searchListener() {
    searchMealsRequest(searchController.text);
  }

  void clearForm() {
    quantityController.clear();
    _selectedPlantId.value = '';
  }

  // * Navigation Functions
  /// add meals view
  void addMealsRequestView() {
    Get.toNamed(HRoutesName.addMealsRequest);
  }

  /// Navigate to Edit Meals
  // void showEditMeals(MealsRequestModel meals) {
  //   Get.toNamed(HRoutesName.addMeals, arguments: AddMealsArguments(isEditing: true, meals: meals));
  // }

  // * Lifecycle Functions
  @override
  void onClose() {
    searchController.removeListener(searchListener);
    quantityController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Implementing PlantDataProvider
  @override
  RxString get selectedPlantId => _selectedPlantId;

  /// Get Plants Id List
  @override
  Future<void> getPlantsIdList({bool isFromApi = false}) async {
    try {
      isLoadingList.value = true;
      final response = await _mealsRequestRepository.getPlantsIdList(isFromApi: isFromApi);
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
  List<Map<String, PlantsIdModel>> get plantsList => _plantsList;

  @override
  RxString get selectedMealId => _selectedMealId;

  @override
  List<Map<String, MealsIdModel>> get mealsList => _mealsList;

  @override
  Future<void> getMealsList({bool isFromApi = false}) async {
    try {
      isLoadingList.value = true;
      final response = await _mealsRequestRepository.getMealsIdList(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('Plants: ${response.data}');
        _mealsList.value = response.data ?? [];
      }
    } catch (e) {
      HLoggerHelper.error('Error getting meals: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to get meals');
    } finally {
      isLoadingList.value = false;
    }
  }
}
