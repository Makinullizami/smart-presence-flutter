import 'dart:convert';
import 'package:crypto/crypto.dart';

class QrService {
  String generateQrToken(int userId, String faceId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = '$userId:$faceId:$timestamp';
    final hash = sha256.convert(utf8.encode(data)).toString();
    return '$userId:$faceId:$timestamp:$hash';
  }

  bool validateQrToken(String token) {
    try {
      final parts = token.split(':');
      if (parts.length != 4) return false;

      final userId = parts[0];
      final faceId = parts[1];
      final timestamp = parts[2];
      final providedHash = parts[3];

      final data = '$userId:$faceId:$timestamp';
      final calculatedHash = sha256.convert(utf8.encode(data)).toString();

      // Check if token is not expired (24 hours)
      final tokenTime = int.tryParse(timestamp);
      if (tokenTime == null) return false;

      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - tokenTime;
      if (diff > 24 * 60 * 60 * 1000) return false; // 24 hours

      return providedHash == calculatedHash;
    } catch (e) {
      return false;
    }
  }

  String generateBackupQr(int userId) {
    return generateQrToken(userId, 'backup');
  }
}
