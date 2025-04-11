import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';

/// A function that queues future call entries for execution.
typedef DispatchEntries = void Function(List<FutureCallEntry> entries);

/// A function that checks if the concurrent limit has been reached. Returns
/// `true` if the limit has been reached, `false` otherwise.
typedef ShouldSkipScan = bool Function();

/// Scans the database for overdue future calls and queues them for execution.
class FutureCallScanner {
  final Server _server;

  Timer? _timer;

  final Duration _scanInterval;

  final ShouldSkipScan _shouldSkipScan;
  final DispatchEntries _dispatchEntries;

  bool _isStopping = false;

  /// Creates a new [FutureCallScanner].
  FutureCallScanner({
    required Server server,
    required Duration scanInterval,
    required ShouldSkipScan shouldSkipScan,
    required DispatchEntries dispatchEntries,
  })  : _server = server,
        _scanInterval = scanInterval,
        _shouldSkipScan = shouldSkipScan,
        _dispatchEntries = dispatchEntries;

  /// Starts the task scanner, which will scan the database for overdue future
  /// calls at the given interval.
  void start() {
    _timer = Timer.periodic(
      _scanInterval,
      (_) => scanFutureCalls(),
    );
  }

  /// Stops the task scanner.
  void stop() {
    // TODO(ALEX): Make this method async and wait for any current running task to stop.
    // The _isStopping should syncronously prevent any new timers from being started.

    // TODO(ALEX): We need to ensure that a single scan is running at a time for the Server.
    // This can be done using the same `scan completed` Completer.
    _isStopping = true;
    _timer?.cancel();
  }

  /// Scans the database for overdue future calls and queues them for execution.
  Future<void> scanFutureCalls() async {
    if (_isStopping || _shouldSkipScan()) {
      return;
    }

    try {
      final now = DateTime.now().toUtc();

      final internalSession = _server.serverpod.internalSession;

      final entries = await FutureCallEntry.db.deleteWhere(
        internalSession,
        where: (row) => row.time <= now,
      );

      entries.sort((a, b) => a.time.compareTo(b.time));

      _dispatchEntries(entries);
    } catch (error, stackTrace) {
      // Most likely we lost connection to the database
      var message =
          'Internal server error. Failed to connect to database in future call manager.';

      _server.serverpod.internalSubmitEvent(
        ExceptionEvent(error, stackTrace, message: message),
        space: OriginSpace.framework,
        context: contextFromServer(_server),
      );

      stderr.writeln('${DateTime.now().toUtc()} $message');
      stderr.writeln('$error');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }
  }
}
