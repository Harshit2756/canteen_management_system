import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/media/text_strings.dart';
import '../../../../../core/widgets/cards/dashboard/feature_card.dart';
import '../../../../../core/widgets/data_table/custom_data_table.dart';
import '../../../../../core/widgets/sidebar/controller/sidebar_controller.dart';
import '../../../../../core/widgets/texts/heading_text.dart';
import '../../controllers/dashboard_controller.dart';
import '../table/dashboard_table.dart';
import 'dashboard_summary_card.dart';

class DashboardBody extends StatelessWidget {
  final bool isDesktop;

  const DashboardBody({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = DashboardController.instance;
    final SidebarController sidebarController = SidebarController.instance;

    return isDesktop ? desktopDashboardBody(controller, sidebarController, context) : mobileDashboardBody(controller, sidebarController);
  }

  Widget desktopDashboardBody(DashboardController controller, SidebarController sidebarController, BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? _buildShimmerEffect()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 24,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DashboardSummaryCard(
                          title: 'Approved Request',
                          value: controller.summary.value.approvedVisitsCount.toString(),
                          icon: HIcons.approved,
                          color: Colors.lightGreen,
                          iconColor: Colors.green,
                          actionColor: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: DashboardSummaryCard(
                          title: 'Pending Request',
                          value: controller.summary.value.pendingRequestCount.toString(),
                          icon: HIcons.pending,
                          color: Colors.orange.shade300,
                          iconColor: Colors.orange,
                          actionColor: Colors.orange,
                          onTap: () => sidebarController.onMenuTap(HRoutesName.mealsRequestList),
                        ),
                      ),
                      Expanded(
                        child: DashboardSummaryCard(
                          title: 'Total Monthly Request',
                          value: controller.summary.value.monthlyVisitsCount.toString(),
                          icon: HIcons.monthly,
                          color: Colors.lightBlue,
                          iconColor: Colors.blue,
                          actionColor: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: DashboardSummaryCard(
                          title: 'Today Request',
                          value: controller.summary.value.todayVisitCount.toString(),
                          icon: HIcons.today,
                          color: Colors.red.shade300,
                          iconColor: Colors.red,
                          actionColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HSizes.md16),
                  HHeaderText("Todays Meals Requests"),
                  const SizedBox(height: HSizes.md16),
                  Expanded(
                    child: CustomDataTable(
                      minWidth: 1500,
                      // heading: Text('Today Visitor List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      searchController: controller.searchController,
                      sortColumnIndex: controller.sortColumnIndex.value,
                      sortAscending: controller.sortAscending.value,
                      columns: [
                        ...controller.columns.map((column) {
                          return DataColumn2(
                            headingRowAlignment: MainAxisAlignment.start,
                            label: Text(column.headerName ?? '', softWrap: true),
                            size: ColumnSize.L,
                            onSort: (columnIndex, ascending) {
                              controller.sortColumnIndex.value = columnIndex;
                              controller.sortAscending.value = ascending;
                              controller.sortVisitors(column.field, ascending);
                            },
                          );
                        }),
                      ],
                      source: DashboardDataTableSource(controller),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ListView mobileDashboardBody(DashboardController dashBoardController, SidebarController sidebarController) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // FeatureHorizontalCard(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       const CircleAvatar(child: Icon(HIcons.account)),
        //       const SizedBox(width: 16),
        //       Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('Role: ${controller.authService.role}'),
        //           const SizedBox(height: 4),
        //           Text(controller.user?.name ?? ''),
        //         ],
        //       )
        //     ],
        //   ),
        // ),
        // const SizedBox(height: HSizes.sm8),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 1,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            FeatureCard(
              title: HTexts.mealsAction,
              icon: HIcons.visitor,
              onTap: () => sidebarController.onMenuTap(HRoutesName.mealsRequestList),
            ),
            FeatureCard(
              title: HTexts.addMeals,
              icon: HIcons.visitor,
              onTap: () => sidebarController.onMenuTap(HRoutesName.addMeals),
            ),
            FeatureCard(
              title: HTexts.reports,
              icon: HIcons.reports,
              onTap: () => sidebarController.onMenuTap(HRoutesName.mealsReports),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: DashboardSummaryCard(
                    title: 'Loading...',
                    value: '...',
                    icon: Icons.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: DashboardSummaryCard(
                    title: 'Loading...',
                    value: '...',
                    icon: Icons.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: DashboardSummaryCard(
                    title: 'Loading...',
                    value: '...',
                    icon: Icons.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: DashboardSummaryCard(
                    title: 'Loading...',
                    value: '...',
                    icon: Icons.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HSizes.md16),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
