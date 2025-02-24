import 'package:canteen_app/core/utils/constants/extension/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/local/plants_id_model.dart';
import '../../interfaces/dropdown_data_provider.dart';
import '../../utils/media/icons_strings.dart';
import '../../utils/media/text_strings.dart';
import '../../utils/theme/colors.dart';
import 'base_dropdown.dart';

class PlantDropdown extends StatelessWidget {
  final PlantDataProvider controller;

  const PlantDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BaseDropdown<int>(
          value: controller.selectedPlantId.isNotEmpty ? int.tryParse(controller.selectedPlantId.value) : null,
          labelText: HTexts.plant,
          hintText: HTexts.selectPlant,
          prefixIcon: const Icon(HIcons.plant),
          suffix: InkWell(
            onTap: () => controller.getPlantsIdList(isFromApi: true),
            child: const Icon(HIcons.refresh),
          ),
          dropdownColor: HColors.white,
          validator: (value) => value.toString().validateNotEmpty(HTexts.plant),
          items: controller.plantsList.isEmpty ? [_buildEmptyItem(context, HTexts.noPlantsFound)] : _buildPlantItems(controller.plantsList),
          onChanged: (value) => controller.selectedPlantId.value = value?.toString() ?? '',
        ));
  }

  DropdownMenuItem<int> _buildEmptyItem(BuildContext context, String text) {
    return DropdownMenuItem(
      value: null,
      child: Center(
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildPlantItems(List<Map<String, dynamic>> plants) {
    return plants.map((plantMap) {
      final plant = plantMap.values.first as PlantsIdModel;
      return DropdownMenuItem<int>(
        value: plant.id,
        child: Text(plant.name),
      );
    }).toList();
  }
}
