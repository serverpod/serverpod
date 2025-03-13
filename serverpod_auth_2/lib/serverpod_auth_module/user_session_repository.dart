import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';

class UserSessionRepository {
  @visibleForTesting
  final activeSessions = <ActiveUserSession>[];

  @visibleForTesting
  final pendingSessions = <UserSessionPendingSecondFactor>[];

  ActiveUserSession createSession(
    int userId, {
    required String authProvider,
    bool secondFactorUsed = false,
  }) {
    final session = ActiveUserSession()
      ..id = DateTime.now().microsecondsSinceEpoch.toString()
      ..authenticationProvider = authProvider
      ..createdAt = DateTime.now()
      ..userId = userId
      ..secondFactor = secondFactorUsed;

    activeSessions.add(session);

    return session;
  }

  void destroySession(String sessionId) {
    final session = activeSessions.firstWhere((s) => s.id == sessionId);

    activeSessions.remove(session);
  }

  List<ActiveUserSession> sessionsForUser(int userId) {
    return activeSessions.where((s) => s.userId == userId).toList();
  }

  ActiveUserSession getSessionById(String sessionId) {
    return activeSessions.firstWhere((s) => s.id == sessionId);
  }

  UserSessionPendingSecondFactor createSessionPendingSecondFactorVerification(
    int userId, {
    required String authProvider,
  }) {
    final pendingSession = UserSessionPendingSecondFactor()
      ..id = DateTime.now().microsecondsSinceEpoch.toString()
      ..authenticationProvider = authProvider
      ..createdAt = DateTime.now()
      ..userId = userId;

    pendingSessions.add(pendingSession);

    return pendingSession;
  }

  ActiveUserSession verifyPendingSession(String pendingSessionId) {
    final pendingSession =
        pendingSessions.firstWhere((p) => p.id == pendingSessionId);

    pendingSessions.remove(pendingSession);

    if (DateTime.now()
        .isAfter(pendingSession.createdAt.add(Duration(minutes: 10)))) {
      throw Exception('2FA window expired');
    }

    return createSession(
      pendingSession.userId,
      authProvider: pendingSession.authenticationProvider,
      secondFactorUsed: true,
    );
  }
}
