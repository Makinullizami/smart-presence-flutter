<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\User;
use App\Models\Appeal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Carbon\Carbon;

class NotificationController extends Controller
{
    /**
     * Get user's notifications
     */
    public function index(Request $request)
    {
        $userId = auth()->id();
        $limit = $request->get('limit', 20);

        $notifications = Notification::where('user_id', $userId)
            ->orderBy('created_at', 'desc')
            ->paginate($limit);

        return response()->json([
            'data' => $notifications->items(),
            'pagination' => [
                'current_page' => $notifications->currentPage(),
                'last_page' => $notifications->lastPage(),
                'per_page' => $notifications->perPage(),
                'total' => $notifications->total(),
            ]
        ]);
    }

    /**
     * Mark notification as read
     */
    public function markAsRead($id)
    {
        $userId = auth()->id();

        $notification = Notification::where('id', $id)
            ->where('user_id', $userId)
            ->first();

        if (!$notification) {
            return response()->json(['message' => 'Notification not found'], 404);
        }

        $notification->update(['read_at' => now()]);

        return response()->json(['message' => 'Notification marked as read']);
    }

    /**
     * Send push notification to specific user
     */
    public function sendNotification(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'title' => 'required|string|max:255',
            'body' => 'required|string',
            'type' => 'required|string',
            'data' => 'nullable|array',
        ]);

        $user = User::find($request->user_id);

        // Create in-app notification
        $notification = Notification::create([
            'user_id' => $request->user_id,
            'title' => $request->title,
            'message' => $request->body,
            'type' => $request->type,
            'data' => $request->data,
        ]);

        // Send push notification if user has FCM token
        if ($user->fcm_token) {
            $this->sendFCMNotification(
                $user->fcm_token,
                $request->title,
                $request->body,
                $request->type,
                $request->data
            );
        }

        return response()->json([
            'message' => 'Notification sent successfully',
            'notification' => $notification
        ]);
    }

    /**
     * Send broadcast notification to all users or specific role
     */
    public function sendBroadcast(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'body' => 'required|string',
            'type' => 'required|string',
            'target_role' => 'nullable|string|in:user,supervisor,admin',
            'data' => 'nullable|array',
        ]);

        $query = User::query();

        if ($request->target_role) {
            $query->where('role', $request->target_role);
        }

        $users = $query->get();
        $notifications = [];

        foreach ($users as $user) {
            // Create in-app notification
            $notification = Notification::create([
                'user_id' => $user->id,
                'title' => $request->title,
                'message' => $request->body,
                'type' => $request->type,
                'data' => $request->data,
            ]);

            $notifications[] = $notification;

            // Send push notification if user has FCM token
            if ($user->fcm_token) {
                $this->sendFCMNotification(
                    $user->fcm_token,
                    $request->title,
                    $request->body,
                    $request->type,
                    $request->data
                );
            }
        }

        return response()->json([
            'message' => 'Broadcast notification sent successfully',
            'sent_count' => count($notifications)
        ]);
    }

    /**
     * Send attendance reminder notifications
     */
    public function sendAttendanceReminders()
    {
        // This would typically be called by a scheduled job
        // For now, we'll send reminders to all users who haven't checked in today

        $today = now()->toDateString();
        $reminderTime = now()->addMinutes(10); // 10 minutes from now

        $usersWithoutAttendance = User::whereDoesntHave('attendances', function ($query) use ($today) {
            $query->where('date', $today);
        })->where('role', 'user')->get();

        $remindersSent = 0;

        foreach ($usersWithoutAttendance as $user) {
            // Create reminder notification
            Notification::create([
                'user_id' => $user->id,
                'title' => 'Pengingat Absensi',
                'message' => 'Jangan lupa melakukan absensi masuk hari ini!',
                'type' => 'attendance_reminder',
                'data' => ['reminder_time' => $reminderTime->toISOString()],
            ]);

            // Send push notification
            if ($user->fcm_token) {
                $this->sendFCMNotification(
                    $user->fcm_token,
                    'Pengingat Absensi',
                    'Jangan lupa melakukan absensi masuk hari ini!',
                    'attendance_reminder',
                    ['reminder_time' => $reminderTime->toISOString()]
                );
            }

            $remindersSent++;
        }

        return response()->json([
            'message' => 'Attendance reminders sent',
            'reminders_sent' => $remindersSent
        ]);
    }

    /**
     * Send leave request approval/rejection notifications
     */
    public function sendLeaveNotification(Appeal $appeal)
    {
        $user = $appeal->user;
        $status = $appeal->status;
        $type = $appeal->type;

        $title = $status === 'approved' ? 'Izin Disetujui' : 'Izin Ditolak';
        $message = $status === 'approved'
            ? "Izin $type Anda telah disetujui."
            : "Izin $type Anda telah ditolak. " . ($appeal->rejection_reason ?? '');

        // Create in-app notification
        Notification::create([
            'user_id' => $user->id,
            'title' => $title,
            'message' => $message,
            'type' => $status === 'approved' ? 'leave_approved' : 'leave_rejected',
            'data' => [
                'appeal_id' => $appeal->id,
                'type' => $type,
                'status' => $status,
            ],
        ]);

        // Send push notification
        if ($user->fcm_token) {
            $this->sendFCMNotification(
                $user->fcm_token,
                $title,
                $message,
                $status === 'approved' ? 'leave_approved' : 'leave_rejected',
                [
                    'appeal_id' => $appeal->id,
                    'type' => $type,
                    'status' => $status,
                ]
            );
        }
    }

    /**
     * Send announcement notifications
     */
    public function sendAnnouncementNotification($announcement)
    {
        $targetUsers = User::query();

        if ($announcement->target_role) {
            $targetUsers->where('role', $announcement->target_role);
        }

        $users = $targetUsers->get();

        foreach ($users as $user) {
            // Create in-app notification
            Notification::create([
                'user_id' => $user->id,
                'title' => $announcement->title,
                'message' => $announcement->content,
                'type' => 'announcement',
                'data' => [
                    'announcement_id' => $announcement->id,
                    'priority' => $announcement->priority ?? 'normal',
                ],
            ]);

            // Send push notification
            if ($user->fcm_token) {
                $this->sendFCMNotification(
                    $user->fcm_token,
                    $announcement->title,
                    $announcement->content,
                    'announcement',
                    [
                        'announcement_id' => $announcement->id,
                        'priority' => $announcement->priority ?? 'normal',
                    ]
                );
            }
        }
    }

    /**
     * Update user's FCM token
     */
    public function updateFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = auth()->user();
        $user->update(['fcm_token' => $request->fcm_token]);

        return response()->json(['message' => 'FCM token updated successfully']);
    }

    /**
     * Send FCM notification using Firebase Cloud Messaging
     */
    private function sendFCMNotification($fcmToken, $title, $body, $type, $data = null)
    {
        // You'll need to set up Firebase server key in your .env file
        $serverKey = env('FCM_SERVER_KEY');

        if (!$serverKey) {
            return; // Skip if server key not configured
        }

        $payload = [
            'to' => $fcmToken,
            'notification' => [
                'title' => $title,
                'body' => $body,
                'sound' => 'default',
            ],
            'data' => array_merge([
                'type' => $type,
                'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
            ], $data ?? []),
        ];

        try {
            Http::withHeaders([
                'Authorization' => 'key=' . $serverKey,
                'Content-Type' => 'application/json',
            ])->post('https://fcm.googleapis.com/fcm/send', $payload);
        } catch (\Exception $e) {
            // Log error but don't fail the request
            \Log::error('FCM notification failed: ' . $e->getMessage());
        }
    }

    /**
     * Get notification statistics (for admin)
     */
    public function getStatistics()
    {
        $this->authorize('viewAny', Notification::class);

        $stats = [
            'total_notifications' => Notification::count(),
            'unread_notifications' => Notification::whereNull('read_at')->count(),
            'today_notifications' => Notification::whereDate('created_at', today())->count(),
            'notifications_by_type' => Notification::selectRaw('type, COUNT(*) as count')
                ->groupBy('type')
                ->pluck('count', 'type')
                ->toArray(),
        ];

        return response()->json($stats);
    }
}