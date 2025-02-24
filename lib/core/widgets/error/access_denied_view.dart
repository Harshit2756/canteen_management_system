import 'package:canteen_app/core/routes/routes_name.dart';
import 'package:canteen_app/core/widgets/appbar/custom_appbar.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.withText(title: 'Access Denied'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You do not have permission to access this page.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Get.toNamed(HRoutesName.login);
                },
                text: 'Go to Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
