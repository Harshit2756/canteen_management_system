import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/searchbar/searchbar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/utils/constants/extension/platform_extensions.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/data_table/custom_data_table.dart';
import '../../../../core/widgets/loading/shimmer/shimmer_list_view.dart';
import '../controller/employee_controller.dart';
import 'table/employee_table.dart';

class EmployeesListView extends StatelessWidget {
  const EmployeesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeesController());

    // Ensure that the data is fetched after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllEmployee();
      controller.searchController.addListener(() {
        controller.searchEmployee(controller.searchController.text);
      });
    });

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(
        showBackButton: PlatformHelper.isMobileOs,
        title: HTexts.employee,
        actions: [
          if (!PlatformHelper.isMobile)
            IconButton(
              onPressed: () => controller.getAllEmployee(isFromApi: true),
              icon: const Icon(HIcons.refresh),
            ),
        ],
      ),
      mobile: RefreshIndicator(
        onRefresh: () => controller.getAllEmployee(isFromApi: true),
        child: Obx(
          () => controller.isLoadingList.value
              ? const ShimmerListView()
              : Center(
                  child: Column(
                    children: [
                      if (!PlatformHelper.isDesktop) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: HSizes.md16,
                            right: HSizes.md16,
                            top: HSizes.sm8,
                            bottom: HSizes.sm8,
                          ),
                          child: HSearchBar(
                            searchController: controller.searchController,
                            hintText: HTexts.searchMeals,
                          ),
                        ),
                      ],
                      const SizedBox(height: HSizes.sm8),
                      dataTable(controller, context),
                      const SizedBox(height: HSizes.sm8),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget dataTable(EmployeesController controller, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
        child: CustomDataTable(
          searchController: controller.searchController,
          sortColumnIndex: controller.sortColumnIndex.value,
          sortAscending: controller.sortAscending.value,
          heading: Row(
            children: [
              CustomButton(onPressed: controller.addEmployeeView, text: HTexts.addEmployee),
            ],
          ),
          columns: [
            ...controller.columns.map((column) {
              return DataColumn2(
                headingRowAlignment: MainAxisAlignment.start,
                label: Text(column.headerName ?? '', softWrap: true),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) {
                  controller.sortColumnIndex.value = columnIndex;
                  controller.sortAscending.value = ascending;
                  controller.sortEmployees(column.field ?? '', ascending);
                },
              );
            }),
          ],
          source: EmployeesDataTableSource(controller),
        ),
      ),
    );
  }
}
