import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'crashes_of_app.dart';
import 'crashes_of_app_parameters.dart';
import 'crashes_of_app_service.dart';
import 'crashes_of_app_splash.dart';

class CrashesOfAppWebViewTwo extends StatefulWidget {
  const CrashesOfAppWebViewTwo({super.key, required this.link});

  final String link;

  @override
  State<CrashesOfAppWebViewTwo> createState() => _CrashesOfAppWebViewTwoState();
}

class _CrashesOfAppWebViewTwoState extends State<CrashesOfAppWebViewTwo>
    with WidgetsBindingObserver {
  late _CrashesOfAppChromeSafariBrowser _browser;
  bool showLoading = true;
  bool wasOpenNotification =
      crashesOfAppSharedPreferences.getBool(
            crashesOfAppWasOpenNotificationKey,
          ) ??
          false;
  bool savePermission = crashesOfAppSharedPreferences.getBool(
        crashesOfAppSavePermissionKey,
      ) ??
      false;
  bool _isOpening = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _browser = _CrashesOfAppChromeSafariBrowser(
      onClosedCallback: _handleBrowserClosed,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openBrowser();
    });
  }

  Future<void> _openBrowser() async {
    if (_isOpening || _disposed) return;
    _isOpening = true;
    try {
      await _browser.open(
        url: WebUri(widget.link),
        settings: ChromeSafariBrowserSettings(
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
        ),
      );
      showLoading = false;
      if (mounted) setState(() {});
      if (!wasOpenNotification) {
        await Future.delayed(const Duration(seconds: 3));
        await _handlePushPermissionFlow();
      }
    } finally {
      _isOpening = false;
    }
  }

  void _handleBrowserClosed() {
    if (_disposed) return;
    _openBrowser();
  }

  Future<void> _handlePushPermissionFlow() async {
    final bool systemNotificationsEnabled =
        await CrashesOfAppService().isSystemPermissionGranted();

    if (systemNotificationsEnabled) {
      crashesOfAppSharedPreferences.setBool(
          crashesOfAppWasOpenNotificationKey, true);
      wasOpenNotification = true;
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, false);
      savePermission = false;
      CrashesOfAppService().sendRequestToBackend();
      CrashesOfAppService().notifyOneSignalAccepted();
      return;
    }

    await CrashesOfAppService().requestPermissionOneSignal();

    final bool systemNotificationsEnabledAfter =
        await CrashesOfAppService().isSystemPermissionGranted();

    if (systemNotificationsEnabledAfter) {
      crashesOfAppSharedPreferences.setBool(
          crashesOfAppWasOpenNotificationKey, true);
      wasOpenNotification = true;
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, false);
      savePermission = false;
      CrashesOfAppService().sendRequestToBackend();
      CrashesOfAppService().notifyOneSignalAccepted();
    } else {
      crashesOfAppSharedPreferences.setBool(crashesOfAppSavePermissionKey, true);
      savePermission = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CrashesOfAppSplash(),
        if (showLoading)
          const Positioned.fill(
            child: ColoredBox(color: Colors.transparent),
          ),
      ],
    );
  }
}

class _CrashesOfAppChromeSafariBrowser extends ChromeSafariBrowser {
  _CrashesOfAppChromeSafariBrowser({required this.onClosedCallback});

  final VoidCallback onClosedCallback;

  @override
  void onOpened() {
  }

  @override
  void onClosed() {
    onClosedCallback();
  }
}
