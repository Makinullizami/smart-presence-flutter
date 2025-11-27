# Daftar Fitur Aplikasi Smart Presence (Absen Cerdas)

## 1. Deskripsi Singkat Aplikasi

Smart Presence adalah aplikasi mobile berbasis Flutter yang dirancang untuk sistem absensi otomatis menggunakan teknologi pengenalan wajah. Aplikasi ini menggunakan backend Laravel untuk API dan penyimpanan data, dengan integrasi ML Kit untuk deteksi wajah secara real-time pada perangkat mobile.

Aplikasi ini memanfaatkan teknologi kecerdasan buatan untuk mendeteksi dan mengenali wajah siswa secara otomatis, sehingga proses absensi menjadi lebih efisien dan akurat. Sistem menggunakan embedding wajah untuk identifikasi siswa, dengan backend yang menyimpan data embedding dan melakukan pencocokan wajah untuk validasi kehadiran.

## 2. Fitur-Fitur Untuk Role SISWA

### 2.1. Login & Autentikasi
- Siswa dapat login menggunakan email dan password yang telah terdaftar
- Validasi input dengan pesan error yang jelas untuk field yang kosong
- Sistem menggunakan token authentication (Laravel Sanctum) untuk keamanan
- Pesan error informatif jika login gagal (password salah, email tidak terdaftar)
- Opsi "Lupa Password" untuk reset password (opsional)

### 2.2. Registrasi Wajah (Face Enrollment)
- Akses halaman registrasi wajah setelah login pertama kali
- Menggunakan kamera perangkat untuk mengambil foto wajah
- ML Kit secara real-time mendeteksi posisi wajah dalam frame kamera
- Sistem memotong (crop) wajah dari gambar asli secara otomatis
- Embedding wajah dikirim ke backend Laravel untuk penyimpanan
- Backend menyimpan embedding wajah dalam format JSON di database
- Konfirmasi berhasil dengan notifikasi dan preview gambar wajah

### 2.3. Melakukan Absensi
- Siswa membuka halaman absensi dengan kamera aktif secara otomatis
- Sistem mendeteksi wajah secara real-time menggunakan ML Kit
- Bounding box hijau menunjukkan area wajah yang terdeteksi
- Sistem mengirim embedding wajah ke backend untuk pencocokan
- Backend membandingkan embedding dengan data siswa terdaftar
- Jika cocok (similarity score > threshold), status "Hadir" dicatat otomatis
- Jika wajah tidak cocok, tampil pesan "Wajah tidak dikenali"
- Notifikasi berhasil dengan suara dan animasi
- Timestamp otomatis berdasarkan waktu server

### 2.4. Lihat Riwayat Absensi
- Tabel riwayat absensi dengan filter harian/mingguan/bulanan
- Menampilkan kolom: Tanggal, Jam Masuk, Status (Hadir/Telat/Tidak Hadir)
- Status "Telat" jika absensi setelah jam 08:00 pagi
- Statistik persentase kehadiran bulanan
- Export riwayat ke PDF (opsional)
- Indikator warna: Hijau (Hadir), Orange (Telat), Merah (Tidak Hadir)

### 2.5. Edit Profil Siswa
- Mengubah data nama lengkap siswa
- Update informasi kelas dan NIM
- Upload ulang foto profil (bukan wajah untuk absensi)
- Upload ulang data wajah jika diperlukan (opsional)
- Validasi input dengan pesan error yang jelas
- Konfirmasi perubahan dengan dialog

### 2.6. Logout
- Tombol logout di menu profil atau app bar
- Konfirmasi logout dengan dialog "Yakin ingin keluar?"
- Menghapus token authentication dari penyimpanan lokal
- Redirect otomatis ke halaman login
- Clear semua data session

## 3. Fitur-Fitur Untuk Role ADMIN

### 3.1. Login Admin
- Akses halaman login khusus admin atau unified login
- Login menggunakan akun admin yang telah terdaftar di sistem
- Redirect otomatis ke dashboard admin setelah login berhasil
- Session management dengan token yang lebih panjang

### 3.2. Manajemen Data Siswa
- Halaman list semua siswa dengan pagination
- Tambah data siswa baru dengan form lengkap (nama, email, NIM, kelas)
- Edit data siswa existing dengan validasi duplikasi
- Soft delete siswa (menandai sebagai tidak aktif)
- Reset password siswa ke default
- Preview dan download foto wajah siswa yang terdaftar
- Filter dan search siswa berdasarkan nama, NIM, atau kelas

### 3.3. Manajemen Wajah Siswa
- Galeri embedding wajah semua siswa
- Preview gambar wajah yang telah di-crop
- Validasi embedding untuk mendeteksi duplikasi wajah
- Approve/reject pendaftaran wajah siswa
- Re-enrollment wajah jika ada masalah
- Backup dan restore data embedding

### 3.4. Monitoring Absensi
- Dashboard real-time dengan statistik kehadiran hari ini
- Tabel absensi semua siswa dengan filter advanced:
  - Filter berdasarkan tanggal (date picker)
  - Filter berdasarkan kelas (dropdown)
  - Filter berdasarkan siswa tertentu (search)
- Menampilkan: waktu presensi, status, foto bukti absensi
- Status indicator: Hadir (hijau), Telat (orange), Alpha (merah)
- Pagination untuk handling data besar

