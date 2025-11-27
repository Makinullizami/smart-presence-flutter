import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/ml_service.dart';
import '../services/api_service.dart';

class CameraControllerX extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isInitialized = false.obs;
  var faces = <Face>[].obs;
  var isProcessing = false.obs;

  final MLService _mlService = MLService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    requestPermissionsAndInitialize();
  }

  Future<void> requestPermissionsAndInitialize() async {
    try {
      if (kIsWeb) {
        // On web, try to initialize camera directly
        await initializeCamera();
      } else {
        // Request camera permission for mobile
        var status = await Permission.camera.request();
        if (status.isGranted) {
          await initializeCamera();
        } else {
          Get.snackbar('Error', 'Camera permission denied');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Error', 'No cameras available');
        return;
      }

      // Use front camera if available, otherwise back camera
      int cameraIndex = cameras.length > 1 ? 1 : 0;
      cameraController = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.medium,
      );

      await cameraController.initialize();
      isInitialized.value = true;

      // Start image stream for face detection
      cameraController.startImageStream(
        (CameraImage image) => processImage(image),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  void processImage(CameraImage image) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage != null) {
        faces.value = await _mlService.detectFaces(inputImage);
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // Simplified conversion for demo
    final bytes = image.planes[0].bytes;
    final inputImageData = InputImageData(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormat.nv21,
      planeData: image.planes
          .map(
            (plane) => InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            ),
          )
          .toList(),
    );
    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  Future<void> captureAndProcess() async {
    if (!isInitialized.value) {
      // Mock functionality for when camera is not available
      Get.snackbar(
        'Demo',
        'Kamera tidak tersedia di web. Menggunakan mode demo.',
      );
      // Simulate face detection
      faces.value = []; // Clear faces
      await Future.delayed(Duration(seconds: 1)); // Simulate processing
      Get.snackbar('Berhasil', 'Wajah diproses (mode demo)');
      return;
    }

    try {
      if (kIsWeb) {
        // On web, simulate the process
        Get.snackbar('Demo', 'Mode demo: wajah berhasil diproses');
        return;
      }

      final image = await cameraController.takePicture();
      final file = File(image.path);

      if (faces.isNotEmpty) {
        final croppedPath = await _mlService.cropFace(file, faces.first);
        if (croppedPath != null) {
          final embedding = _mlService.generateEmbedding(faces.first);
          // Upload to server
          await _apiService.uploadFaceEmbedding(
            1,
            croppedPath,
            embedding,
          ); // userId hardcoded for demo
          Get.snackbar('Berhasil', 'Wajah diproses dan diunggah');
        } else {
          Get.snackbar('Peringatan', 'Tidak dapat memotong wajah');
        }
      } else {
        Get.snackbar('Peringatan', 'Tidak ada wajah terdeteksi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses wajah: $e');
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    _mlService.dispose();
    super.onClose();
  }
}
