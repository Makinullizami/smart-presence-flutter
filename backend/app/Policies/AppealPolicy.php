<?php

namespace App\Policies;

use App\Models\Appeal;
use App\Models\User;

class AppealPolicy
{
    public function view(User $user, Appeal $appeal): bool
    {
        // Users can view their own appeals
        if ($appeal->user_id === $user->id) {
            return true;
        }

        // Admins can view all appeals
        if ($user->role === 'admin') {
            return true;
        }

        // Supervisors can view appeals from users they supervise
        if ($user->role === 'supervisor') {
            $supervisedUserIds = User::where('class_id', $user->supervisedClasses->pluck('id'))
                ->orWhere('department_id', $user->managedDepartment?->id)
                ->pluck('id');

            return $supervisedUserIds->contains($appeal->user_id);
        }

        return false;
    }

    public function approve(User $user, Appeal $appeal): bool
    {
        // Only supervisors and admins can approve/reject appeals
        if (!in_array($user->role, ['supervisor', 'admin'])) {
            return false;
        }

        // Supervisors can only approve appeals from users they supervise
        if ($user->role === 'supervisor') {
            $supervisedUserIds = User::where('class_id', $user->supervisedClasses->pluck('id'))
                ->orWhere('department_id', $user->managedDepartment?->id)
                ->pluck('id');

            return $supervisedUserIds->contains($appeal->user_id);
        }

        // Admins can approve any appeal
        return true;
    }

    public function create(User $user): bool
    {
        // All authenticated users can create appeals
        return true;
    }

    public function update(User $user, Appeal $appeal): bool
    {
        // Only the appeal owner can update (if still pending)
        return $appeal->user_id === $user->id && $appeal->status === 'pending';
    }

    public function delete(User $user, Appeal $appeal): bool
    {
        // Only admins can delete appeals
        return $user->role === 'admin';
    }
}