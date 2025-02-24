import 'package:flutter/material.dart';

import '../../../../../../../core/utils/media/icons_strings.dart';
import '../../../../../../../core/utils/theme/colors.dart';

enum ReportFormat {
  daywise,
  summarized,
}

class ReportModeSelector extends StatelessWidget {
  final ReportFormat selectedFormat;
  final Function(Set<ReportFormat>) onSelectionChanged;

  const ReportModeSelector({super.key, required this.selectedFormat, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REPORT TYPE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: HColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ReportFormat>(
          selectedIcon: const Icon(HIcons.selected),
          selected: {selectedFormat},
          onSelectionChanged: onSelectionChanged,
          segments: const [
            ButtonSegment(
              value: ReportFormat.daywise,
              label: Text('Daywise'),
            ),
            ButtonSegment(
              value: ReportFormat.summarized,
              label: Text('Summarized'),
            ),
          ],
        ),
      ],
    );
  }
}
