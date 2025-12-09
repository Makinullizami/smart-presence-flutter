<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ClassModel;
use App\Models\Department;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Maatwebsite\Excel\Facades\Excel;
use App\Imports\UsersImport;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $this->authorize('viewUsers', $user);

        $query = User::with(['class', 'department']);

        // Search
        if ($request->has('search') && !empty($request->search)) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('nip_nim', 'like', "%{$search}%");
            });
        }

        // Filters
        if ($request->has('role') && !empty($request->role)) {
            $query->where('role', $request->role);
        }

        if ($request->has('department_id') && !empty($request->department_id)) {
            $query->where('department_id', $request->department_id);
        }

        if ($request->has('class_id') && !empty($request->class_id)) {
            $query->where('class_id', $request->class_id);
        }

        if ($request->has('status')) {
            $query->where('is_active', $request->status === 'active');
        }

        // Pagination
        $perPage = $request->get('per_page', 15);
        $users = $query->paginate($perPage);

        return response()->json([
            'users' => $users->items(),
            'pagination' => [
                'current_page' => $users->currentPage(),
                'last_page' => $users->lastPage(),
                'per_page' => $users->perPage(),
                'total' => $users->total(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $user = $request->user();

        $this->authorize('createUser', $user);

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'nip_nim' => 'required|string|max:50|unique:users,nip_nim',
            'phone' => 'nullable|string|max:20',
            'role' => 'required|in:admin,hr,lecturer,employee,student',
            'department_id' => 'nullable|exists:departments,id',
            'class_id' => 'nullable|exists:classes,id',
            'password' => 'required|string|min:8',
            'profile_photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->only([
            'name', 'email', 'nip_nim', 'phone', 'role',
            'department_id', 'class_id'
        ]);

        $data['password'] = Hash::make($request->password);
        $data['is_active'] = true;

        // Handle profile photo upload
        if ($request->hasFile('profile_photo')) {
            $photoPath = $request->file('profile_photo')->store('profile_photos', 'public');
            $data['profile_photo'] = $photoPath;
        }

        $newUser = User::create($data);

        return response()->json([
            'message' => 'User created successfully',
            'user' => $newUser->load(['class', 'department']),
        ], 201);
    }

    public function show(User $user)
    {
        $currentUser = request()->user();

        $this->authorize('viewUser', [$currentUser, $user]);

        return response()->json([
            'user' => $user->load(['class', 'department']),
        ]);
    }

    public function update(Request $request, User $user)
    {
        $currentUser = $request->user();

        $this->authorize('updateUser', [$currentUser, $user]);

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'nip_nim' => 'required|string|max:50|unique:users,nip_nim,' . $user->id,
            'phone' => 'nullable|string|max:20',
            'role' => 'required|in:admin,hr,lecturer,employee,student',
            'department_id' => 'nullable|exists:departments,id',
            'class_id' => 'nullable|exists:classes,id',
            'profile_photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->only([
            'name', 'email', 'nip_nim', 'phone', 'role',
            'department_id', 'class_id'
        ]);

        // Handle profile photo upload
        if ($request->hasFile('profile_photo')) {
            // Delete old photo if exists
            if ($user->profile_photo) {
                Storage::disk('public')->delete($user->profile_photo);
            }
            $photoPath = $request->file('profile_photo')->store('profile_photos', 'public');
            $data['profile_photo'] = $photoPath;
        }

        $user->update($data);

        return response()->json([
            'message' => 'User updated successfully',
            'user' => $user->load(['class', 'department']),
        ]);
    }

    public function destroy(User $user)
    {
        $currentUser = request()->user();

        $this->authorize('deleteUser', [$currentUser, $user]);

        // Soft delete or deactivate
        $user->update(['is_active' => false]);

        return response()->json([
            'message' => 'User deactivated successfully',
        ]);
    }

    public function toggleStatus(Request $request, User $user)
    {
        $currentUser = $request->user();

        $this->authorize('updateUser', [$currentUser, $user]);

        $user->update(['is_active' => !$user->is_active]);

        return response()->json([
            'message' => 'User status updated successfully',
            'user' => $user,
        ]);
    }

    public function resetPassword(Request $request, User $user)
    {
        $currentUser = $request->user();

        $this->authorize('resetUserPassword', [$currentUser, $user]);

        $validator = Validator::make($request->all(), [
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user->update([
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'message' => 'Password reset successfully',
        ]);
    }

    public function import(Request $request)
    {
        $user = $request->user();

        $this->authorize('importUsers', $user);

        $validator = Validator::make($request->all(), [
            'file' => 'required|file|mimes:xlsx,xls,csv|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            Excel::import(new UsersImport(), $request->file('file'));

            return response()->json([
                'message' => 'Users imported successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Import failed: ' . $e->getMessage(),
            ], 422);
        }
    }

    public function getRoles()
    {
        return response()->json([
            'roles' => [
                ['value' => 'admin', 'label' => 'Administrator'],
                ['value' => 'hr', 'label' => 'HR Manager'],
                ['value' => 'lecturer', 'label' => 'Lecturer'],
                ['value' => 'employee', 'label' => 'Employee'],
                ['value' => 'student', 'label' => 'Student'],
            ],
        ]);
    }

    public function getDepartments()
    {
        $departments = Department::select('id', 'name')->get();

        return response()->json([
            'departments' => $departments,
        ]);
    }

    public function getClasses()
    {
        $classes = ClassModel::select('id', 'name')->get();

        return response()->json([
            'classes' => $classes,
        ]);
    }
}