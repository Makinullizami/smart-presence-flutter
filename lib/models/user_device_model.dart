class UserDevice {
  final int id;
  final int userId;
  final String deviceId;
  final String? deviceName;
  final String? deviceModel;
  final String? platform;
  final String? osVersion;
  final String? appVersion;
  final String? fcmToken;
  final bool isActive;
  final bool isVerified;
  final bool isCurrentDevice;
  final DateTime? lastLoginAt;
  final String? ipAddress;
  final DateTime createdAt;

  UserDevice({
    required this.id,
    required this.userId,
    required this.deviceId,
    this.deviceName,
    this.deviceModel,
    this.platform,
    this.osVersion,
    this.appVersion,
    this.fcmToken,
    required this.isActive,
    required this.isVerified,
    required this.isCurrentDevice,
    this.lastLoginAt,
    this.ipAddress,
    required this.createdAt,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      deviceModel: json['device_model'],
      platform: json['platform'],
      osVersion: json['os_version'],
      appVersion: json['app_version'],
      fcmToken: json['fcm_token'],
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      isCurrentDevice: json['is_current_device'] ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      ipAddress: json['ip_address'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'device_name': deviceName,
      'device_model': deviceModel,
      'platform': platform,
      'os_version': osVersion,
      'app_version': appVersion,
      'fcm_token': fcmToken,
      'is_active': isActive,
      'is_verified': isVerified,
      'is_current_device': isCurrentDevice,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'ip_address': ipAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String getDeviceDisplayName() {
    if (deviceName != null && deviceName!.isNotEmpty) {
      return deviceName!;
    }

    // Generate display name from platform and model
    String platformName = platform ?? 'Unknown';
    String modelName = deviceModel ?? 'Device';

    return '$platformName $modelName';
  }

  String getLastLoginDisplay() {
    if (lastLoginAt == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);

    if (difference.inDays == 0) {
      return 'Today ${lastLoginAt!.hour}:${lastLoginAt!.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${lastLoginAt!.day}/${lastLoginAt!.month}/${lastLoginAt!.year}';
    }
  }

  bool get isOnline => isActive && isVerified;
}
