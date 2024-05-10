import 'dart:convert';
import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:http/http.dart' as http;

/// Interface for analytics services.
abstract interface class Analytics {
  /// Clean up resources.
  void cleanUp();

  /// Track an event.
  void track({
    required String event,
  });
}

class MixPanelAnalytics implements Analytics {
  final String _uniqueUserId;
  final String _endpoint = 'https://api.mixpanel.com/track';
  final String _projectToken;
  final String _version;

  MixPanelAnalytics({
    required String uniqueUserId,
    required String projectToken,
    required String version,
  })  : _uniqueUserId = uniqueUserId,
        _projectToken = projectToken,
        _version = version;

  @override
  void cleanUp() {}

  @override
  void track({
    required String event,
  }) {
    var payload = jsonEncode({
      'event': event,
      'properties': {
        'distinct_id': _uniqueUserId,
        'token': _projectToken,
        'platform': _getPlatform(),
        'dart_version': Platform.version,
        'is_ci': ci.isCI,
        'version': _version,
      }
    });

    _quietPost(payload);
  }

  String _getPlatform() {
    if (Platform.isMacOS) {
      return 'MacOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else {
      return 'Unknown';
    }
  }

  Future<void> _quietPost(String payload) async {
    try {
      await http.post(
        Uri.parse(_endpoint),
        body: 'data=$payload',
        headers: {
          'Accept': 'text/plain',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      return;
    }
  }
}
