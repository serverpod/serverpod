import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../../../common/rate_limited_request_attempt/rate_limit.dart';
import '../../../utils/get_passwords_extension.dart';
import '../../utils/default_code_generators.dart';
import 'passwordless_idp.dart';

export '../../../common/rate_limited_request_attempt/rate_limit.dart';
export '../../utils/default_code_generators.dart'
    show defaultNumericVerificationCodeGenerator;

/// Function for resolving an auth user id from a handle.
///
/// Called after the verification code has been successfully verified.
/// If the handle does not correspond to an existing user, the implementation
/// is responsible for creating one and returning the new auth user ID.
typedef ResolveAuthUserIdFunction =
    FutureOr<UuidValue> Function(
      Session session, {
      required String handle,
      required String? handleType,
      required Transaction? transaction,
    });

/// Function for sending out passwordless verification codes.
typedef SendPasswordlessVerificationCodeFunction =
    FutureOr<void> Function(
      Session session, {
      required String handle,
      required String? handleType,
      required UuidValue requestId,
      required String verificationCode,
      required Transaction? transaction,
    });

/// {@template passwordless_idp_config}
/// Configuration options for the passwordless identity provider.
/// {@endtemplate}
class PasswordlessIdpConfig extends IdentityProviderBuilder<PasswordlessIdp> {
  /// The pepper used for hashing verification codes.
  ///
  /// To rotate peppers without invalidating existing codes, use
  /// [fallbackSecretHashPeppers].
  final String secretHashPepper;

  /// Callback for resolving which auth user should be signed in after a login
  /// request has been verified.
  ///
  /// If the handle does not correspond to an existing user, the implementation
  /// is responsible for creating one and returning the new auth user ID.
  final ResolveAuthUserIdFunction resolveAuthUserId;

  /// Optional fallback peppers for validating verification codes created with
  /// previous peppers.
  final List<String> fallbackSecretHashPeppers;

  /// The length of the random salt in bytes for hashing verification codes.
  final int secretHashSaltLength;

  /// The lifetime of login verification codes.
  final Duration loginVerificationCodeLifetime;

  /// Maximum number of recorded verification attempts allowed per login request
  /// within [loginVerificationCodeLifetime].
  ///
  /// Counting is keyed by the pending login request id. Unless already over the
  /// limit, each call that enters the verification flow records one attempt
  /// before the request is loaded and the code is checked.
  ///
  /// Successful verification, invalid codes, missing requests, expired
  /// requests, and concurrent completion failures all count as verification
  /// attempts. If the request is already over the limit, no additional row is
  /// recorded and the login fails with too many attempts.
  final int loginVerificationCodeAllowedAttempts;

  /// Function to generate login verification codes.
  final String Function() loginVerificationCodeGenerator;

  /// Rate limit for login requests.
  ///
  /// Each call to [PasswordlessIdp.startLogin] that passes the rate limit check
  /// records one attempt in a **separate committed transaction** before the
  /// rest of `startLogin` runs. If a later step in the same `startLogin` fails
  /// (for example [sendLoginVerificationCode] throws, or the database
  /// transaction rolls back), that attempt **still counts** toward this limit
  /// for the handle and handle type combination.
  final RateLimit loginRequestRateLimit;

  /// Callback for sending login verification codes.
  ///
  /// Receives the same `String handle` that will be persisted and later passed
  /// to [resolveAuthUserId].
  ///
  /// This is optional. If `null`, no verification code will be delivered.
  /// This allows integrators to deliver codes through other channels.
  ///
  /// The callback runs inside the same database transaction as the created
  /// login request. If it throws, that transaction rolls back and no pending
  /// request row is left, but the login attempt recorded for
  /// [loginRequestRateLimit] is **not** rolled back (see [loginRequestRateLimit]).
  final SendPasswordlessVerificationCodeFunction? sendLoginVerificationCode;

  /// Creates a new passwordless identity provider configuration.
  PasswordlessIdpConfig({
    required this.secretHashPepper,
    required this.resolveAuthUserId,
    this.fallbackSecretHashPeppers = const [],
    this.secretHashSaltLength = 16,
    this.loginVerificationCodeLifetime = const Duration(minutes: 10),
    this.loginVerificationCodeAllowedAttempts = 3,
    this.loginVerificationCodeGenerator =
        defaultNumericVerificationCodeGenerator,
    this.loginRequestRateLimit = const RateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 10),
    ),
    this.sendLoginVerificationCode,
  });

  @override
  PasswordlessIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return PasswordlessIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
    );
  }
}

/// Creates a new [PasswordlessIdpConfig] instance from passwords.yaml
/// configuration.
///
/// This constructor requires that a [Serverpod] instance has already been
/// initialized.
class PasswordlessIdpConfigFromPasswords extends PasswordlessIdpConfig {
  /// Creates a new [PasswordlessIdpConfigFromPasswords] instance.
  PasswordlessIdpConfigFromPasswords({
    required super.resolveAuthUserId,
    super.fallbackSecretHashPeppers,
    super.secretHashSaltLength,
    super.loginVerificationCodeLifetime,
    super.loginVerificationCodeAllowedAttempts,
    super.loginVerificationCodeGenerator,
    super.loginRequestRateLimit,
    super.sendLoginVerificationCode,
  }) : super(
         secretHashPepper: Serverpod.instance.getPasswordOrThrow(
           'passwordlessSecretHashPepper',
         ),
       );
}
