# Kehadiran Cerdas - Aplikasi Flutter

Aplikasi mobile untuk absensi cerdas menggunakan pengenalan wajah dengan Flutter dan ML Kit.

## Fitur

- Masuk dan daftar pengguna
- Pengenalan wajah menggunakan ML Kit
- Absensi otomatis
- Dashboard untuk admin dan siswa
- Integrasi dengan backend Laravel

## Persyaratan

- Flutter SDK
- Android Studio atau VS Code
- Perangkat Android dengan kamera

## Instalasi

### Frontend (Flutter)
1. Clone repository ini
2. Jalankan `flutter pub get` untuk menginstall dependencies

### Backend (Laravel)
1. Masuk ke direktori backend: `cd backend`
2. Install dependencies: `composer install`
3. Copy environment: `cp .env.example .env`
4. Generate key: `php artisan key:generate`
5. Setup database di `.env` file
6. Jalankan migrasi: `php artisan migrate`
7. Jalankan server: `php artisan serve`

## Menjalankan Aplikasi

### Backend
```bash
cd backend
php artisan serve
```
Backend akan berjalan di `http://localhost:8000`

### Frontend
```bash
flutter run
```

## Akun Default

Setelah menjalankan migrasi, buat akun admin manual di database atau gunakan seeder.

Contoh akun untuk testing:
- Admin: admin@example.com / password123
- Siswa: student@example.com / password123

## Konfigurasi API

URL API sudah dikonfigurasi untuk Android emulator (`http://10.0.2.2:8000/api`).

Untuk device fisik, ubah di `lib/app/services/api_service.dart`:

```dart
static const String baseUrl = 'http://192.168.1.xxx:8000/api'; // Ganti dengan IP komputer
```

## Permissions

Pastikan menambahkan permissions kamera di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## Struktur Proyek

```
lib/
  main.dart
  app/
    bindings/
    controllers/
    routes/
    screens/
      auth/
      attendance/
      admin_dashboard/
      student_dashboard/
    services/
      api_service.dart
      ml_service.dart
  models/
    user_model.dart
    attendance_model.dart
```

## Dependencies

- get: ^4.6.5
- http: ^1.6.0
- camera: ^0.10.0
- image_picker: ^0.8.7
- google_mlkit_face_detection: ^0.4.0
- path_provider: ^2.0.12
- flutter_secure_storage: ^8.0.0
- image: ^4.0.17
