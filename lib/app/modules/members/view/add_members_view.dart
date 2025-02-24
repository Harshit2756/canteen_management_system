import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/desktop_card.dart';
import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../controller/members_controller.dart';

class AddMembersView extends StatelessWidget {
  const AddMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MembersController>() ? Get.find<MembersController>() : Get.put(MembersController());

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.getPlantsIdList(isFromApi: false);
    // });

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(title: HTexts.addMember),
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

  Widget buildForm(MembersController controller, BuildContext context) {
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
                //* UserName
                CustomTextField(
                  type: TextFieldType.username,
                  focusNode: controller.usernameFocusNode,
                  controller: controller.usernameController,
                  onFieldSubmitted: (value) {
                    controller.usernameFocusNode.unfocus();
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
                  ),
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * Mobile field
                CustomTextField(
                  type: TextFieldType.mobile,
                  focusNode: controller.mobileFocusNode,
                  controller: controller.mobileController,
                  onFieldSubmitted: (value) {
                    controller.mobileFocusNode.unfocus();
                  },
                ),
                const SizedBox(height: HSizes.spaceBtwInputFields16),
                // * plant name
                //  PlantDropdown(controller: controller),

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
                        onPressed: () => controller.registerMember(),
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
