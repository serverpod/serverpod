import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

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
  final FutureCallSessionBuilder _sessionBuilder;
  final InitializeFutureCall _initializeFutureCall;

  final FutureCallConfig _config;

  final SerializationManager _serializationManager;

  final _futureCalls = <String, FutureCall>{};
  final FutureCallDiagnosticsService _diagnosticsService;

  late final ServerpodTaskScheduler _scheduler;
  late final FutureCallScanner _scanner;

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
  FutureCallManager(
    this._config,
    this._serializationManager, {
    required FutureCallDiagnosticsService diagnosticsService,
    required Session internalSession,
    required FutureCallSessionBuilder sessionProvider,
    required InitializeFutureCall initializeFutureCall,
  }) : _diagnosticsService = diagnosticsService,
       _internalSession = internalSession,
       _sessionBuilder = sessionProvider,
       _initializeFutureCall = initializeFutureCall {
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
  void registerFutureCall(FutureCall futureCall, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    _initializeFutureCall(futureCall, name);

    _futureCalls[name] = futureCall;
  }

  /// Executes all scheduled future calls that are past their due date. This
  /// method scans the database for overdue tasks and processes them.
  Future<void> runScheduledFutureCalls() async {
    stdout.writeln('Processing future calls.');

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
  Future<void> scheduleFutureCall(
    String name,
    SerializableModel? object,
    DateTime time,
    String serverId,
    String? identifier,
  ) async {
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
    );

    var session = _internalSession;
    await FutureCallEntry.db.insertRow(session, entry);
  }

  /// Starts the [FutureCallManager], enabling it to monitor the database
  /// for overdue future calls and execute them automatically.
  void start() {
    _scanner.start();
  }

  /// Stops the [FutureCallManager], preventing it from monitoring and
  /// executing overdue future calls.
  Future<void> stop() async {
    await _scanner.stop();
    await _scheduler.drain();
  }

  /// Internal method to dispatch a list of [FutureCallEntry] objects to
  /// the task scheduler for execution.
  void _dispatchEntries(List<FutureCallEntry> entries) {
    final callbacks = entries.map<TaskCallback?>((entry) {
      final futureCall = _futureCalls[entry.name];

      if (futureCall == null) {
        // ISSUE(https://github.com/serverpod/serverpod/issues/3485):
        // This should be logged or caught otherwise.
        return null;
      }

      return () => _runFutureCall(
        futureCallEntry: entry,
        futureCall: futureCall,
      );
    });

    _scheduler.addTaskCallbacks(callbacks.nonNulls.toList());
  }

  /// Runs a [FutureCallEntry] and completes when the future call is completed.
  Future<void> _runFutureCall({
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
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
    }
  }
}
