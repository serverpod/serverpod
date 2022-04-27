import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../downloads/resource_manager.dart';
import '../generated/version.dart';

const _projectToken = '05e8ab306c393c7482e0f41851a176d8';
const _endpoint = 'https://api.mixpanel.com/track';

class Analytics {
  Future<http.Response>? _futureResponse;

  void track({
    required String event,
  }) {
    assert(_futureResponse == null, 'Only one event can be tracked');

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

    _futureResponse = http.post(
      Uri.parse(_endpoint),
      body: 'data=$payload',
      headers: {
        'Accept': 'text/plain',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
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

  void cleanUp() {
    _futureResponse?.timeout(
      const Duration(seconds: 1),
      onTimeout: () => http.Response('Timed out', 408),
    );
  }
}
