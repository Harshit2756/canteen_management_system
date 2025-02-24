import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/enums/enums.dart';
import '../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../core/utils/theme/colors.dart';
import '../../../../data/models/network/meals/meals_request_model.dart';
import '../../controller/meal_request_controller.dart';
import '../widgets/meal_status_dialog.dart';
import '../widgets/meals_enter_dialog.dart';

class MealRequestDataTableSource extends DataTableSource {
  final MealRequestController controller;
  MealRequestDataTableSource(this.controller) {
    controller.filteredMealsResquestList.listen((_) => notifyListeners());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredMealsResquestList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final meal = controller.filteredMealsResquestList[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ...controller.columns.map((column) {
          final field = column.field;
          final value = meal.toJson()[field];

          // Check for specific fields to show icon buttons
          if (field?.contains('process') ?? false) {
            return DataCell(statusButton(meal));
          } else if (field?.contains('handleEntry') ?? false) {
            return DataCell(
              markEntryButton(meal),
            );
          }

          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }

  Widget markEntryButton(MealsRequestModel mealRequest) {
    if (mealRequest.status.toStatusEnum() == Status.APPROVED) {
      return IconButton(
        icon: Icon(HIcons.scanQr),
        onPressed: () {
          showDialog(
            context: Get.context!,
            builder: (context) => MealsEnterDialog(
              name: mealRequest.mealName,
              status: mealRequest.status,
              plantName: mealRequest.plantName,
              ticketId: mealRequest.ticketId,
              onOk: () => Get.back(),
              onMarkEntry: () {
                Get.back();
                controller.markEntry(mealRequest.ticketId);
              },
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget statusButton(MealsRequestModel mealRequest) {
    if (mealRequest.status.toStatusEnum() == Status.PENDING) {
      return IconButton(
        icon: Icon(HIcons.status),
        onPressed: () {
          showDialog(
            context: Get.context!,
            builder: (context) => mealstatusDialog(mealsId: mealRequest.ticketId, mealName: mealRequest.mealName),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
