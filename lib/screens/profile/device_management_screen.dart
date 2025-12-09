import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/device_controller.dart';
import '../../models/user_device_model.dart';

class DeviceManagementScreen extends StatelessWidget {
  final DeviceController controller = Get.put(DeviceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Perangkat'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadDevices,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Device limit info
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.devices, color: Colors.blue),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perangkat Terhubung',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.devices.length}/${controller.maxDevices} perangkat',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (controller.devices.length <
                          controller.maxDevices.value)
                        ElevatedButton.icon(
                          onPressed: () => _showAddDeviceDialog(context),
                          icon: Icon(Icons.add),
                          label: Text('Tambah'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Device list
              if (controller.devices.isEmpty) ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.devices_other,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada perangkat terhubung',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddDeviceDialog(context),
                        icon: Icon(Icons.add),
                        label: Text('Tambah Perangkat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...controller.devices.map((device) => _buildDeviceCard(device)),
              ],

              SizedBox(height: 16),

              // Security info
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keamanan Perangkat',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                              ),
                            ),
                            Text(
                              'Sistem membatasi maksimal ${controller.maxDevices} perangkat aktif per akun untuk keamanan.',
                              style: TextStyle(color: Colors.orange[800]),
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
      }),
    );
  }

  Widget _buildDeviceCard(UserDevice device) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  device.isCurrentDevice ? Icons.smartphone : Icons.devices,
                  color: device.isOnline ? Colors.green : Colors.grey,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.getDeviceDisplayName(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        device.isCurrentDevice
                            ? 'Perangkat ini'
                            : 'Perangkat lain',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildDeviceStatus(device),
              ],
            ),

            if (device.platform != null || device.osVersion != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  if (device.platform != null) ...[
                    Icon(Icons.android, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      device.platform!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                  if (device.osVersion != null) ...[
                    SizedBox(width: 12),
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      device.osVersion!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
            ],

            SizedBox(height: 8),
            Text(
              'Terakhir login: ${device.getLastLoginDisplay()}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            if (device.ipAddress != null) ...[
              SizedBox(height: 4),
              Text(
                'IP: ${device.ipAddress}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],

            if (!device.isCurrentDevice) ...[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showRemoveDeviceDialog(device),
                    icon: Icon(Icons.delete, color: Colors.red),
                    label: Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatus(UserDevice device) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: device.isOnline ? Colors.green[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: device.isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            device.isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: device.isOnline ? Colors.green[800] : Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final deviceNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Perangkat Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Untuk menambahkan perangkat baru, Anda perlu login dari perangkat tersebut. Sistem akan otomatis mendeteksi dan meminta verifikasi.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            TextField(
              controller: deviceNameController,
              decoration: InputDecoration(
                labelText: 'Nama Perangkat (Opsional)',
                hintText: 'Contoh: iPhone 12 Pro',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would trigger device registration
              // For demo purposes, we'll just show a message
              Navigator.of(context).pop();
              Get.snackbar(
                'Info',
                'Untuk menambah perangkat, silakan login dari perangkat baru tersebut.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            child: Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDeviceDialog(UserDevice device) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Hapus Perangkat'),
        content: Text(
          'Apakah Anda yakin ingin menghapus perangkat "${device.getDeviceDisplayName()}"? Perangkat ini tidak akan dapat mengakses akun Anda lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await controller.removeDevice(device.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
