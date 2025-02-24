import 'package:canteen_app/core/utils/constants/extension/formatter.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/helpers/helper_functions.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:canteen_app/core/widgets/cards/base_info_card.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/enums/enums.dart';
import '../../../../../core/widgets/dialog_bottomsheet/custom_dialog.dart';

class MealsEnterDialog extends StatelessWidget {
  final VoidCallback onOk;
  final VoidCallback onMarkEntry;
  final VoidCallback? onMarkExit;
  final String status, name, plantName, ticketId;

  const MealsEnterDialog({
    super.key,
    required this.onOk,
    required this.onMarkEntry,
    required this.status,
    required this.name,
    required this.plantName,
    required this.ticketId,
    this.onMarkExit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      maxHeight: 400,
      padding: const EdgeInsets.symmetric(horizontal: HSizes.md16, vertical: HSizes.spaceBtwItems24),
      child: BaseInfoCard(
        name: name,
        statusBgColor: HHelperFunctions.getStatusBgColor(status),
        statusTextColor: HHelperFunctions.getStatusColor(status),
        roleText: status,
        extraWidget: Column(
          spacing: 12,
          children: [
            if (status.toStatusEnum() == Status.PENDING) ...[
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: HColors.warning,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: HColors.warning, width: 1.5),
                ),
                child: Text(
                  'Note: Please approve the request first',
                  style: TextStyle(color: HColors.black),
                ),
              ),
            ],
            Row(
              children: [
                if (status.toStatusEnum() == Status.APPROVED) ...[
                  Expanded(child: CustomButton(text: HTexts.markEntry, onPressed: onMarkEntry)),
                  const SizedBox(width: HSizes.md16),
                ],
                Expanded(child: CustomButton(text: HTexts.ok, onPressed: onOk)),
              ],
            ),
          ],
        ),
        detailTiles: [
          DetailTileData(icon: HIcons.ticket, label: HTexts.ticketId, value: ticketId),
          DetailTileData(icon: HIcons.status, label: HTexts.plantName, value: plantName),
        ],
      ),
    );
  }
}
