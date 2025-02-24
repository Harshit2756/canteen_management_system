import 'package:canteen_app/core/utils/constants/extension/formatter.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:flutter/material.dart';

import 'date_select_button.dart';

enum DateSelectionType {
  single,
  range,
}

class DateSelector extends StatelessWidget {
  final DateSelectionType selectedType;
  final Function(Set<DateSelectionType>) onTypeChanged;
  final DateTime singleDate;
  final DateTimeRange dateRange;
  final Function(DateTime) onSingleDateChanged;
  final Function(DateTime, DateTime) onDateRangeChanged;

  const DateSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.singleDate,
    required this.dateRange,
    required this.onSingleDateChanged,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATE SELECTION',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<DateSelectionType>(
          selectedIcon: const Icon(HIcons.selected),
          selected: {selectedType},
          onSelectionChanged: onTypeChanged,
          segments: const [
            ButtonSegment(
              value: DateSelectionType.single,
              label: Text('Single Date'),
            ),
            ButtonSegment(
              value: DateSelectionType.range,
              label: Text('Date Range'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          selectedType == DateSelectionType.single
              ? 'SELECT DATE'
              : 'SELECT DATE RANGE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),
        if (selectedType == DateSelectionType.single)
          DatePickerButton(
            text: singleDate.shortDateWithShortYear,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: singleDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onSingleDateChanged(picked);
              }
            },
          )
        else
          DatePickerButton(
            text:
                '${dateRange.start.shortDateWithShortYear} - ${dateRange.end.shortDateWithShortYear}',
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: dateRange,
              );
              if (picked != null) {
                onDateRangeChanged(picked.start, picked.end);
              }
            },
          ),
      ],
    );
  }
}
