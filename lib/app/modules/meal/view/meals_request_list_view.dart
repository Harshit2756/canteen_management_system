import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/searchbar/searchbar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/utils/constants/enums/enums.dart';
import '../../../../core/utils/constants/extension/platform_extensions.dart';
import '../../../../core/utils/theme/colors.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/chips/filter_chip.dart';
import '../../../../core/widgets/data_table/custom_data_table.dart';
import '../../../../core/widgets/loading/shimmer/shimmer_list_view.dart';
import '../controller/meal_request_controller.dart';
import 'table/meal_request_table.dart';

class MealsRequestListView extends StatelessWidget {
  const MealsRequestListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MealRequestController>() ? Get.find<MealRequestController>() : Get.put(MealRequestController());

    // Ensure that the data is fetched after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllMealsRequest();
      controller.searchController.addListener(() {
        controller.searchMealsRequest(controller.searchController.text);
      });
    });

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(
        showBackButton: PlatformHelper.isMobileOs,
        actions: [
          if (!PlatformHelper.isMobile)
            IconButton(
              onPressed: () => controller.getAllMealsRequest(isFromApi: true),
              icon: const Icon(HIcons.refresh),
            ),
        ],
      ),
      mobile: RefreshIndicator(
        onRefresh: () => controller.getAllMealsRequest(isFromApi: true),
        child: Obx(
          () => controller.isLoadingList.value
              ? const ShimmerListView(showFilterChips: true)
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
                        filterChips(controller),
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

  Widget dataTable(MealRequestController controller, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
        child: controller.columns.isEmpty
            ? const Center(child: Text('No data available'))
            : CustomDataTable(
                searchController: controller.searchController,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                heading: Row(
                  children: [
                    CustomButton(onPressed: controller.addMealsRequestView, text: HTexts.addMealsRequest),
                    if (!PlatformHelper.isMobileOs) filterDropDwon(controller),
                  ],
                ),
                columns: controller.columns
                    .map((column) => DataColumn2(
                          headingRowAlignment: MainAxisAlignment.start,
                          label: Text(column.headerName ?? '', softWrap: true),
                          size: ColumnSize.L,
                          onSort: (columnIndex, ascending) {
                            controller.sortColumnIndex.value = columnIndex;
                            controller.sortAscending.value = ascending;
                            controller.sortMealsRequest(column.field ?? '', ascending);
                          },
                        ))
                    .toList(),
                source: MealRequestDataTableSource(controller),
              ),
      ),
    );
  }

  Widget filterChips(MealRequestController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            Status.values.length,
            (index) {
              final status = Status.values[index];
              final colors = {
                Status.ALL: (HColors.primary, HColors.white),
                Status.PENDING: (HColors.pendingColor, HColors.pendingBgColor),
                Status.APPROVED: (HColors.approvedColor, HColors.approvedBgColor),
                Status.REJECTED: (HColors.rejectedColor, HColors.rejectedBgColor),
              }[status];

              return Padding(
                padding: EdgeInsets.only(
                  right: index != Status.values.length - 1 ? HSizes.sm8 : 0,
                ),
                child: CustomFilterChip(
                  label: status.name,
                  isSelected: controller.selectedFilter.value == status,
                  onSelected: (_) {
                    controller.selectedFilter.value = status;
                    controller.searchMealsRequest(controller.searchController.text);
                  },
                  selectedBackgroundColor: colors?.$1,
                  unselectedTextColor: colors?.$1,
                  unselectedBackgroundColor: colors?.$2,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget filterDropDwon(MealRequestController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.md16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Status>(
          value: controller.selectedFilter.value,
          onChanged: (Status? newValue) {
            if (newValue != null) {
              controller.selectedFilter.value = newValue;
              controller.searchMealsRequest(controller.searchController.text);
            }
          },
          items: Status.values.map<DropdownMenuItem<Status>>((Status status) {
            final colors = {
              Status.ALL: (HColors.primary, HColors.white),
              Status.PENDING: (HColors.pendingColor, HColors.pendingBgColor),
              Status.APPROVED: (HColors.approvedColor, HColors.approvedBgColor),
              Status.REJECTED: (HColors.rejectedColor, HColors.rejectedBgColor),
            }[status];

            return DropdownMenuItem<Status>(
              value: status,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: controller.selectedFilter.value == status ? colors?.$1 : colors?.$2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.name,
                  style: TextStyle(
                    color: controller.selectedFilter.value == status ? HColors.white : colors?.$1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
