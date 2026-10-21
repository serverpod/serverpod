import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Checks that pub.dev is reachable, which installing packages and the CLI
/// itself depend on.
class NetworkCheck {
  static const id = 'network';

  static final _url = Uri.https('pub.dev', '/api/packages/serverpod_cli');

  /// [client] and [timeout] stand in for the real network in tests.
  static Future<DoctorCheckResult> probe({
    final http.Client? client,
    final Duration timeout = const Duration(seconds: 5),
  }) async {
    final owned = client == null;
    final http = client ?? _newClient();
    try {
      final response = await http.head(_url).timeout(timeout);
      return evaluate(reachable: response.statusCode < 500);
    } catch (e) {
      log.debug('Could not reach $_url: $e');
      return evaluate(reachable: false);
    } finally {
      if (owned) http.close();
    }
  }

  static http.Client _newClient() => http.Client();

  static DoctorCheckResult evaluate({required final bool reachable}) {
    const title = 'Network';

    if (!reachable) {
      return DoctorCheckResult(
        id: id,
        title: title,
        status: DoctorStatus.missing,
        message: 'Could not reach ${_url.host}.',
        remedy: 'Check your internet connection, proxy, and firewall settings.',
      );
    }

    return DoctorCheckResult(
      id: id,
      title: title,
      status: DoctorStatus.ready,
      message: '${_url.host} is reachable.',
    );
  }
}
