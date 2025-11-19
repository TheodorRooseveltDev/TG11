import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_consent_prompt.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_splash.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_check.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({super.key});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget>
    with WidgetsBindingObserver {
  late InAppWebViewController crashEsofAppWebViewController;

  bool crashEsofAppShowLoading = true;
  bool crashEsofAppShowConsentPrompt = false;

  bool crashEsofAppWasOpenNotification =
      aSharedPreferences.getBool("wasOpenNotification") ?? false;

  final bool savePermission =
      aSharedPreferences.getBool("savePermission") ?? false;

  bool waitingForSettingsReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (waitingForSettingsReturn) {
        waitingForSettingsReturn = false;
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) {
            crashEsofAppAfterSetting();
          }
        });
      }
    }
  }

  Future<void> crashEsofAppAfterSetting() async {
    final deviceState = OneSignal.User.pushSubscription;

    bool havePermission = deviceState.optedIn ?? false;
    final bool systemNotificationsEnabled = await CrashEsofAppService()
        .isSystemPermissionGranted();

    if (havePermission || systemNotificationsEnabled) {
      aSharedPreferences.setBool("wasOpenNotification", true);
      crashEsofAppWasOpenNotification = true;
      CrashEsofAppService().crashEsofAppSendRequiestToBack();
    }

    crashEsofAppShowConsentPrompt = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: crashEsofAppShowLoading ? 0 : 1,

          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(analyticsLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                      ),
                      onWebViewCreated: (controller) {
                        crashEsofAppWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        crashEsofAppShowLoading = false;
                        setState(() {});
                        if (crashEsofAppWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await CrashEsofAppService().isSystemPermissionGranted();

                        await Future.delayed(Duration(milliseconds: 3000));

                        if (systemNotificationsEnabled) {
                          aSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                          crashEsofAppWasOpenNotification = true;
                        }

                        if (!systemNotificationsEnabled) {
                          crashEsofAppShowConsentPrompt = true;
                          crashEsofAppWasOpenNotification = true;
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return crashEsofAppBuildWebBottomBar(orientation);
              },
            ),
          ),
        ),
        if (crashEsofAppShowLoading) const CrashEsofAppSplash(),
        if (!crashEsofAppShowLoading)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            reverseDuration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: crashEsofAppShowConsentPrompt
                ? CrashEsofAppConsentPromptPage(
                    key: const ValueKey('consent_prompt'),
                    onYes: () async {
                      if (savePermission == true) {
                        waitingForSettingsReturn = true;
                        await AppSettings.openAppSettings(
                          type: AppSettingsType.settings,
                        );
                      } else {
                        await CrashEsofAppService()
                            .crashEsofAppRequestPermissionOneSignal();

                        final bool systemNotificationsEnabled =
                            await CrashEsofAppService().isSystemPermissionGranted();

                        if (systemNotificationsEnabled) {
                          aSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                        } else {
                          aSharedPreferences.setBool("savePermission", true);
                        }
                        crashEsofAppWasOpenNotification = true;
                        crashEsofAppShowConsentPrompt = false;
                        setState(() {});
                      }
                    },
                    onNo: () {
                      setState(() {
                        crashEsofAppWasOpenNotification = true;
                        crashEsofAppShowConsentPrompt = false;
                      });
                    },
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
      ],
    );
  }

  Widget crashEsofAppBuildWebBottomBar(Orientation orientation) {
    return Container(
      color: Colors.black,
      height: orientation == Orientation.portrait ? 25 : 30,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await crashEsofAppWebViewController.canGoBack()) {
                crashEsofAppWebViewController.goBack();
              }
            },
          ),
          const SizedBox.shrink(),
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await crashEsofAppWebViewController.canGoForward()) {
                crashEsofAppWebViewController.goForward();
              }
            },
          ),
        ],
      ),
    );
  }
}

