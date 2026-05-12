import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/log.dart' hide LogLevel;

import 'future_call_diagnostics_service.dart';
import 'future_call_scanner.dart';
import 'serverpod_task_scheduler.dart';

/// A function that builds a [Session] for a [FutureCall].
typedef FutureCallSessionBuilder = Session Function(String futureCallName);

/// A function that initializes a [FutureCall].
typedef InitializeFutureCall =
    void Function(
      FutureCall futureCall,
      String name,
    );

/// The [FutureCallManager] is responsible for managing and executing
/// [FutureCall]s in the [Serverpod] framework. A [FutureCall] is a task
/// that is scheduled to run at a specific time in the future. These tasks
/// are persistent, meaning they are stored in the database and will still
/// execute even if the server is restarted.
///
/// Key responsibilities of the [FutureCallManager]:
/// - Scheduling future calls with optional arguments.
/// - Cancelling scheduled future calls.
/// - Registering future call handlers.
/// - Monitoring and executing overdue future calls.
class FutureCallManager {
  final Session _internalSession;
  final Session _logSession;
  final FutureCallSessionBuilder _sessionBuilder;
  final InitializeFutureCall _initializeFutureCall;
  final FutureCallConfig _config;
  final SerializationManager _serializationManager;

  final _futureCalls = <String, FutureCall>{};
  final FutureCallDiagnosticsService _diagnosticsService;

  late final ServerpodTaskScheduler _scheduler;
  late final FutureCallScanner _scanner;
  final Duration _heartbeatInterval;

  /// Tracks whether start() was called but the scanner hasn't been started
  /// yet because there were no registered future calls at the time.
  bool _hasPendingStart = false;

  /// Collection of active claim heartbeat timers.
  final List<Timer> _heartbeatTimers = [];

  /// Creates a new [FutureCallManager]. Typically, this is instantiated
  /// internally by the [Serverpod].
  ///
  /// - [config]: Configuration for future calls, such as concurrency limits.
  /// - [serializationManager]: Handles serialization and deserialization of
  ///   objects passed to future calls.
  /// - [diagnosticsService]: Service for reporting errors and diagnostics.
  /// - [internalSession]: A session used internally for database operations.
  /// - [sessionProvider]: A function to create sessions for executing future calls.
  /// - [initializeFutureCall]: A function to initialize a [FutureCall] with its name.
  /// - [heartbeatInterval]: The interval for updating future call claims with a heartbeat
  /// to keep them alive. Defaults to 30 seconds.
  FutureCallManager(
    this._config,
    this._serializationManager, {
    required FutureCallDiagnosticsService diagnosticsService,
    required Session internalSession,
    required Session logSession,
    required FutureCallSessionBuilder sessionProvider,
    required InitializeFutureCall initializeFutureCall,
    Duration? heartbeatInterval,
  }) : _diagnosticsService = diagnosticsService,
       _internalSession = internalSession,
       _logSession = logSession,
       _sessionBuilder = sessionProvider,
       _initializeFutureCall = initializeFutureCall,
       _heartbeatInterval = heartbeatInterval ?? const Duration(minutes: 1) {
    _scheduler = ServerpodTaskScheduler(
      concurrencyLimit: _config.concurrencyLimit,
    );

    _scanner = FutureCallScanner(
      internalSession: _internalSession,
      scanInterval: _config.scanInterval,
      shouldSkipScan: _scheduler.isConcurrentLimitReached,
      dispatchEntries: _dispatchEntries,
      diagnosticsService: _diagnosticsService,
    );
  }

  /// Cancels a [FutureCall] with the specified [identifier]. If no future
  /// call with the given identifier exists, this method has no effect.
  Future<void> cancelFutureCall(String identifier) async {
    var session = _internalSession;

    await FutureCallEntry.db.deleteWhere(
      session,
      where: (t) => t.identifier.equals(identifier),
    );
  }

  /// Registers a [FutureCall] with the manager. This associates a [FutureCall]
  /// implementation with a specific [name].
  ///
  /// Throws an exception if a future call with the same name is already registered.
  ///
  /// If [start] has been called previously but the scanner hasn't started yet
  /// (because there were no registered future calls), this will trigger the
  /// scanner to begin scanning for overdue future calls.
  void registerFutureCall(FutureCall futureCall, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    _initializeFutureCall(futureCall, name);

    _futureCalls[name] = futureCall;

    // If start() was called but we deferred starting the scanner,
    // start it now that we have a registered future call.
    if (_hasPendingStart) {
      _hasPendingStart = false;
      _scanner.start();
    }
  }

