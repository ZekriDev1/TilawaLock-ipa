import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';

class PermissionProvider extends ChangeNotifier {
  final PermissionService _permissionService;

  PermissionStatus _microphoneStatus = PermissionStatus.denied;
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  bool _isOverlayGranted = false;

  PermissionProvider(this._permissionService) {
    refreshStatuses();
  }

  PermissionStatus get microphoneStatus => _microphoneStatus;
  PermissionStatus get notificationStatus => _notificationStatus;
  bool get isOverlayGranted => _isOverlayGranted;

  Future<void> refreshStatuses() async {
    _microphoneStatus = await _permissionService.getMicrophoneStatus();
    _notificationStatus = await _permissionService.getNotificationStatus();
    _isOverlayGranted = await _permissionService.isOverlayPermissionGranted();
    notifyListeners();
  }

  Future<void> requestMicrophone() async {
    _microphoneStatus = await _permissionService.requestMicrophonePermission();
    notifyListeners();
  }

  Future<void> requestNotifications() async {
    _notificationStatus = await _permissionService.requestNotificationPermission();
    notifyListeners();
  }

  Future<void> requestOverlay() async {
    await _permissionService.requestOverlayPermission();
    _isOverlayGranted = await _permissionService.isOverlayPermissionGranted();
    notifyListeners();
  }
}
