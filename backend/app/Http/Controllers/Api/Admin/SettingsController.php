<?php

namespace App\Http\Controllers\Api\Admin;

use App\Contracts\SettingsServiceInterface;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\AttendanceSettingsRequest;
use App\Http\Requests\Admin\FaceSettingsRequest;
use App\Http\Requests\Admin\IntegrationSettingsRequest;
use App\Http\Requests\Admin\LocationDeviceSettingsRequest;
use App\Http\Requests\Admin\NotificationEmailSettingsRequest;
use App\Http\Requests\Admin\ProfileSettingsRequest;
use App\Http\Requests\Admin\SystemSecuritySettingsRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class SettingsController extends Controller
{
    public function __construct(
        private SettingsServiceInterface $settingsService
    ) {}

    /**
     * Get profile settings.
     */
    public function showProfile(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('profile');
        return response()->json($data);
    }

    /**
     * Update profile settings.
     */
    public function updateProfile(ProfileSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('profile', $request->validated());

        return response()->json([
            'message' => 'Profil instansi berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get attendance settings.
     */
    public function showAttendance(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('attendance');
        return response()->json($data);
    }

    /**
     * Update attendance settings.
     */
    public function updateAttendance(AttendanceSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('attendance', $request->validated());

        return response()->json([
            'message' => 'Pengaturan absensi berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get location & device settings.
     */
    public function showLocationDevice(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('location_device');
        return response()->json($data);
    }

    /**
     * Update location & device settings.
     */
    public function updateLocationDevice(LocationDeviceSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('location_device', $request->validated());

        return response()->json([
            'message' => 'Pengaturan lokasi & perangkat berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get face recognition settings.
     */
    public function showFace(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('face');
        return response()->json($data);
    }

    /**
     * Update face recognition settings.
     */
    public function updateFace(FaceSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('face', $request->validated());

        return response()->json([
            'message' => 'Pengaturan face recognition berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get notification & email settings.
     */
    public function showNotificationEmail(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('notification_email');
        return response()->json($data);
    }

    /**
     * Update notification & email settings.
     */
    public function updateNotificationEmail(NotificationEmailSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('notification_email', $request->validated());

        return response()->json([
            'message' => 'Pengaturan notifikasi & email berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get integration settings.
     */
    public function showIntegration(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('integration');
        return response()->json($data);
    }

    /**
     * Update integration settings.
     */
    public function updateIntegration(IntegrationSettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('integration', $request->validated());

        return response()->json([
            'message' => 'Pengaturan integrasi berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Get system & security settings.
     */
    public function showSystemSecurity(): \Illuminate\Http\JsonResponse
    {
        $data = $this->settingsService->getGroup('system_security');
        return response()->json($data);
    }

    /**
     * Update system & security settings.
     */
    public function updateSystemSecurity(SystemSecuritySettingsRequest $request): \Illuminate\Http\JsonResponse
    {
        $updated = $this->settingsService->updateGroup('system_security', $request->validated());

        return response()->json([
            'message' => 'Pengaturan sistem & keamanan berhasil diperbarui.',
            'data' => $updated,
        ]);
    }

    /**
     * Upload institution logo.
     */
    public function uploadLogo(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'logo' => ['required', 'image', 'mimes:jpeg,png,jpg,gif,svg', 'max:2048'],
        ]);

        if ($request->hasFile('logo')) {
            // Delete old logo if exists
            $oldLogo = $this->settingsService->getGroup('profile')['institution_logo_path'] ?? null;
            if ($oldLogo && Storage::disk('public')->exists($oldLogo)) {
                Storage::disk('public')->delete($oldLogo);
            }

            // Store new logo
            $path = $request->file('logo')->store('logos', 'public');

            // Update setting
            $this->settingsService->updateGroup('profile', [
                'institution_logo_path' => $path,
            ]);

            return response()->json([
                'message' => 'Logo instansi berhasil diupload.',
                'data' => [
                    'logo_path' => $path,
                    'logo_url' => Storage::disk('public')->url($path),
                ],
            ]);
        }

        return response()->json([
            'message' => 'File logo tidak ditemukan.',
        ], 400);
    }
}