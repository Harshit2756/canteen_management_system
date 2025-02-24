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
import '../../../../core/widgets/loading/loading_widget.dart';
import '../controller/meals_menu_controller.dart';

class AddMealMenuView extends StatelessWidget {
  const AddMealMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MealsMenuController>() ? Get.find<MealsMenuController>() : Get.put(MealsMenuController());

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

  Widget buildForm(MealsMenuController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.spaceBtwItems24),
      child: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                // * Meal name text field
                CustomTextField(
                  controller: controller.nameController,
                  type: TextFieldType.general,
                  keyboardType: TextInputType.text,
                  labelText: HTexts.mealName,
                  hintText: HTexts.mealName,
                  prefixIcon: HIcons.meal,
                  validator: (value) => value.validateAlphaWithSpace(HTexts.mealName),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Price text field
                CustomTextField(
                  controller: controller.priceController,
                  type: TextFieldType.general,
                  keyboardType: TextInputType.number,
                  labelText: HTexts.price,
                  hintText: HTexts.price,
                  prefixIcon: HIcons.price,
                  validator: (value) => value.validateNumeric(HTexts.price),
                ),

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
                        onPressed: controller.addMealsMenu,
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
