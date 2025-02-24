import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../core/utils/theme/colors.dart';
import '../../controller/meals_menu_controller.dart';

class MealMenuDataTableSource extends DataTableSource {
  final MealsMenuController controller;
  MealMenuDataTableSource(this.controller) {
    controller.filteredMealsMenuList.listen((_) => notifyListeners());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredMealsMenuList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final meal = controller.filteredMealsMenuList[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ...controller.columns.map((column) {
          final field = column.field;
          final value = meal.toJson()[field];

          // Check for specific fields to show icon buttons
          // if (field?.contains('process') ?? false) {
          //   return DataCell(markEntryButton(meal));
          // }

          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }
}
