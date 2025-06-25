import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an auth user created without parameters,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late AuthUserModel authUser;

    setUp(() async {
      session = sessionBuilder.build();

      authUser = await AuthUsers.create(session);
    });

    test('when inspecting it, then the scopes are empty.', () {
      expect(authUser.scopeNames, isEmpty);
    });

    test('when inspecting it, then it is not blocked.', () {
      expect(authUser.blocked, isFalse);
    });

    test('when updating it, then the returned model contains the new value.',
        () async {
      final updatedAuthUser = await AuthUsers.update(
        session,
        authUserId: authUser.id,
        scopes: {Scope.admin},
        blocked: true,
      );

      expect(updatedAuthUser.scopes, {Scope.admin});
      expect(updatedAuthUser.blocked, isTrue);
    });

    test('when deleting it, then it is removed from the database.', () async {
      await AuthUsers.delete(session, authUserId: authUser.id);

      expect(await AuthUser.db.find(session), isEmpty);
    });

    test('when listing auth users, then it is returned.', () async {
      final authUsers = await AuthUsers.list(session);

      expect(authUsers.single.id, authUser.id);
    });
  });

  withServerpod('Given no auth users,',
      (final sessionBuilder, final endpoints) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
    });

    test('when trying to get a non-existent auth user by ID, then it throws.',
        () async {
      await expectLater(
        () => AuthUsers.get(session, authUserId: const Uuid().v4obj()),
        throwsA(isA<AuthUserNotFoundException>()),
      );
    });

    test(
        'when trying to update a non-existent auth user by ID, then it throws.',
        () async {
      await expectLater(
        () => AuthUsers.update(session, authUserId: const Uuid().v4obj()),
        throwsA(isA<AuthUserNotFoundException>()),
      );
    });

    test(
        'when trying to delete a non-existent auth user by ID, then it throws.',
        () async {
      await expectLater(
        () => AuthUsers.delete(session, authUserId: const Uuid().v4obj()),
        throwsA(isA<AuthUserNotFoundException>()),
      );
    });
  });
}
