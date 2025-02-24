import 'package:canteen_app/app/data/services/auth/auth_service.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/loading/loading_widget.dart';
import 'package:canteen_app/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/internet/internet_service.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [HColors.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: Future.wait([initServices()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        child: FlutterLogo(
                          size: 80,
                          style: FlutterLogoStyle.stacked,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome to Attendance App',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: HColors.primary,
                              ),
                    ),
                    const SizedBox(height: 20),
                    const LoadingWidget(),
                  ],
                ),
              );
            } else {
              final AuthService authService = Get.find<AuthService>();
              final internetService = Get.find<CheckInternetService>();

              return Obx(() {
                if (internetService.isConnected.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAllNamed(authService.handleRouteRedirection());
                  });
                }
                return const SizedBox();
              });
            }
          },
        ),
      ),
    );
  }
}
