import 'package:canteen_app/core/responsive/layouts/desktop_card.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:canteen_app/core/widgets/loading/loading_widget.dart';
import 'package:canteen_app/core/widgets/searchbar/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/layouts/responsive_layout.dart';
import '../../../../core/widgets/appbar/custom_appbar.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/shimmer/shimmer_list_view.dart';
import '../../../../core/widgets/dropdown/plants_dropdown.dart'; // Add this import for PlantDropdown
import '../controller/plants_controller.dart';
import '../../../../core/widgets/dropdown/member_dropdown.dart';
import 'widget/plant_member_list_card.dart';

class PlantMembersListView extends StatelessWidget {
  const PlantMembersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PlantsController>() ? Get.find<PlantsController>() : Get.put(PlantsController());

    // Ensure that the data is fetched after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMemberList();
      controller.searchMembersController.addListener(() {
        controller.searchMembers(controller.searchMembersController.text);
      });
    });

    return ResponsiveLayout(
      appBar: CustomAppBar.withText(
        title: 'Plant - ${controller.selectedPlantName.value}',
        actions: [],
      ),
      mobile: RefreshIndicator(
        onRefresh: () => controller.getAllPlants(isFromApi: true),
        child: Obx(
          () {
            return controller.isLoadingList.value ? const ShimmerListView() : buildListView(controller);
          },
        ),
      ),
      desktop: Row(
        children: [
          Expanded(child: DesktopCard(child: buildListView(controller))),
          Expanded(child: buildForms(controller, context)),
        ],
      ),
    );
  }

  Widget buildForms(PlantsController controller, BuildContext context) {
    return Column(children: [
      //* Add Plant
      Expanded(
        child: DesktopCard(
          padding: EdgeInsets.symmetric(horizontal: HSizes.lg24, vertical: HSizes.md16),
          child: controller.isLoadingAdd.value
              ? const LoadingWidget()
              : Form(
                  key: controller.formKeyAdd,
                  child: ListView(
                    children: [
                      Text(HTexts.addPlant, style: context.theme.textTheme.titleMedium),
                      const SizedBox(height: HSizes.spaceBtwItems24),
                      CustomTextField(
                        controller: controller.nameController,
                        type: TextFieldType.name,
                      ),
                      const SizedBox(height: HSizes.spaceBtwInputFields16),
                      CustomButton(
                        text: HTexts.editPlant,
                        onPressed: () => controller.updatePlants(controller.selectedPlantId.value),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      //* Add Member to Plant
      Expanded(
        child: DesktopCard(
          child: controller.isLoadingMember.value
              ? const LoadingWidget()
              : Form(
                  key: controller.formKeyToPlant,
                  child: ListView(
                    children: [
                      Text('Add Member To Plant', style: context.theme.textTheme.titleMedium),
                      const SizedBox(height: HSizes.spaceBtwItems24),

                      MemberDropdown(controller: controller),

                      const SizedBox(height: HSizes.spaceBtwItems8),
                      Center(child: Text('To', style: context.theme.textTheme.titleMedium)),
                      const SizedBox(height: HSizes.spaceBtwItems8),

                      // Replace the old dropdown with PlantDropdown
                      PlantDropdown(controller: controller),

                      const SizedBox(height: HSizes.spaceBtwInputFields16),
                      CustomButton(
                        text: 'Add Member To Plant',
                        onPressed: controller.addMemberToPlant,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    ]);
  }

  Widget buildListView(PlantsController controller) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: HSizes.md16,
              right: HSizes.md16,
              top: HSizes.sm8,
              bottom: HSizes.sm8,
            ),
            child: HSearchBar(
              searchController: controller.searchMembersController,
              hintText: HTexts.searchMember,
            ),
          ),
          const SizedBox(height: HSizes.sm8),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: HSizes.sm8),
              itemCount: controller.filteredMembersList.length,
              itemBuilder: (context, index) {
                final member = controller.filteredMembersList[index];
                return PlantMemberListCard(
                  member: member,
                  onDelete: () => controller.removeMemberFromPlant(member.userId.toString()),
                );
              },
            ),
          ),
          const SizedBox(height: HSizes.sm8),
        ],
      ),
    );
  }
}
