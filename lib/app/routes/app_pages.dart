import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/camera_binding.dart';
import '../bindings/attendance_binding.dart';
import '../screens/auth/login_view.dart';
import '../screens/auth/register_view.dart';
import '../screens/attendance/attendance_view.dart';
import '../screens/admin_dashboard/dashboard_admin_view.dart';
import '../screens/student_dashboard/dashboard_siswa_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => AttendanceView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => DashboardAdminView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => DashboardSiswaView(),
      binding: AttendanceBinding(),
    ),
  ];
}
