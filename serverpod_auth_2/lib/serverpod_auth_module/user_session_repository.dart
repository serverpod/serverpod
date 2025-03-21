import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/additional_data.dart';

abstract class SessionRepository {
  String createSession(
    int userId, {
    required String authProvider,
    required AdditionalData? additionalData,
  });

  String createSessionPendingSecondFactorVerification(
    int userId, {
    required String authProvider,
  });

  String upgradeSessionWithSecondFactor(
    String sessionId, {
    required String secondFactorAuthProvider,
  });

  (int userId, bool stillNeedsSecondFactor) resolveSessionToUserId(
    String sessionId,
  );
}

// TODO: Also thinkg about patterns like GitHub where you need to verify your password again
//       Is this an additional data on top of a 2FA flow? Maybe only that would be time-limited, while the normal 2FA is just done post login.

sealed class SecondFactorStatus {}

class SecondFactorNone implements SecondFactorStatus {}

class SecondFactorPending implements SecondFactorStatus {}

class SecondFactorActive implements SecondFactorStatus {
  SecondFactorActive({
    required this.provider,
    required this.verifiedAt,
  });

  /// The second factor provider used
  final String provider;

  /// The time when the second factor was last verified
  final DateTime verifiedAt;
}

class UserSessionRepository implements SessionRepository {
  @visibleForTesting
  final sessionsBySessionId =
      <String, (int userId, String provider, SecondFactorStatus secondFacor)>{};

  @override
  String createSession(
    int userId, {
    required String authProvider,
    // TODO: Should this be retained?
    required AdditionalData? additionalData,
  }) {
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();

    sessionsBySessionId[sessionId] = (userId, authProvider, SecondFactorNone());

    return sessionId;
  }

  @override
  String createSessionPendingSecondFactorVerification(
    int userId, {
    required String authProvider,
  }) {
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();

    sessionsBySessionId[sessionId] =
        (userId, authProvider, SecondFactorPending());

    return sessionId;
  }

  @override
  (int, bool) resolveSessionToUserId(String sessionId) {
    // final sessionId = DateTime.now().microsecondsSinceEpoch.toString();

    final session = sessionsBySessionId[sessionId];

    return (session!.$1, session.$3 is SecondFactorPending);
  }

  @override
  String upgradeSessionWithSecondFactor(
    String sessionId, {
    required String secondFactorAuthProvider,
  }) {
    final session = sessionsBySessionId.remove(sessionId);

    assert(session!.$3 is SecondFactorPending);

    // needs to handle rotating session keys (= return value), e.g. when implemented via signed token
    var newSessionId = DateTime.now().microsecondsSinceEpoch.toString();

    sessionsBySessionId[sessionId] = (
      session!.$1,
      session.$2,
      SecondFactorActive(
        provider: secondFactorAuthProvider,
        verifiedAt: DateTime.now(),
      ),
    );

    return newSessionId;
  }
}
