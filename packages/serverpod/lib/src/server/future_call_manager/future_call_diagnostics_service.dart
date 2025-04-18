import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';

/// Interface for reporting diagnostic events related to future calls.
///
/// This interface should be generalized to allow any module library to report
/// diagnostic events without directly depending on serverpod server.
abstract interface class FutureCallDiagnosticsService {
  /// Submits a framework diagnostics event.
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  });

  /// Submits a diagnostics event for an exception occurred when processing a
  /// call.
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  });
}

/// Implementation of [FutureCallDiagnosticsService] that reports events to the
/// server's event system.
final class ServerpodFutureCallDiagnosticsService
    implements FutureCallDiagnosticsService {
  final Server _server;

  /// Creates a new [ServerpodFutureCallDiagnosticsService].
  ServerpodFutureCallDiagnosticsService(this._server);

  @override
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  }) {
    _server.serverpod.internalSubmitEvent(
      ExceptionEvent(error, stackTrace, message: message),
      space: OriginSpace.framework,
      context: contextFromServer(_server),
    );
  }

  @override
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  }) {
    _server.serverpod.internalSubmitEvent(
      ExceptionEvent(error, stackTrace),
      space: OriginSpace.application,
      context: contextFromSession(session),
    );
  }
}
