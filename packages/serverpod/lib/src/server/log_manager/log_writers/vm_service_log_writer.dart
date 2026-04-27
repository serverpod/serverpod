import 'dart:developer' as developer;

import 'package:serverpod_shared/log.dart';

/// Posts structured log events via the VM service extension
/// `ext.serverpod.log`, so CLI clients can subscribe via
/// `vmService.onExtensionEvent` and render them. In production where
/// the VM service is disabled, [developer.postEvent] is a no-op.
class VmServiceLogWriter extends LogWriter {
  @override
  Future<void> log(LogEntry entry) async {
    _postEvent({
      'type': 'log',
      'level': entry.level.name,
      'message': entry.message,
      'scopeId': entry.scope.id,
      'timestamp': entry.time.toUtc().toIso8601String(),
      'error': entry.error?.toString(),
      'stackTrace': entry.stackTrace?.toString(),
    });
  }

  @override
  Future<void> openScope(LogScope scope) async {
    _postEvent({
      'type': 'scope_start',
      'id': scope.id,
      'label': scope.label,
      'parentId': scope.parent?.id,
      'timestamp': scope.startTime.toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    _postEvent({
      'type': 'scope_end',
      'id': scope.id,
      'success': success,
      'duration': duration.inMicroseconds / 1000000,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  static void _postEvent(Map<String, Object?> data) {
    data.removeWhere((_, v) => v == null);
    developer.postEvent('ext.serverpod.log', data);
  }
}
