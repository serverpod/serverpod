import 'dart:async';
import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:system_resources/system_resources.dart';

import '../../protocol.dart';
import '../../serverpod.dart';
import '../util/date_time_extension.dart';
import 'command_line_args.dart';
import 'health_check.dart';

/// Performs health checks on the server once a minute, typically this class
/// is managed internally by Serverpod. Writes results to the database.
/// The [HealthCheckManager] is also responsible for periodically read and 
/// update the server configuration.
class HealthCheckManager {
  final Serverpod _pod;

  /// Called when health checks have been completed, if the server is
  /// running in [ServerpodRole.maintenance] mode.
  final VoidCallback onCompleted;

  bool _running = false;
  Timer? _timer;

  /// Creates a new [HealthCheckManager].
  HealthCheckManager(this._pod, this.onCompleted);

  /// Starts the health check manager.
  Future<void> start() async {
    _running = true;
    try {
      await SystemResources.init();
    } catch (e) {
      stderr.writeln(
        'CPU and memory usage metrics are not supported on this platform.',
      );
    }
    _scheduleNextCheck();
  }

  /// Stops the health check manager.
  void stop() {
    _running = false;
    _timer?.cancel();
  }

  Future<void> _performHealthCheck() async {
    if (_pod.commandLineArgs.role == ServerpodRole.maintenance) {
      stdout.writeln('Performing health checks.');
    }

    final session = await _pod.createSession(enableLogging: false);
    var numHealthChecks = 0;

    try {
      final result = await performHealthChecks(_pod);
      numHealthChecks = result.metrics.length;

      for (final metric in result.metrics) {
        await ServerHealthMetric.insert(session, metric);
      }

      for (final connectionInfo in result.connectionInfos) {
        await ServerHealthConnectionInfo.insert(session, connectionInfo);
      }
    } catch (e) {
      // TODO: Sometimes serverpod attempts to write duplicate health checks for
      // the same time. Doesn't cause any harm, but would be nice to fix.
    }

    await session.close();

    await _pod.reloadRuntimeSettings();

    await _cleanUpClosedSessions();

    await _optimizeHealthCheckData(numHealthChecks);

    // If we are running in maintenance mode, we don't want to schedule the next
    // health check, as it should only be run once.
    if (_pod.commandLineArgs.role == ServerpodRole.monolith) {
      _scheduleNextCheck();
    } else if (_pod.commandLineArgs.role == ServerpodRole.maintenance) {
      onCompleted();
    }
  }

  void _scheduleNextCheck() {
    _timer?.cancel();
    if (!_running) {
      return;
    }
    _timer = Timer(_timeUntilNextMinute(), _performHealthCheck);
  }

  Future<void> _cleanUpClosedSessions() async {
    final session = await _pod.createSession(enableLogging: false);

    try {
      final encoder = DatabasePoolManager.encoder;

      final now = encoder.convert(DateTime.now().toUtc());
      final threeMinutesAgo = encoder.convert(
        DateTime.now().subtract(const Duration(minutes: 3)).toUtc(),
      );
      final serverStartTime = encoder.convert(_pod.startedTime);
      final serverId = encoder.convert(_pod.serverId);

      // Touch all sessions that have been opened by this server.
      final touchQuery =
          'UPDATE serverpod_session_log SET touched = $now '
          'WHERE "serverId" = $serverId '
          'AND "isOpen" = TRUE AND "time" > $serverStartTime';
      await session.db.query(touchQuery);

      // Close sessions that haven't been touched in 3 minutes.
      final closeQuery =
          'UPDATE serverpod_session_log '
          'SET "isOpen" = FALSE '
          'WHERE "isOpen" = TRUE AND "touched" < $threeMinutesAgo';
      await session.db.query(closeQuery);
    } catch (e, stackTrace) {
      stderr
        ..writeln('Failed to cleanup closed sessions: $e')
        ..write('$stackTrace');
    }
    await session.close();
  }

  Future<void> _optimizeHealthCheckData(int numHealthChecks) async {
    final session = await _pod.createSession(enableLogging: false);
    try {
      // Optimize connection info entries.
      var didOptimizeMinutes = await _optimizeConnectionInfoEntries(
        session,
        1,
        const Duration(hours: 48),
      );
      if (!didOptimizeMinutes) {
        // All minutes are packed into hours, we can safely pack hours into
        // days.
        await _optimizeConnectionInfoEntries(
          session,
          60,
          const Duration(days: 31),
        );
      }

      // Optimize health checks.
      didOptimizeMinutes = await _optimizeHealthCheckEntries(
        session,
        1,
        const Duration(hours: 48),
        numHealthChecks,
      );
      if (!didOptimizeMinutes) {
        // All minutes are packed into hours, we can safely pack
        // hours into days.
        await _optimizeHealthCheckEntries(
          session,
          60,
          const Duration(days: 31),
          numHealthChecks,
        );
      }
    } catch (e, stackTrace) {
      await session.close(error: e, stackTrace: stackTrace);
      return;
    }
    await session.close();
  }

