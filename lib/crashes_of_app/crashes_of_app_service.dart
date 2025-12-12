import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';
import 'crashes_of_app.dart';
import 'crashes_of_app_parameters.dart';
import 'crashes_of_app_web_view.dart';
import 'crashes_of_app_web_view_two.dart';

class CrashesOfAppService {
  void navigateToWebView(BuildContext context) {
    final bool useCustomTab =
        crashesOfAppWebViewType == 2 && crashesOfAppLink != null;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            useCustomTab
                ? CrashesOfAppWebViewTwo(link: crashesOfAppLink!)
                : const CrashesOfAppWebViewWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> initializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(crashesOfAppOneSignalAppId);
    crashesOfAppExternalId = const Uuid().v1();
  }

  Future<void> requestPermissionOneSignal() async {
    await OneSignal.Notifications.requestPermission(true);
    crashesOfAppExternalId = const Uuid().v1();
    try {
      OneSignal.login(crashesOfAppExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void notifyOneSignalAccepted() {
    try {
      OneSignal.login(crashesOfAppExternalId ?? const Uuid().v1());
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void sendRequestToBackend() {
    try {
      OneSignal.login(crashesOfAppExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  Future<void> navigateToStandardApp(BuildContext context) async {
    crashesOfAppSharedPreferences.setBool(crashesOfAppSentFlagKey, true);
    crashesOfAppOpenStandardAppLogic(context);
  }

  Future<bool> isSystemPermissionGranted() async {
    if (!Platform.isIOS) return false;
    try {
      final status = await OneSignal.Notifications.permissionNative();
      return status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
    } catch (_) {
      return false;
    }
  }

  AppsFlyerOptions createAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (crashesOfAppAfDevKeyPart1 + crashesOfAppAfDevKeyPart2),
      appId: crashesOfAppAppsFlyerAppId,
      timeToWaitForATTUserAuthorization: 5,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> requestTrackingPermission() async {
    if (Platform.isIOS) {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      crashesOfAppTrackingPermissionStatus = status.toString();

      if (status == TrackingStatus.authorized) {
        await _getAdvertisingId();
      }
    }
  }

  Future<void> _getAdvertisingId() async {
    try {
      crashesOfAppAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendCrashesOfAppRequest(
      Map<dynamic, dynamic> parameters) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {crashesOfAppKeyword: base64Parameters};

      final response = await http.post(
        Uri.parse(crashesOfAppBackendUrl),
        body: requestBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
