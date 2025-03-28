import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/additional_data.dart';

/// This is the store what would need to be implemented on the client, and provided to the Serverpod instance there
/// Before each request, a token is requested through [getSessionKey]
// TODO: Check with the mechanism for expiring essions for long-running stream. This is probably unrelated to this store, but rather an implementation detail on the backend that drops all open connections if a user account got disabled.
abstract class SessionStore {
  // JWT-based implementations would store both refresh and access token and could rotate the access token on expiration internally
  FutureOr<String?> getSessionKey();
}

abstract class SessionRepository {
  String createSession(
    int userId, {
    required String authProvider,
    required AdditionalData? additionalData,
  });

  /// Returns the user ID for the given session
  int resolveSessionToUserId(
    String sessionKey,
  );

  void revokeSession(String sessionKey);

  void revokeAllSessionsForUser(int userId);
}

// TODO: Also thinkg about patterns like GitHub where you need to verify your password again
//       Is this an additional data on top of a 2FA flow? Maybe only that would be time-limited, while the normal 2FA is just done post login.

class UserSessionRepository implements SessionRepository {
  @visibleForTesting
  final sessionsBySessionKey = <String, (int userId, String provider)>{};

  @override
  String createSession(
    int userId, {
    required String authProvider,
    // TODO: Should this be retained?
    required AdditionalData? additionalData,
  }) {
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();

    sessionsBySessionKey[sessionId] = (userId, authProvider);

    return sessionId;
  }

  @override
  int resolveSessionToUserId(String sessionKey) {
    final session = sessionsBySessionKey[sessionKey];

    return session!.$1;
  }

  @override
  void revokeSession(String sessionKey) {
    sessionsBySessionKey.remove(sessionKey);
  }

  @override
  void revokeAllSessionsForUser(int userId) {
    sessionsBySessionKey.removeWhere((_, value) => value.$1 == userId);
  }
}
