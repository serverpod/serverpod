import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:synchronized/synchronized.dart';

@internal
class LogCleanupManager {
  final Database _database;
  final SessionLogConfig _config;
  final Lock _cleanupLock = Lock();
  DateTime? _lastCleanupTime;

  LogCleanupManager({
    required Database database,
    required SessionLogConfig config,
  })  : _database = database,
        _config = config;

  Future<void> maybePerformCleanup() async {
    if (_config.cleanupIntervalHours == null) {
      return;
    }

    final now = DateTime.now();
    final lastCleanup = _lastCleanupTime;

    if (lastCleanup != null) {
      final timeSinceLastCleanup = now.difference(lastCleanup);
      final cleanupInterval =
          Duration(hours: _config.cleanupIntervalHours!);

      if (timeSinceLastCleanup < cleanupInterval) {
        return;
      }
    }

    unawaited(_performCleanupWithLock());
  }

  Future<void> _performCleanupWithLock() async {
    await _cleanupLock.synchronized(() async {
      final now = DateTime.now();
      final lastCleanup = _lastCleanupTime;

      if (lastCleanup != null) {
        final timeSinceLastCleanup = now.difference(lastCleanup);
        final cleanupInterval =
            Duration(hours: _config.cleanupIntervalHours!);

        if (timeSinceLastCleanup < cleanupInterval) {
          return;
        }
      }

      try {
        await _performCleanup();
        _lastCleanupTime = DateTime.now();
      } catch (e, stackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO CLEAN UP LOGS');
        stderr.writeln('ERROR: $e');
        stderr.writeln('$stackTrace');
      }
    });
  }

  Future<void> _performCleanup() async {
    final tables = [
      'serverpod_session_log',
      'serverpod_log',
      'serverpod_query_log',
    ];

    for (final table in tables) {
      await _cleanupTable(table);
    }
  }

  Future<void> _cleanupTable(String tableName) async {
    int totalDeleted = 0;

    if (_config.retentionPeriodDays != null) {
      final timeDeleted = await _performTimeBasedCleanup(tableName);
      totalDeleted += timeDeleted;
    }

    if (_config.retentionCount != null) {
      final countDeleted = await _performCountBasedCleanup(tableName);
      totalDeleted += countDeleted;
    }

    if (totalDeleted > 0) {
      stderr.writeln(
        '${DateTime.now().toUtc()} Cleaned up $totalDeleted log entries from $tableName',
      );
    }
  }

  Future<int> _performTimeBasedCleanup(String tableName) async {
    final retentionDays = _config.retentionPeriodDays!;
    final cutoffTime =
        DateTime.now().subtract(Duration(days: retentionDays));

    if (tableName == 'serverpod_session_log') {
      final result = await _database.unsafeExecute(
        'DELETE FROM serverpod_session_log WHERE time < @cutoffTime',
        parameters: QueryParameters.named({'cutoffTime': cutoffTime}),
      );
      return result;
    } else {
      final result = await _database.unsafeExecute(
        'DELETE FROM $tableName WHERE sessionLogId IN (SELECT id FROM serverpod_session_log WHERE time < @cutoffTime)',
        parameters: QueryParameters.named({'cutoffTime': cutoffTime}),
      );
      return result;
    }
  }

  Future<int> _performCountBasedCleanup(String tableName) async {
    final maxCount = _config.retentionCount!;

    if (tableName == 'serverpod_session_log') {
      final result = await _database.unsafeExecute(
        '''
        DELETE FROM serverpod_session_log 
        WHERE id < (
          SELECT id FROM serverpod_session_log 
          ORDER BY id DESC 
          OFFSET @maxCount LIMIT 1
        )
        ''',
        parameters: QueryParameters.named({'maxCount': maxCount}),
      );

      return result;
    } else {
      final result = await _database.unsafeExecute(
        '''
        DELETE FROM $tableName 
        WHERE sessionLogId IN (
          SELECT id FROM serverpod_session_log 
          WHERE id < (
            SELECT id FROM serverpod_session_log 
            ORDER BY id DESC 
            OFFSET @maxCount LIMIT 1
          )
        )
        ''',
        parameters: QueryParameters.named({'maxCount': maxCount}),
      );

      return result;
    }
  }
}
