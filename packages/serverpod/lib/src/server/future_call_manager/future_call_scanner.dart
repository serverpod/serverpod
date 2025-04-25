import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import 'future_call_diagnostics_service.dart';

/// A function that queues future call entries for execution.
typedef DispatchEntries = void Function(List<FutureCallEntry> entries);

/// A function that checks if the concurrent limit has been reached. Returns
/// `true` if the limit has been reached, `false` otherwise.
typedef ShouldSkipScan = bool Function();

/// Scans the database for overdue future calls and queues them for execution.
class FutureCallScanner {
  final Session _internalSession;
  final FutureCallDiagnosticsService _diagnosticReporting;

  Timer? _timer;

  final Duration _scanInterval;

  final ShouldSkipScan _shouldSkipScan;
  final DispatchEntries _dispatchEntries;

  bool _isStopping = false;

  var _scanCompleter = Completer<void>()..complete();

  /// Creates a new [FutureCallScanner].
  FutureCallScanner({
    required Session internalSession,
    required Duration scanInterval,
    required ShouldSkipScan shouldSkipScan,
    required DispatchEntries dispatchEntries,
    required FutureCallDiagnosticsService diagnosticsService,
  })  : _internalSession = internalSession,
        _scanInterval = scanInterval,
        _shouldSkipScan = shouldSkipScan,
        _dispatchEntries = dispatchEntries,
        _diagnosticReporting = diagnosticsService;

  /// Starts the task scanner, which will scan the database for overdue future
  /// calls at the given interval.
  void start() {
    if (_timer != null) {
      throw StateError('Future call scanner already started.');
    }

    _timer = Timer.periodic(
      _scanInterval,
      (_) => scanFutureCallEntries(),
    );
  }

  /// Stops the task scanner.
  Future<void> stop() async {
    _isStopping = true;

    _timer?.cancel();

    await _scanCompleter.future;
  }

  /// Scans the database for overdue future calls and queues them for execution.
  Future<void> scanFutureCallEntries() async {
    if (_isStopping || _shouldSkipScan() || !_scanCompleter.isCompleted) {
      return;
    }

    // Wait for any previous scan to complete. This is to ensure that a single
    // scan is running at a time.

    _scanCompleter = Completer<void>();

    try {
      final now = DateTime.now().toUtc();

      final entries = await FutureCallEntry.db.deleteWhere(
        _internalSession,
        where: (row) => row.time <= now,
      );

      entries.sort((a, b) => a.time.compareTo(b.time));

      _dispatchEntries(entries);
    } catch (error, stackTrace) {
      // Most likely we lost connection to the database
      var message =
          'Internal server error. Failed to connect to database in future call manager.';

      _diagnosticReporting.submitFrameworkException(
        error,
        stackTrace,
        message: message,
      );

      stderr.writeln('${DateTime.now().toUtc()} $message');
      stderr.writeln('$error');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }

    _scanCompleter.complete();
  }
}
