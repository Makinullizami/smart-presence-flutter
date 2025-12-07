<?php

namespace App\Http\Controllers;

use App\Models\Appeal;
use App\Models\Notification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class AppealController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'admin' || $user->role === 'supervisor') {
            // Admin/Supervisor can see all appeals or appeals from their supervised users
            $query = Appeal::with(['user', 'approver']);

            if ($user->role === 'supervisor') {
                // Supervisors can only see appeals from users in their classes/departments
                $supervisedUserIds = User::where('class_id', $user->supervisedClasses->pluck('id'))
                    ->orWhere('department_id', $user->managedDepartment?->id)
                    ->pluck('id');
                $query->whereIn('user_id', $supervisedUserIds);
            }
        } else {
            // Regular users can only see their own appeals
            $query = Appeal::where('user_id', $user->id)->with(['approver']);
        }

        $appeals = $query->orderBy('created_at', 'desc')->paginate(15);

        return response()->json($appeals);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type' => 'required|in:izin,cuti,sakit',
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after_or_equal:start_date',
            'reason' => 'required|string|max:1000',
            'attachment' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120', // 5MB max
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = $request->user();

        // Check for overlapping appeals
        $overlapping = Appeal::where('user_id', $user->id)
            ->where(function ($query) use ($request) {
                $query->whereBetween('start_date', [$request->start_date, $request->end_date])
                      ->orWhereBetween('end_date', [$request->start_date, $request->end_date])
                      ->orWhere(function ($q) use ($request) {
                          $q->where('start_date', '<=', $request->start_date)
                            ->where('end_date', '>=', $request->end_date);
                      });
            })
            ->whereIn('status', ['pending', 'approved'])
            ->exists();

        if ($overlapping) {
            return response()->json(['error' => 'You already have a pending or approved appeal for this period'], 422);
        }

        $attachmentPath = null;
        if ($request->hasFile('attachment')) {
            $attachmentPath = $request->file('attachment')->store('appeal-attachments', 'public');
        }

        $appeal = Appeal::create([
            'user_id' => $user->id,
            'type' => $request->type,
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
            'reason' => $request->reason,
            'attachment_path' => $attachmentPath,
        ]);

        // Create notification for supervisors/admins
        $supervisors = User::where('role', 'supervisor')
            ->orWhere('role', 'admin')
            ->get();

        foreach ($supervisors as $supervisor) {
            Notification::create([
                'user_id' => $supervisor->id,
                'title' => 'New Leave Request',
                'message' => "{$user->name} has submitted a {$request->type} request",
                'type' => 'appeal',
            ]);
        }

        return response()->json($appeal->load(['user']), 201);
    }

    public function show(Appeal $appeal)
    {
        $this->authorize('view', $appeal);

        return response()->json($appeal->load(['user', 'approver']));
    }

    public function approve(Request $request, Appeal $appeal)
    {
        $this->authorize('approve', $appeal);

        if ($appeal->status !== 'pending') {
            return response()->json(['error' => 'Appeal has already been processed'], 422);
        }

        $appeal->update([
            'status' => 'approved',
            'approved_by' => $request->user()->id,
            'approved_at' => now(),
        ]);

        // Create notification for the user
        Notification::create([
            'user_id' => $appeal->user_id,
            'title' => 'Leave Request Approved',
            'message' => "Your {$appeal->type} request has been approved",
            'type' => 'appeal',
        ]);

        return response()->json($appeal->load(['user', 'approver']));
    }

    public function reject(Request $request, Appeal $appeal)
    {
        $this->authorize('approve', $appeal);

        $validator = Validator::make($request->all(), [
            'rejection_reason' => 'required|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if ($appeal->status !== 'pending') {
            return response()->json(['error' => 'Appeal has already been processed'], 422);
        }

        $appeal->update([
            'status' => 'rejected',
            'approved_by' => $request->user()->id,
            'approved_at' => now(),
            'rejection_reason' => $request->rejection_reason,
        ]);

        // Create notification for the user
        Notification::create([
            'user_id' => $appeal->user_id,
            'title' => 'Leave Request Rejected',
            'message' => "Your {$appeal->type} request has been rejected",
            'type' => 'appeal',
        ]);

        return response()->json($appeal->load(['user', 'approver']));
    }

    public function downloadAttachment(Appeal $appeal)
    {
        $this->authorize('view', $appeal);

        if (!$appeal->attachment_path) {
            return response()->json(['error' => 'No attachment found'], 404);
        }

        return Storage::disk('public')->download($appeal->attachment_path);
    }
}