<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserDevice;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    /**
     * Get current user profile
     */
    public function show()
    {
        $user = auth()->user()->load(['class', 'department']);

        return response()->json([
            'user' => $user,
            'devices' => $user->devices()->orderBy('last_login_at', 'desc')->get(),
        ]);
    }

    /**
     * Update user profile
     */
    public function update(Request $request)
    {
        $user = auth()->user();

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:500',
            'date_of_birth' => 'nullable|date|before:today',
            'gender' => 'nullable|in:male,female,other',
            'bio' => 'nullable|string|max:500',
            'emergency_contact_name' => 'nullable|string|max:255',
            'emergency_contact_phone' => 'nullable|string|max:20',
            'language_preference' => 'nullable|in:id,en',
            'theme_preference' => 'nullable|in:light,dark,system',
            'profile_photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // 2MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->only([
            'name', 'phone', 'address', 'date_of_birth', 'gender',
            'bio', 'emergency_contact_name', 'emergency_contact_phone',
            'language_preference', 'theme_preference'
        ]);

        // Handle profile photo upload
        if ($request->hasFile('profile_photo')) {
            // Delete old photo if exists
            if ($user->profile_photo_path) {
                Storage::disk('public')->delete($user->profile_photo_path);
            }

            $file = $request->file('profile_photo');
            $filename = 'profile_' . $user->id . '_' . time() . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('profiles', $filename, 'public');
            $data['profile_photo_path'] = $path;
        }

        $user->update($data);

        return response()->json([
            'message' => 'Profile updated successfully',
            'user' => $user->load(['class', 'department'])
        ]);
    }

    /**
     * Update password
     */
    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = auth()->user();

        // Check current password
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect'
            ], 422);
        }

        $user->update([
            'password' => Hash::make($request->password)
        ]);

        // Logout from all devices except current
        $currentDeviceId = $request->header('X-Device-ID');
        if ($currentDeviceId) {
            $user->devices()
                 ->where('device_id', '!=', $currentDeviceId)
                 ->update(['is_active' => false]);
        }

        return response()->json([
            'message' => 'Password updated successfully. Please login again on other devices.'
        ]);
    }

    /**
     * Update notification preferences
     */
    public function updateNotificationPreferences(Request $request)
    {
        $request->validate([
            'attendance_reminder' => 'boolean',
            'announcement' => 'boolean',
            'appeal_status' => 'boolean',
            'schedule_change' => 'boolean',
        ]);

        $user = auth()->user();
        $preferences = $request->only([
            'attendance_reminder', 'announcement', 'appeal_status', 'schedule_change'
        ]);

        $user->update(['notification_preferences' => $preferences]);

        return response()->json([
            'message' => 'Notification preferences updated successfully',
            'preferences' => $user->getNotificationPreferences()
        ]);
    }

    /**
     * Get user's devices
     */
    public function getDevices()
    {
        $user = auth()->user();

        $devices = $user->devices()
                        ->orderBy('last_login_at', 'desc')
                        ->get()
                        ->map(function ($device) {
                            return [
                                'id' => $device->id,
                                'device_id' => $device->device_id,
                                'device_name' => $device->device_name,
                                'device_model' => $device->device_model,
                                'platform' => $device->platform,
                                'os_version' => $device->os_version,
                                'app_version' => $device->app_version,
                                'is_active' => $device->is_active,
                                'is_verified' => $device->is_verified,
                                'is_current_device' => $device->device_id === request()->header('X-Device-ID'),
                                'last_login_at' => $device->last_login_at,
                                'ip_address' => $device->ip_address,
                                'created_at' => $device->created_at,
                            ];
                        });

        return response()->json([
            'devices' => $devices,
            'max_devices' => 2, // Configurable
            'current_device_count' => $user->activeDevices()->count(),
        ]);
    }

    /**
     * Register new device
     */
    public function registerDevice(Request $request)
    {
        $request->validate([
            'device_id' => 'required|string|unique:user_devices,device_id',
            'device_name' => 'nullable|string|max:255',
            'device_model' => 'nullable|string|max:255',
            'platform' => 'nullable|string|in:iOS,Android',
            'os_version' => 'nullable|string|max:50',
            'app_version' => 'nullable|string|max:50',
            'fcm_token' => 'nullable|string',
        ]);

        $user = auth()->user();

        // Check device limit
        if (!UserDevice::isWithinDeviceLimit($user->id)) {
            return response()->json([
                'message' => 'Maximum device limit reached. Please remove an existing device first.',
                'requires_verification' => true
            ], 422);
        }

        $device = UserDevice::create([
            'user_id' => $user->id,
            'device_id' => $request->device_id,
            'device_name' => $request->device_name ?? $this->generateDeviceName($request),
            'device_model' => $request->device_model,
            'platform' => $request->platform,
            'os_version' => $request->os_version,
            'app_version' => $request->app_version,
            'fcm_token' => $request->fcm_token,
            'ip_address' => $request->ip(),
            'is_verified' => false, // Requires verification for new devices
        ]);

        // Send verification code
        $verificationCode = $this->sendDeviceVerification($user, $device);

        return response()->json([
            'message' => 'Device registered. Please verify with the code sent to your email.',
            'device' => $device,
            'requires_verification' => true,
            'verification_sent' => true
        ], 201);
    }

    /**
     * Verify device
     */
    public function verifyDevice(Request $request)
    {
        $request->validate([
            'device_id' => 'required|string',
            'verification_code' => 'required|string|size:6',
        ]);

        $user = auth()->user();
        $device = $user->devices()->where('device_id', $request->device_id)->first();

        if (!$device) {
            return response()->json(['message' => 'Device not found'], 404);
        }

        // Check verification code (simplified - in production use proper OTP system)
        if ($request->verification_code !== '123456') { // Temporary for demo
            return response()->json(['message' => 'Invalid verification code'], 422);
        }

        $device->markAsVerified();
        $device->recordLogin($request->ip());

        return response()->json([
            'message' => 'Device verified successfully',
            'device' => $device
        ]);
    }

    /**
     * Remove device
     */
    public function removeDevice(Request $request, $deviceId)
    {
        $user = auth()->user();
        $device = $user->devices()->where('id', $deviceId)->first();

        if (!$device) {
            return response()->json(['message' => 'Device not found'], 404);
        }

        // Prevent removing current device
        if ($device->device_id === $request->header('X-Device-ID')) {
            return response()->json(['message' => 'Cannot remove current device'], 422);
        }

        $device->deactivate();

        return response()->json([
            'message' => 'Device removed successfully'
        ]);
    }

    /**
     * Update FCM token for device
     */
    public function updateFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = auth()->user();
        $deviceId = $request->header('X-Device-ID');

        if ($deviceId) {
            $user->updateFcmToken($request->fcm_token, $deviceId);
        }

        return response()->json([
            'message' => 'FCM token updated successfully'
        ]);
    }

    /**
     * Generate device name
     */
    private function generateDeviceName(Request $request): string
    {
        $platform = $request->platform ?? 'Unknown';
        $model = $request->device_model ?? 'Device';

        return "$platform $model";
    }

    /**
     * Send device verification code
     */
    private function sendDeviceVerification(User $user, UserDevice $device): string
    {
        // In production, send actual email/SMS with OTP
        // For demo purposes, return a fixed code
        $code = '123456';

        // Here you would send email or SMS with the code
        // Mail::to($user->email)->send(new DeviceVerificationMail($code));

        return $code;
    }
}