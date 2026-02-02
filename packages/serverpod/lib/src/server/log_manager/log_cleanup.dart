import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

@internal
class LogCleanupManager {
  final Duration? _cleanupInterval;
  final Duration? _retentionPeriod;
  final int? _retentionCount;

  LogCleanupManager({
    required Database database,
    required SessionLogConfig config,
  }) : _cleanupInterval = config.cleanupInterval,
       _retentionPeriod = config.retentionPeriod,
       _retentionCount = config.retentionCount;

  DateTime? _lastCleanupTime;
  Future<void>? _activeCleanupTask;

  Duration? get _durationSinceLastCleanup {
    final lastCleanup = _lastCleanupTime;
    if (lastCleanup == null) return null;
    return DateTime.now().difference(lastCleanup);
  }

  bool get shouldPerformCleanup {
    final durationSinceLastCleanup = _durationSinceLastCleanup;
    if (durationSinceLastCleanup == null) return true;

    final cleanupInterval = _cleanupInterval;
    if (cleanupInterval == null) return false;

    return durationSinceLastCleanup < cleanupInterval;
  }

  Future<void> performCleanup(Session session) async {
    if (!shouldPerformCleanup) return;
    if (_activeCleanupTask != null) return;

    _activeCleanupTask = _performCleanup(session)
        .timeout(const Duration(hours: 1))
        .whenComplete(() {
          _lastCleanupTime = DateTime.now();
          _activeCleanupTask = null;
        })
        .catchError((error, stackTrace) {
          stdout.writeln(
            '${DateTime.now().toUtc()} FAILED TO CLEAN UP LOGS\n'
            'ERROR: $error\n'
            'STACK TRACE: $stackTrace',
          );
          _activeCleanupTask = null;
        });

    unawaited(_activeCleanupTask);
  }

  Future<void> _performCleanup(Session session) async {
    await _performTimeBasedCleanup(session);
    await _performCountBasedCleanup(session);
  }

  static final _sessionLogsTable = SessionLogEntry.t.tableName;

  Future<void> _performTimeBasedCleanup(Session session) async {
    final retentionPeriod = _retentionPeriod;
    if (retentionPeriod == null) return;

    final cutoffTime = DateTime.now().subtract(retentionPeriod);
    final deletedCount = await session.db.unsafeExecute(
      'DELETE FROM $_sessionLogsTable WHERE time < @cutoffTime',
      parameters: QueryParameters.named({'cutoffTime': cutoffTime}),
    );

    stdout.writeln(
      '${DateTime.now().toUtc()} Cleaned up $deletedCount log entries from '
      '"$_sessionLogsTable" older than $_retentionPeriod.',
    );
  }

  Future<void> _performCountBasedCleanup(Session session) async {
    final retentionCount = _retentionCount;
    if (retentionCount == null) return;

    final deletedCount = await session.db.unsafeExecute('''
      DELETE FROM $_sessionLogsTable
      WHERE id < (
        SELECT id
        FROM $_sessionLogsTable
        ORDER BY id DESC
        LIMIT 1
        OFFSET $retentionCount
      )
    ''');

    stdout.writeln(
      '${DateTime.now().toUtc()} Cleaned up $deletedCount log entries from '
      '"$_sessionLogsTable" exceeding the retention count of $retentionCount.',
    );
  }
}
