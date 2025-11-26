import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_splash.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_service.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_parameters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences crashEsofAppSharedPreferences;

dynamic crashEsofAppConversionData;
String? crashEsofAppTrackingPermissionStatus;
String? crashEsofAppAdvertisingId;
String? crashEsofAppLink;

String? crashEsofAppAppsflyerId;
String? crashEsofAppExternalId;

String? crashEsofAppPushConsentMsg;

class CrashEsofApp extends StatefulWidget {
  const CrashEsofApp({super.key});

  @override
  State<CrashEsofApp> createState() => _CrashEsofAppState();
}

class _CrashEsofAppState extends State<CrashEsofApp> {
  @override
  void initState() {
    super.initState();
    crashEsofAppInitAll();
  }

  crashEsofAppInitAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    crashEsofAppSharedPreferences = await SharedPreferences.getInstance();
    bool sendedAnalytics =
        crashEsofAppSharedPreferences.getBool("sendedAnalytics") ?? false;
    crashEsofAppLink = crashEsofAppSharedPreferences.getString("link");

    crashEsofAppPushConsentMsg = crashEsofAppSharedPreferences.getString(
      "pushconsentmsg",
    );

    if (crashEsofAppLink != null &&
        crashEsofAppLink != "" &&
        !sendedAnalytics) {
      CrashEsofAppService().crashEsofAppNavigateToWebView(context);
    } else {
      if (sendedAnalytics) {
        CrashEsofAppService().crashEsofAppNavigateToSplash(context);
      } else {
        crashEsofAppInitializeMainPart();
      }
    }
  }

  void crashEsofAppInitializeMainPart() async {
    await CrashEsofAppService().crashEsofAppRequestTrackingPermission();
    await CrashEsofAppService().crashEsofAppInitializeOneSignal();
    await crashEsofAppTakeParams();
  }

  String? crashEsofAppGetPushConsentMsgValue(String link) {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;

      return params['pushconsentmsg'];
    } catch (e) {
      return null;
    }
  }

  Future<void> crashEsofAppCreateLink() async {
    Map<dynamic, dynamic> parameters = crashEsofAppConversionData;

    parameters.addAll({
      "tracking_status": crashEsofAppTrackingPermissionStatus,
      "${crashEsofAppStandartWord}_id": crashEsofAppAdvertisingId,
      "external_id": crashEsofAppExternalId,
      "appsflyer_id": crashEsofAppAppsflyerId,
    });

    String? link = await CrashEsofAppService().sendCrashEsofAppRequest(
      parameters,
    );

    crashEsofAppLink = link;

    if (crashEsofAppLink == "" || crashEsofAppLink == null) {
      CrashEsofAppService().crashEsofAppNavigateToSplash(context);
    } else {
      crashEsofAppPushConsentMsg = crashEsofAppGetPushConsentMsgValue(
        crashEsofAppLink!,
      );
      if (crashEsofAppPushConsentMsg != null) {
        crashEsofAppSharedPreferences.setString(
          "pushconsentmsg",
          crashEsofAppPushConsentMsg!,
        );
      }
      crashEsofAppSharedPreferences.setString(
        "link",
        crashEsofAppLink.toString(),
      );
      crashEsofAppSharedPreferences.setBool("success", true);
      CrashEsofAppService().crashEsofAppNavigateToWebView(context);
    }
  }

  Future<void> crashEsofAppTakeParams() async {
    final appsFlyerOptions = CrashEsofAppService()
        .crashEsofAppCreateAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    crashEsofAppAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();

    appsFlyerSdk.onInstallConversionData((res) async {
      crashEsofAppConversionData = res;
      await crashEsofAppCreateLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        CrashEsofAppService().crashEsofAppNavigateToSplash(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CrashEsofAppSplash();
  }
}
