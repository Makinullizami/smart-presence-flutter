<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\User;
use App\Models\ClassModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ReportController extends Controller
{
    /**
     * Get personal attendance report for a user
     */
    public function getPersonalReport(Request $request)
    {
        $userId = auth()->id();
        $month = $request->get('month', now()->format('Y-m'));
        $year = $request->get('year', now()->format('Y'));

        // Parse month and year
        $startDate = Carbon::createFromFormat('Y-m', $month)->startOfMonth();
        $endDate = Carbon::createFromFormat('Y-m', $month)->endOfMonth();

        // Get attendance data for the month
        $attendances = Attendance::where('user_id', $userId)
            ->whereBetween('date', [$startDate, $endDate])
            ->orderBy('date')
            ->get();

        // Calculate statistics
        $totalDays = $startDate->daysInMonth;
        $presentDays = $attendances->where('status', 'present')->count();
        $lateDays = $attendances->where('status', 'late')->count();
        $absentDays = $totalDays - $attendances->count();
        $leaveDays = $attendances->where('status', 'leave')->count();
        $sickDays = $attendances->where('status', 'sick')->count();

        // Calculate attendance percentage
        $attendancePercentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100, 2) : 0;

        // Get monthly tardiness count
        $totalLateMinutes = $attendances->where('status', 'late')->sum(function ($attendance) {
            // Calculate minutes late (assuming standard time is 08:00)
            $checkInTime = Carbon::parse($attendance->check_in_time);
            $standardTime = Carbon::createFromTime(8, 0, 0);
            return max(0, $checkInTime->diffInMinutes($standardTime));
        });

        // Prepare chart data
        $chartData = [
            'labels' => ['Hadir', 'Terlambat', 'Izin', 'Sakit', 'Alfa'],
            'data' => [$presentDays, $lateDays, $leaveDays, $sickDays, $absentDays],
            'colors' => ['#4CAF50', '#FF9800', '#2196F3', '#9C27B0', '#F44336']
        ];

        return response()->json([
            'month' => $month,
            'year' => $year,
            'statistics' => [
                'total_days' => $totalDays,
                'present_days' => $presentDays,
                'late_days' => $lateDays,
                'absent_days' => $absentDays,
                'leave_days' => $leaveDays,
                'sick_days' => $sickDays,
                'attendance_percentage' => $attendancePercentage,
                'total_late_minutes' => $totalLateMinutes,
            ],
            'chart_data' => $chartData,
            'attendance_history' => $attendances->map(function ($attendance) {
                return [
                    'date' => $attendance->date->format('Y-m-d'),
                    'day' => $attendance->date->format('l'),
                    'check_in_time' => $attendance->check_in_time,
                    'check_out_time' => $attendance->check_out_time,
                    'status' => $attendance->status,
                    'notes' => $attendance->notes,
                ];
            })
        ]);
    }

    /**
     * Get supervisor report for their classes/teams
     */
    public function getSupervisorReport(Request $request)
    {
        $supervisorId = auth()->id();
        $date = $request->get('date', now()->format('Y-m-d'));

        // Get classes supervised by this supervisor
        $classes = ClassModel::where('supervisor_id', $supervisorId)->with('users')->get();

        $classReports = [];

        foreach ($classes as $class) {
            $students = $class->users;

            // Get attendance for this class on the specified date
            $attendances = Attendance::whereIn('user_id', $students->pluck('id'))
                ->where('date', $date)
                ->get()
                ->keyBy('user_id');

            $presentCount = 0;
            $lateCount = 0;
            $absentCount = $students->count();

            $studentDetails = [];

            foreach ($students as $student) {
                $attendance = $attendances->get($student->id);

                if ($attendance) {
                    $absentCount--;
                    if ($attendance->status === 'present') {
                        $presentCount++;
                    } elseif ($attendance->status === 'late') {
                        $lateCount++;
                    }
                }

                $studentDetails[] = [
                    'id' => $student->id,
                    'name' => $student->name,
                    'nim' => $student->nim,
                    'status' => $attendance ? $attendance->status : 'absent',
                    'check_in_time' => $attendance ? $attendance->check_in_time : null,
                    'check_out_time' => $attendance ? $attendance->check_out_time : null,
                    'notes' => $attendance ? $attendance->notes : null,
                ];
            }

            $totalStudents = $students->count();
            $attendancePercentage = $totalStudents > 0 ? round((($presentCount + $lateCount) / $totalStudents) * 100, 2) : 0;

            $classReports[] = [
                'class_id' => $class->id,
                'class_name' => $class->name,
                'date' => $date,
                'total_students' => $totalStudents,
                'present_count' => $presentCount,
                'late_count' => $lateCount,
                'absent_count' => $absentCount,
                'attendance_percentage' => $attendancePercentage,
                'students' => $studentDetails,
            ];
        }

        return response()->json([
            'date' => $date,
            'classes' => $classReports,
            'summary' => [
                'total_classes' => count($classReports),
                'total_students' => array_sum(array_column($classReports, 'total_students')),
                'total_present' => array_sum(array_column($classReports, 'present_count')),
                'total_late' => array_sum(array_column($classReports, 'late_count')),
                'total_absent' => array_sum(array_column($classReports, 'absent_count')),
            ]
        ]);
    }

    /**
     * Get detailed attendance report with filters
     */
    public function getDetailedReport(Request $request)
    {
        $startDate = $request->get('start_date', now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->get('end_date', now()->endOfMonth()->format('Y-m-d'));
        $classId = $request->get('class_id');
        $userId = $request->get('user_id');

        $query = Attendance::with(['user:id,name,email,nim', 'user.class:id,name'])
            ->whereBetween('date', [$startDate, $endDate]);

        if ($classId) {
            $query->whereHas('user', function ($q) use ($classId) {
                $q->where('class_id', $classId);
            });
        }

        if ($userId) {
            $query->where('user_id', $userId);
        }

        $attendances = $query->orderBy('date', 'desc')
            ->orderBy('user_id')
            ->paginate(50);

        // Calculate summary statistics
        $summary = [
            'total_records' => $attendances->total(),
            'present_count' => $attendances->where('status', 'present')->count(),
            'late_count' => $attendances->where('status', 'late')->count(),
            'absent_count' => $attendances->where('status', 'absent')->count(),
            'leave_count' => $attendances->where('status', 'leave')->count(),
            'sick_count' => $attendances->where('status', 'sick')->count(),
        ];

        return response()->json([
            'summary' => $summary,
            'attendances' => $attendances->items(),
            'pagination' => [
                'current_page' => $attendances->currentPage(),
                'last_page' => $attendances->lastPage(),
                'per_page' => $attendances->perPage(),
                'total' => $attendances->total(),
            ]
        ]);
    }

    /**
     * Export report to PDF (placeholder - would need additional package)
     */
    public function exportReport(Request $request)
    {
        // This would require a PDF generation package like dompdf or tcpdf
        // For now, return a placeholder response
        return response()->json([
            'message' => 'Export functionality would be implemented with PDF generation library',
            'status' => 'not_implemented'
        ]);
    }
}