  /// Executes all scheduled future calls that are past their due date. This
  /// method scans the database for overdue tasks and processes them.
  ///
  /// If no future calls are registered, this method will skip processing
  /// and return immediately.
  Future<void> runScheduledFutureCalls() async {
    await _checkBrokenFutureCalls();
    if (_futureCalls.isEmpty) {
      log.info(
        'No future calls registered. Skipping processing.',
      );
      return;
    }

    log.info('Processing future calls.');

    await _scanner.scanFutureCallEntries();

    await _scheduler.drain();
  }

  /// Schedules a [FutureCall] by its [name]. The call will execute at or
  /// after the specified [time]. Optionally, a [SerializableModel] can
  /// be passed as an argument to the call.
  ///
  /// - [name]: The name of the future call to schedule.
  /// - [object]: An optional argument to pass to the future call.
  /// - [time]: The time at which the future call should execute.
  /// - [serverId]: The ID of the server responsible for executing the call.
  /// - [identifier]: An optional unique identifier for the call, used for cancellation.
  /// - [scheduling]: An optional scheduling configuration for recurring calls.
  Future<void> scheduleFutureCall(
    String name,
    SerializableModel? object,
    DateTime time,
    String serverId,
    String? identifier, {
    FutureCallScheduling? scheduling,
  }) async {
    String? serialization;
    if (object != null) {
      serialization = SerializationManager.encode(object.toJson());
    }

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
      identifier: identifier,
      scheduling: scheduling,
    );

