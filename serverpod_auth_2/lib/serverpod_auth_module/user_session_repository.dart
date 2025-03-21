import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/additional_data.dart';

abstract class SessionRepository {
  String createSession(
    int userId, {
    required String authProvider,
    required AdditionalData? additionalData,
  });

  /// Returns the user ID for the given session
  int resolveSessionToUserId(
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
  final sessionsBySessionId = <String, (int userId, String provider)>{};

  @override
  String createSession(
    int userId, {
    required String authProvider,
    // TODO: Should this be retained?
    required AdditionalData? additionalData,
  }) {
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();

    sessionsBySessionId[sessionId] = (userId, authProvider);

    return sessionId;
  }

  @override
  int resolveSessionToUserId(String sessionId) {
    final session = sessionsBySessionId[sessionId];

    return session!.$1;
  }
}
