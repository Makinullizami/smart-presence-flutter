import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.settings, size: 28),
              SizedBox(width: 8),
              Text('⚙️ Pengaturan'),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Profil Instansi'),
              Tab(text: 'Aturan Absensi'),
              Tab(text: 'Lokasi & Perangkat'),
              Tab(text: 'Face Recognition'),
              Tab(text: 'Notifikasi & Email'),
              Tab(text: 'Integrasi'),
              Tab(text: 'Sistem & Keamanan'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: TabBarView(
            children: [
              _buildInstitutionProfileTab(),
              _buildAttendanceRulesTab(),
              _buildLocationDevicesTab(),
              _buildFaceRecognitionTab(),
              _buildNotificationsTab(),
              _buildIntegrationTab(),
              _buildSystemSecurityTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.saveSettings(),
          child: Icon(Icons.save),
          backgroundColor: Colors.blue.shade600,
          tooltip: 'Simpan Pengaturan',
        ),
      ),
    );
  }

  Widget _buildInstitutionProfileTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Instansi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.appName.value,
                  decoration: InputDecoration(
                    labelText: 'Nama Aplikasi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.app_settings_alt),
                  ),
                  onChanged: (value) => controller.appName.value = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.institutionName.value,
                  decoration: InputDecoration(
                    labelText: 'Nama Instansi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  onChanged: (value) =>
                      controller.institutionName.value = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.institutionAddress.value,
                  decoration: InputDecoration(
                    labelText: 'Alamat Instansi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                  onChanged: (value) =>
                      controller.institutionAddress.value = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.institutionPhone.value,
                  decoration: InputDecoration(
                    labelText: 'Telepon Instansi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  onChanged: (value) =>
                      controller.institutionPhone.value = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.institutionEmail.value,
                  decoration: InputDecoration(
                    labelText: 'Email Instansi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  onChanged: (value) =>
                      controller.institutionEmail.value = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceRulesTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aturan Absensi Global',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.attendanceToleranceMinutes.value
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Toleransi Keterlambatan (menit)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.schedule),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.attendanceToleranceMinutes.value =
                              int.tryParse(value) ?? 10,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.minimumAttendancePercentage.value
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Persentase Kehadiran Minimum (%)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.minimumAttendancePercentage.value =
                              int.tryParse(value) ?? 75,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.workingHoursStart.value,
                            decoration: InputDecoration(
                              labelText: 'Jam Masuk',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onChanged: (value) =>
                                controller.workingHoursStart.value = value,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.workingHoursEnd.value,
                            decoration: InputDecoration(
                              labelText: 'Jam Keluar',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onChanged: (value) =>
                                controller.workingHoursEnd.value = value,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDevicesTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Geofencing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Aktifkan Geofencing'),
                      subtitle: Text('Validasi lokasi untuk absensi'),
                      value: controller.geofenceEnabled.value,
                      onChanged: (value) =>
                          controller.geofenceEnabled.value = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.geofenceCenterLat.value,
                      decoration: InputDecoration(
                        labelText: 'Latitude Pusat Geofence',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      enabled: controller.geofenceEnabled.value,
                      onChanged: (value) =>
                          controller.geofenceCenterLat.value = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.geofenceCenterLng.value,
                      decoration: InputDecoration(
                        labelText: 'Longitude Pusat Geofence',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      enabled: controller.geofenceEnabled.value,
                      onChanged: (value) =>
                          controller.geofenceCenterLng.value = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.geofenceRadiusMeters.value
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Radius Geofence (meter)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.radio_button_checked),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: controller.geofenceEnabled.value,
                      onChanged: (value) =>
                          controller.geofenceRadiusMeters.value =
                              int.tryParse(value) ?? 500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceRecognitionTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Face Recognition & Foto Absensi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.faceRecognitionThreshold.value,
                      decoration: InputDecoration(
                        labelText: 'Threshold Face Recognition (0.0 - 1.0)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.face),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) =>
                          controller.faceRecognitionThreshold.value = value,
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Wajibkan Foto Saat Absensi'),
                      subtitle: Text(
                        'Pengguna harus mengambil foto saat absensi',
                      ),
                      value: controller.requirePhotoOnAttendance.value,
                      onChanged: (value) =>
                          controller.requirePhotoOnAttendance.value = value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifikasi & Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Notifikasi Email'),
                      subtitle: Text('Kirim notifikasi melalui email'),
                      value: controller.emailNotificationsEnabled.value,
                      onChanged: (value) =>
                          controller.emailNotificationsEnabled.value = value,
                    ),
                    SizedBox(height: 8),
                    SwitchListTile(
                      title: Text('Notifikasi SMS'),
                      subtitle: Text('Kirim notifikasi melalui SMS'),
                      value: controller.smsNotificationsEnabled.value,
                      onChanged: (value) =>
                          controller.smsNotificationsEnabled.value = value,
                    ),
                    SizedBox(height: 8),
                    SwitchListTile(
                      title: Text('Notifikasi Push'),
                      subtitle: Text('Kirim notifikasi push ke aplikasi'),
                      value: controller.pushNotificationsEnabled.value,
                      onChanged: (value) =>
                          controller.pushNotificationsEnabled.value = value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Integrasi Sistem',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.integration_instructions,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Integrasi dengan sistem eksternal\nakan ditambahkan di versi mendatang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSecurityTab() {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistem & Keamanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.sessionTimeoutMinutes.value
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Timeout Sesi (menit)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.sessionTimeoutMinutes.value =
                              int.tryParse(value) ?? 60,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.passwordMinLength.value
                          .toString(),
                      decoration: InputDecoration(
                        labelText: 'Panjang Minimum Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.passwordMinLength.value =
                          int.tryParse(value) ?? 8,
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Wajibkan Karakter Khusus'),
                      subtitle: Text(
                        'Password harus mengandung karakter khusus',
                      ),
                      value: controller.requireSpecialCharacters.value,
                      onChanged: (value) =>
                          controller.requireSpecialCharacters.value = value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
