import 'package:canteen_app/core/utils/constants/extension/platform_extensions.dart';
import 'package:canteen_app/core/widgets/error/empty_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/theme/colors.dart';
import '../searchbar/searchbar.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn2> columns;
  final DataTableSource source;
  final int? sortColumnIndex;
  final int rowsPerPage;
  final double minWidth;
  final double dataRowHeight;
  final void Function(int)? onPageChanged;
  final bool sortAscending;
  final bool showCheckboxColumn;
  final SearchController? searchController;
  final String searchHintText;
  final Widget? heading;
  final List<Widget>? actions;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.source,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.rowsPerPage = 10,
    this.minWidth = 1800,
    this.dataRowHeight = 56,
    this.onPageChanged,
    this.showCheckboxColumn = false,
    this.searchController,
    this.searchHintText = 'Search By Name',
    this.heading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = PlatformHelper.isDesktop;

    // Return EmptyWidget if columns is empty
    if (columns.isEmpty) {
      return const EmptyWidget(message: 'No data Available');
    }

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(color: HColors.white, elevation: 0),
      ),
      child: Container(
        padding: isDesktop ? const EdgeInsets.symmetric(horizontal: 16) : null,
        decoration: BoxDecoration(color: HColors.white),
        child: PaginatedDataTable2(
          source: source,
          columns: columns,
          columnSpacing: 10,
          minWidth: minWidth,
          dividerThickness: 0,
          horizontalMargin: 12,
          rowsPerPage: rowsPerPage,
          showFirstLastButtons: true,
          dataRowHeight: dataRowHeight,
          sortAscending: sortAscending,
          onPageChanged: onPageChanged,
          renderEmptyRowsInTheEnd: false,
          sortColumnIndex: sortColumnIndex,
          showCheckboxColumn: showCheckboxColumn,
          onRowsPerPageChanged: (noOfRows) {},
          headingTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: HColors.white),
          headingRowDecoration: BoxDecoration(
            color: HColors.primary,
          ),
          empty: EmptyWidget(message: 'No data Available'),
          border: TableBorder.all(color: HColors.grey, width: 1),
          sortArrowBuilder: (ascending, sorted) => Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              sorted ? (ascending ? Iconsax.arrow_circle_up_bold : Iconsax.arrow_circle_down_bold) : Iconsax.arrange_circle_bold,
              color: HColors.white,
              size: 15,
            ),
          ),
          actions: actions,
          header: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                heading ?? const SizedBox(),
                searchController != null && isDesktop
                    ? HSearchBar(
                        searchController: searchController!,
                        hintText: searchHintText,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
