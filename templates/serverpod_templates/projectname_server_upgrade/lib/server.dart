import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Configure our token managers.
  final serverSideSessionsConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: pod.getPassword(
      'serverSideSessionKeyHashPepper',
    )!,
  );

  final emailIdpConfig = EmailIdpConfig(
    secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
    sendRegistrationVerificationCode:
        (
          session, {
          required accountRequestId,
          required email,
          required verificationCode,
          required transaction,
        }) {
          // NOTE: Here you call your mail service to send the verification code to
          // the user. For testing, we will just log the verification code.
          session.log(
            '[EmailIdp] Registration code ($email): $verificationCode',
          );
        },
    sendPasswordResetVerificationCode:
        (
          session, {
          required email,
          required passwordResetRequestId,
          required verificationCode,
          required transaction,
        }) {
          // NOTE: Here you call your mail service to send the verification code to
          // the user. For testing, we will just log the verification code.
          session.log(
            '[EmailIdp] Password reset code ($email): $verificationCode',
          );
        },
  );

  final authServices = AuthServices.set(
    primaryTokenManager: ServerSideSessionsTokenManagerFactory(
      serverSideSessionsConfig,
    ),
    identityProviders: [
      EmailIdentityProviderFactory(emailIdpConfig),
    ],
  );

  pod.authenticationHandler = authServices.authenticationHandler;

  // Start the server.
  await pod.start();
}
