<?php

namespace App\Http\Controllers;

use App\Models\Announcement;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class AnnouncementController extends Controller
{
    /**
     * Get announcements for the current user
     */
    public function index(Request $request)
    {
        $user = auth()->user();
        $limit = $request->get('limit', 20);
        $category = $request->get('category');
        $search = $request->get('search');
        $dateFrom = $request->get('date_from');
        $dateTo = $request->get('date_to');

        $query = Announcement::query();

        // Filter by target audience
        $query->where(function ($q) use ($user) {
            $q->where('target_type', 'global')
              ->orWhere(function ($subQ) use ($user) {
                  $subQ->where('target_type', 'role')
                       ->where('target_id', $user->role);
              })
              ->orWhere(function ($subQ) use ($user) {
                  $subQ->where('target_type', 'class')
                       ->where('target_id', $user->class_id);
              })
              ->orWhere(function ($subQ) use ($user) {
                  $subQ->where('target_type', 'department')
                       ->where('target_id', $user->department_id);
              });
        });

        // Filter by category
        if ($category) {
            $query->where('category', $category);
        }

        // Search by title or content
        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('content', 'like', "%{$search}%");
            });
        }

        // Filter by date range
        if ($dateFrom) {
            $query->whereDate('created_at', '>=', $dateFrom);
        }
        if ($dateTo) {
            $query->whereDate('created_at', '<=', $dateTo);
        }

        $announcements = $query->with('creator')
                              ->orderBy('created_at', 'desc')
                              ->paginate($limit);

        return response()->json([
            'data' => $announcements->items(),
            'pagination' => [
                'current_page' => $announcements->currentPage(),
                'last_page' => $announcements->lastPage(),
                'per_page' => $announcements->perPage(),
                'total' => $announcements->total(),
            ]
        ]);
    }

    /**
     * Create a new announcement
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|string|in:academic,general,urgent,administrative',
            'target_type' => 'required|string|in:global,role,class,department',
            'target_id' => 'nullable|integer',
            'priority' => 'nullable|string|in:low,normal,high,urgent',
            'attachment' => 'nullable|file|mimes:pdf,doc,docx,jpg,jpeg,png|max:5120', // 5MB
        ]);

        $data = $request->only([
            'title', 'content', 'category', 'target_type', 'target_id', 'priority'
        ]);
        $data['created_by'] = auth()->id();

        // Handle file upload
        if ($request->hasFile('attachment')) {
            $file = $request->file('attachment');
            $filename = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('announcements', $filename, 'public');
            $data['attachment_path'] = $path;
        }

        $announcement = Announcement::create($data);

        // Send notifications to target audience
        $this->sendAnnouncementNotifications($announcement);

        return response()->json([
            'message' => 'Announcement created successfully',
            'announcement' => $announcement->load('creator')
        ], 201);
    }

    /**
     * Get a specific announcement
     */
    public function show($id)
    {
        $user = auth()->user();
        $announcement = Announcement::with('creator')->findOrFail($id);

        // Check if user can view this announcement
        if (!$this->canUserViewAnnouncement($user, $announcement)) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Mark as read for this user (you might want to create a separate read status table)
        // For now, we'll just return the announcement

        return response()->json($announcement);
    }

    /**
     * Update an announcement
     */
    public function update(Request $request, $id)
    {
        $announcement = Announcement::findOrFail($id);

        // Check if user can edit this announcement
        if ($announcement->created_by !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|string|in:academic,general,urgent,administrative',
            'target_type' => 'required|string|in:global,role,class,department',
            'target_id' => 'nullable|integer',
            'priority' => 'nullable|string|in:low,normal,high,urgent',
            'attachment' => 'nullable|file|mimes:pdf,doc,docx,jpg,jpeg,png|max:5120',
        ]);

        $data = $request->only([
            'title', 'content', 'category', 'target_type', 'target_id', 'priority'
        ]);

        // Handle file upload
        if ($request->hasFile('attachment')) {
            // Delete old attachment if exists
            if ($announcement->attachment_path) {
                Storage::disk('public')->delete($announcement->attachment_path);
            }

            $file = $request->file('attachment');
            $filename = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('announcements', $filename, 'public');
            $data['attachment_path'] = $path;
        }

        $announcement->update($data);

        return response()->json([
            'message' => 'Announcement updated successfully',
            'announcement' => $announcement->load('creator')
        ]);
    }

    /**
     * Delete an announcement
     */
    public function destroy($id)
    {
        $announcement = Announcement::findOrFail($id);

        // Check if user can delete this announcement
        if ($announcement->created_by !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Delete attachment if exists
        if ($announcement->attachment_path) {
            Storage::disk('public')->delete($announcement->attachment_path);
        }

        $announcement->delete();

        return response()->json(['message' => 'Announcement deleted successfully']);
    }

    /**
     * Get announcement categories
     */
    public function getCategories()
    {
        return response()->json([
            'categories' => [
                ['value' => 'academic', 'label' => 'Akademik'],
                ['value' => 'general', 'label' => 'Umum'],
                ['value' => 'urgent', 'label' => 'Penting'],
                ['value' => 'administrative', 'label' => 'Administratif'],
            ]
        ]);
    }

    /**
     * Get available targets for announcement
     */
    public function getTargets()
    {
        $user = auth()->user();

        $targets = [
            ['type' => 'global', 'label' => 'Semua Pengguna', 'id' => null],
        ];

        // Add role-based targets
        if (in_array($user->role, ['admin', 'supervisor'])) {
            $targets[] = ['type' => 'role', 'label' => 'User/Karyawan', 'id' => 'user'];
            $targets[] = ['type' => 'role', 'label' => 'Supervisor/Dosen', 'id' => 'supervisor'];
        }

        // Add class targets for supervisors
        if ($user->role === 'supervisor') {
            $classes = \App\Models\ClassModel::where('supervisor_id', $user->id)->get();
            foreach ($classes as $class) {
                $targets[] = [
                    'type' => 'class',
                    'label' => "Kelas: {$class->name}",
                    'id' => $class->id
                ];
            }
        }

        // Add department targets for admins
        if ($user->role === 'admin') {
            $departments = \App\Models\Department::all();
            foreach ($departments as $dept) {
                $targets[] = [
                    'type' => 'department',
                    'label' => "Departemen: {$dept->name}",
                    'id' => $dept->id
                ];
            }
        }

        return response()->json(['targets' => $targets]);
    }

    /**
     * Check if user can view the announcement
     */
    private function canUserViewAnnouncement(User $user, Announcement $announcement): bool
    {
        switch ($announcement->target_type) {
            case 'global':
                return true;
            case 'role':
                return $announcement->target_id === $user->role;
            case 'class':
                return $announcement->target_id === $user->class_id;
            case 'department':
                return $announcement->target_id === $user->department_id;
            default:
                return false;
        }
    }

    /**
     * Send notifications for new announcement
     */
    private function sendAnnouncementNotifications(Announcement $announcement)
    {
        $query = User::query();

        // Filter users based on target
        switch ($announcement->target_type) {
            case 'global':
                // All users
                break;
            case 'role':
                $query->where('role', $announcement->target_id);
                break;
            case 'class':
                $query->where('class_id', $announcement->target_id);
                break;
            case 'department':
                $query->where('department_id', $announcement->target_id);
                break;
        }

        $users = $query->get();

        foreach ($users as $user) {
            // Create in-app notification
            \App\Models\Notification::create([
                'user_id' => $user->id,
                'title' => $announcement->title,
                'message' => substr($announcement->content, 0, 100) . (strlen($announcement->content) > 100 ? '...' : ''),
                'type' => 'announcement',
                'data' => ['announcement_id' => $announcement->id],
            ]);

            // Send push notification if user has FCM token
            if ($user->fcm_token) {
                $this->sendFCMNotification(
                    $user->fcm_token,
                    $announcement->title,
                    substr($announcement->content, 0, 100) . (strlen($announcement->content) > 100 ? '...' : ''),
                    'announcement',
                    ['announcement_id' => $announcement->id]
                );
            }
        }
    }

    /**
     * Send FCM notification
     */
    private function sendFCMNotification($fcmToken, $title, $body, $type, $data = null)
    {
        $serverKey = env('FCM_SERVER_KEY');

        if (!$serverKey) {
            return;
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
            \Illuminate\Support\Facades\Http::withHeaders([
                'Authorization' => 'key=' . $serverKey,
                'Content-Type' => 'application/json',
            ])->post('https://fcm.googleapis.com/fcm/send', $payload);
        } catch (\Exception $e) {
            \Log::error('FCM notification failed: ' . $e->getMessage());
        }
    }
}