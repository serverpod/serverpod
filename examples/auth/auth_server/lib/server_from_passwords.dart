// This is an example of how to use initialize the auth services directly from a
// passwords file or environment variables. The `*FromPasswords` classes exist
// to simplify the secrets retrieval, while still allowing full customization of
// each token manager and identity provider. This file is functionally identical
// to the `server.dart` file.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      ServerSideSessionsConfigFromPasswords(),
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      AppleIdpConfigFromPasswords(),
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
        sendOtpLoginVerificationCode: _sendOtpLoginCode,
        // Lets users set an optional password when creating an account through
        // the passwordless sign-in, to also sign in with it.
        allowPasswordOnOtpRegistration: true,
      ),
      GoogleIdpConfigFromPasswords(),
      PasskeyIdpConfigFromPasswords(),
    ],
  );

  // Paths must match paths configured on Apple's developer portal. The values
  // below are the defaults if not provided.
  pod.configureAppleIdpRoutes(
    revokedNotificationRoutePath: '/hooks/apple-notification',
    webAuthenticationCallbackRoutePath: '/auth/callback',
  );

  // Start the server.
  await pod.start();
}

// Sends the verification code for registering an account with a password
// through the `startRegistration` method of the email endpoint. One-time
// passwords are sent by `_sendOtpLoginCode` instead.
void _sendRegistrationCode(
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

// Sends the code to reset a forgotten password, which users request from the
// password sign-in of `EmailOtpSignInWidget`.
void _sendPasswordResetCode(
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

// Sends the one-time password users enter to sign in, or to create an account
// if none exists for the email yet.
void _sendOtpLoginCode(
  Session session, {
  required String email,
  required UuidValue otpLoginRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the one-time password to
  // the user. For testing, we will just log the code.
  session.log('[EmailIDP] Login code ($email): $verificationCode');
}
