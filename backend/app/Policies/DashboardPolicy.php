<?php

namespace App\Policies;

use App\Models\User;
use App\Models\ClassModel;

class DashboardPolicy
{
    public function viewSupervisorDashboard(User $user): bool
    {
        return $user->role === 'supervisor';
    }

    public function manageClassAttendance(User $user, ClassModel $class): bool
    {
        if ($user->role !== 'supervisor') {
            return false;
        }

        // Check if supervisor manages this class
        return $user->supervisedClasses->contains('id', $class->id);
    }

    public function markManualAttendance(User $user, User $targetUser): bool
    {
        if ($user->role !== 'supervisor') {
            return false;
        }

        // Check if supervisor can manage this user's attendance
        $canManage = $user->supervisedClasses->contains('id', $targetUser->class_id) ||
                    ($user->managedDepartment && $user->managedDepartment->id === $targetUser->department_id);

        return $canManage;
    }

    public function addAttendanceNote(User $user, User $targetUser): bool
    {
        // Same logic as markManualAttendance
        return $this->markManualAttendance($user, $targetUser);
    }
}