    var session = _internalSession;
    await FutureCallEntry.db.insertRow(session, entry);
  }

  /// Starts the [FutureCallManager], enabling it to monitor the database
  /// for overdue future calls and execute them automatically.
  ///
  /// If no future calls are registered, the scanner will not start immediately.
  /// Instead, the scanner will be started when the first future call is
  /// registered via [registerFutureCall].
  Future<void> start() async {
    await _checkBrokenFutureCalls();
    if (_futureCalls.isNotEmpty) {
      _scanner.start();
    } else {
      _hasPendingStart = true;
    }
  }

  /// Stops the [FutureCallManager], preventing it from monitoring and
  /// executing overdue future calls.
  Future<void> stop({bool unregisterAll = false}) async {
    _hasPendingStart = false;
    await _scanner.stop();
    await _scheduler.drain();
    if (unregisterAll) _futureCalls.clear();
    _heartbeatTimers.forEach(_cancelHeartbeatTimer);
  }

  /// Internal method to dispatch a list of [FutureCallEntry] objects to
  /// the task scheduler for execution.
  void _dispatchEntries(List<FutureCallEntry> entries) {
    final callbacks = entries.map<TaskCallback?>((entry) {
      final futureCall = _futureCalls[entry.name];

      if (futureCall == null) {
        _logSession.log(
          'Attempted to run a FutureCall that was not registered. This is likely due '
          'to changing a FutureCall method after it was scheduled, leading to an '
          'entry that no longer has a matching method. For legacy future calls, '
          'make sure they are registered in the server start. Entry: $entry',
          level: LogLevel.error,
        );
        return null;
      }

      return () => _runFutureCall(
        futureCallEntry: entry,
        futureCall: futureCall,
      );
    });

    _scheduler.addTaskCallbacks(callbacks.nonNulls.toList());
  }

  /// Collection of active claim heartbeat timers used for testing purposes.
  @visibleForTesting
  List<Timer> get heartbeatTimers => _heartbeatTimers;

  void _cancelHeartbeatTimer(Timer timer) {
    _heartbeatTimers.remove(timer..cancel());
  }

  /// Updates heartbeat for a future call claim to keep it alive.
  /// Heartbeat is only updated if the claim is held by the
  /// running process.
  Future<void> _updateHeartbeat({
    required int claimId,
    required Timer timer,
  }) async {
    try {
      final rows = await FutureCallClaimEntry.db.updateWhere(
        _internalSession,
        where: (t) => t.id.equals(claimId),
        columnValues: (t) => [t.lastHeartbeatTime(DateTime.now().toUtc())],
      );

      if (rows.isEmpty) {
        _cancelHeartbeatTimer(timer);
      }
    } catch (error, stackTrace) {
      _diagnosticsService.submitFrameworkException(error, stackTrace);
    }
  }

  /// Threshold for considering future call claims as stale.
  /// Claims with [FutureCallClaimEntry.lastHeartbeatTime]
  /// that are older than this threshold are considered stale.
  DateTime get _staleClaimThreshold {
    return DateTime.now().toUtc().subtract(
      _heartbeatInterval * 3,
    );
  }

  /// Attempts to claim the execution for a [FutureCallEntry].
  /// Any stale claim for the [FutureCallEntry] is deleted to allow
  /// re-claiming.
  ///
  /// Returns a [Future] that:
  /// - resolves to a heartbeat timer if a claim was successfully inserted
  /// - resolves to null otherwise
  Future<Timer?> _claimFutureCallAndStartHeartbeatTimer(
    FutureCallEntry futureCallEntry,
  ) async {
    try {
      final entries = await _internalSession.db.transaction(
        (transaction) async {
          // Delete any existing stale claim to allow re-claiming.
          // This will throw and return eagerly if a concurrent deletion
          // is attempted allowing the instance with the first transaction
          // to correctly claim the future call.
          await FutureCallClaimEntry.db.deleteWhere(
            _internalSession,
            transaction: transaction,
            where: (t) =>
                t.futureCallId.equals(futureCallEntry.id) &
                (t.lastHeartbeatTime < _staleClaimThreshold),
          );

          final claim = FutureCallClaimEntry(
            futureCallId: futureCallEntry.id,
            lastHeartbeatTime: DateTime.now().toUtc(),
          );

          return await FutureCallClaimEntry.db.insert(
            _internalSession,
            [claim],
            ignoreConflicts: true,
            transaction: transaction,
          );
        },
        settings: const TransactionSettings(
          // Prevents concurrent transactions with delete and insert queries on the same entry
          isolationLevel: IsolationLevel.repeatableRead,
        ),
      );

      final claimId = entries.firstOrNull?.id;
      if (claimId != null) {
        final timer = Timer.periodic(
          _heartbeatInterval,
          (timer) => _updateHeartbeat(claimId: claimId, timer: timer),
        );
        _heartbeatTimers.add(timer);
        return timer;
      }
    } catch (error, stackTrace) {
      if (error is DatabaseQueryException &&
          error.code == PgErrorCode.serializationFailure) {
        return null;
      }
      _diagnosticsService.submitFrameworkException(error, stackTrace);
    }
    return null;
  }

  /// Runs a [FutureCallEntry] and completes when the future call is completed.
  Future<void> _runFutureCall({
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    final heartbeatTimer = await _claimFutureCallAndStartHeartbeatTimer(
      futureCallEntry,
    );

    // Claim already exists. The instance with the
    // claim will run the call and clean up after running.
    if (heartbeatTimer == null) return;

    await _scheduleNextRecurringCallIfNeeded(futureCallEntry);

    final futureCallSession = _sessionBuilder(futureCallEntry.name);

    try {
      dynamic object;
      if (futureCallEntry.serializedObject != null) {
        object = _serializationManager.decode(
          futureCallEntry.serializedObject!,
          futureCall.dataType,
        );
      }

      await futureCall.invoke(futureCallSession, object);
      await futureCallSession.close();
    } catch (error, stackTrace) {
      _diagnosticsService.submitCallException(
        error,
        stackTrace,
        session: futureCallSession,
      );

      await futureCallSession.close(error: error, stackTrace: stackTrace);
    } finally {
      _cancelHeartbeatTimer(heartbeatTimer);
      await FutureCallEntry.db.deleteWhere(
        _internalSession,
        where: (t) => t.id.equals(futureCallEntry.id),
      );
    }
  }

  /// Returns the next time the [futureCallEntry] should run
  /// if it is a recurring future call.
  /// Otherwise, returns null.
  DateTime? _getNextRecurringRunTime(FutureCallEntry futureCallEntry) {
    var scheduling = futureCallEntry.scheduling;
    if (scheduling == null) return null;

    switch (scheduling) {
      case CronFutureCallScheduling(cron: var cron):
        return Cron.parse(cron).nextTime();
      case IntervalFutureCallScheduling(
        interval: var interval,
        start: var start,
      ):
        final now = clock.now().toUtc();
        final startTime = start ?? futureCallEntry.time;
        final difference = now.difference(startTime);
        final count = (difference.inMilliseconds / interval.inMilliseconds)
            .ceil();
        return startTime.add(interval * count);
    }
  }

  /// Schedules [futureCallEntry] for its next recurring run.
  /// This method does nothing if [futureCallEntry] is not recurring.
  Future<void> _scheduleNextRecurringCallIfNeeded(
    FutureCallEntry futureCallEntry,
  ) async {
    final nextRunTime = _getNextRecurringRunTime(futureCallEntry);
    if (futureCallEntry.scheduling == null || nextRunTime == null) return;

    await FutureCallEntry.db.insertRow(
      _internalSession,
      futureCallEntry.copyWith(id: null, time: nextRunTime),
    );
  }

  /// Returns `true` if the server is configured to check for broken
  /// future calls or if the server can perform a default check.
  ///
  /// The server can perform a default check for broken future calls
  /// if the amount of future calls in the database
  /// is less than [threshold].
  Future<bool> _canCheckBrokenFutureCalls({
    int threshold = 1000,
  }) async {
    if (_config.checkBrokenCalls != null) {
      return _config.checkBrokenCalls!;
    }

    final count = await FutureCallEntry.db.count(
      _internalSession,
      limit: threshold,
    );

    if (count >= threshold) {
      _logSession.log(
        'Skipping automatic check for broken future calls due to high number of future calls in the database. '
        'Enable FutureCallConfig.checkBrokenCalls to always perform the check, regardless of the number of future calls. '
        'Optionally enable FutureCallConfig.deleteBrokenCalls to automatically delete broken future calls.',
        level: LogLevel.warning,
      );
    }

    return count < threshold;
  }

  /// Checks the database for broken future calls.
  /// Broken future calls include unregistered calls and
  /// those with stored inputs that cannot be deserialized.
  ///
  /// If [FutureCallConfig.deleteBrokenCalls] is enabled,
  /// the broken future calls are deleted.
  ///
  /// The check will not happen if
  /// [FutureCallConfig.checkBrokenCalls] is disabled.
  Future<void> _checkBrokenFutureCalls() async {
    if (!await _canCheckBrokenFutureCalls()) return;

    List<FutureCallEntry> unregisteredCalls = [];
    List<FutureCallEntry> brokenCalls = [];
    final entries = await FutureCallEntry.db.find(_internalSession);

    final buffer = StringBuffer();

    for (final entry in entries) {
      final futureCall = _futureCalls[entry.name];
      if (futureCall == null) {
        unregisteredCalls.add(entry);
        buffer.writeln('Unregistered future call: $entry');
      } else {
        final error = _canDecodeFutureCallSerializedData(
          futureCallEntry: entry,
          futureCall: futureCall,
        );

        if (error != null) {
          brokenCalls.add(entry);
          buffer.writeln(
            'Future call failed deserialization. Error: $error. Entry: $entry',
          );
        }
      }
    }
    if (buffer.isNotEmpty) {
      _logSession.log(buffer.toString(), level: LogLevel.warning);
    }

    final allCalls = unregisteredCalls + brokenCalls;

    if (_config.deleteBrokenCalls && allCalls.isNotEmpty) {
      final deletedEntries = await FutureCallEntry.db.delete(
        _internalSession,
        allCalls,
      );
      _logSession.log(
        'Deleted ${deletedEntries.length}/${allCalls.length} broken future calls.',
      );
    }
  }

  /// Returns `null` if [futureCallEntry]'s stored serializedObject
  /// can be deserialized for [futureCall]'s data type.
  /// Otherwise, the error is returned.
  String? _canDecodeFutureCallSerializedData({
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) {
    try {
      if (futureCallEntry.serializedObject != null) {
        _serializationManager.decode(
          futureCallEntry.serializedObject!,
          futureCall.dataType,
        );
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
