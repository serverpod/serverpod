import 'package:serverpod/serverpod.dart';

import 'push_test/controllable_fcm_provider.dart';
import 'push_test/push_test_cases.dart';

/// Interactive matrix harness for push notification testing.
class PushTestEndpoint extends Endpoint {
  /// Shared controllable provider installed from [run].
  static late ControllableFcmProvider controllable;

  /// Lists every case id and its description.
  Future<Map<String, String>> listCases(final Session session) async {
    return Map<String, String>.from(pushTestCaseCatalog);
  }

  /// Runs a single matrix case. Optional [installationId] / [credential] are
  /// needed for lifecycle cases that act on the calling device.
  Future<String> runCase(
    final Session session, {
    required final String caseId,
    final String? installationId,
    final String? credential,
  }) {
    return PushTestCases(controllable).run(
      session,
      caseId: caseId,
      installationId: installationId,
      credential: credential,
    );
  }

  /// Queue depth snapshot.
  Future<String> queueStatus(final Session session) {
    return PushTestCases(controllable).run(
      session,
      caseId: 'queue.empty',
    );
  }

  /// Enqueues a real FCM ping to every live device with [notBefore]=+15s.
  ///
  /// Returns immediately after enqueue so you can background or terminate
  /// the app before delivery.
  Future<String> scheduleDelayedPing(final Session session) {
    return PushTestCases(controllable).run(
      session,
      caseId: 'broadcast.delayed_ping',
    );
  }

  /// Authenticated-only send. Anonymous callers get [NotAuthorizedException].
  /// Used by the security.unauthorized_send matrix case.
  Future<String> authorizedSend(final Session session) async {
    if (session.authenticated == null) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.unauthenticated,
      );
    }
    return PushTestCases(controllable).run(
      session,
      caseId: 'basic.success',
    );
  }
}
