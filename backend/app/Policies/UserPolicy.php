<?php

namespace App\Policies;

use App\Models\User;

class UserPolicy
{
    public function viewUsers(User $user): bool
    {
        return in_array($user->role, ['admin', 'hr']);
    }

    public function viewUser(User $user, User $targetUser): bool
    {
        if ($user->role === 'admin') {
            return true;
        }

        if ($user->role === 'hr') {
            return true;
        }

        // Users can view their own profile
        return $user->id === $targetUser->id;
    }

    public function createUser(User $user): bool
    {
        return in_array($user->role, ['admin', 'hr']);
    }

    public function updateUser(User $user, User $targetUser): bool
    {
        if ($user->role === 'admin') {
            return true;
        }

        if ($user->role === 'hr') {
            // HR cannot modify admin accounts
            return $targetUser->role !== 'admin';
        }

        // Users can update their own profile
        return $user->id === $targetUser->id;
    }

    public function deleteUser(User $user, User $targetUser): bool
    {
        if ($user->role === 'admin') {
            // Admin cannot delete other admins
            return $targetUser->role !== 'admin';
        }

        if ($user->role === 'hr') {
            // HR cannot delete admin or other HR accounts
            return !in_array($targetUser->role, ['admin', 'hr']);
        }

        return false;
    }

    public function resetUserPassword(User $user, User $targetUser): bool
    {
        if ($user->role === 'admin') {
            return true;
        }

        if ($user->role === 'hr') {
            // HR cannot reset admin passwords
            return $targetUser->role !== 'admin';
        }

        return false;
    }

    public function importUsers(User $user): bool
    {
        return in_array($user->role, ['admin', 'hr']);
    }
}