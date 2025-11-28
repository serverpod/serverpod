import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import 'future_call_diagnostics_service.dart';

/// Callback used to dispatch entries from the scanner.
typedef DispatchEntries = void Function(List<FutureCallEntry> entries);

/// A function that determines whether the scanner should skip the scan.
/// If true, the scanner will not scan the database.
typedef ShouldSkipScan = bool Function();

/// Scans the database for overdue future calls and dispatches them.
class FutureCallScanner {
  final Session _internalSession;
  final FutureCallDiagnosticsService _diagnosticReporting;

  Timer? _timer;

  final Duration _scanInterval;

  final ShouldSkipScan _shouldSkipScan;
  final DispatchEntries _dispatchEntries;

  bool _isStopping = false;
  bool _isStarted = false;

  var _scanCompleter = Completer<void>()..complete();

  /// Creates a new [FutureCallScanner].
  ///
  /// The [internalSession] is used to access the database.
  ///
  /// The [scanInterval] is the interval at which the scanner will scan the
  /// database for overdue future calls.
  ///
  /// The [shouldSkipScan] is a callback that determines whether the scanner
  /// should skip the scan. If it returns true, the scanner will not scan the
  /// database.
  ///
  /// The [dispatchEntries] is a callback that is called with the list of
  /// overdue future calls that were found in the database.
  ///
  /// The [diagnosticsService] is used to report any errors that occur during
  /// the scan.
  FutureCallScanner({
    required Session internalSession,
    required Duration scanInterval,
    required ShouldSkipScan shouldSkipScan,
    required DispatchEntries dispatchEntries,
    required FutureCallDiagnosticsService diagnosticsService,
  }) : _internalSession = internalSession,
       _scanInterval = scanInterval,
       _shouldSkipScan = shouldSkipScan,
       _dispatchEntries = dispatchEntries,
       _diagnosticReporting = diagnosticsService;

  /// Scans the database for overdue future calls and queues them for execution.
  Future<void> scanFutureCallEntries() async {
    if (_isStopping || !_scanCompleter.isCompleted || _shouldSkipScan()) {
      return;
    }

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

  /// Starts the task scanner, which will scan the database for overdue future
  /// calls at the given interval.
  ///
  /// If the scanner is already started, this method has no effect.
  /// Call [startScanning] to actually begin scanning if the scanner
  /// has been started but not yet scanning.
  void start() {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    _isStopping = false;
  }

  /// Begins the periodic scanning process for overdue future calls.
  ///
  /// This should only be called after [start] has been called and
  /// when there are registered future calls to process.
  void startScanning() {
    if (_timer != null || !_isStarted) {
      return;
    }

    _timer = Timer.periodic(
      _scanInterval,
      (_) => scanFutureCallEntries(),
    );
  }

  /// Returns true if the scanner has been started via [start].
  bool get isStarted => _isStarted;

  /// Stops the task scanner.
  Future<void> stop() async {
    _isStopping = true;
    _isStarted = false;

    _timer?.cancel();
    _timer = null;

    await _scanCompleter.future;
  }
}
