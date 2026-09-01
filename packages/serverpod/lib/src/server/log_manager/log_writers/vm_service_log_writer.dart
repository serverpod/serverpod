import 'dart:developer' as developer;

import 'package:serverpod_shared/log.dart';

/// Posts structured log events via the VM service extension
/// [serverpodLogEvent], so CLI clients can subscribe via
/// `vmService.onExtensionEvent` and render them. In production where
/// the VM service is disabled, [developer.postEvent] is a no-op.
///
/// [encodeLogEntry] and [decodeLogEntry] in `serverpod_shared` are the two
/// ends of the encoding. [developer.postEvent] is a no-op where the VM
/// service is disabled.
class VmServiceLogWriter extends LogWriter {
  @override
  Future<void> log(LogEntry entry) async => _postEvent(encodeLogEntry(entry));

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
    developer.postEvent(serverpodLogEvent, data);
  }
}
