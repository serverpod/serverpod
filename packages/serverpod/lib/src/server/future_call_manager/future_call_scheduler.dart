import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:synchronized/synchronized.dart';

/// A class responsible for scheduling and executing future call entries.
class FutureCallScheduler {
  final Server _server;

  final SerializationManager _serializationManager;

  final _futureCalls = <String, FutureCall>{};

  final int? _concurrencyLimit;

  final _queue = Queue<FutureCallEntry>();
  final _queueLock = Lock();

  var _runningFutureCalls = 0;
  final _runningFutureCallFutures = <Future>[];

  var _isStopping = false;

  /// Creates a new [FutureCallScheduler].
  FutureCallScheduler({
    required Server server,
    required SerializationManager serializationManager,
    required int? concurrencyLimit,
  })  : _server = server,
        _serializationManager = serializationManager,
        _concurrencyLimit = concurrencyLimit;

  /// Registers a [FutureCall] with the queue.
  void registerFutureCall(FutureCall futureCall, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    futureCall.initialize(_server, name);
    _futureCalls[name] = futureCall;
  }

  /// Makes sure any running future calls and queued future calls are processed.
  /// Once called, [shouldSkipScan] will always return `true`.
  Future<void> stop() async {
    _isStopping = true;

    await Future.any(_runningFutureCallFutures.toList());

    while (_queue.isNotEmpty) {
      await _handleQueue();

      await Future.any(_runningFutureCallFutures.toList());
    }
  }

  /// Returns `true` if the concurrent limit for FutureCalls is reached.
  /// Returns `false` otherwise.
  bool shouldSkipScan() {
    if (_isStopping) {
      return true;
    }

    final concurrencyLimit = _concurrencyLimit;

    if (concurrencyLimit == null) {
      return false;
    }

    final isLimitReached = _runningFutureCalls >= concurrencyLimit;

    return isLimitReached;
  }

  /// Adds a list of [FutureCallEntry] to the queue.
  /// It's safe to add the same [FutureCallEntry] multiple times.
  /// The queue will ensure that each [FutureCallEntry] is only processed
  /// once.
  ///
  /// If the [FutureCallEntry] is already in the queue, it is not added again.
  Future<void> addFutureCallEntries(
    List<FutureCallEntry> futureCallEntries,
  ) async {
    // Add only future call entries that are not already in the queue.
    _queue.addAll(
      futureCallEntries.where(
        (entry) => _queue.none((queueEntry) => queueEntry.id == entry.id),
      ),
    );

    unawaited(_handleQueue());
  }

  /// Handles the queue of future call entries.
  /// While the concurrency limit is not reached, the queue is processed.
  /// If the concurrency limit is reached, the queue is not processed further.
  Future<void> _handleQueue() async {
    // Run this in a synchronized block to avoid race conditions. This method
    // can be called asynchronously from any completing FutureCall or when
    // addFutureCallEntries is called. This code must not be running more than
    // once at a time.
    await _queueLock.synchronized(() async {
      while (_queue.isNotEmpty) {
        final isConcurrentLimitReached = shouldSkipScan();

        if (isConcurrentLimitReached) {
          break;
        }

        final futureCallEntry = _queue.removeFirst();
        final futureCall = _futureCalls[futureCallEntry.name];

        if (futureCall == null) {
          // Future Call not found, ignore.
          // TODO this should be logged as an error.
          continue;
        }

        _runningFutureCalls++;

        final completer = Completer<void>();

        _runningFutureCallFutures.add(completer.future);
        unawaited(
          completer.future
              .then((_) => _runningFutureCallFutures.remove(completer.future)),
        );

        unawaited(
          _runFutureCall(
            session: _server.serverpod.internalSession,
            futureCallEntry: futureCallEntry,
            futureCall: futureCall,
          ).whenComplete(
            () {
              _runningFutureCalls--;

              completer.complete();

              if (_isStopping) {
                return;
              }

              _handleQueue();
            },
          ),
        );
      }
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
}
