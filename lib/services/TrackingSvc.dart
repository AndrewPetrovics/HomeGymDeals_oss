import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:flutter/foundation.dart';

late Mixpanel mixpanel;
FirebaseAnalytics fbAnalytics = FirebaseAnalytics.instance;

class TrackingSvc {
  static Future<void> init() async {
    if (!kDebugMode) {
      mixpanel = await Mixpanel.init("", optOutTrackingDefault: false, trackAutomaticEvents: true);
    }
  }

  static void track(String eventName, Map<String, dynamic>? properties) {
    if (!kDebugMode) {
      mixpanel.track(eventName, properties: properties);
      fbAnalytics.logEvent(name: eventName, parameters: properties);
    }
  }
}

enum TrackingEvents {
  equipmentAdded,
}
