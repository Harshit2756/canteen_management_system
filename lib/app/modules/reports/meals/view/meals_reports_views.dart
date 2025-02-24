import 'package:canteen_app/core/responsive/layouts/responsive_layout.dart';
import 'package:canteen_app/core/utils/constants/extension/platform_extensions.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/widgets/appbar/custom_appbar.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/helpers/logger.dart';
import '../../../../../core/utils/media/icons_strings.dart';
import '../../../../../core/utils/media/text_strings.dart';
import '../../../../../core/widgets/data_table/custom_data_table.dart';
import '../../../../../core/widgets/dialog_bottomsheet/custom_dialog.dart';
import '../../../../../core/widgets/inputs/date_selector.dart';
import '../../../../../core/widgets/loading/shimmer/shimmer_list_view.dart';
import '../../../../../core/widgets/searchbar/searchbar.dart';
import '../controllers/meals_reports_controller.dart';
import 'table/meals_report_table.dart';

class MealsReportsView extends StatelessWidget {
  const MealsReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MealsReportController());

    return ResponsiveLayout(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.exportAllMealss,
        icon: const Icon(HIcons.export),
        label: const Text(HTexts.export),
      ),
      appBar: CustomAppBar.withText(showBackButton: PlatformHelper.isMobileOs, title: 'Meals Report'),
      mobile: Obx(
        () {
          return controller.isLoadingList.value
              ? const ShimmerListView()
              : Column(
                  children: [
                    if (!PlatformHelper.isDesktop)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: HSizes.md16,
                          vertical: HSizes.sm8,
                        ),
                        child: HSearchBar(
                          searchController: controller.searchController,
                          hintText: HTexts.searchMeals,
                        ),
                      ),
                    dataTable(controller, context),
                  ],
                );
        },
      ),
    );
  }

  Widget dataTable(MealsReportController controller, BuildContext context) {
    HLoggerHelper.info('controller.filteredMealsList: ${controller.filteredMealsList.length}');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
        child: CustomDataTable(
          searchController: controller.searchController,
          sortColumnIndex: controller.sortColumnIndex.value,
          sortAscending: controller.sortAscending.value,
          heading: CustomButton(onPressed: controller.exportAllMealss, text: 'Export (Excel)'),
          actions: [filterButton(context, controller)],
          columns: [
            ...controller.columns.map((column) {
              return DataColumn2(
                headingRowAlignment: MainAxisAlignment.start,
                label: Text(
                  column.headerName ?? '',
                  softWrap: true,
                ),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) {
                  controller.sortColumnIndex.value = columnIndex;
                  controller.sortAscending.value = ascending;
                  controller.sortMealss(column.field, ascending);
                },
              );
            }),
          ],
          source: MealsReportDataTableSource(controller),
        ),
      ),
    );
  }

  Widget filterButton(BuildContext context, MealsReportController controller) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Obx(
            () => CustomDialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DateSelector(
                    selectedType: controller.dateSelectionType.value,
                    onTypeChanged: (value) => controller.updateDateSelectionType(value.first),
                    singleDate: controller.singleDate.value,
                    dateRange: controller.dateRange.value,
                    onSingleDateChanged: controller.updateSingleDate,
                    onDateRangeChanged: controller.updateDateRange,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onPressed: () => Get.back(),
                        text: HTexts.cancel,
                        isSecondaryButton: true,
                      ),
                      CustomButton(
                        onPressed: () {
                          controller.showMealsTable();
                          Get.back();
                        },
                        text: 'Apply Filters',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: const Icon(HIcons.filter),
    );
  }
}
