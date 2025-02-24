import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/desktop_card.dart';
import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/dropdown/plants_dropdown.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../controller/employee_controller.dart';

class AddEmployeesView extends StatelessWidget {
  const AddEmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EmployeesController>() ? Get.find<EmployeesController>() : Get.put(EmployeesController());

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(title: HTexts.addEmployee),
      mobile: Obx(() {
        return controller.isLoadingList.value ? const LoadingWidget() : buildForm(controller, context);
      }),
      desktop: DesktopCard(
        child: Obx(() {
          return controller.isLoadingList.value ? const LoadingWidget() : buildForm(controller, context);
        }),
      ),
    );
  }

  Widget buildForm(EmployeesController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HSizes.spaceBtwItems24),
      child: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                // * Name field
                CustomTextField(
                  type: TextFieldType.name,
                  focusNode: controller.nameFocusNode,
                  controller: controller.nameController,
                  onFieldSubmitted: (value) {
                    controller.nameFocusNode.unfocus();
                    controller.mobileFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Mobile field
                CustomTextField(
                  type: TextFieldType.mobile,
                  focusNode: controller.mobileFocusNode,
                  controller: controller.mobileController,
                  onFieldSubmitted: (value) {
                    controller.mobileFocusNode.unfocus();
                    controller.passwordFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                //* Password
                Obx(
                  () => CustomTextField(
                    type: TextFieldType.password,
                    onIconTap: () => controller.togglePasswordVisibility(),
                    focusNode: controller.passwordFocusNode,
                    controller: controller.passwordController,
                    isPasswordVisible: controller.hidePassword.value,
                    onFieldSubmitted: (value) {
                      controller.passwordFocusNode.unfocus();
                      controller.departmentFocusNode.requestFocus();
                    },
                  ),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                //* department field
                CustomTextField(
                  type: TextFieldType.general,
                  hintText: HTexts.department,
                  labelText: HTexts.department,
                  focusNode: controller.departmentFocusNode,
                  controller: controller.departmentController,
                  toValidate: false,
                  onFieldSubmitted: (value) {
                    controller.departmentFocusNode.unfocus();
                    controller.designationFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                //* designation field
                CustomTextField(
                  type: TextFieldType.general,
                  focusNode: controller.designationFocusNode,
                  controller: controller.designationController,
                  hintText: HTexts.designation,
                  labelText: HTexts.designation,
                  toValidate: false,
                  onFieldSubmitted: (value) {
                    controller.designationFocusNode.unfocus();
                  },
                ),

                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * plant name
                PlantDropdown(controller: controller),
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
                      // width: context.width * 0.4,
                      text: HTexts.cancel,
                      isSecondaryButton: true,
                    ),
                    Obx(
                      () => CustomButton(
                        // width: context.width * 0.4,
                        onPressed: () => controller.registerEmployee(),
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
