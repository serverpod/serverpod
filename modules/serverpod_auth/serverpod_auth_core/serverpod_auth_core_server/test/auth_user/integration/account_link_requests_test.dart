import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../common/business/fakes/fakes.dart';
import '../../serverpod_test_tools.dart';

/// Captures the ids passed to an application merge handler.
class _MergeRecorder {
  UuidValue? userToKeepId;
  UuidValue? userToRemoveId;
  var invoked = false;

  Future<void> call(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    invoked = true;
    this.userToKeepId = userToKeepId;
    this.userToRemoveId = userToRemoveId;
  }
}

void main() {
  const authUsers = AuthUsers();
  late FakeTokenStorage tokenStorage;
  late _MergeRecorder mergeRecorder;

  /// Configures [AuthServices] with a fake token manager, so that proof tokens
  /// can be issued and validated.
  void setUpAuthServices({final AccountMergeConfig? accountMergeConfig}) {
    tokenStorage = FakeTokenStorage();
    AuthServices.set(
      tokenManagerBuilders: [
        FakeTokenManagerBuilder(tokenStorage: tokenStorage),
      ],
      identityProviderBuilders: [],
      accountMergeConfig: accountMergeConfig ?? const AccountMergeConfig(),
    );
  }

  /// Builds a session authenticated as [authUserId] with the given [authId].
  Session sessionFor(
    final TestSessionBuilder sessionBuilder, {
    required final UuidValue authUserId,
    required final String authId,
  }) {
    return sessionBuilder
        .copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.toString(),
            {},
            authId: authId,
          ),
        )
        .build();
  }

  /// Runs the identity provider's attach call in a real transaction, the way an
  /// actual sign-in would.
  Future<void> attachSignIn(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    required final bool newAccount,
  }) {
    return session.db.transaction(
      (final transaction) => AccountLinkRequests.attachToActiveLinkRequest(
        session,
        authUserId: authUserId,
        method: method,
        newAccount: newAccount,
        transaction: transaction,
      ),
    );
  }

  /// Issues a token for [authUserId] without going through the sign-in policy.
  Future<String> issueProofToken(
    final Session session, {
    required final UuidValue authUserId,
    final String method = 'google',
  }) async {
    final authSuccess = await AuthServices.instance.tokenManager.createToken(
      session,
      authUserId: authUserId,
      method: method,
    );

    return authSuccess.token;
  }

  group('Given a link request lifecycle,', () {
    withServerpod('with an authenticated user,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      const authId = 'session-a';

      setUp(() async {
        setUpAuthServices();
        user = await authUsers.create(sessionBuilder.build());
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: authId,
        );
      });

      test(
        'when a link request is created, then it records the session.',
        () async {
          await accountLinkRequests.createLinkRequest(session);

          final request = await AccountLinkRequest.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(user.id),
          );
          expect(request, isNotNull);
          expect(request!.authId, authId);
          expect(request.linkedAuthUserId, isNull);
          expect(request.expiresAt.isAfter(DateTime.now().toUtc()), isTrue);
        },
      );

      test(
        'when a link request is created twice, then only the newest remains.',
        () async {
          await accountLinkRequests.createLinkRequest(session);
          final first = await AccountLinkRequest.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(user.id),
          );

          await accountLinkRequests.createLinkRequest(session);
          final all = await AccountLinkRequest.db.find(
            session,
            where: (final t) => t.authUserId.equals(user.id),
          );

          expect(all, hasLength(1));
          expect(all.single.id, isNot(first!.id));
        },
      );

      test('when the request is cancelled, then it is removed.', () async {
        await accountLinkRequests.createLinkRequest(session);
        await accountLinkRequests.cancelLinkRequest(session);

        final all = await AccountLinkRequest.db.find(
          session,
          where: (final t) => t.authUserId.equals(user.id),
        );
        expect(all, isEmpty);
      });

      test(
        'when cancelling without a request, then it completes without error.',
        () async {
          await expectLater(
            accountLinkRequests.cancelLinkRequest(session),
            completes,
          );
        },
      );
    });

    withServerpod('with an unauthenticated caller,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();

      setUp(() => setUpAuthServices());

      test(
        'when a link request is created, then it throws a StateError.',
        () async {
          await expectLater(
            accountLinkRequests.createLinkRequest(sessionBuilder.build()),
            throwsA(isA<StateError>()),
          );
        },
      );
    });
  });

  group('Given an abandoned link request,', () {
    withServerpod('that attached a newly created account,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel strayUser;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        strayUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: strayUser.id,
          method: 'google',
          newAccount: true,
        );
      });

      test('when cancelled, then the stray account is removed too.', () async {
        await accountLinkRequests.cancelLinkRequest(session);

        expect(await AuthUser.db.findById(session, strayUser.id), isNull);
      });

      test(
        'when a new request is created, then the stray account is cleaned up.',
        () async {
          await accountLinkRequests.createLinkRequest(session);

          expect(await AuthUser.db.findById(session, strayUser.id), isNull);
        },
      );

      test(
        'when another sign-in attaches, then the previous stray account is removed.',
        () async {
          final secondUser = await authUsers.create(session);
          await attachSignIn(
            session,
            authUserId: secondUser.id,
            method: 'apple',
            newAccount: false,
          );

          expect(await AuthUser.db.findById(session, strayUser.id), isNull);
        },
      );
    });

    withServerpod('that attached a pre-existing account,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel otherUser;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: false,
        );
      });

      test('when cancelled, then the other account is left alone.', () async {
        await accountLinkRequests.cancelLinkRequest(session);

        expect(await AuthUser.db.findById(session, otherUser.id), isNotNull);
      });
    });
  });

  group('Given a sign-in that may attach to a link request,', () {
    withServerpod('with an active request,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel otherUser;
      const authId = 'session-a';

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: authId,
        );
        await accountLinkRequests.createLinkRequest(session);
      });

      test('when a sign-in attaches, then the request records it.', () async {
        await attachSignIn(
          session,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: true,
        );

        final request = await AccountLinkRequest.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(user.id),
        );
        expect(request!.linkedAuthUserId, otherUser.id);
        expect(request.linkedMethod, 'google');
        expect(request.linkedAccountWasCreated, isTrue);
      });

      test(
        'when a second sign-in attaches, then the newest one wins.',
        () async {
          final thirdUser = await authUsers.create(session);

          await attachSignIn(
            session,
            authUserId: otherUser.id,
            method: 'google',
            newAccount: true,
          );
          await attachSignIn(
            session,
            authUserId: thirdUser.id,
            method: 'github',
            newAccount: false,
          );

          final request = await AccountLinkRequest.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(user.id),
          );
          expect(request!.linkedAuthUserId, thirdUser.id);
          expect(request.linkedMethod, 'github');
          expect(request.linkedAccountWasCreated, isFalse);
        },
      );

      test('when the sign-in resolves to the caller, then it throws that the '
          'account is already linked.', () async {
        await expectLater(
          attachSignIn(
            session,
            authUserId: user.id,
            method: 'google',
            newAccount: false,
          ),
          throwsA(isA<AccountAlreadyLinkedException>()),
        );
      });

      test('when the sign-in comes from another session, then nothing is '
          'attached.', () async {
        final otherDeviceSession = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-b',
        );

        await attachSignIn(
          otherDeviceSession,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: true,
        );

        final request = await AccountLinkRequest.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(user.id),
        );
        expect(request!.linkedAuthUserId, isNull);
      });
    });

    withServerpod('without an active request,', (
      final sessionBuilder,
      final endpoints,
    ) {
      late AuthUserModel user;
      late AuthUserModel otherUser;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
      });

      test(
        'when an unauthenticated sign-in happens, then nothing is recorded.',
        () async {
          final session = sessionBuilder.build();

          await attachSignIn(
            session,
            authUserId: otherUser.id,
            method: 'google',
            newAccount: true,
          );

          expect(await AccountLinkRequest.db.find(session), isEmpty);
        },
      );

      test(
        'when an authenticated sign-in happens, then nothing is recorded.',
        () async {
          final session = sessionFor(
            sessionBuilder,
            authUserId: user.id,
            authId: 'session-a',
          );

          await attachSignIn(
            session,
            authUserId: otherUser.id,
            method: 'google',
            newAccount: true,
          );

          expect(await AccountLinkRequest.db.find(session), isEmpty);
        },
      );
    });
  });

  group('Given a link request that is being executed,', () {
    withServerpod('with a newly created account attached,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel newUser;
      late String proofToken;

      setUp(() async {
        // Deliberately left with the default config, which has no application
        // merge handler, to show that linking a brand new sign-in method needs
        // no merge configuration.
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        newUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: newUser.id,
          method: 'google',
          newAccount: true,
        );
        proofToken = await issueProofToken(session, authUserId: newUser.id);
      });

      test('when executed, then the accounts are linked.', () async {
        final result = await accountLinkRequests.executeLinkRequest(
          session,
          proofToken: proofToken,
        );

        expect(result.status, AccountLinkStatus.linked);
        expect(result.conflict, isNull);
        expect(await AuthUser.db.findById(session, newUser.id), isNull);
        expect(await AccountLinkRequest.db.find(session), isEmpty);
      });

      test('when executed, then the proof token is revoked.', () async {
        await accountLinkRequests.executeLinkRequest(
          session,
          proofToken: proofToken,
        );

        expect(
          await AuthServices.instance.tokenManager.validateToken(
            session,
            proofToken,
          ),
          isNull,
        );
      });
    });

    withServerpod('with a pre-existing account attached,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel otherUser;
      late String proofToken;

      setUp(() async {
        mergeRecorder = _MergeRecorder();
        setUpAuthServices(
          accountMergeConfig: AccountMergeConfig(
            applicationMergeHandler: mergeRecorder.call,
          ),
        );
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: false,
        );
        proofToken = await issueProofToken(session, authUserId: otherUser.id);
      });

      test('when executed without approval, then it reports that a merge is '
          'required.', () async {
        final result = await accountLinkRequests.executeLinkRequest(
          session,
          proofToken: proofToken,
        );

        expect(result.status, AccountLinkStatus.mergeRequired);
        expect(result.conflict, isNotNull);
        expect(result.conflict!.authUserId, otherUser.id);
        expect(result.conflict!.method, 'google');
      });

      test(
        'when executed without approval and profile exists, then conflict profile is populated.',
        () async {
          const userProfiles = UserProfiles();
          await userProfiles.createUserProfile(
            session,
            otherUser.id,
            UserProfileData(
              email: 'other@example.com',
              userName: 'otheruser',
              fullName: 'Other User',
            ),
          );

          final result = await accountLinkRequests.executeLinkRequest(
            session,
            proofToken: proofToken,
          );

          expect(result.status, AccountLinkStatus.mergeRequired);
          expect(result.conflict, isNotNull);
          expect(result.conflict!.profile, isNotNull);
          expect(result.conflict!.profile!.email, 'other@example.com');
          expect(result.conflict!.profile!.userName, 'otheruser');
          expect(result.conflict!.profile!.fullName, 'Other User');
        },
      );

      test(
        'when executed without approval, then nothing is changed.',
        () async {
          await accountLinkRequests.executeLinkRequest(
            session,
            proofToken: proofToken,
          );

          expect(mergeRecorder.invoked, isFalse);
          expect(await AuthUser.db.findById(session, otherUser.id), isNotNull);
          expect(await AccountLinkRequest.db.find(session), hasLength(1));
          expect(
            await AuthServices.instance.tokenManager.validateToken(
              session,
              proofToken,
            ),
            isNotNull,
          );
        },
      );

      test(
        'when executed with approval, then the accounts are merged.',
        () async {
          final result = await accountLinkRequests.executeLinkRequest(
            session,
            proofToken: proofToken,
            approveMerge: true,
          );

          expect(result.status, AccountLinkStatus.merged);
          expect(result.conflict!.authUserId, otherUser.id);
          expect(mergeRecorder.userToKeepId, user.id);
          expect(mergeRecorder.userToRemoveId, otherUser.id);
          expect(await AuthUser.db.findById(session, otherUser.id), isNull);
          expect(await AccountLinkRequest.db.find(session), isEmpty);
        },
      );

      test('when a dry run is followed by an approval, then the accounts are '
          'merged.', () async {
        await accountLinkRequests.executeLinkRequest(
          session,
          proofToken: proofToken,
        );
        final result = await accountLinkRequests.executeLinkRequest(
          session,
          proofToken: proofToken,
          approveMerge: true,
        );

        expect(result.status, AccountLinkStatus.merged);
        expect(await AuthUser.db.findById(session, otherUser.id), isNull);
      });

      test(
        'when the proof token is for another account, then it throws.',
        () async {
          final unrelatedUser = await authUsers.create(session);
          final unrelatedToken = await issueProofToken(
            session,
            authUserId: unrelatedUser.id,
          );

          await expectLater(
            accountLinkRequests.executeLinkRequest(
              session,
              proofToken: unrelatedToken,
              approveMerge: true,
            ),
            throwsA(isA<AccountLinkRequestNotFoundException>()),
          );
        },
      );

      test('when the proof token is not valid, then it throws.', () async {
        await expectLater(
          accountLinkRequests.executeLinkRequest(
            session,
            proofToken: 'not-a-token',
            approveMerge: true,
          ),
          throwsA(isA<AccountLinkRequestNotFoundException>()),
        );
      });

      test('when executed from another session, then it throws.', () async {
        final otherDeviceSession = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-b',
        );

        await expectLater(
          accountLinkRequests.executeLinkRequest(
            otherDeviceSession,
            proofToken: proofToken,
            approveMerge: true,
          ),
          throwsA(isA<AccountLinkRequestNotFoundException>()),
        );
      });

      test('when the link request has expired, then it throws.', () async {
        final futureTime = clock.now().add(const Duration(hours: 1));
        await withClock(Clock.fixed(futureTime), () async {
          await expectLater(
            accountLinkRequests.executeLinkRequest(
              session,
              proofToken: proofToken,
              approveMerge: true,
            ),
            throwsA(isA<AccountLinkRequestNotFoundException>()),
          );
        });
      });
    });

    withServerpod('with a pre-existing account but no merge configuration,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel otherUser;
      late String proofToken;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: false,
        );
        proofToken = await issueProofToken(session, authUserId: otherUser.id);
      });

      test(
        'when executed, then it throws that merging is not configured.',
        () async {
          await expectLater(
            accountLinkRequests.executeLinkRequest(
              session,
              proofToken: proofToken,
            ),
            throwsA(isA<AccountMergeNotConfiguredException>()),
          );
        },
      );
    });

    withServerpod('with an application merge handler that fails,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late AuthUserModel otherUser;
      late String proofToken;

      setUp(() async {
        setUpAuthServices(
          accountMergeConfig: AccountMergeConfig(
            applicationMergeHandler:
                (
                  final session, {
                  required final userToKeepId,
                  required final userToRemoveId,
                  required final transaction,
                }) => throw Exception('Application merge failed.'),
          ),
        );
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        await attachSignIn(
          session,
          authUserId: otherUser.id,
          method: 'google',
          newAccount: false,
        );
        proofToken = await issueProofToken(session, authUserId: otherUser.id);
      });

      test(
        'when executed with approval, then it throws that the merge failed.',
        () async {
          await expectLater(
            accountLinkRequests.executeLinkRequest(
              session,
              proofToken: proofToken,
              approveMerge: true,
            ),
            throwsA(isA<AccountMergeFailedException>()),
          );
        },
      );

      test(
        'when the merge fails, then both accounts are left untouched.',
        () async {
          await expectLater(
            accountLinkRequests.executeLinkRequest(
              session,
              proofToken: proofToken,
              approveMerge: true,
            ),
            throwsA(isA<AccountMergeFailedException>()),
          );

          expect(await AuthUser.db.findById(session, user.id), isNotNull);
          expect(await AuthUser.db.findById(session, otherUser.id), isNotNull);
          expect(await AccountLinkRequest.db.find(session), hasLength(1));
        },
      );
    });

    withServerpod('with no sign-in attached,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late AuthUserModel user;
      late String proofToken;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        user = await authUsers.create(setupSession);
        final otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );

        await accountLinkRequests.createLinkRequest(session);
        proofToken = await issueProofToken(session, authUserId: otherUser.id);
      });

      test('when executed, then it throws.', () async {
        await expectLater(
          accountLinkRequests.executeLinkRequest(
            session,
            proofToken: proofToken,
          ),
          throwsA(isA<AccountLinkRequestNotFoundException>()),
        );
      });
    });

    withServerpod('with no request at all,', (
      final sessionBuilder,
      final endpoints,
    ) {
      const accountLinkRequests = AccountLinkRequests();
      late Session session;
      late String proofToken;

      setUp(() async {
        setUpAuthServices();
        final setupSession = sessionBuilder.build();
        final user = await authUsers.create(setupSession);
        final otherUser = await authUsers.create(setupSession);
        session = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );
        proofToken = await issueProofToken(session, authUserId: otherUser.id);
      });

      test('when executed, then it throws.', () async {
        await expectLater(
          accountLinkRequests.executeLinkRequest(
            session,
            proofToken: proofToken,
          ),
          throwsA(isA<AccountLinkRequestNotFoundException>()),
        );
      });
    });
  });
}
