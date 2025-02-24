import 'package:canteen_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:canteen_app/app/data/services/internet/internet_service.dart';
import 'package:canteen_app/app/data/services/local_db/storage_service.dart';
import 'package:canteen_app/app/data/services/network_db/api_service.dart';
import 'package:get/get.dart';

import 'core/widgets/sidebar/controller/sidebar_controller.dart';

Future<void> initServices() async {
  Get.put(CheckInternetService(), permanent: true);
  await Get.putAsync<StorageService>(() async => StorageService().init(),
      permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(AuthRepository(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(SidebarController(), permanent: true);
}
