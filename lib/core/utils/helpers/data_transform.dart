import '../../../app/data/models/local/meals_id_mode.dart';
import '../../../app/data/models/local/member_id_model.dart';
import '../../../app/data/models/local/plants_id_model.dart';
import '../../../app/data/models/network/meals/meals_menu_model.dart';
import '../../../app/data/models/network/member/member_model.dart';
import '../../../app/data/models/network/plants/plants_model.dart';

class DataTransform {
  static String convertCamelCaseToTitle(String field) {
    return field.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  static List<Map<String, PlantsIdModel>> transformPlantsList(List<PlantsModel> plants) {
    return plants.map((plant) {
      final plantData = PlantsIdModel(id: plant.id, name: plant.name);
      return {plant.id.toString(): plantData};
    }).toList();
  }

  static List<Map<String, MealsIdModel>> transformMealsList(List<MealsMenuModel> meals) {
    return meals.map((meal) {
      final mealData = MealsIdModel(id: meal.id, name: meal.name);
      return {meal.id.toString(): mealData};
    }).toList();
  }

  static List<Map<String, MemberIdModel>> transformMemberIdList(List<MemberModel> users) {
    return users.map((user) {
      final userData = MemberIdModel(id: user.id.toString(), name: user.name);
      return {user.id.toString(): userData};
    }).toList();
  }
}
