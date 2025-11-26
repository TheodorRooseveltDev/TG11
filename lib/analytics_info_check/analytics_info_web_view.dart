import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_consent_prompt.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_service.dart';
import 'package:bingo_clash/crash_esof_app/crash_esof_app_splash.dart';

class CrashEsofAppWebViewWidget extends StatefulWidget {
  const CrashEsofAppWebViewWidget({super.key});

  @override
  State<CrashEsofAppWebViewWidget> createState() =>
      _CrashEsofAppWebViewWidgetState();
}

class _CrashEsofAppWebViewWidgetState extends State<CrashEsofAppWebViewWidget>
    with WidgetsBindingObserver {
  late InAppWebViewController crashEsofAppWebViewController;

  bool crashEsofAppShowLoading = true;
  bool crashEsofAppShowConsentPrompt = false;

  bool crashEsofAppWasOpenNotification =
      crashEsofAppSharedPreferences.getBool("wasOpenNotification") ?? false;

  final bool savePermission =
      crashEsofAppSharedPreferences.getBool("savePermission") ?? false;

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
      crashEsofAppSharedPreferences.setBool("wasOpenNotification", true);
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
                      onCreateWindow:
                          (
                            controller,
                            CreateWindowAction createWindowRequest,
                          ) async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                final dialogSize = MediaQuery.of(
                                  dialogContext,
                                ).size;

                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        width: dialogSize.width,
                                        height: dialogSize.height * 0.8,
                                        child: InAppWebView(
                                          windowId:
                                              createWindowRequest.windowId,
                                          initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: true,
                                          ),
                                          onCloseWindow: (controller) {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: -18,
                                        right: -18,
                                        child: Material(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            return true;
                          },
                      initialUrlRequest: URLRequest(
                        url: WebUri(crashEsofAppLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportMultipleWindows: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      ),
                      onWebViewCreated: (controller) {
                        crashEsofAppWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        crashEsofAppShowLoading = false;
                        setState(() {});
                        if (crashEsofAppWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await CrashEsofAppService()
                                .isSystemPermissionGranted();

                        await Future.delayed(Duration(milliseconds: 3000));

                        if (systemNotificationsEnabled) {
                          crashEsofAppSharedPreferences.setBool(
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
                            await CrashEsofAppService()
                                .isSystemPermissionGranted();

                        if (systemNotificationsEnabled) {
                          crashEsofAppSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                        } else {
                          crashEsofAppSharedPreferences.setBool(
                            "savePermission",
                            true,
                          );
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
