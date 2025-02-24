import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../../core/utils/theme/colors.dart';
import '../../../../../core/utils/media/icons_strings.dart';
import '../../controller/plants_controller.dart';

class PlantsDataTableSource extends DataTableSource {
  final PlantsController _controller;

  PlantsDataTableSource(this._controller) {
    // Add listener to notify table when data changes
    _controller.filteredPlantsList.listen((_) => notifyListeners());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _controller.filteredPlantsList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final plant = _controller.filteredPlantsList[index];
    return DataRow2(
      onTap: () => _controller.showEmployeeListView(plant.members ?? [], plant.id.toString(), plant.name),
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ..._controller.columns.map((column) {
          final field = column.field;
          final value = plant.toJson()[field];

          if (field == 'Button') {
            return DataCell(
              IconButton(onPressed: () => _controller.deletePlants(plant.id.toString()), icon: const Icon(HIcons.delete, color: Colors.red)),
            );
          }
          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }
}
