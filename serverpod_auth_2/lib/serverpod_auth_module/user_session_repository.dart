import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/additional_data.dart';

/// This is the store what would need to be implemented on the client, and provided to the Serverpod instance there
/// Before each request, a token is requested through [getSessionKey]
// TODO: Check with the mechanism for expiring essions for long-running stream. This is probably unrelated to this store, but rather an implementation detail on the backend that drops all open connections if a user account got disabled.
// TODO: Should this be a function (passed as configuration to the client) instead of an interface?
abstract class SessionStore {
  // JWT-based implementations would store both refresh and access token and could rotate the access token on expiration internally
  FutureOr<String?> getSessionKey();
}

abstract class MinimalSessionRepository {
  // Endpoint request -> Session to User object mapping
  int resolveSessionToUserId(
    String sessionKey,
  );

  // void revokeAllSessionsForUser(int userId);
}

// TODO: Potentially remove the interface, and just rely on the concrete DB sessions in the example
abstract class SessionRepository {
  String createSession(
    int userId, {
    required String authProvider,
    // TODO: Only make sense if stored and returned
    required AdditionalData? additionalData,
  });

  /// Returns the user ID for the given session
  // TODO: This would need to check `user.blocked` and throw in case it's disabled, right?
  int resolveSessionToUserId(
    String sessionKey,
  );

  void revokeSession(String sessionKey);

  // TODO: Instead of a method, these might also come through the internal message bus
  // (but still there is the problem that the implementation does not / can not implement these)
  void revokeAllSessionsForUser(int userId);
}

class UserSessionRepository implements SessionRepository {
  @visibleForTesting
  final sessionsBySessionKey = <String, (int userId, String provider)>{};

  @override
  String createSession(
    int userId, {
    required String authProvider,
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
