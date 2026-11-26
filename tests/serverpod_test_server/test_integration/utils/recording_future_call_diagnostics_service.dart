import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';

/// Records the errors the future call manager reports.
class RecordingFutureCallDiagnosticsService
    implements FutureCallDiagnosticsService {
  /// The errors reported for future calls, in order.
  final callExceptions = <Object>[];

  /// The errors reported for the framework, in order.
  final frameworkExceptions = <Object>[];

  @override
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  }) {
    callExceptions.add(error);
  }

  @override
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  }) {
    frameworkExceptions.add(error);
  }
}
