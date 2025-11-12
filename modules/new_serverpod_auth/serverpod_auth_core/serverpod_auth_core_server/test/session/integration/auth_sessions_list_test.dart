import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final authSessions = AuthSessions(
    config: AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod('Given an auth session for a user,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue authSessionId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await authSessions.authUsers.create(session)).id;

      // ignore: unused_result
      await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
      authSessionId = (await AuthSession.db.find(session)).single.id!;
    });

    test(
      'when calling `listSessions` for the user, then it is returned.',
      () async {
        final sessions = await authSessions.listSessions(
          session,
          authUserId: authUserId,
        );

        expect(
          sessions.single.id,
          authSessionId,
        );
      },
    );

    test(
      'when calling `listSessions` for another user, then nothing is returned.',
      () async {
        final sessions = await authSessions.listSessions(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(sessions, isEmpty);
      },
    );
  });
}
