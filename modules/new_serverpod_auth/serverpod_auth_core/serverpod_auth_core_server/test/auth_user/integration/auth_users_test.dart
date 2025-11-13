import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();

  withServerpod('Given an auth user created without parameters,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late AuthUserModel authUser;

    setUp(() async {
      session = sessionBuilder.build();

      authUser = await authUsers.create(session);
    });

    test('when inspecting it, then the scopes are empty.', () {
      expect(authUser.scopeNames, isEmpty);
    });

    test('when inspecting it, then it is not blocked.', () {
      expect(authUser.blocked, isFalse);
    });

    test(
      'when updating it, then the returned model contains the new value.',
      () async {
        final updatedAuthUser = await authUsers.update(
          session,
          authUserId: authUser.id,
          scopes: {Scope.admin},
          blocked: true,
        );

        expect(updatedAuthUser.scopes, {Scope.admin});
        expect(updatedAuthUser.blocked, isTrue);
      },
    );

    test('when deleting it, then it is removed from the database.', () async {
      await authUsers.delete(session, authUserId: authUser.id);

      expect(await AuthUser.db.find(session), isEmpty);
    });

    test('when listing auth users, then it is returned.', () async {
      final listedAuthUsers = await authUsers.list(session);

      expect(listedAuthUsers.single.id, authUser.id);
    });
  });

  withServerpod('Given no auth users,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
    });

    test(
      'when trying to get a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.get(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );

    test(
      'when trying to update a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.update(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );

    test(
      'when trying to delete a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.delete(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );
  });

  withServerpod(
    'Given an auth user creation hook that adds admin scope and blocked,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUsers authUsers;

      setUp(() async {
        session = sessionBuilder.build();

        authUsers = AuthUsers(
          config: AuthUsersConfig(
            onBeforeAuthUserCreated:
                (
                  final session,
                  final scopes,
                  final blocked, {
                  required final transaction,
                }) => (scopes: {...scopes, Scope.admin}, blocked: true),
          ),
        );
      });

      test(
        'when creating an auth user with empty scopes, then the created auth user has admin scope and is blocked.',
        () async {
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {},
            blocked: false,
          );

          expect(createdAuthUser.scopes, {Scope.admin});
          expect(createdAuthUser.blocked, isTrue);
        },
      );

      test(
        'when creating an auth user with a custom scope, then the created auth user has the custom scope and is blocked.',
        () async {
          const customScope = Scope('test');
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {customScope},
            blocked: false,
          );

          expect(createdAuthUser.scopes, {customScope, Scope.admin});
          expect(createdAuthUser.blocked, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given an auth user creation hook that captures the created user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUsers authUsers;
      late AuthUserModel? createdAuthUserFromCallback;

      setUp(() async {
        session = sessionBuilder.build();
        createdAuthUserFromCallback = null;

        authUsers = AuthUsers(
          config: AuthUsersConfig(
            onAfterAuthUserCreated:
                (
                  final session,
                  final authUser, {
                  required final transaction,
                }) {
                  createdAuthUserFromCallback = authUser;
                },
          ),
        );
      });

      test(
        'when creating an auth user, then the hook is invoked with the created auth user.',
        () async {
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {Scope.admin},
            blocked: true,
          );

          expect(
            createdAuthUser,
            equals(createdAuthUserFromCallback),
          );
        },
      );
    },
  );
}
