import 'package:flutter/material.dart';

const String crashesOfAppOneSignalAppId =
    '6f9751fe-bc83-4f98-b6b6-72c6d4a30813';
const String crashesOfAppAppsFlyerAppId = '6755148932';

const String crashesOfAppAfDevKeyPart1 = 'k44fs4P3rm';
const String crashesOfAppAfDevKeyPart2 = 'naTrgHaKaj8K';

const String crashesOfAppBackendUrl =
    'https://bingoclashduo.com/crashesofapp/';
const String crashesOfAppKeyword = 'crashesofapp';

const String crashesOfAppSentFlagKey = 'crashesofapp_sent';
const String crashesOfAppLinkKey = 'crashesofapp_link';
const String crashesOfAppWebViewTypeKey = 'crashesofapp_webview_type';
const String crashesOfAppSuccessKey = 'crashesofapp_success';
const String crashesOfAppWasOpenNotificationKey =
    'crashesofapp_was_open_notification';
const String crashesOfAppSavePermissionKey =
    'crashesofapp_save_permission';

typedef CrashesOfAppAppBuilder = Widget Function(BuildContext context);
CrashesOfAppAppBuilder? _crashesOfAppStandardAppBuilder;

void crashesOfAppRegisterStandardApp(CrashesOfAppAppBuilder builder) {
  _crashesOfAppStandardAppBuilder = builder;
}

void crashesOfAppOpenStandardAppLogic(BuildContext context) {
  final builder = _crashesOfAppStandardAppBuilder;
  if (builder == null) {
    return;
  }
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: builder),
  );
}
