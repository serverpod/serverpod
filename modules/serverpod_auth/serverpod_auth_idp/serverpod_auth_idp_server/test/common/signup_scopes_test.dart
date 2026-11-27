import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

enum _Provider { email, emailOtp, anonymous, google }

enum _Callback { authUser, emailAccount, profile, provider }

void main() {
  for (final useJwt in [false, true]) {
    for (final provider in _Provider.values) {
      for (final callback in _Callback.values) {
        if (callback == _Callback.emailAccount &&
            provider != _Provider.email &&
            provider != _Provider.emailOtp) {
          continue;
        }
        if (callback == _Callback.provider &&
            provider != _Provider.anonymous &&
            provider != _Provider.google) {
          continue;
        }

        withServerpod(
          'Given ${provider.name} registration with '
          '${useJwt ? 'JWT' : 'server-side sessions'} and '
          'a ${callback.name} callback that replaces scopes,',
          // The registration flow performs concurrent transactions internally
          // (rate limiting, challenge verification), which is unsupported
          // with rollbacks enabled, so cleanup happens in tearDown instead.
          rollbackDatabase: RollbackDatabase.disabled,
          (sessionBuilder, endpoints) {
            const initialScope = Scope('initial');
            const grantedScope = Scope('granted');

            Future<void> replaceScopes(
              Session session,
              UuidValue authUserId,
              Transaction? transaction,
            ) async {
              await const AuthUsers().update(
                session,
                authUserId: authUserId,
                scopes: {grantedScope},
                transaction: transaction,
              );
            }

            final authUsers = AuthUsers(
              config: AuthUsersConfig(
                onBeforeAuthUserCreated:
                    (session, scopes, blocked, {required transaction}) =>
                        (scopes: {initialScope}, blocked: blocked),
                onAfterAuthUserCreated: callback == _Callback.authUser
                    ? (session, authUser, {required transaction}) =>
                          replaceScopes(session, authUser.id, transaction)
                    : null,
              ),
            );
            final userProfiles = UserProfiles(
              config: UserProfileConfig(
                onAfterUserProfileCreated: callback == _Callback.profile
                    ? (session, profile, {required transaction}) =>
                          replaceScopes(
                            session,
                            profile.authUserId,
                            transaction,
                          )
                    : null,
              ),
            );
            final TokenManager tokenManager = useJwt
                ? JwtConfig(
                    algorithm: JwtAlgorithm.hmacSha512(
                      SecretKey('signup-scopes-test-key'),
                    ),
                    refreshTokenHashPepper: 'test-pepper',
                  ).build(authUsers: authUsers)
                : ServerSideSessionsConfig(
                    sessionKeyHashPepper: 'test-pepper',
                  ).build(authUsers: authUsers);
            final emailConfig = EmailIdpConfig(
              secretHashPepper: 'test-pepper',
              registrationVerificationCodeGenerator: () => '123456',
              otpLoginVerificationCodeGenerator: () => '123456',
              sendOtpLoginVerificationCode:
                  (
                    session, {
                    required email,
                    required otpLoginRequestId,
                    required verificationCode,
                    required transaction,
                  }) {},
              onAfterAccountCreated: callback == _Callback.emailAccount
                  ? (
                      session, {
                      required email,
                      required authUserId,
                      required emailAccountId,
                      required transaction,
                    }) => replaceScopes(session, authUserId, transaction)
                  : null,
            );
            final anonymousIdp = AnonymousIdp(
              callback == _Callback.provider
                  ? AnonymousIdpConfig(
                      onAfterAnonymousAccountCreated:
                          (
                            session, {
                            required authUserId,
                            required transaction,
                          }) => replaceScopes(session, authUserId, transaction),
                    )
                  : const AnonymousIdpConfig(),
              tokenManager: tokenManager,
              authUsers: authUsers,
              userProfiles: userProfiles,
            );
            final baseGoogleConfig = googleIdpConfig();
            final googleIdp = GoogleIdp(
              callback == _Callback.provider
                  ? GoogleIdpConfig(
                      clientSecret: baseGoogleConfig.clientSecret,
                      onAfterGoogleAccountCreated:
                          (
                            session,
                            authUser,
                            googleAccount, {
                            required transaction,
                          }) =>
                              replaceScopes(session, authUser.id, transaction),
                    )
                  : baseGoogleConfig,
              tokenIssuer: tokenManager,
              authUsers: authUsers,
              userProfiles: userProfiles,
            );

            late AuthSuccess result;
            final authUserIds = <UuidValue>[];

            setUp(() async {
              final session = sessionBuilder.build();
              result = await _register(
                session,
                provider,
                tokenManager,
                authUsers,
                userProfiles,
                anonymousIdp,
                googleIdp,
                emailConfig,
              );
              authUserIds.add(result.authUserId);
            });

            // The registration flow uses concurrent transactions internally,
            // so database rollbacks cannot be used here; delete the created
            // rows instead.
            tearDown(() async {
              final session = sessionBuilder.build();
              await session.db.transaction((transaction) async {
                final userIds = authUserIds.toSet();
                await Future.wait([
                  EmailAccount.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  GoogleAccount.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  AnonymousAccount.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  RefreshToken.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  ServerSideSession.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  UserProfile.db.deleteWhere(
                    session,
                    where: (t) => t.authUserId.inSet(userIds),
                    transaction: transaction,
                  ),
                  AuthUser.db.deleteWhere(
                    session,
                    where: (t) => t.id.inSet(userIds),
                    transaction: transaction,
                  ),
                ]);
              });
              authUserIds.clear();
            });

            test(
              'then the auth user carries the updated scopes.',
              () async {
                final session = sessionBuilder.build();
                final user = await authUsers.get(
                  session,
                  authUserId: result.authUserId,
                );
                expect(user.scopes, {grantedScope});
              },
            );

            test(
              'then the returned scope names match the updated scopes.',
              () {
                expect(result.scopeNames, {grantedScope.name});
              },
            );

            test(
              'then the validated token carries the updated scopes.',
              () async {
                final session = sessionBuilder.build();
                final authentication = await tokenManager.validateToken(
                  session,
                  result.token,
                );
                expect(authentication, isNotNull);
                expect(authentication!.scopes, {grantedScope});
              },
            );

            test(
              'then the stored token carries the updated scopes.',
              () async {
                final session = sessionBuilder.build();
                // For JWT this checks the refresh token's persisted scopes too.
                final tokens = await tokenManager.listTokens(
                  session,
                  authUserId: result.authUserId,
                );
                expect(tokens, hasLength(1));
                expect(tokens.single.scopes, {grantedScope});
              },
            );
          },
        );
      }
    }
  }
}

