import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../core/utils/theme/colors.dart';
import '../../../../data/models/network/dashboard/visitor_dashboard_model.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardDataTableSource extends DataTableSource {
  final DashboardController controller;

  DashboardDataTableSource(this.controller) {
    // Add listener to notify table when data changes
    controller.filteredVisitorList.listen((_) => notifyListeners());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredVisitorList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final visitor = controller.filteredVisitorList[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ...controller.columns.map((column) {
          final field = column.field;
          final value = field != null ? _getVisitorFieldValue(visitor, field) : '';
          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }

  dynamic _getVisitorFieldValue(VisitorDashboardModel visitor, String field) {
    switch (field) {
      case 'entryTime':
        return visitor.entryTime;
      case 'exitTime':
        return visitor.exitTime;
      default:
        return visitor.toJson()[field];
    }
  }
}
