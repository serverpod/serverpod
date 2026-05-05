import 'package:meta/meta.dart';

import 'log_types.dart';

/// A completed scope record for test assertions.
class ClosedScope {
  /// Captures the arguments passed to [LogWriter.closeScope].
  ClosedScope({
    required this.scope,
    required this.success,
    required this.duration,
    this.error,
    this.stackTrace,
  });

  /// The scope that was closed.
  final LogScope scope;

  /// Whether the scope completed successfully.
  final bool success;

  /// How long the scope was open.
  final Duration duration;

  /// Optional error captured when the scope failed.
  final Object? error;

  /// Optional stack trace for [error].
  final StackTrace? stackTrace;
}

/// A [LogWriter] that collects entries and scopes for test assertions.
@visibleForTesting
class TestLogWriter extends LogWriter {
  /// Log entries written via [log], in call order.
  final List<LogEntry> entries = [];

  /// Scopes opened via [openScope], in call order.
  final List<LogScope> openedScopes = [];

  /// Scopes closed via [closeScope], in call order, with their close-time
  /// success/error details.
  final List<ClosedScope> closedScopes = [];

  @override
  Future<void> log(LogEntry entry) async => entries.add(entry);

  @override
  Future<void> openScope(LogScope scope) async => openedScopes.add(scope);

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    closedScopes.add(
      ClosedScope(
        scope: scope,
        success: success,
        duration: duration,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
