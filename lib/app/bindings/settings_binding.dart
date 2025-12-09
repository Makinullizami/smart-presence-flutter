import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../services/api_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
