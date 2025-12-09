import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class DashboardRedirectView extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Redirect based on user role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.user.value != null) {
        if (authController.user.value!.role == 'admin') {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else {
          Get.offAllNamed(AppRoutes.studentDashboard);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
