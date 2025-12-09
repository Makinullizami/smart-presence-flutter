abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const adminDashboard = '/admin-dashboard';
  static const studentDashboard = '/student-dashboard';
  static const supervisorDashboard = '/supervisor-dashboard';
  static const personalReport = '/personal-report';
  static const supervisorReport = '/supervisor-report';
  static const notifications = '/notifications';
  static const announcements = '/announcements';

  // User Management
  static const userManagement = '/user-management';
  static const userManagementList = '/user-management/list';
  static const userManagementAdd = '/user-management/add';
  static const userManagementEdit = '/user-management/edit/:id';
  static const userManagementImport = '/user-management/import';
  static const userManagementRoles = '/user-management/roles';

  // Department Management
  static const departmentManagement = '/department-management';
  static const departmentDetail = '/department-detail/:id';

  // Class Management
  static const classManagement = '/class-management';
  static const classDetail = '/class-detail/:id';

  // Reports
  static const reports = '/reports';

  // Settings
  static const settings = '/settings';
}
