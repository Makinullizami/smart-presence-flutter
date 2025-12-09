import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../services/api_service.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}
