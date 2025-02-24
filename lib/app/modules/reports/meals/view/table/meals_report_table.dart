import 'package:canteen_app/app/modules/reports/meals/controllers/meals_reports_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../../core/utils/theme/colors.dart';

class MealsReportDataTableSource extends DataTableSource {
  final MealsReportController controller;
  MealsReportDataTableSource(this.controller) {
    controller.filteredMealsList.listen((_) => notifyListeners());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredMealsList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final meals = controller.filteredMealsList[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ...controller.columns.map((column) {
          final field = column.field;
          final value = field != null ? meals.toJson()[field] : '';
          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }
}
