import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_splash.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_service.dart';
import 'package:bingo_clash/crash_esof_app/parameters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences aSharedPreferences;

dynamic crashEsofAppConversionData;
String? crashEsofAppTrackingPermissionStatus;
String? crashEsofAppAdvertisingId;
String? analyticsLink;

String? appsflyer_id;
String? external_id;

String? crashEsofAppPushconsentmsg;

class CrashEsofAppCheck extends StatefulWidget {
  const CrashEsofAppCheck({super.key});

  @override
  State<CrashEsofAppCheck> createState() => _CrashEsofAppCheckState();
}

class _CrashEsofAppCheckState extends State<CrashEsofAppCheck> {
  @override
  void initState() {
    super.initState();
    crashEsofAppInitAll();
  }

  crashEsofAppInitAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    aSharedPreferences = await SharedPreferences.getInstance();
    bool sendedAnalytics =
        aSharedPreferences.getBool("sendedAnalytics") ?? false;
    analyticsLink = aSharedPreferences.getString("link");

    crashEsofAppPushconsentmsg = aSharedPreferences.getString("pushconsentmsg");

    if (analyticsLink != null && analyticsLink != "" && !sendedAnalytics) {
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
      "external_id": external_id,
      "appsflyer_id": appsflyer_id,
    });

    String? link = await CrashEsofAppService().sendAnalyticsRequest(parameters);

    analyticsLink = link;

    if (analyticsLink == "" || analyticsLink == null) {
      CrashEsofAppService().crashEsofAppNavigateToSplash(context);
    } else {
      crashEsofAppPushconsentmsg = crashEsofAppGetPushConsentMsgValue(analyticsLink!);
      if (crashEsofAppPushconsentmsg != null) {
        aSharedPreferences.setString("pushconsentmsg", crashEsofAppPushconsentmsg!);
      }
      aSharedPreferences.setString("link", analyticsLink.toString());
      aSharedPreferences.setBool("success", true);
      CrashEsofAppService().crashEsofAppNavigateToWebView(context);
    }
  }

  Future<void> crashEsofAppTakeParams() async {
    final appsFlyerOptions = CrashEsofAppService().crashEsofAppCreateAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appsflyer_id = await appsFlyerSdk.getAppsFlyerUID();

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

