import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crashes_of_app_parameters.dart';
import 'crashes_of_app_service.dart';
import 'crashes_of_app_splash.dart';

late SharedPreferences crashesOfAppSharedPreferences;

dynamic crashesOfAppConversionData;
String? crashesOfAppTrackingPermissionStatus;
String? crashesOfAppAdvertisingId;
String? crashesOfAppLink;

String? crashesOfAppAppsflyerId;
String? crashesOfAppExternalId;

int crashesOfAppWebViewType = 1;
bool crashesOfAppConversionHandled = false;

class CrashesOfApp extends StatefulWidget {
  const CrashesOfApp({super.key});

  @override
  State<CrashesOfApp> createState() => _CrashesOfAppState();
}

class _CrashesOfAppState extends State<CrashesOfApp> {
  @override
  void initState() {
    super.initState();
    crashesOfAppInitAll();
  }

  Future<void> crashesOfAppInitAll() async {
    await Future.delayed(const Duration(milliseconds: 10));
    crashesOfAppSharedPreferences = await SharedPreferences.getInstance();
    final bool sentAnalytics =
        crashesOfAppSharedPreferences.getBool(crashesOfAppSentFlagKey) ??
            false;
    crashesOfAppLink =
        crashesOfAppSharedPreferences.getString(crashesOfAppLinkKey);
    crashesOfAppWebViewType = crashesOfAppSharedPreferences
            .getInt(crashesOfAppWebViewTypeKey) ??
        1;

    if (crashesOfAppLink != null && crashesOfAppLink!.isNotEmpty) {
      crashesOfAppWebViewType =
          crashesOfAppDetectWebViewType(crashesOfAppLink!);
      crashesOfAppSharedPreferences.setInt(
        crashesOfAppWebViewTypeKey,
        crashesOfAppWebViewType,
      );
    }

    if (crashesOfAppLink != null &&
        crashesOfAppLink!.isNotEmpty &&
        !sentAnalytics) {
      CrashesOfAppService().navigateToWebView(context);
    } else if (sentAnalytics) {
      await CrashesOfAppService().navigateToStandardApp(context);
    } else {
      await crashesOfAppInitializeMainPart();
    }
  }

  Future<void> crashesOfAppInitializeMainPart() async {
    final attRequest = CrashesOfAppService().requestTrackingPermission();
    final oneSignalInit = CrashesOfAppService().initializeOneSignal();

    await attRequest;
    await crashesOfAppTakeParams();
    await oneSignalInit;
  }

  int crashesOfAppDetectWebViewType(String link) {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;
      return int.tryParse(params['wtype'] ?? '') ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> crashesOfAppCreateLink() async {
    final Map<dynamic, dynamic> parameters = crashesOfAppConversionData;

    parameters.addAll({
      "tracking_status": crashesOfAppTrackingPermissionStatus,
      "${crashesOfAppKeyword}_id": crashesOfAppAdvertisingId,
      "external_id": crashesOfAppExternalId,
      "appsflyer_id": crashesOfAppAppsflyerId,
    });

    final String? link =
        await CrashesOfAppService().sendCrashesOfAppRequest(parameters);

    crashesOfAppLink = link;

    if (crashesOfAppLink == null || crashesOfAppLink!.isEmpty) {
      await CrashesOfAppService().navigateToStandardApp(context);
    } else {
      crashesOfAppWebViewType =
          crashesOfAppDetectWebViewType(crashesOfAppLink!);
      crashesOfAppSharedPreferences.setInt(
        crashesOfAppWebViewTypeKey,
        crashesOfAppWebViewType,
      );
      crashesOfAppSharedPreferences.setString(
        crashesOfAppLinkKey,
        crashesOfAppLink!,
      );
      crashesOfAppSharedPreferences.setBool(crashesOfAppSuccessKey, true);
      CrashesOfAppService().navigateToWebView(context);
    }
  }

  Future<void> crashesOfAppTakeParams() async {
    final appsFlyerOptions = CrashesOfAppService().createAppsFlyerOptions();
    final AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    crashesOfAppAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();

    appsFlyerSdk.onInstallConversionData((res) async {
      if (crashesOfAppConversionHandled) {
        return;
      }
      crashesOfAppConversionHandled = true;
      crashesOfAppConversionData = res;
      await crashesOfAppCreateLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        CrashesOfAppService().navigateToStandardApp(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CrashesOfAppSplash();
  }
}
