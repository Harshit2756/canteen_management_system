import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../core/utils/theme/colors.dart';
import '../../../../data/models/column_model.dart';
import '../../../../data/models/network/employee/employee_model.dart';
import '../../controller/employee_controller.dart';

class EmployeesDataTableSource extends DataTableSource {
  RxList<EmployeeModel> _data = <EmployeeModel>[].obs;
  List<ColumnModel> _columns = [];
  final EmployeesController _controller;
  EmployeesDataTableSource(this._controller) {
    _data = _controller.filteredEmployeeList;
    _columns = _controller.columns;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final employee = _data[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ..._columns.map((column) {
          final field = column.field;
          final value = employee.toJson()[field];

          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }
}