### 3.5. Rekap Laporan Absensi
- Generate laporan absensi mingguan/bulanan/tahunan
- Export laporan ke format PDF dan Excel
- Statistik detail:
  - Jumlah siswa hadir per hari
  - Persentase kehadiran per siswa
  - Tren kehadiran bulanan
  - Ranking siswa berdasarkan kedisiplinan
- Filter laporan berdasarkan kelas atau periode waktu

### 3.6. Manajemen Kelas
- CRUD operasi untuk data kelas (nama kelas, wali kelas)
- Assign siswa ke kelas masing-masing
- Transfer siswa antar kelas
- Statistik kehadiran per kelas
- Laporan perbandingan antar kelas

### 3.7. Pengaturan Sistem
- Konfigurasi threshold kecocokan wajah (0.0 - 1.0)
- Set waktu absensi dibuka dan ditutup (jam operasional)
- Pengaturan nama sekolah dan informasi institusi
- Manajemen multiple admin dengan role berbeda
- Backup database otomatis
- Log aktivitas sistem

### 3.8. Logout Admin
- Logout dengan konfirmasi keamanan
- Clear session admin
- Redirect ke halaman login admin
- Log aktivitas logout untuk audit trail

## 4. Fitur AI yang Digunakan

### 4.1. Face Detection (ML Kit – On Device)
- Deteksi real-time posisi wajah dalam frame kamera
- Bounding box hijau mengelilingi wajah terdeteksi
- Landmark detection untuk mata, hidung, dan mulut
- Face tracking untuk mengikuti pergerakan wajah
- Confidence score untuk akurasi deteksi
- Multiple face detection dalam satu frame

### 4.2. Face Embedding (Backend Processing)
- Konversi gambar wajah menjadi vektor numerik 128-dimensi
- Penyimpanan embedding dalam format JSON di database
- Pencocokan wajah menggunakan cosine similarity
- Threshold konfigurasi untuk menentukan kecocokan
- Batch processing untuk embedding massal
- Optimisasi performa dengan indexing

## 5. Arsitektur Singkat Sistem

Aplikasi Smart Presence menggunakan arsitektur client-server dengan Flutter sebagai frontend mobile dan web, Laravel sebagai backend API, serta MySQL/MariaDB sebagai database. Sistem ML Kit berjalan on-device untuk face detection real-time, sementara face recognition dan embedding processing dilakukan di backend untuk akurasi dan keamanan. File storage digunakan untuk menyimpan gambar wajah, dengan sistem backup otomatis untuk mencegah kehilangan data.

## 6. Struktur Navigasi Aplikasi

```
Login Page
├── Siswa Login → Dashboard Siswa
│   ├── Profil Siswa → Edit Profil
│   ├── Absensi → Kamera Face Detection → Konfirmasi Absensi
│   └── Riwayat Absensi → Detail per Tanggal
│
└── Admin Login → Dashboard Admin
    ├── Manajemen Siswa → CRUD Siswa → Manajemen Wajah
    ├── Monitoring Absensi → Filter & View → Detail Siswa
    ├── Laporan Absensi → Generate PDF/Excel
    ├── Manajemen Kelas → CRUD Kelas → Assign Siswa
    └── Pengaturan Sistem → Konfigurasi Threshold → Backup Data
```

## 7. Daftar Fitur Versi MVP (Minimal)

- ✅ Autentikasi login siswa dan admin
- ✅ Registrasi wajah siswa dengan ML Kit
- ✅ Absensi otomatis dengan face recognition
- ✅ Riwayat absensi siswa harian/mingguan
- ✅ Dashboard admin untuk monitoring
- ✅ Laporan absensi harian untuk admin
- ✅ Manajemen data siswa dasar

## 8. Fitur Tambahan (Opsional)

- Push notification untuk reminder absensi
- GPS location tracking untuk validasi lokasi
- QR Code sebagai backup method absensi
- Export laporan dalam format PDF dengan chart
- Multi-admin dengan role-based permissions
- Dark mode UI theme
- Offline mode dengan sync otomatis
- Biometric authentication (fingerprint/face unlock)
- Integration dengan sistem akademik sekolah
- Real-time dashboard dengan WebSocket

## 9. Teknologi yang Digunakan

### Frontend (Flutter)
- Framework: Flutter 3.x dengan Dart
- State Management: GetX
- UI Components: Material Design 3
- Camera Integration: camera package
- Face Detection: google_mlkit_face_detection
- HTTP Client: http package
- Local Storage: flutter_secure_storage

### Backend (Laravel)
- Framework: Laravel 10.x dengan PHP 8.1+
- Authentication: Laravel Sanctum
- Database: MySQL/MariaDB
- API: RESTful JSON API
- File Storage: Laravel Storage
- Validation: Laravel Request Validation

### AI/ML
- Face Detection: Google ML Kit (on-device)
- Face Recognition: Cosine Similarity Algorithm
- Embedding Storage: JSON format in database
- Threshold Configuration: Admin adjustable

### Database Schema
- Users table: id, name, email, password, role, nim, class
- Attendances table: id, user_id, date, time, status
- Faces table: id, user_id, image_path, embedding
- Classes table: id, name, teacher_name (optional)

---

**Dibuat untuk keperluan tugas kuliah Smart Presence (Absen Cerdas)**  
**Teknologi: Flutter + Laravel + ML Kit**  
**Tanggal: November 2024**