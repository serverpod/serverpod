import 'package:serverpod/serverpod.dart';

/// A future call that always fails, used to test that the generated future
/// call forwards the retry decision to [shouldRetry].
class TestRetryCall extends FutureCall {
  /// The reasons given to the runs of [fail], in order.
  static final runs = <String>[];

  Future<void> fail(Session session, String reason) async {
    runs.add(reason);
    throw Exception('TestRetryCall failed: $reason');
  }

  /// Retries every failure except those of runs with the reason `permanent`.
  @override
  Future<bool> shouldRetry(
    Session session,
    FutureCallRetryContext context,
  ) async {
    return !'${context.error}'.endsWith('permanent');
  }
}
