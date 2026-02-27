import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class PermissionService {
  Future<PermissionStatus> requestMicrophonePermission() async {
    return await Permission.microphone.request();
  }

  Future<PermissionStatus> getMicrophoneStatus() async {
    return await Permission.microphone.status;
  }

  Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }

  Future<PermissionStatus> getNotificationStatus() async {
    return await Permission.notification.status;
  }

  Future<bool> isOverlayPermissionGranted() async {
    if (Platform.isAndroid) {
      return await FlutterOverlayWindow.isPermissionGranted();
    }
    return true; // Overlay is Android-only
  }

  Future<bool?> requestOverlayPermission() async {
    if (Platform.isAndroid) {
      return await FlutterOverlayWindow.requestPermission();
    }
    return true;
  }

  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}
