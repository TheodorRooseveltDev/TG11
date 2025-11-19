import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'storage_service.dart';

/// Notification Service
/// Manages push notifications through OneSignal
class NotificationService extends ChangeNotifier {
  final StorageService _storage;
  
  bool _notificationsEnabled = false;
  bool _permissionGranted = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get permissionGranted => _permissionGranted;
  bool get isNotificationsEnabled => _notificationsEnabled;

  NotificationService(this._storage) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationsEnabled = _storage.isNotificationsEnabled();
    _permissionGranted = _storage.isNotificationsPermissionGranted();
    
    // Check actual permission status on load
    await checkPermissionStatus();
    
    notifyListeners();
  }

  /// Request notification permission from OneSignal (without ID)
  /// This only requests permission, does not login or set user ID
  Future<bool> requestPermission() async {
    try {
      await OneSignal.Notifications.requestPermission(true);
      
      // Check if permission was granted
      final status = await OneSignal.Notifications.permissionNative();
      final granted = status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
      
      _permissionGranted = granted;
      await _storage.saveNotificationsPermissionGranted(granted);
      
      if (granted) {
        _notificationsEnabled = true;
        await _storage.saveNotificationsEnabled(true);
      }
      
      notifyListeners();
      return granted;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Toggle notifications on/off
  /// If enabling, requests permission first
  Future<void> toggleNotifications() async {
    if (!_notificationsEnabled && !_permissionGranted) {
      // Request permission when enabling
      final granted = await requestPermission();
      if (!granted) {
        // Permission denied, keep notifications disabled
        return;
      }
    } else {
      // Toggle state
      _notificationsEnabled = !_notificationsEnabled;
      await _storage.saveNotificationsEnabled(_notificationsEnabled);
      notifyListeners();
    }
  }

  /// Check current permission status
  Future<void> checkPermissionStatus() async {
    try {
      final status = await OneSignal.Notifications.permissionNative();
      final granted = status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
      
      if (_permissionGranted != granted) {
        _permissionGranted = granted;
        await _storage.saveNotificationsPermissionGranted(granted);
        
        // If permission was revoked, disable notifications
        if (!granted && _notificationsEnabled) {
          _notificationsEnabled = false;
          await _storage.saveNotificationsEnabled(false);
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking notification permission: $e');
    }
  }
}

