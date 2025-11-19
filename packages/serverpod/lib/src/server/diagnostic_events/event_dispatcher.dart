import 'dart:async';
import 'dart:io';

import 'event_handler.dart';

/// Dispatches diagnostic events to a set of handlers.
///
/// The handlers are run concurrently with each other
/// and asynchronously with the caller.
class DiagnosticEventDispatcher implements DiagnosticEventHandler {
  final List<DiagnosticEventHandler> _handlers;

  /// If set, this timeout is applied to each event handler invocation.
  final Duration? timeout;

  /// Creates a new [DiagnosticEventDispatcher] with the specified list of handlers.
  const DiagnosticEventDispatcher(
    this._handlers, {
    this.timeout = const Duration(seconds: 30),
  });

  @override
  void handleEvent(
    DiagnosticEvent event, {
    required OriginSpace space,
    required DiagnosticEventContext context,
  }) {
    var futures = _handlers.map(
      (handler) => Future(
        () => handler.handleEvent(event, space: space, context: context),
      ),
    );

    var to = timeout;
    if (to != null) {
      futures = futures.map((future) => future.timeout(to));
    }

    futures.wait.onError((ParallelWaitError e, stackTrace) {
      var errors = e.errors;
      if (errors is Iterable<AsyncError?>) {
        for (var error in errors) {
          if (error != null) {
            stderr.writeln('Error in event handler: $error');
          }
        }
      } else {
        stderr.writeln('Error in an event handler: $errors');
      }
      return e.values;
    });
  }
}
