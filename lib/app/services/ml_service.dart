import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class MLService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    final faces = await _faceDetector.processImage(inputImage);
    return faces;
  }

  Future<String?> cropFace(File imageFile, Face face) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) return null;

      // Get bounding box
      final boundingBox = face.boundingBox;

      // Crop the face
      final croppedImage = img.copyCrop(
        decodedImage,
        x: boundingBox.left.toInt(),
        y: boundingBox.top.toInt(),
        width: boundingBox.width.toInt(),
        height: boundingBox.height.toInt(),
      );

      // Save cropped image
      final directory = await getTemporaryDirectory();
      final croppedFile = File(
        '${directory.path}/cropped_face_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

      return croppedFile.path;
    } catch (e) {
      print('Error cropping face: $e');
      return null;
    }
  }

  // Dummy embedding generation (replace with actual ML model)
  List<double> generateEmbedding(Face face) {
    // This is a placeholder. In real implementation, use a proper face recognition model
    // For now, return a list of random doubles as embedding
    return List.generate(128, (index) => face.boundingBox.left + index * 0.1);
  }

  void dispose() {
    _faceDetector.close();
  }
}
