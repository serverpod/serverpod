import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../downloads/resource_manager.dart';
import '../generated/version.dart';
import '../util/constants.dart';

const _projectToken = '05e8ab306c393c7482e0f41851a176d8';
const _endpoint = 'https://api.mixpanel.com/track';

class Analytics {
  void track({
    required String event,
  }) {
    var payload = jsonEncode({
      'event': event,
      'properties': {
        'distinct_id': ResourceManager().uniqueUserId,
        'token': _projectToken,
        'platform': _getPlatform(),
        'dart_version': Platform.version,
        'version': templateVersion,
      }
    });

    _quietPost(payload);
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

  String _getPlatform() {
    if (isMacOs) {
      return 'MacOS';
    } else if (isWindows) {
      return 'Windows';
    } else if (isLinux) {
      return 'Linux';
    } else {
      return 'Unknown';
    }
  }

  void cleanUp() {}
}
