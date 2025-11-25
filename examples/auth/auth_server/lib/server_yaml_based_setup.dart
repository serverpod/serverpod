import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Initialize
  pod.initializeAuthServices(
    tokenManagers: [
      // AuthSessionsTokenManagerFactory(
      //   AuthSessionsConfig(
      //     sessionKeyHashPepper: pod.getPassword(
      //       'authSessionsSessionKeyHashPepper',
      //     )!,
      //   ),
      // ),
      AuthenticationTokensTokenManagerFactory(
        AuthenticationTokenConfig(
          refreshTokenHashPepper: pod.getPassword(
            'authenticationTokenRefreshTokenHashPepper',
          )!,
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey(pod.getPassword('authenticationTokenPrivateKey')!),
          ),
        ),
      ),
    ],
    identityProviders: [
      // GoogleIdentityProviderFactory.fromKeys(pod.getPassword),
      // AppleIdentityProviderFactory.fromKeys(pod.getPassword),
      EmailIdentityProviderFactory.fromKeys(
        pod.getPassword,
        sendRegistrationVerificationCode: _sendRegistrationVerificationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetVerificationCode,
      ),
      // PasskeyIdentityProviderFactory.fromKeys(pod.getPassword),
    ],
  );

  // Start the server.
  await pod.start();
}

void _sendRegistrationVerificationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Registration code ($email): $verificationCode');
}

void _sendPasswordResetVerificationCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Password reset code ($email): $verificationCode');
}
