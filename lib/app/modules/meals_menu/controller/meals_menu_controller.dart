import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../core/routes/routes_name.dart';
import '../../../data/models/column_model.dart';
import '../../../data/models/network/meals/meals_menu_model.dart';
import '../repositories/meal_menu_repository.dart';

class MealsMenuController extends GetxController {
  static MealsMenuController get instance => Get.find();
  final MealsMenuRepository _mealsMenuRepository = Get.isRegistered<MealsMenuRepository>() ? Get.find<MealsMenuRepository>() : Get.put(MealsMenuRepository());

  /// Variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final allMealsMenuList = <MealsMenuModel>[].obs;
  final filteredMealsMenuList = <MealsMenuModel>[].obs;
  final formKey = GlobalKey<FormState>();
  final columns = <ColumnModel>[].obs;
  final priceController = TextEditingController();
  final nameController = TextEditingController();

  // * Searching and Sorting
  final searchController = SearchController();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 0.obs;

  // * Functions
  ///  add Meal Menu
  Future<void> addMealsMenu() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> meals = {
        "name": nameController.text.trim(),
        "price": int.parse(priceController.text.trim()),
      };
      final response = await _mealsMenuRepository.addMealMenu(meals);

      if (response.success) {
        clearForm();
        Get.back();
        await getAllMealsMenu(isFromApi: true);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Meals registered successfully');
      }
    } catch (e) {
      HLoggerHelper.error('Error registering meals: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to register meals');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get All Meals
  Future<void> getAllMealsMenu({bool isFromApi = false}) async {
    isLoadingList.value = true;
    try {
      final response = await _mealsMenuRepository.getAllMealsMenu(isFromApi: isFromApi);
      if (response.success) {
        HLoggerHelper.info('meals: ${response.data}');
        allMealsMenuList.value = response.data?.meals ?? [];
        columns.value = response.data?.columns ?? [];
        // Apply initial filter
        searchMealsMenu('');
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
  void searchMealsMenu(String query) {
    HLoggerHelper.info(query);
    List<MealsMenuModel> filteredList = allMealsMenuList;

    if (query.isNotEmpty) {
      filteredList = filteredList.where((meals) {
        return meals.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filteredMealsMenuList.value = filteredList;
  }

  void sortMealsMenu(String field, bool ascending) {
    filteredMealsMenuList.sort((a, b) {
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
    searchMealsMenu(searchController.text);
  }

  void clearForm() {
    priceController.clear();
    nameController.clear();
  }

  // * Navigation Functions
  /// add meals view
  void addMealsMenuView() {
    Get.toNamed(HRoutesName.addMeals);
  }

  /// Navigate to Edit Meals
  // void showEditMeals(MealsMenuModel meals) {
  //   Get.toNamed(HRoutesName.addMeals, arguments: AddMealsArguments(isEditing: true, meals: meals));
  // }

  // * Lifecycle Functions
  @override
  void onClose() {
    searchController.removeListener(searchListener);
    priceController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
