import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'crashes_of_app.dart';
import 'crashes_of_app_parameters.dart';
import 'crashes_of_app_service.dart';
import 'crashes_of_app_splash.dart';

class CrashesOfAppWebViewWidget extends StatefulWidget {
  const CrashesOfAppWebViewWidget({super.key});

  @override
  State<CrashesOfAppWebViewWidget> createState() =>
      _CrashesOfAppWebViewWidgetState();
}

class _CrashesOfAppWebViewWidgetState extends State<CrashesOfAppWebViewWidget>
    with WidgetsBindingObserver {
  InAppWebViewController? crashesOfAppWebViewController;

  bool crashesOfAppShowLoading = true;

  bool crashesOfAppWasOpenNotification =
      crashesOfAppSharedPreferences.getBool(
            crashesOfAppWasOpenNotificationKey,
          ) ??
          false;

  bool crashesOfAppSavePermission = crashesOfAppSharedPreferences.getBool(
        crashesOfAppSavePermissionKey,
      ) ??
      false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    crashesOfAppSyncNotificationState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  Future<void> crashesOfAppSyncNotificationState() async {
    final bool systemNotificationsEnabled =
        await CrashesOfAppService().isSystemPermissionGranted();

    crashesOfAppWasOpenNotification = systemNotificationsEnabled;
    crashesOfAppSharedPreferences.setBool(
      crashesOfAppWasOpenNotificationKey,
      systemNotificationsEnabled,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> crashesOfAppAfterSetting() async {
    final deviceState = OneSignal.User.pushSubscription;

    bool havePermission = deviceState.optedIn ?? false;
    final bool systemNotificationsEnabled =
        await CrashesOfAppService().isSystemPermissionGranted();

    if (havePermission || systemNotificationsEnabled) {
      crashesOfAppSharedPreferences.setBool(
          crashesOfAppWasOpenNotificationKey, true);
      crashesOfAppWasOpenNotification = true;
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, false);
      crashesOfAppSavePermission = false;
      CrashesOfAppService().sendRequestToBackend();
    }

    setState(() {});
  }

  Future<void> crashesOfAppHandlePushPermissionFlow() async {
    await CrashesOfAppService().requestPermissionOneSignal();

    final bool systemNotificationsEnabled =
        await CrashesOfAppService().isSystemPermissionGranted();

    if (systemNotificationsEnabled) {
      crashesOfAppSharedPreferences.setBool(
          crashesOfAppWasOpenNotificationKey, true);
      crashesOfAppWasOpenNotification = true;
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, false);
      crashesOfAppSavePermission = false;
      CrashesOfAppService().sendRequestToBackend();
    } else {
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, true);
      crashesOfAppSavePermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: crashesOfAppShowLoading ? 0 : 1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      onCreateWindow: (controller,
                          CreateWindowAction createWindowRequest) async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => _CrashesOfAppPopupWebView(
                              windowId: createWindowRequest.windowId,
                              initialRequest: createWindowRequest.request,
                            ),
                          ),
                        );
                        return true;
                      },
                      initialUrlRequest: URLRequest(
                        url: WebUri(crashesOfAppLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportMultipleWindows: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        cacheEnabled: true,
                        clearCache: false,
                        cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                        useOnLoadResource: false,
                        useShouldInterceptAjaxRequest: false,
                        useShouldInterceptFetchRequest: false,
                        hardwareAcceleration: true,
                        thirdPartyCookiesEnabled: true,
                        sharedCookiesEnabled: true,
                        disallowOverScroll: true,
                      ),
                      onWebViewCreated: (controller) {
                        crashesOfAppWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        crashesOfAppShowLoading = false;
                        setState(() {});
                        if (crashesOfAppWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await CrashesOfAppService()
                                .isSystemPermissionGranted();

                        await Future.delayed(const Duration(seconds: 3));

                        if (systemNotificationsEnabled) {
                          crashesOfAppSharedPreferences.setBool(
                            crashesOfAppWasOpenNotificationKey,
                            true,
                          );
                          crashesOfAppWasOpenNotification = true;
                          CrashesOfAppService().sendRequestToBackend();
                          CrashesOfAppService().notifyOneSignalAccepted();
                        }

                        if (!systemNotificationsEnabled) {
                          crashesOfAppWasOpenNotification = true;
                          await crashesOfAppHandlePushPermissionFlow();
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
                return crashesOfAppBuildWebBottomBar(orientation);
              },
            ),
          ),
        ),
        if (crashesOfAppShowLoading) const CrashesOfAppSplash(),
      ],
    );
  }

  Widget crashesOfAppBuildWebBottomBar(Orientation orientation) {
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
              if (crashesOfAppWebViewController != null &&
                  await crashesOfAppWebViewController!.canGoBack()) {
                crashesOfAppWebViewController!.goBack();
              }
            },
          ),
          const SizedBox.shrink(),
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (crashesOfAppWebViewController != null &&
                  await crashesOfAppWebViewController!.canGoForward()) {
                crashesOfAppWebViewController!.goForward();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CrashesOfAppPopupWebView extends StatelessWidget {
  const _CrashesOfAppPopupWebView({
    required this.windowId,
    required this.initialRequest,
  });

  final int? windowId;
  final URLRequest? initialRequest;

  @override
  Widget build(BuildContext context) {
    return _CrashesOfAppPopupWebViewBody(
      windowId: windowId,
      initialRequest: initialRequest,
    );
  }
}

class _CrashesOfAppPopupWebViewBody extends StatefulWidget {
  const _CrashesOfAppPopupWebViewBody({
    required this.windowId,
    required this.initialRequest,
  });

  final int? windowId;
  final URLRequest? initialRequest;

  @override
  State<_CrashesOfAppPopupWebViewBody> createState() =>
      _CrashesOfAppPopupWebViewBodyState();
}

class _CrashesOfAppPopupWebViewBodyState
    extends State<_CrashesOfAppPopupWebViewBody> {
  InAppWebViewController? popupController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        foregroundColor: Colors.white,
        toolbarHeight: 36,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: progress < 1 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: LinearProgressIndicator(
                value: progress < 1 ? progress : null,
                minHeight: 2,
                backgroundColor: Colors.white12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xff007AFF)),
              ),
            ),
            Expanded(
              child: InAppWebView(
                windowId: widget.windowId,
                initialUrlRequest: widget.initialRequest,
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  supportMultipleWindows: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  allowsInlineMediaPlayback: true,
                ),
                onWebViewCreated: (controller) {
                  popupController = controller;
                },
                onProgressChanged: (controller, newProgress) {
                  setState(() {
                    progress = newProgress / 100;
                  });
                },
                onLoadStop: (controller, uri) {
                  setState(() {
                    progress = 1;
                  });
                },
                onCloseWindow: (controller) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
