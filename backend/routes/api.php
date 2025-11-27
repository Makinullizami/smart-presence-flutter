<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\FaceController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Attendance routes
    Route::post('/attendance', [AttendanceController::class, 'markAttendance']);
    Route::get('/attendance/{userId}', [AttendanceController::class, 'getAttendanceHistory']);
    Route::get('/attendance', [AttendanceController::class, 'getAllAttendances']);

    // Face recognition routes
    Route::post('/faces/embedding', [FaceController::class, 'uploadEmbedding']);
    Route::get('/faces/{userId}', [FaceController::class, 'getUserFaces']);
    Route::post('/faces/recognize', [FaceController::class, 'recognizeFace']);
});