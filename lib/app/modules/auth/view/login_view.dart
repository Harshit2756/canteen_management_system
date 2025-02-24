import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:canteen_app/core/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/media/icons_strings.dart';
import '../../../../core/utils/media/text_strings.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      appBar: CustomAppBar.withText(
        title: HTexts.signIn,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(HSizes.md16),
            child: Column(
              children: [
                const SizedBox(height: HSizes.spaceBtwSections32),
                // Logo with circular background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: HColors.primary,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.task,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: HSizes.spaceBtwSections32),
                // Card containing text fields and buttons
                Container(
                  width: 300,
                  margin: const EdgeInsets.symmetric(horizontal: HSizes.md16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(HSizes.cardRadiusLg16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(HSizes.md16),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: HSizes.sm8),
                          Text(
                            'Please sign in to your account',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: HSizes.spaceBtwSections32),
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
                          Obx(
                            () => CustomTextField(
                              type: TextFieldType.password,
                              focusNode: controller.passwordFocusNode,
                              controller: controller.passwordController,
                              isPasswordVisible: controller.hidePassword.value,
                              onIconTap: () =>
                                  controller.togglePasswordVisibility(),
                              toValidate: false,
                            ),
                          ),
                          const SizedBox(height: HSizes.spaceBtwSections32),
                          Obx(
                            () => CustomButton(
                              text: HTexts.signIn,
                              isLoading: controller.isLoading.value,
                              onPressed: controller.login,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.bottomSheet(
                                Container(
                                  padding: const EdgeInsets.all(
                                      HSizes.spaceBtwSections32),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          HSizes.cardRadiusLg16),
                                      topRight: Radius.circular(
                                          HSizes.cardRadiusLg16),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Select Role',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                          height: HSizes.spaceBtwItems24),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.admin_panel_settings),
                                        title: const Text('Admin'),
                                        onTap: () {
                                          controller.usernameController.text =
                                              'admin';
                                          controller.passwordController.text =
                                              'admin@123';
                                          // controller.usernameController.text =
                                          //     'whynotparit';
                                          // controller.passwordController.text =
                                          //     'b14ck-cyph3R';
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(HIcons.contractor),
                                        title: const Text('Contractor'),
                                        onTap: () {
                                          controller.usernameController.text =
                                              'manager';
                                          controller.passwordController.text =
                                              'Manager@123';
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(HIcons.manager),
                                        title: const Text('Manager'),
                                        onTap: () {
                                          controller.usernameController.text =
                                              'Contractor';
                                          controller.passwordController.text =
                                              'Contractor@123';
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.work),
                                        title: const Text('Labour'),
                                        onTap: () {
                                          controller.usernameController.text =
                                              'Labour';
                                          controller.passwordController.text =
                                              'Labour@123';
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(HTexts.dontHaveAnAccount),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