Future<AuthSuccess> _register(
  Session session,
  _Provider provider,
  TokenManager tokenManager,
  AuthUsers authUsers,
  UserProfiles userProfiles,
  AnonymousIdp anonymousIdp,
  GoogleIdp googleIdp,
  EmailIdpConfig emailConfig,
) async {
  switch (provider) {
    case _Provider.email:
    case _Provider.emailOtp:
      final idp = EmailIdp(
        emailConfig,
        tokenManager: tokenManager,
        authUsers: authUsers,
        userProfiles: userProfiles,
      );
      final email = '${const Uuid().v4()}@example.com';
      if (provider == _Provider.emailOtp) {
        final requestId = await idp.startOtpLogin(session, email: email);
        final verification = await idp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: requestId,
          verificationCode: '123456',
        );
        return idp.finishOtpRegistration(
          session,
          otpLoginToken: verification.token,
        );
      }
      final requestId = await idp.startRegistration(session, email: email);
      final registrationToken = await idp.verifyRegistrationCode(
        session,
        accountRequestId: requestId,
        verificationCode: '123456',
      );
      return idp.finishRegistration(
        session,
        registrationToken: registrationToken,
        password: 'ValidPassword123!',
      );
    case _Provider.anonymous:
      return anonymousIdp.login(session);
    case _Provider.google:
      final idToken = createSignedIdToken(
        subject: const Uuid().v4(),
        issuer: 'https://accounts.google.com',
        audience: googleTestClientId,
        claims: {
          'email': 'test@example.com',
          'email_verified': true,
          'given_name': 'Test',
          'name': 'Test User',
        },
      );
      return http.runWithClient(
        () => googleIdp.login(session, idToken: idToken, accessToken: null),
        googleApisClient,
      );
  }
}