  Future<bool> _optimizeConnectionInfoEntries(
    Session session,
    int srcGranularity,
    Duration preserveDelay,
  ) async {
    final now = DateTime.now().toUtc();
    final startTime = DateTime.utc(
      now.year,
      now.month,
      now.day,
      srcGranularity == 1 ? now.hour : 0,
    ).subtract(preserveDelay);

    // Select entries from a past hour or day.
    final entries = await ServerHealthConnectionInfo.find(
      session,
      where: (t) =>
          (t.timestamp < startTime) &
          t.granularity.equals(srcGranularity) &
          t.serverId.equals(_pod.serverId),
      orderBy: ServerHealthConnectionInfo.t.timestamp,
      orderDescending: true,
      limit: srcGranularity == 1 ? 61 : 25,
    );

    if (entries.isEmpty) {
      // There is nothing here to optimize.
      return false;
    }
    final firstEntryTime = srcGranularity == 1
        ? entries.first.timestamp.asHour
        : entries.first.timestamp.asDay;

    // There is stuff to optimize.
    var maxActive = 0;
    var maxIdle = 0;
    var maxClosing = 0;

    for (final entry in entries) {
      if ((srcGranularity == 1 && firstEntryTime.isSameHour(entry.timestamp)) ||
          (srcGranularity == 60 && firstEntryTime.isSameDay(entry.timestamp))) {
        if (entry.active > maxActive) maxActive = entry.active;
        if (entry.idle > maxIdle) maxIdle = entry.idle;
        if (entry.closing > maxClosing) maxClosing = entry.closing;
      }
    }

    // Write new, compressed entry.
    final hourlyInfo = ServerHealthConnectionInfo(
      serverId: _pod.serverId,
      timestamp: firstEntryTime,
      active: maxActive,
      closing: maxClosing,
      idle: maxIdle,
      granularity: srcGranularity == 1 ? 60 : 60 * 24,
    );
    try {
      await ServerHealthConnectionInfo.insert(session, hourlyInfo);
    } catch (e) {
      // Ignore failed inserts.
    }

    // Remove old entries.
    await ServerHealthConnectionInfo.delete(
      session,
      where: (t) =>
          (t.timestamp >= firstEntryTime) &
          (t.timestamp <
              firstEntryTime.add(
                srcGranularity == 1
                    ? const Duration(hours: 1)
                    : const Duration(days: 1),
              )) &
          t.granularity.equals(srcGranularity) &
          t.serverId.equals(_pod.serverId),
    );

    // All done.
    return true;
  }

  Future<bool> _optimizeHealthCheckEntries(
    Session session,
    int srcGranularity,
    Duration preserveDelay,
    int numHealthChecks,
  ) async {
    if (numHealthChecks == 0) {
      return false;
    }

    final now = DateTime.now().toUtc();
    final startTime = DateTime.utc(
      now.year,
      now.month,
      now.day,
      srcGranularity == 1 ? now.hour : 0,
    ).subtract(preserveDelay);

    // Select entries from a past hour or day.
    final entries = await ServerHealthMetric.find(
      session,
      where: (t) =>
          (t.timestamp < startTime) &
          t.granularity.equals(srcGranularity) &
          t.serverId.equals(_pod.serverId),
      orderBy: ServerHealthMetric.t.timestamp,
      orderDescending: true,
      limit: (srcGranularity == 1 ? 61 : 25) * numHealthChecks,
    );

    if (entries.isEmpty) {
      // There is nothing here to optimize.
      return false;
    }

    // There is stuff to optimize.
    final firstEntryTime = srcGranularity == 1
        ? entries.first.timestamp.asHour
        : entries.first.timestamp.asDay;

    // Sort entries by their name/type.
    final entryMap = <String, List<ServerHealthMetric>>{};
    for (final entry in entries) {
      if (entryMap.containsKey(entry.name)) {
        entryMap[entry.name]!.add(entry);
      } else {
        entryMap[entry.name] = [entry];
      }
    }

    for (final entryName in entryMap.keys) {
      var numEntries = 0;
      var totalValue = 0.0;
      var hasFail = false;

      for (final entry in entryMap[entryName]!) {
        if ((srcGranularity == 1 &&
                firstEntryTime.isSameHour(entry.timestamp)) ||
            (srcGranularity == 60 &&
                firstEntryTime.isSameDay(entry.timestamp))) {
          if (!entry.isHealthy) hasFail = true;
          totalValue += entry.value;
        }
        numEntries++;
      }

      // Write new, compressed entry.
      final compressedEntry = ServerHealthMetric(
        serverId: _pod.serverId,
        name: entryName,
        timestamp: firstEntryTime,
        value: totalValue / numEntries,
        isHealthy: !hasFail,
        granularity: srcGranularity == 1 ? 60 : 60 * 24,
      );
      try {
        await ServerHealthMetric.insert(session, compressedEntry);
      } catch (e) {
        // Ignore failed inserts.
      }
    }

    // Remove old entries.
    await ServerHealthMetric.delete(
      session,
      where: (t) =>
          (t.timestamp >= firstEntryTime) &
          (t.timestamp <
              firstEntryTime.add(
                srcGranularity == 1
                    ? const Duration(hours: 1)
                    : const Duration(days: 1),
              )) &
          t.granularity.equals(srcGranularity) &
          t.serverId.equals(_pod.serverId),
    );

    return true;
  }
}

Duration _timeUntilNextMinute() {
  // Add a second to make sure we don't end up on the same minute.
  final now = DateTime.now().toUtc().add(const Duration(seconds: 2));
  final next =
      DateTime.utc(now.year, now.month, now.day, now.hour, now.minute).add(
    const Duration(minutes: 1),
  );

  return next.difference(now);
}
