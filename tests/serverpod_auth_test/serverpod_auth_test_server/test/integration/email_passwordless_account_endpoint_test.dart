import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email_passwordless.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart'
    show Client;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

final tokenManagerConfig = ServerSideSessionsConfig(
  sessionKeyHashPepper: 'test-pepper',
);

void main() {
  late List<({String email, UuidValue loginRequestId, String code})> sent;

  setUp(() async {
    sent = [];
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [
        EmailPasswordlessIdpConfig(
          secretHashPepper: 'test',
          resendCooldown: Duration.zero,
          sendSignUpVerificationCode:
              (
                final session, {
                required final email,
                required final loginRequestId,
                required final verificationCode,
                required final transaction,
              }) {
                sent.add((
                  email: email,
                  loginRequestId: loginRequestId,
                  code: verificationCode,
                ));
              },
          sendSignInVerificationCode:
              (
                final session, {
                required final email,
                required final loginRequestId,
                required final verificationCode,
                required final transaction,
              }) {
                sent.add((
                  email: email,
                  loginRequestId: loginRequestId,
                  code: verificationCode,
                ));
              },
        ),
      ],
    );
  });

  tearDown(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given no users,',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      tearDown(() async {
        final session = sessionBuilder.build();
        await EmailAccountLoginRequest.db.deleteWhere(
          session,
          where: (final t) => Constant.bool(true),
        );
        await EmailAccount.db.deleteWhere(
          session,
          where: (final t) => Constant.bool(true),
        );
      });

      test(
        'when calling startLogin and finishLogin through the endpoint, '
        'then an account is created and a session is returned.',
        () async {
          final loginRequestId = await endpoints.emailPasswordlessAccount
              .startLogin(sessionBuilder, email: 'new@serverpod.dev');

          expect(sent.single.email, 'new@serverpod.dev');
          expect(sent.single.loginRequestId, loginRequestId);

          final authSuccess = await endpoints.emailPasswordlessAccount
              .finishLogin(
                sessionBuilder,
                loginRequestId: loginRequestId,
                verificationCode: sent.single.code,
              );

          expect(authSuccess.token, isNotEmpty);
          expect(
            await EmailAccount.db.count(
              sessionBuilder.build(),
              where: (final t) => t.email.equals('new@serverpod.dev'),
            ),
            1,
          );
        },
      );

      test(
        'when calling finishLogin with a wrong code, '
        'then an invalid EmailPasswordlessLoginException is thrown.',
        () async {
          final loginRequestId = await endpoints.emailPasswordlessAccount
              .startLogin(sessionBuilder, email: 'new@serverpod.dev');

          await expectLater(
            endpoints.emailPasswordlessAccount.finishLogin(
              sessionBuilder,
              loginRequestId: loginRequestId,
              verificationCode: '${sent.single.code}0',
            ),
            throwsA(
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an unauthenticated session',
    (final sessionBuilder, final endpoints) {
      test(
        'when calling hasAccount then it returns false',
        () async {
          final result = await endpoints.emailPasswordlessAccount.hasAccount(
            sessionBuilder,
          );
          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod('Given an authenticated session with a passwordless account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late TestSessionBuilder session;

    setUp(() async {
      final setupSession = sessionBuilder.build();
      final authUser = await const AuthUsers().create(setupSession);
      await EmailAccount.db.insertRow(
        setupSession,
        EmailAccount(
          authUserId: authUser.id,
          email: 'test-${const Uuid().v4()}@serverpod.dev',
          passwordHash: '',
        ),
      );
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUser.id.uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns true',
      () async {
        final result = await endpoints.emailPasswordlessAccount.hasAccount(
          session,
        );
        expect(result, isTrue);
      },
    );
  });

  withServerpod('Given an authenticated session but no Email account', (
    final sessionBuilder,
    final endpoints,
  ) {
    test(
      'when calling hasAccount then it returns false',
      () async {
        final session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            const Uuid().v4obj().uuid,
            {},
          ),
        );

        final result = await endpoints.emailPasswordlessAccount.hasAccount(
          session,
        );
        expect(result, isFalse);
      },
    );
  });

  test('The generated client exposes the passwordless endpoint', () {
    final client = Client('http://localhost:8080/');
    expect(client.emailPasswordlessAccount, isNotNull);
  });
}
