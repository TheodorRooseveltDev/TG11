import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';

/// Thin wrapper around Meta App Events.
class MetaEventsService {
  MetaEventsService._();

  static final FacebookAppEvents _fbAppEvents = FacebookAppEvents();

  /// Enable advertiser tracking on iOS to allow events to be sent.
  static Future<void> initialize() async {
    if (!Platform.isIOS) return;
    try {
      await _fbAppEvents.setAdvertiserTracking(enabled: true);
    } catch (_) {}
  }

  /// Log a simple app launch event.
  static Future<void> logAppLaunch() async {
    try {
      await _fbAppEvents.logEvent(name: 'app_launch');
    } catch (_) {}
  }
}
