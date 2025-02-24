import 'package:canteen_app/core/utils/constants/extension/validator.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/desktop_card.dart';
import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/utils/media/icons_strings.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/dropdown/meals_dropdown.dart';
import '../../../../core/widgets/dropdown/plants_dropdown.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../controller/meal_request_controller.dart';

class AddMealRequestView extends StatelessWidget {
  const AddMealRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MealRequestController(), tag: 'visitorController');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getPlantsIdList(isFromApi: false);
    });

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(),
      mobile: Obx(() {
        return controller.isLoadingList.value ? const LoadingWidget() : buildForm(controller, context);
      }),
      desktop: DesktopCard(
        width: 0.6,
        child: Obx(() {
          return controller.isLoadingList.value ? const LoadingWidget() : buildForm(controller, context);
        }),
      ),
    );
  }

  Widget buildForm(MealRequestController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.spaceBtwItems24),
      child: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.quantityController,
                  type: TextFieldType.general,
                  keyboardType: TextInputType.number,
                  labelText: HTexts.quantity,
                  hintText: HTexts.quantity,
                  prefixIcon: HIcons.quantity,
                  validator: (value) => value.validateNumeric(HTexts.quantity),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Plant dropdown
                PlantDropdown(controller: controller),

                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Meal dropdown
                MealDropdown(controller: controller),

                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Register and cancel buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onPressed: () {
                        controller.clearForm();
                        Get.back();
                      },
                      text: HTexts.cancel,
                      isSecondaryButton: true,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: controller.addMealRequest,
                        text: HTexts.register,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
