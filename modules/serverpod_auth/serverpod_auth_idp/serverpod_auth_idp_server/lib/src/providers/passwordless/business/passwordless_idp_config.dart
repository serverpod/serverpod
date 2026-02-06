import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import '../util/default_code_generators.dart';
import 'passwordless_idp.dart';

export '../util/default_code_generators.dart';

/// Function for sending out passwordless verification codes.
typedef SendPasswordlessVerificationCodeFunction =
    FutureOr<void> Function(
      Session session, {
      required String handle,
      required UuidValue requestId,
      required String verificationCode,
      required Transaction? transaction,
    });

/// Function for normalizing a login handle before using it.
typedef NormalizeHandleFunction = String Function(String handle);

/// Function for creating an opaque nonce for a login handle.
///
/// The nonce is stored on the server and later used to resolve an auth user.
typedef BuildNonceFunction = String Function(String normalizedHandle);

/// Function for resolving an auth user id from a nonce.
typedef ResolveAuthUserIdFunction =
    FutureOr<UuidValue> Function(
      Session session, {
      required String nonce,
      required Transaction? transaction,
    });

/// A rolling rate limit configuration.
class PasswordlessRateLimit {
  /// The maximum number of attempts allowed within the timeframe.
  final int maxAttempts;

  /// The timeframe within which the attempts are allowed.
  final Duration timeframe;

  /// Creates a new [PasswordlessRateLimit] instance.
  const PasswordlessRateLimit({
    required this.maxAttempts,
    required this.timeframe,
  });
}

/// {@template passwordless_idp_config}
/// Configuration options for the passwordless identity provider.
/// {@endtemplate}
class PasswordlessIdpConfig extends IdentityProviderBuilder<PasswordlessIdp> {
  /// The pepper used for hashing verification codes.
  ///
  /// To rotate peppers without invalidating existing codes, use
  /// [fallbackSecretHashPeppers].
  final String secretHashPepper;

  /// Optional fallback peppers for validating verification codes created with
  /// previous peppers.
  final List<String> fallbackSecretHashPeppers;

  /// The length of the random salt in bytes for hashing verification codes.
  final int secretHashSaltLength;

  /// Whether passwordless login is enabled.
  final bool enableLogin;

  /// Function for normalizing a login handle before using it.
  ///
  /// Defaults to trimming whitespace.
  final NormalizeHandleFunction normalizeHandle;

  /// Function for creating an opaque nonce for a login handle.
  ///
  /// Defaults to returning the normalized handle as is.
  final BuildNonceFunction buildNonce;

  /// The lifetime of login verification codes.
  final Duration loginVerificationCodeLifetime;

  /// The number of allowed attempts for login verification codes.
  final int loginVerificationCodeAllowedAttempts;

  /// Function to generate login verification codes.
  final String Function() loginVerificationCodeGenerator;

  /// Rate limit for login requests.
  final PasswordlessRateLimit loginRequestRateLimit;

  /// Callback for sending login verification codes.
  ///
  /// This is optional. If `null`, no verification code will be delivered.
  final SendPasswordlessVerificationCodeFunction? sendLoginVerificationCode;

  /// Callback for resolving which auth user should be signed in after a login
  /// request has been verified.
  ///
  /// If `null`, calling [PasswordlessIdp.finishLogin] will throw.
  final ResolveAuthUserIdFunction? resolveAuthUserId;

  /// Creates a new passwordless identity provider configuration.
  const PasswordlessIdpConfig({
    required this.secretHashPepper,
    this.fallbackSecretHashPeppers = const [],
    this.secretHashSaltLength = 16,
    this.enableLogin = true,
    this.normalizeHandle = _defaultNormalizeHandle,
    this.buildNonce = _defaultBuildNonce,
    this.loginVerificationCodeLifetime = const Duration(minutes: 10),
    this.loginVerificationCodeAllowedAttempts = 3,
    this.loginVerificationCodeGenerator =
        defaultPasswordlessVerificationCodeGenerator,
    this.loginRequestRateLimit = const PasswordlessRateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 10),
    ),
    this.sendLoginVerificationCode,
    this.resolveAuthUserId,
  });

  static String _defaultNormalizeHandle(final String handle) => handle.trim();

  static String _defaultBuildNonce(final String normalizedHandle) =>
      normalizedHandle;

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
    super.fallbackSecretHashPeppers,
    super.secretHashSaltLength,
    super.enableLogin,
    super.normalizeHandle,
    super.buildNonce,
    super.loginVerificationCodeLifetime,
    super.loginVerificationCodeAllowedAttempts,
    super.loginVerificationCodeGenerator,
    super.loginRequestRateLimit,
    super.sendLoginVerificationCode,
    super.resolveAuthUserId,
  }) : super(
         secretHashPepper: Serverpod.instance.getPasswordOrThrow(
           'passwordlessSecretHashPepper',
         ),
       );
}
