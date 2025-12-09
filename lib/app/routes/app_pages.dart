import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/camera_binding.dart';
import '../bindings/attendance_binding.dart';
import '../bindings/admin_binding.dart';
import '../bindings/reports_binding.dart';
import '../bindings/settings_binding.dart';
import '../bindings/user_management_binding.dart';
import '../screens/department_management/department_management_view.dart';
import '../screens/class_management/class_management_view.dart';
import '../screens/reports/attendance_report_page.dart';
import '../screens/settings/settings_page.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../screens/dashboard_redirect_view.dart';
import '../screens/attendance/attendance_view.dart';
import '../screens/admin_dashboard/dashboard_admin_view.dart';
import '../screens/student_dashboard/dashboard_siswa_view.dart';
import '../screens/supervisor_dashboard/dashboard_supervisor_view.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/announcements/announcements_screen.dart';
import '../screens/user_management/user_list_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardRedirectView(),
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
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => DashboardSiswaView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.supervisorDashboard,
      page: () => DashboardSupervisorView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => NotificationsScreen(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.announcements,
      page: () => AnnouncementsScreen(),
      binding: AttendanceBinding(),
    ),

    // User Management Routes
    GetPage(
      name: AppRoutes.userManagement,
      page: () => UserListScreen(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.userManagementList,
      page: () => UserListScreen(),
      binding: UserManagementBinding(),
    ),

    // Department Management Routes
    GetPage(
      name: AppRoutes.departmentManagement,
      page: () => DepartmentManagementView(),
      binding: AdminBinding(),
    ),

    // Class Management Routes
    GetPage(
      name: AppRoutes.classManagement,
      page: () => ClassManagementView(),
      binding: AdminBinding(),
    ),

    // Reports Route
    GetPage(
      name: AppRoutes.reports,
      page: () => AttendanceReportPage(),
      binding: ReportsBinding(),
    ),

    // Settings Route
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
  ];
}
