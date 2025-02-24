import 'package:canteen_app/core/utils/constants/extension/platform_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/desktop_card.dart';
import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/utils/media/icons_strings.dart';
import '../../../../core/utils/media/text_strings.dart';
import '../../../../core/utils/theme/colors.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(
        showBackButton: PlatformHelper.isMobileOs,
        title: HTexts.profile,
      ),
      mobile: _buildMobileView(controller),
      desktop: _buildUserView(controller),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HColors.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: HColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: HColors.primary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMobileView(ProfileController controller) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ID Card Design with custom gradient background
              _buildUserCard(controller),
              const SizedBox(height: 32),
              // Upgraded Menu Items
              _buildMenuItem(HIcons.phone, 'Contact Number: ${controller.user.value?.mobileNumber ?? "N/A"}', () {
                // Handle contact number tap
              }),
              _buildMenuItem(HIcons.address, 'Address: 123 Main St, City, Country', () {
                // Handle address tap
              }),
              _buildMenuItem(HIcons.profile, 'Bio: A brief description about the user goes here.', () {
                // Handle bio tap
              }),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  // Handle edit profile action
                },
                text: HTexts.edit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HColors.secondary,
            HColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Text(
              controller.user.value?.name ?? "User Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),
          Obx(() {
            return Text(
              controller.user.value?.username ?? "user@example.com",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            );
          }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Employee ID Card',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserView(ProfileController controller) {
    return DesktopCard(
      child: Column(
        children: [
          _buildUserCard(controller),
          const SizedBox(height: 32),
          _buildMenuItem(HIcons.phone, 'Contact Number: ${controller.user.value?.mobileNumber ?? "N/A"}', () {
            // Handle contact number tap
          }),
          _buildMenuItem(HIcons.address, 'Address: 123 Main St, City, Country', () {
            // Handle address tap
          }),
          _buildMenuItem(HIcons.profile, 'Bio: A brief description about the user goes here.', () {
            // Handle bio tap
          }),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () {
              // Handle edit profile action
            },
            text: HTexts.edit,
          ),
        ],
      ),
    );
  }
}
