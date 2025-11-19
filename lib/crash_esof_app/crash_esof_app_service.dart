import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_check.dart';
import 'package:bingo_clash/crash_esof_app/parameters.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

class CrashEsofAppService {
  Future<void> crashEsofAppInitializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(crashEsofAppOneSignalString);
    external_id = Uuid().v1();
  }

  Future<void> crashEsofAppRequestPermissionOneSignal() async {
    await OneSignal.Notifications.requestPermission(true);
    external_id = Uuid().v1();
    try {
      OneSignal.login(external_id!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void crashEsofAppSendRequiestToBack() {
    try {
      OneSignal.login(external_id!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  Future crashEsofAppNavigateToSplash(BuildContext context) async {
    aSharedPreferences.setBool("sendedAnalytics", true);
    crashEsofAppOpenStandartAppLogic(context);
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

  void crashEsofAppNavigateToWebView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WebViewWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  AppsFlyerOptions crashEsofAppCreateAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (crashEsofAppAfDevKey1 + crashEsofAppAfDevKey2),
      appId: crashEsofAppDevKeypndAppId,
      timeToWaitForATTUserAuthorization: 7,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> crashEsofAppRequestTrackingPermission() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 2));
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        crashEsofAppTrackingPermissionStatus = status.toString();

        if (status == TrackingStatus.authorized) {
          crashEsofAppGetAdvertisingId();
        }
        if (status == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          crashEsofAppTrackingPermissionStatus = status.toString();

          if (status == TrackingStatus.authorized) {
            crashEsofAppGetAdvertisingId();
          }
        }
      }
    }
  }

  Future<void> crashEsofAppGetAdvertisingId() async {
    try {
      crashEsofAppAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendAnalyticsRequest(Map<dynamic, dynamic> parameters) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {crashEsofAppStandartWord: base64Parameters};

      final response = await http.post(
        Uri.parse(crashEsofAppUrl),
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

