<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    public function markAttendance(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $userId = $request->user_id;
        $today = Carbon::today()->toDateString();
        $now = Carbon::now()->toTimeString();

        // Check if user already attended today
        $existingAttendance = Attendance::where('user_id', $userId)
            ->where('date', $today)
            ->first();

        if ($existingAttendance) {
            return response()->json([
                'message' => 'User has already attended today',
                'attendance' => $existingAttendance,
            ], 200);
        }

        // Determine status based on time
        $currentTime = Carbon::now();
        $startTime = Carbon::createFromTime(7, 0, 0); // 07:00
        $lateTime = Carbon::createFromTime(8, 0, 0); // 08:00

        $status = 'present';
        if ($currentTime->greaterThan($lateTime)) {
            $status = 'late';
        }

        $attendance = Attendance::create([
            'user_id' => $userId,
            'date' => $today,
            'time' => $now,
            'status' => $status,
        ]);

        return response()->json([
            'message' => 'Attendance marked successfully',
            'attendance' => $attendance,
        ], 200);
    }

    public function getAttendanceHistory(Request $request, $userId)
    {
        $attendances = Attendance::where('user_id', $userId)
            ->orderBy('date', 'desc')
            ->orderBy('time', 'desc')
            ->get();

        return response()->json($attendances);
    }

    public function getAllAttendances(Request $request)
    {
        $attendances = Attendance::with('user')
            ->orderBy('date', 'desc')
            ->orderBy('time', 'desc')
            ->get();

        return response()->json($attendances);
    }
}