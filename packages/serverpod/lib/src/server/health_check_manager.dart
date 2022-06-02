import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/health_check.dart';

/// Performs health checks on the server once a minute, typically this class
/// is managed internally by Serverpod. Writes results to the database.
/// The [HealthCheckManager] is also responsible for periodically read and update
/// the server configuration.
class HealthCheckManager {
  final Serverpod _pod;
  bool _running = false;
  Timer? _timer;

  /// Creates a new [HealthCheckManager].
  HealthCheckManager(this._pod) {
    _pod.registerFutureCall(_HealthCheckFutureCall(), 'serverpod_health_check');
  }

  /// Starts the health check manager.
  void start() {
    _running = true;
    _scheduleNextCheck();
  }

  /// Stops the health check manager.
  void stop() {
    _running = false;
    _timer?.cancel();
  }

  void _performHealthCheck() async {
    var session = await _pod.createSession();

    try {
      var result = await performHealthChecks(_pod);

      for (var metric in result.metrics) {
        await ServerHealthMetric.insert(session, metric);
      }

      for (var connectionInfo in result.connectionInfos) {
        await ServerHealthConnectionInfo.insert(session, connectionInfo);
      }
    } catch (e, stackTrace) {
      stderr.writeln('Exception in health check: $e');
      stderr.write(stackTrace);
    }

    await session.close(logSession: false);

    await _pod.reloadRuntimeSettings();

    _scheduleNextCheck();
  }

  void _scheduleNextCheck() {
    _timer?.cancel();
    if (!_running) {
      return;
    }
    _timer = Timer(_timeUntilNextMinute(), _performHealthCheck);
  }
}

class _HealthCheckFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableEntity? object) async {}
}

Duration _timeUntilNextMinute() {
  // Add a second to make sure we don't end up on the same minute.
  var now = DateTime.now().toUtc().add(const Duration(seconds: 1));
  var next =
      DateTime.utc(now.year, now.month, now.day, now.hour, now.minute).add(
    const Duration(minutes: 1),
  );

  return next.difference(now);
}
