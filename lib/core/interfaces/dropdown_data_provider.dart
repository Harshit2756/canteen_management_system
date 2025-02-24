import 'package:canteen_app/app/data/models/local/plants_id_model.dart';
import 'package:get/get.dart';
import '../../app/data/models/local/member_id_model.dart';

import '../../app/data/models/local/meals_id_mode.dart';

abstract class PlantDataProvider {
  RxString get selectedPlantId;
  List<Map<String, PlantsIdModel>> get plantsList;
  Future<void> getPlantsIdList({bool isFromApi = false});
}

abstract class MealDataProvider {
  RxString get selectedMealId;
  List<Map<String, MealsIdModel>> get mealsList;
  Future<void> getMealsList({bool isFromApi = false});
}

abstract class MemberDataProvider {
  RxString get selectedMemberId;
  List<Map<String, MemberIdModel>> get membersList;
  Future<void> getMemberList({bool isFromApi = false});
}
