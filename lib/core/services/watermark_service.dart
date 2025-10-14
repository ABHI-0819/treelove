
/*
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class WatermarkCameraService {
  final ImagePicker _picker = ImagePicker();

  /// Capture and process image with watermark
  Future<File?> captureAndSaveImage() async {
    try {
      // 1️⃣ Open system camera
      final XFile? rawImage = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 95,
        maxWidth:1024,
        maxHeight:1024 ,
        // reduce size while keeping quality
      );

      if (rawImage == null) return null;

      // 2️⃣ Get location & address
      final position = await _getCurrentLocation();
      final address = await _getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final locationText =
          "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      final timestamp = DateTime.now().toString().split('.')[0];

      // 3️⃣ Use cache/temp directory
      final tempDir = await getTemporaryDirectory();

      // 4️⃣ Add watermark + resize
      final watermarkedFile = await _addWatermark(
        File(rawImage.path),
        tempDir.path,
        locationText,
        timestamp,
        address,
      );

      return watermarkedFile;
    } catch (e) {
      debugPrint("Capture error: $e");
      rethrow;
    }
  }

  /// Get current location safely
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 10),
    );
  }

  /// Reverse geocode address
  Future<String> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}"
            .replaceAll(RegExp(r"^,\s*|,\s*$"), "");
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
    return "Address not found";
  }

  /// Add watermark (location, timestamp, address) to image
  Future<File> _addWatermark(
      File imageFile,
      String folderPath,
      String locationText,
      String timestamp,
      String address,
      ) async {
    final bytes = await imageFile.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) throw Exception("Could not decode image");

    // ✅ Resize to 1280x720 before watermark
    final resized = img.copyResize(original, width: 1280, height: 720);
    final image = img.Image.from(resized);

    final w = image.width;
    final h = image.height;
    final fontSize = (w * 0.025).round().clamp(16, 24);
    final padding = (w * 0.02).round();
    final lineHeight = (fontSize * 1.4).round();
    final watermarkHeight = (lineHeight * 3 + padding * 2);
    final yStart = h - watermarkHeight;

    // Dark background bar
    img.fillRect(
      image,
      x1: 0,
      y1: yStart,
      x2: w,
      y2: h,
      color: img.ColorRgba8(0, 0, 0, 180),
    );

    final textColor = img.ColorRgba8(255, 255, 255, 255);

    img.drawString(
      image,
      "📍 Location: $locationText",
      font: img.arial14,
      x: padding,
      y: yStart + padding,
      color: textColor,
    );

    img.drawString(
      image,
      "🕒 Time: $timestamp",
      font: img.arial14,
      x: padding,
      y: yStart + padding + lineHeight,
      color: textColor,
    );

    img.drawString(
      image,
      "📍 $address",
      font: img.arial14,
      x: padding,
      y: yStart + padding + lineHeight * 2,
      color: textColor,
    );

    // Save new file in temp folder
    final fileName = "watermarked_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedFile = File(path.join(folderPath, fileName));
    await savedFile.writeAsBytes(img.encodeJpg(image, quality: 95));

    return savedFile;
  }
}

 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class WatermarkCameraService {
  final ImagePicker _picker = ImagePicker();

  /// Capture and process image with watermark
  Future<File?> captureAndSaveImage() async {
    try {
      // 1. Open camera
      final XFile? rawImage = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (rawImage == null) return null;

      // 2 Get location & address
      final position = await _getCurrentLocation();
      final address = await _getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final locationText =
          "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      final timestamp = DateTime.now().toString().split('.')[0];

      // 3 Temp directory
      final tempDir = await getTemporaryDirectory();

      // 4 Add watermark
      final watermarkedFile = await _addWatermark(
        File(rawImage.path),
        tempDir.path,
        locationText,
        timestamp,
        address,
      );

      // 5 Compress for minimal size
      final imgBytes = await watermarkedFile.readAsBytes();
      final compressedBytes = await FlutterImageCompress.compressWithList(
        imgBytes,
        minWidth: 1024,
        minHeight: 1024,
        quality: 70, // adjust for smaller size
      );

      final compressedFile =
      File(path.join(tempDir.path, "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg"));
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      debugPrint("Capture error: $e");
      rethrow;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 10),
    );
  }

  Future<String> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}"
            .replaceAll(RegExp(r"^,\s*|,\s*$"), "");
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
    return "Address not found";
  }

  Future<File> _addWatermark(
      File imageFile,
      String folderPath,
      String locationText,
      String timestamp,
      String address,
      ) async {
    final bytes = await imageFile.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) throw Exception("Could not decode image");

    // Resize image if needed
    final resized = img.copyResize(original, width: 1024, height: 1024);
    final image = img.Image.from(resized);

    final w = image.width;
    final h = image.height;
    final fontSize = (w * 0.02).round().clamp(12, 20);
    final padding = (w * 0.015).round();
    final lineHeight = (fontSize * 1.3).round();
    final watermarkHeight = lineHeight * 3 + padding * 2;
    final yStart = h - watermarkHeight;

    // Semi-transparent background
    img.fillRect(
      image,
      x1: 0,
      y1: yStart,
      x2: w,
      y2: h,
      color: img.ColorRgba8(0, 0, 0, 120),
    );

    final textColor = img.ColorRgba8(255, 255, 255, 255);

    img.drawString(image, "📍 $locationText", font: img.arial14, x: padding, y: yStart + padding, color: textColor);
    img.drawString(image, "🕒 $timestamp", font: img.arial14, x: padding, y: yStart + padding + lineHeight, color: textColor);
    img.drawString(image, "📍 $address", font: img.arial14, x: padding, y: yStart + padding + lineHeight * 2, color: textColor);

    final fileName = "watermarked_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedFile = File(path.join(folderPath, fileName));
    await savedFile.writeAsBytes(img.encodeJpg(image, quality: 85)); // keep initial quality reasonable

    return savedFile;
  }
}


