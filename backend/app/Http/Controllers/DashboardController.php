<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\User;
use App\Models\ClassModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function getSupervisorDashboard(Request $request)
    {
        $user = $request->user();

        $this->authorize('viewSupervisorDashboard', $user);

        $today = Carbon::today();

        // Get supervised classes
        $supervisedClasses = $user->supervisedClasses;

        $dashboardData = [];

        foreach ($supervisedClasses as $class) {
            // Get all users in this class
            $classUsers = $class->users;

            // Get today's attendance for this class
            $todayAttendances = Attendance::where('date', $today)
                ->whereIn('user_id', $classUsers->pluck('id'))
                ->with('user')
                ->get()
                ->keyBy('user_id');

            $presentCount = 0;
            $lateCount = 0;
            $absentCount = 0;
            $attendanceDetails = [];

            foreach ($classUsers as $classUser) {
                $attendance = $todayAttendances->get($classUser->id);

                if ($attendance) {
                    if ($attendance->status === 'present') {
                        $presentCount++;
                    } elseif ($attendance->status === 'late') {
                        $lateCount++;
                    } elseif ($attendance->status === 'absent') {
                        $absentCount++;
                    }

                    $attendanceDetails[] = [
                        'user_id' => $classUser->id,
                        'name' => $classUser->name,
                        'status' => $attendance->status,
                        'check_in_time' => $attendance->check_in_time,
                        'notes' => $attendance->notes,
                    ];
                } else {
                    $absentCount++;
                    $attendanceDetails[] = [
                        'user_id' => $classUser->id,
                        'name' => $classUser->name,
                        'status' => 'absent',
                        'check_in_time' => null,
                        'notes' => null,
                    ];
                }
            }

            $dashboardData[] = [
                'class_id' => $class->id,
                'class_name' => $class->name,
                'total_students' => $classUsers->count(),
                'present_count' => $presentCount,
                'late_count' => $lateCount,
                'absent_count' => $absentCount,
                'attendance_percentage' => $classUsers->count() > 0 ?
                    round(($presentCount / $classUsers->count()) * 100, 1) : 0,
                'attendance_details' => $attendanceDetails,
            ];
        }

        return response()->json([
            'date' => $today->format('Y-m-d'),
            'classes' => $dashboardData,
        ]);
    }

    public function markManualAttendance(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'date' => 'required|date',
            'status' => 'required|in:present,late,absent,early_leave',
            'check_in_time' => 'nullable|date_format:H:i',
            'check_out_time' => 'nullable|date_format:H:i',
            'notes' => 'nullable|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $supervisor = $request->user();
        $targetUser = User::findOrFail($request->user_id);

        $this->authorize('markManualAttendance', [$supervisor, $targetUser]);

        // Create or update attendance record
        $attendance = Attendance::updateOrCreate(
            [
                'user_id' => $request->user_id,
                'date' => $request->date,
            ],
            [
                'status' => $request->status,
                'check_in_time' => $request->check_in_time,
                'check_out_time' => $request->check_out_time,
                'notes' => $request->notes,
                'validation_method' => 'manual',
                'is_offline_sync' => false,
            ]
        );

        // Create notification for the user
        \App\Models\Notification::create([
            'user_id' => $targetUser->id,
            'title' => 'Attendance Updated',
            'message' => "Your attendance for {$request->date} has been marked as {$request->status}",
            'type' => 'attendance',
        ]);

        return response()->json([
            'message' => 'Attendance marked successfully',
            'attendance' => $attendance->load('user'),
        ]);
    }

    public function addAttendanceNote(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'date' => 'required|date',
            'notes' => 'required|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $supervisor = $request->user();
        $targetUser = User::findOrFail($request->user_id);

        $this->authorize('addAttendanceNote', [$supervisor, $targetUser]);

        // Find or create attendance record
        $attendance = Attendance::firstOrCreate(
            [
                'user_id' => $request->user_id,
                'date' => $request->date,
            ],
            [
                'status' => 'present', // Default status
                'validation_method' => 'manual',
                'is_offline_sync' => false,
            ]
        );

        // Update notes
        $attendance->update([
            'notes' => $request->notes,
        ]);

        // Create notification for the user
        \App\Models\Notification::create([
            'user_id' => $targetUser->id,
            'title' => 'Attendance Note Added',
            'message' => "A note has been added to your attendance for {$request->date}",
            'type' => 'attendance',
        ]);

        return response()->json([
            'message' => 'Attendance note added successfully',
            'attendance' => $attendance->load('user'),
        ]);
    }

    public function getClassAttendanceSummary(Request $request, ClassModel $class)
    {
        $user = $request->user();

        $this->authorize('manageClassAttendance', [$user, $class]);

        $date = $request->query('date', Carbon::today()->format('Y-m-d'));
        $month = $request->query('month', Carbon::now()->format('Y-m'));

        // Daily summary
        $dailyAttendances = Attendance::where('date', $date)
            ->whereHas('user', function ($query) use ($class) {
                $query->where('class_id', $class->id);
            })
            ->with('user')
            ->get();

        $dailyStats = [
            'date' => $date,
            'total_students' => $class->users()->count(),
            'present' => $dailyAttendances->where('status', 'present')->count(),
            'late' => $dailyAttendances->where('status', 'late')->count(),
            'absent' => $class->users()->count() - $dailyAttendances->count(),
            'early_leave' => $dailyAttendances->where('status', 'early_leave')->count(),
        ];

        // Monthly summary
        $monthlyAttendances = Attendance::where('date', 'like', $month . '%')
            ->whereHas('user', function ($query) use ($class) {
                $query->where('class_id', $class->id);
            })
            ->get()
            ->groupBy('date');

        $monthlyStats = [];
        $totalDays = Carbon::parse($month . '-01')->daysInMonth;

        for ($day = 1; $day <= $totalDays; $day++) {
            $currentDate = Carbon::parse($month . '-' . str_pad($day, 2, '0', STR_PAD_LEFT));
            $dayAttendances = $monthlyAttendances->get($currentDate->format('Y-m-d'), collect());

            $monthlyStats[] = [
                'date' => $currentDate->format('Y-m-d'),
                'present' => $dayAttendances->where('status', 'present')->count(),
                'late' => $dayAttendances->where('status', 'late')->count(),
                'absent' => $class->users()->count() - $dayAttendances->count(),
            ];
        }

        return response()->json([
            'class' => [
                'id' => $class->id,
                'name' => $class->name,
            ],
            'daily_summary' => $dailyStats,
            'monthly_summary' => $monthlyStats,
        ]);
    }
}