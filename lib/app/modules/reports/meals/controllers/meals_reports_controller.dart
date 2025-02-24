import 'package:canteen_app/app/data/models/column_model.dart';
import 'package:canteen_app/core/utils/constants/extension/formatter.dart';
import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../../../core/utils/helpers/helper_functions.dart';
import '../../../../../core/widgets/inputs/date_selector.dart';
import '../../../../data/models/network/reports/meals_reports_model.dart';
import '../repositories/meals_report_repository.dart';

class RxDateTimeRange {
  final Rx<DateTime> _start;
  final Rx<DateTime> _end;

  RxDateTimeRange({required DateTime start, required DateTime end})
      : _start = start.obs,
        _end = end.obs;

  DateTime get end => _end.value;
  DateTime get start => _start.value;

  DateTimeRange get value => DateTimeRange(start: start, end: end);

  set value(DateTimeRange range) {
    _start.value = range.start;
    _end.value = range.end;
  }
}

class MealsReportController extends GetxController {
  static MealsReportController get instance => Get.find();
  final MealsReportRepository _mealsReportRepository = Get.put(MealsReportRepository());

  /// Variables
  final isLoadingList = false.obs;
  final allMealsList = <MealsReportsModel>[].obs;
  final filteredMealsList = <MealsReportsModel>[].obs;

  final columns = <ColumnModel>[].obs;
  final searchController = SearchController();
  final RxDateTimeRange dateRange = RxDateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  final Rx<DateSelectionType> dateSelectionType = DateSelectionType.single.obs;
  final Rx<DateTime> singleDate = DateTime.now().obs;
  final RxInt sortColumnIndex = 0.obs;
  final RxBool sortAscending = true.obs;
  final isExporting = false.obs;

  /// Export all labours to Excel
  Future<void> exportAllMealss() async {
    final headers = columns.map((column) => column.headerName ?? '').toList();
    final rows = allMealsList.map((meals) {
      return columns.map((column) {
        final field = column.field;
        var value = field != null ? meals.toJson()[field] : '';

        if (field == 'date' || field == 'inTime' || field == 'outTime') {
          value = FormateDataCell.formatCellValue(field, value);
        }
        return value?.toString() ?? 'N/A';
      }).toList();
    }).toList();

    await HHelperFunctions.exportToExcel(
      sheetName: 'All Mealss',
      headers: headers,
      rows: rows,
      isLoading: isExporting,
    );
  }

  /// Get All Labour
  Future<void> getMealsReport({String? startDate, String? endDate, bool isDaily = true}) async {
    isLoadingList.value = true;
    try {
      final response = await _mealsReportRepository.getDailyMealsReport(startDate: startDate, endDate: endDate, isDaily: isDaily);

      if (response.success) {
        HLoggerHelper.info('Mealss: ${response.data}');
        final report = response.data;
        allMealsList.value = report?.mealss ?? [];
        columns.value = report?.columns ?? [];

        searchMeals('');
      }
    } catch (e) {
      HLoggerHelper.error('Error getting mealss: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load mealss');
    } finally {
      isLoadingList.value = false;
    }
  }

  @override
  void onClose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(searchListener);
    showMealsTable();
  }

  /// Filter Managers based on search query
  void searchMeals(String query) {
    Future.delayed(const Duration(milliseconds: 100));
    List<MealsReportsModel> filteredList = allMealsList;
    if (query.isNotEmpty) {
      filteredList = allMealsList.where((meals) {
        return meals.mealName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    filteredMealsList.value = filteredList;
  }

  void searchListener() {
    searchMeals(searchController.text);
  }

  /// Show Labour List view
  void showMealsTable() {
    String startDate = singleDate.value.isoDate, endDate = singleDate.value.isoDate;
    if (dateSelectionType.value == DateSelectionType.single) {
      startDate = singleDate.value.isoDate;
      // add 1 day to the start date
      endDate = DateTime.parse(startDate).add(const Duration(days: 1)).isoDate;
    } else if (dateSelectionType.value == DateSelectionType.range) {
      startDate = dateRange.value.start.isoDate;
      endDate = dateRange.value.end.isoDate;
    }
    getMealsReport(startDate: startDate, endDate: endDate, isDaily: dateSelectionType.value == DateSelectionType.single);

    // Get.toNamed(HRoutesName.mealsReports);
  }

  /// Sort labours by column
  void sortMealss(String? field, bool ascending) {
    if (field == null) return;
    filteredMealsList.sort((a, b) {
      final aValue = a.toJson()[field];

      final bValue = b.toJson()[field];
      if (aValue == null || bValue == null) return 0;
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
  }

  void updateDateRange(DateTime start, DateTime end) {
    dateRange.value = DateTimeRange(start: start, end: end);
  }

  void updateDateSelectionType(DateSelectionType type) {
    dateSelectionType.value = type;
    if (type == DateSelectionType.single) {
      singleDate.value = DateTime.now();
    } else {
      dateRange.value = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      );
    }
  }

  // Update single date
  void updateSingleDate(DateTime date) {
    singleDate.value = date;
  }
}
