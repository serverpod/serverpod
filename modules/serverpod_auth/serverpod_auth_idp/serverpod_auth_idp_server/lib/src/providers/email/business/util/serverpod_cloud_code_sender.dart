import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../utils/get_passwords_extension.dart';
import 'serverpod_cloud_email_client.dart';

/// The `passwords.yaml` key holding the Serverpod Cloud email service token.
///
/// This password is provided automatically by Serverpod Cloud.
const _scloudAuthEmailKey = 'scloudAuthEmailKey';

/// A function sending a single verification [code] to [email].
///
/// Shared by the Serverpod Cloud configurations of the identity providers that
/// send codes by email.
typedef SendCodeFunction =
    FutureOr<void> Function(
      Session session, {
      required String email,
      required String code,
    });

/// Builds a verification-code sender for the Serverpod Cloud configurations.
///
/// In development/test mode ([client] is null) the code is logged via
/// [Session.alert] with the given [logLabel]. Otherwise it is sent through the
/// Serverpod Cloud email service as an email of the given [emailType]. The
/// `scloudAuthEmailKey` password is read lazily, and any failure is logged
/// rather than thrown.
///
/// Sending is best-effort because propagating a failure would break the flow
/// when the service is unavailable, and could reveal whether an account exists
/// when the send only runs for known emails, so a failure must not change the
/// response. Operators see it in the logs.
SendCodeFunction serverpodCloudCodeSender({
  required final String appDisplayName,
  required final ServerpodCloudEmailClient? client,
  required final ServerpodCloudEmailType emailType,
  required final String logLabel,
}) {
  return (
    final Session session, {
    required final String email,
    required final String code,
  }) async {
    if (client == null) {
      // `session.alert` shows this as a copyable alert in the `serverpod`
      // CLI's terminal UI and auto-copies the `<...>` segment to the
      // clipboard. Other log destinations treat it as a regular log message.
      session.alert('$logLabel code for $email: <$code>');
      return;
    }

    try {
      final token = Serverpod.instance.getPasswordOrThrow(
        _scloudAuthEmailKey,
      );
      await client.sendEmail(
        token: token,
        emailType: emailType,
        email: email,
        projectName: appDisplayName,
        authCode: code,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to send $logLabel email via the Serverpod Cloud email '
        'service for $email.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    }
  };
}
