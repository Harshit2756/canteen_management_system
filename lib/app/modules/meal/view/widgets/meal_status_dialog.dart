import 'package:canteen_app/app/modules/meal/controller/meal_request_controller.dart';
import 'package:canteen_app/core/utils/constants/enums/enums.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:canteen_app/core/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/dialog_bottomsheet/custom_dialog.dart';

class mealstatusDialog extends StatelessWidget {
  final String mealsId;
  final String mealName;

  const mealstatusDialog({
    super.key,
    required this.mealsId,
    required this.mealName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealRequestController>();

    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(HTexts.processMealRequest, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: HColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: HSizes.sm8),
          Text('${HTexts.mealName}: $mealName', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: HSizes.lg24),
          CustomTextField(
            type: TextFieldType.general,
            controller: controller.remarksController,
            keyboardType: TextInputType.text,
            labelText: HTexts.remarks,
            hintText: HTexts.remarksHint,
            prefixIcon: HIcons.status,
          ),
          const SizedBox(height: HSizes.xl32),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: HTexts.reject,
                  onPressed: () {
                    controller.processStatus(Status.REJECTED, mealsId);
                    Navigator.pop(context);
                  },
                  icon: HIcons.close,
                  bgColor: HColors.rejectedColor,
                  borderColor: HColors.rejectedColor,
                ),
              ),
              const SizedBox(width: HSizes.md16),
              Expanded(
                child: CustomButton(
                  text: HTexts.accept,
                  onPressed: () {
                    controller.processStatus(Status.APPROVED, mealsId);
                    Navigator.pop(context);
                  },
                  icon: Icons.check,
                  bgColor: HColors.approvedColor,
                  borderColor: HColors.approvedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
