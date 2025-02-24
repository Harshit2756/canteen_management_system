import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/extension/formatter.dart';
import '../../../../../core/utils/theme/colors.dart';
import '../../../../data/models/column_model.dart';
import '../../../../data/models/network/member/member_model.dart';
import '../../controller/members_controller.dart';

class MembersDataTableSource extends DataTableSource {
  RxList<MemberModel> _data = <MemberModel>[].obs;
  List<ColumnModel> _columns = [];
  final MembersController _controller;
  MembersDataTableSource(this._controller) {
    _data = _controller.filteredMemberList;
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
    final member = _data[index];
    return DataRow2(
      color: WidgetStateColor.resolveWith((states) => index.isEven ? HColors.white : HColors.grey.withValues(alpha: 0.5)),
      cells: [
        ..._columns.map((column) {
          final field = column.field;
          final value = member.toJson()[field];

          // Check for specific fields to show icon buttons
          if (field?.contains('password') ?? false) {
            return DataCell(passwordText(member));
          }

          return DataCell(Text(FormateDataCell.formatCellValue(field, value)));
        }),
      ],
    );
  }

  Widget passwordText(MemberModel member) {
    if (member.password != null) {
      return Row(
        children: [
          Obx(() {
            return Text(
              _controller.isPasswordVisible.value ? member.password ?? '' : '••••••••',
              style: TextStyle(fontSize: 16),
            );
          }),
          IconButton(
            icon: Icon(_controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              _controller.isPasswordVisible.value = !_controller.isPasswordVisible.value;
            },
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
