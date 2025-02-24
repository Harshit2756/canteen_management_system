import 'package:canteen_app/app/data/models/local/meals_id_mode.dart';
import 'package:canteen_app/core/utils/constants/extension/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../interfaces/dropdown_data_provider.dart';
import '../../utils/media/icons_strings.dart';
import '../../utils/media/text_strings.dart';
import '../../utils/theme/colors.dart';
import 'base_dropdown.dart';

class MealDropdown extends StatelessWidget {
  final MealDataProvider controller;

  const MealDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BaseDropdown<int>(
          value: controller.selectedMealId.isNotEmpty ? int.tryParse(controller.selectedMealId.value) : null,
          labelText: HTexts.meals,
          hintText: HTexts.selectMeal,
          prefixIcon: const Icon(HIcons.meal),
          suffix: InkWell(
            onTap: () => controller.getMealsList(isFromApi: true),
            child: const Icon(HIcons.refresh),
          ),
          dropdownColor: HColors.white,
          validator: (value) => value.toString().validateNotEmpty(HTexts.meals),
          items: controller.mealsList.isEmpty ? [_buildEmptyItem(context, HTexts.noMealsFound)] : _buildMealItems(controller.mealsList),
          onChanged: (value) => controller.selectedMealId.value = value?.toString() ?? '',
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

  List<DropdownMenuItem<int>> _buildMealItems(List<Map<String, dynamic>> meals) {
    return meals.map((mealMap) {
      final meal = mealMap.values.first as MealsIdModel;
      return DropdownMenuItem<int>(
        value: meal.id,
        child: Text(meal.name ),
      );
    }).toList();
  }
}
