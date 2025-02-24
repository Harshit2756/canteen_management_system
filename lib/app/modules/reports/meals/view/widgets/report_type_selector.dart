// import 'package:flutter/material.dart';

// import '../../../../../../../core/utils/media/icons_strings.dart';
// import '../../../../../../../core/utils/theme/colors.dart';

// enum ReportType {
//   attendance,
//   payroll,
// }

// class ReportTypeSelector extends StatelessWidget {
//   final ReportType selectedType;
//   final Function(Set<ReportType>) onSelectionChanged;

//   const ReportTypeSelector({
//     super.key,
//     required this.selectedType,
//     required this.onSelectionChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'REPORT TYPE',
//           style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                 color: HColors.primary,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         const SizedBox(height: 8),
//         SegmentedButton<ReportType>(
//           selectedIcon: const Icon(HIcons.selected),
//           selected: {selectedType},
//           onSelectionChanged: onSelectionChanged,
//           segments: const [
//             ButtonSegment(
//               value: ReportType.attendance,
//               label: Text('Attendance'),
//             ),
//             ButtonSegment(
//               value: ReportType.payroll,
//               label: Text('Payroll'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
