import 'dart:convert' show jsonEncode;

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';

Future<int> countPasswordlessLoginRequestAttempts(
  final Session session, {
  required final String handle,
  final String handleType = PasswordlessIdpConfig.defaultHandleType,
}) => RateLimitedRequestAttempt.db.count(
  session,
  where: (final t) =>
      t.domain.equals('passwordless') &
      t.source.equals('login_request') &
      t.nonce.equals(
        passwordlessLoginRequestRateLimitNonce(handle, handleType: handleType),
      ),
);

String passwordlessLoginRequestRateLimitNonce(
  final String handle, {
  final String handleType = PasswordlessIdpConfig.defaultHandleType,
}) => jsonEncode([handle, handleType]);

Future<int> countPasswordlessLoginVerifyAttempts(
  final Session session, {
  required final UuidValue loginRequestId,
}) => RateLimitedRequestAttempt.db.count(
  session,
  where: (final t) =>
      t.domain.equals('passwordless') &
      t.source.equals('login_verify') &
      t.nonce.equals(SerializationManager.encode(loginRequestId)),
);
