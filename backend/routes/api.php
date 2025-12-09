<?php

use App\Contracts\SettingsServiceInterface;
use App\Http\Controllers\Api\Admin\SettingsController;
use App\Http\Controllers\AppealController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\FaceController;
use App\Http\Controllers\AnnouncementController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\UserController;
use App\Models\User;
use App\Services\SettingsService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Route;

// Define Gates
Gate::define('manage-settings', function (User $user) {
    return in_array($user->role, ['admin', 'super_admin']);
});

// Bind Settings Service
app()->bind(SettingsServiceInterface::class, SettingsService::class);

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Attendance routes
    Route::post('/attendance', [AttendanceController::class, 'markAttendance']);
    Route::get('/attendance/{userId}', [AttendanceController::class, 'getAttendanceHistory']);
    Route::get('/attendance', [AttendanceController::class, 'getAllAttendances']);

    // Face recognition routes
    Route::post('/faces/embedding', [FaceController::class, 'uploadEmbedding']);
    Route::get('/faces/{userId}', [FaceController::class, 'getUserFaces']);
    Route::post('/faces/recognize', [FaceController::class, 'recognizeFace']);

    // Appeal/Leave request routes
    Route::apiResource('appeals', AppealController::class);
    Route::post('/appeals/{appeal}/approve', [AppealController::class, 'approve']);
    Route::post('/appeals/{appeal}/reject', [AppealController::class, 'reject']);
    Route::get('/appeals/{appeal}/download-attachment', [AppealController::class, 'downloadAttachment']);

    // Dashboard routes
    Route::get('/dashboard/admin', [DashboardController::class, 'getAdminDashboard']);
    Route::get('/dashboard/supervisor', [DashboardController::class, 'getSupervisorDashboard']);
    Route::post('/attendance/manual', [DashboardController::class, 'markManualAttendance']);
    Route::post('/attendance/note', [DashboardController::class, 'addAttendanceNote']);
    Route::get('/classes/{class}/attendance-summary', [DashboardController::class, 'getClassAttendanceSummary']);

    // Report routes
    Route::get('/reports/personal', [ReportController::class, 'getPersonalReport']);
    Route::get('/reports/supervisor', [ReportController::class, 'getSupervisorReport']);
    Route::get('/reports/detailed', [ReportController::class, 'getDetailedReport']);
    Route::get('/reports/export', [ReportController::class, 'exportReport']);

    // Notification routes
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::post('/notifications/send', [NotificationController::class, 'sendNotification']);
    Route::post('/notifications/broadcast', [NotificationController::class, 'sendBroadcast']);
    Route::post('/user/fcm-token', [NotificationController::class, 'updateFcmToken']);
    Route::get('/notifications/send-reminders', [NotificationController::class, 'sendAttendanceReminders']);
    Route::get('/notifications/statistics', [NotificationController::class, 'getStatistics']);

    // Announcement routes
    Route::get('/announcements', [AnnouncementController::class, 'index']);
    Route::post('/announcements', [AnnouncementController::class, 'store']);
    Route::get('/announcements/{id}', [AnnouncementController::class, 'show']);
    Route::put('/announcements/{id}', [AnnouncementController::class, 'update']);
    Route::delete('/announcements/{id}', [AnnouncementController::class, 'destroy']);
    Route::get('/announcements/categories', [AnnouncementController::class, 'getCategories']);
    Route::get('/announcements/targets', [AnnouncementController::class, 'getTargets']);

    // Profile routes
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
    Route::put('/profile/password', [ProfileController::class, 'updatePassword']);
    Route::put('/profile/notifications', [ProfileController::class, 'updateNotificationPreferences']);
    Route::put('/profile/fcm-token', [ProfileController::class, 'updateFcmToken']);

    // Device management routes
    Route::get('/devices', [ProfileController::class, 'getDevices']);
    Route::post('/devices', [ProfileController::class, 'registerDevice']);
    Route::post('/devices/verify', [ProfileController::class, 'verifyDevice']);
    Route::delete('/devices/{deviceId}', [ProfileController::class, 'removeDevice']);

    // User management routes
    Route::apiResource('users', UserController::class);
    Route::post('/users/{user}/toggle-status', [UserController::class, 'toggleStatus']);
    Route::post('/users/{user}/reset-password', [UserController::class, 'resetPassword']);
    Route::post('/users/import', [UserController::class, 'import']);
    Route::get('/users-meta/roles', [UserController::class, 'getRoles']);
    Route::get('/users-meta/departments', [UserController::class, 'getDepartments']);
    Route::get('/users-meta/classes', [UserController::class, 'getClasses']);

    // Settings routes (admin only)
    Route::middleware('can:manage-settings')->prefix('admin/settings')->group(function () {
        Route::get('profile', [SettingsController::class, 'showProfile']);
        Route::put('profile', [SettingsController::class, 'updateProfile']);
        Route::post('profile/logo', [SettingsController::class, 'uploadLogo']);

        Route::get('attendance', [SettingsController::class, 'showAttendance']);
        Route::put('attendance', [SettingsController::class, 'updateAttendance']);

        Route::get('location-device', [SettingsController::class, 'showLocationDevice']);
        Route::put('location-device', [SettingsController::class, 'updateLocationDevice']);

        Route::get('face', [SettingsController::class, 'showFace']);
        Route::put('face', [SettingsController::class, 'updateFace']);

        Route::get('notification-email', [SettingsController::class, 'showNotificationEmail']);
        Route::put('notification-email', [SettingsController::class, 'updateNotificationEmail']);

        Route::get('integration', [SettingsController::class, 'showIntegration']);
        Route::put('integration', [SettingsController::class, 'updateIntegration']);

        Route::get('system-security', [SettingsController::class, 'showSystemSecurity']);
        Route::put('system-security', [SettingsController::class, 'updateSystemSecurity']);
    });
});