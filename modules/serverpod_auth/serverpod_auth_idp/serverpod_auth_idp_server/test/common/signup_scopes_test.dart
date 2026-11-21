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

enum _Callback { authUser, emailAccount, profile }

void main() {
  for (final useJwt in [false, true]) {
    for (final provider in _Provider.values) {
      for (final callback in _Callback.values) {
        if (callback == _Callback.emailAccount &&
            provider != _Provider.email &&
            provider != _Provider.emailOtp) {
          continue;
        }

        withServerpod(
          'Given ${provider.name} registration with '
          '${useJwt ? 'JWT' : 'server-side sessions'} and '
          'a ${callback.name} callback that replaces scopes,',
          rollbackDatabase: RollbackDatabase.disabled,
          (sessionBuilder, endpoints) {
            test(
              'when registering, then the issued and stored token scopes '
              'match the updated auth user.',
              () async {
                final session = sessionBuilder.build();
                const initialScope = Scope('initial');
                const grantedScope = Scope('granted');

                Future<void> replaceScopes(
                  Session session,
                  UuidValue authUserId,
                  Transaction? transaction,
                ) async {
                  expect(transaction, isNotNull);
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

                final result = await _register(
                  session,
                  provider,
                  authUsers,
                  userProfiles,
                  tokenManager,
                  emailConfig,
                );

                final user = await authUsers.get(
                  session,
                  authUserId: result.authUserId,
                );
                expect(user.scopes, {grantedScope});
                expect(result.scopeNames, {grantedScope.name});

                final authentication = await tokenManager.validateToken(
                  session,
                  result.token,
                );
                expect(authentication, isNotNull);
                expect(authentication!.scopes, {grantedScope});

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
  AuthUsers authUsers,
  UserProfiles userProfiles,
  TokenManager tokenManager,
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
      return const AnonymousIdpConfig()
          .build(
            tokenManager: tokenManager,
            authUsers: authUsers,
            userProfiles: userProfiles,
          )
          .login(session);
    case _Provider.google:
      final idp = GoogleIdp(
        googleIdpConfig(),
        tokenIssuer: tokenManager,
        authUsers: authUsers,
        userProfiles: userProfiles,
      );
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
        () => idp.login(session, idToken: idToken, accessToken: null),
        googleApisClient,
      );
  }
}
