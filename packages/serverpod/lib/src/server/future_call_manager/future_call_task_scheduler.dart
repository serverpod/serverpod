import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:synchronized/synchronized.dart';

enum _FutureCallInvocationResult {
  success,
  postponed,
  deleted;
}

/// A class responsible for scheduling and executing future call entries.
class FutureCallTaskScheduler {
  final Server _server;

  final SerializationManager _serializationManager;

  final _futureCalls = <String, FutureCall>{};

  final Queue<FutureCallEntry> _queue = Queue();
  final _queueLock = Lock();

  final int? _concurrencyLimit;

  final Map<String, int> _runningFutureCalls = {};
  final _runningFutureCallFutures = <Future>[];
  final _runningFutureCallsLock = Lock();

  bool _shuttingDown = false;

  /// Creates a new [FutureCallTaskScheduler].
  FutureCallTaskScheduler({
    required Server server,
    required SerializationManager serializationManager,
    required int concurrencyLimit,
  })  : _server = server,
        _serializationManager = serializationManager,
        _concurrencyLimit = concurrencyLimit;

  /// Registers a [FutureCall] with the scheduler.
  void registerFutureCall(FutureCall futureCall, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    futureCall.initialize(_server, name);
    _futureCalls[name] = futureCall;
  }

  /// Stops the [FutureCallTaskScheduler].
  ///
  /// This method will wait for all running future calls to complete.
  Future<void> stop() async {
    _shuttingDown = true;
    await Future.wait(_runningFutureCallFutures);
  }

  /// Adds a list of [FutureCallEntry] to the scheduler.
  /// It's safe to add the same [FutureCallEntry] multiple times.
  /// The scheduler will ensure that each [FutureCallEntry] is only processed
  /// once.
  ///
  /// If the scheduler is already shutting down, the [FutureCallEntry]s are
  /// not added to the queue.
  ///
  /// If the [FutureCallEntry] is already in the queue, it is not added again.
  Future<void> addFutureCallEntries(
    List<FutureCallEntry> futureCallEntries,
  ) async {
    if (_shuttingDown) {
      return;
    }

    // Add only future call entries that are not already in the queue.
    await _queueLock.synchronized(() {
      _queue.addAll(
        futureCallEntries.where(
          (entry) => _queue.none((queueEntry) => queueEntry.id == entry.id),
        ),
      );
    });

    unawaited(_handleQueue());
  }

  /// Handles the queue of future call entries.
  /// While the concurrency limit is not reached, the queue is processed.
  /// If the concurrency limit is reached, the queue is not processed further.
  Future<void> _handleQueue() async {
    // Ensure the queue is locked while modifying it.
    await _queueLock.synchronized(() async {
      while (_queue.isNotEmpty && !_shuttingDown) {
        final futureCallEntry = _queue.removeFirst();
        final futureCall = _futureCalls[futureCallEntry.name];

        if (futureCall == null) {
          // Future Call not found, ignore.
          // TODO this should be logged as an error.
          continue;
        }

        final result = await _tryRunFutureCallEntry(
          session: _server.serverpod.internalSession,
          futureCallEntry: futureCallEntry,
          futureCall: futureCall,
        );

        // Concurrency limit reached, stop processing the queue.
        if (result == _FutureCallInvocationResult.postponed) {
          // Add the future call entry to the front of the queue to be processed
          // again once a future call has completed.
          _queue.addFirst(futureCallEntry);

          break;
        }
      }
    });
  }

  /// Tries to start a [FutureCall] as configured by the [FutureCallEntry].
  /// If the concurrency limit allows it, the [FutureCall] is invoked, the
  /// [FutureCallEntry] is deleted from the database and
  /// `_FutureCallInvocationResult.success` is returned.
  /// If the concurrency limit is reached, the future call is not invoked and
  /// `_FutureCallInvocationResult.postponed` is returned.
  /// If the [FutureCallEntry] can not be deleted from the database,
  /// `_FutureCallInvocationResult.deleted` is returned.
  Future<_FutureCallInvocationResult> _tryRunFutureCallEntry({
    required Session session,
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    // Run in a synchronized block to avoid race conditions
    return _runningFutureCallsLock.synchronized(() async {
      final futureCallName = futureCall.name;

      final isConcurrentLimitReached = _isFutureCallConcurrentLimitReached();

      if (isConcurrentLimitReached) {
        return _FutureCallInvocationResult.postponed;
      }

      // Deleting is an atomic operation, so we are safe from race conditions.
      // This will fail if the future call entry is already deleted, either due
      // to being run on another server instance or because it was cancelled.
      try {
        await FutureCallEntry.db.deleteRow(session, futureCallEntry);
      } catch (_) {
        // Future Call Entry already deleted, ignore.
        return _FutureCallInvocationResult.deleted;
      }

      // Increment the number of running future calls.
      // We are in a synchronized block, no race conditions here.
      _runningFutureCalls.update(
        futureCallName,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      final futureCallCompleter = Completer<void>();

      _runningFutureCallFutures.add(futureCallCompleter.future);

      unawaited(
        _runFutureCall(
          session: session,
          futureCallEntry: futureCallEntry,
          futureCall: futureCall,
        ).whenComplete(
          () async {
            // Prevent race conditions by synchronizing the update.
            await _runningFutureCallsLock.synchronized(
              () async => _runningFutureCalls.update(
                futureCallName,
                (value) => value - 1,
                ifAbsent: () => 0,
              ),
            );

            futureCallCompleter.complete();
          },
        ),
      );

      unawaited(
        futureCallCompleter.future.then(
          (_) {
            _runningFutureCallFutures.remove(futureCallCompleter.future);
            // Once a future call is completed, we check if there are more
            // future calls that can be run.
            _handleQueue();
          },
        ),
      );

      return _FutureCallInvocationResult.success;
    });
  }

  /// Runs a [FutureCallEntry] and completes when the future call is completed.
  Future<void> _runFutureCall({
    required Session session,
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    final futureCallName = futureCallEntry.name;

    final futureCallSession = FutureCallSession(
      server: _server,
      futureCallName: futureCallName,
    );

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
      _server.serverpod.internalSubmitEvent(
        ExceptionEvent(error, stackTrace),
        space: OriginSpace.application,
        context: contextFromSession(futureCallSession),
      );

      await futureCallSession.close(error: error, stackTrace: stackTrace);
    }
  }

  /// Returns `true` if the concurrent limit for FutureCalls is reached.
  /// Returns `false` otherwise.
  /// Should be called in a synchronized block.
  bool _isFutureCallConcurrentLimitReached() {
    final concurrencyLimit = _concurrencyLimit;

    if (concurrencyLimit == null) {
      return false;
    }

    final totalRunningFutureCalls =
        _runningFutureCalls.values.fold(0, (sum, value) => sum + value);

    final isLimitReached = totalRunningFutureCalls >= concurrencyLimit;

    return isLimitReached;
  }
}
