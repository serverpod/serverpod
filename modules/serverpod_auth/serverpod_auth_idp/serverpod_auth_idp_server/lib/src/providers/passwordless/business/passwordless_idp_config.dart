import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../../../common/rate_limited_request_attempt/rate_limit.dart';
import '../../../generated/protocol.dart' as proto;
import '../../../utils/get_passwords_extension.dart';
import '../../utils/default_code_generators.dart';
import 'passwordless_idp.dart';

export '../../../common/rate_limited_request_attempt/rate_limit.dart';
export '../../utils/default_code_generators.dart'
    show defaultNumericVerificationCodeGenerator;

/// Function for sending out passwordless verification codes.
typedef SendPasswordlessVerificationCodeFunction =
    FutureOr<void> Function(
      Session session, {
      required String handle,
      required UuidValue requestId,
      required String verificationCode,
      required Transaction? transaction,
    });

/// Function for converting a handle to a stable serialized string.
typedef SerializeHandleFunction<THandle> = String Function(THandle handle);

/// Function for reading a handle from its serialized representation.
typedef DeserializeHandleFunction<THandle> = THandle Function(String handle);

/// Function for resolving an auth user id from a handle.
///
/// Called after the verification code has been successfully verified.
/// If the handle does not correspond to an existing user, the implementation
/// is responsible for creating one and returning the new auth user ID.
typedef ResolveAuthUserIdFunction<THandle> =
    FutureOr<UuidValue> Function(
      Session session, {
      required THandle handle,
      required Transaction? transaction,
    });

/// {@template passwordless_idp_config}
/// Configuration options for the passwordless identity provider.
/// {@endtemplate}
class PasswordlessIdpConfig<THandle>
    extends IdentityProviderBuilder<PasswordlessIdp<THandle>> {
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
  final ResolveAuthUserIdFunction<THandle> resolveAuthUserId;

  /// Optional fallback peppers for validating verification codes created with
  /// previous peppers.
  final List<String> fallbackSecretHashPeppers;

  /// The length of the random salt in bytes for hashing verification codes.
  final int secretHashSaltLength;

  /// Function for converting a handle to a serialized string for persistence.
  final SerializeHandleFunction<THandle> serializeHandle;

  /// Function for reading a handle from a serialized string.
  final DeserializeHandleFunction<THandle> deserializeHandle;

  /// The lifetime of login verification codes.
  final Duration loginVerificationCodeLifetime;

  /// The number of allowed attempts for login verification codes.
  final int loginVerificationCodeAllowedAttempts;

  /// Function to generate login verification codes.
  final String Function() loginVerificationCodeGenerator;

  /// Rate limit for login requests.
  final RateLimit loginRequestRateLimit;

  /// Callback for sending login verification codes.
  ///
  /// This is optional. If `null`, no verification code will be delivered.
  /// This allows integrators to deliver codes through other channels.
  final SendPasswordlessVerificationCodeFunction? sendLoginVerificationCode;

  /// Creates a new passwordless identity provider configuration.
  PasswordlessIdpConfig({
    required this.secretHashPepper,
    required this.resolveAuthUserId,
    final SerializeHandleFunction<THandle>? serializeHandle,
    final DeserializeHandleFunction<THandle>? deserializeHandle,
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
  }) : serializeHandle = serializeHandle ?? _defaultSerializeHandle<THandle>(),
       deserializeHandle =
           deserializeHandle ?? _defaultDeserializeHandle<THandle>();

  static SerializeHandleFunction<THandle> _defaultSerializeHandle<THandle>() =>
      (final handle) =>
          handle is String ? handle : SerializationManager.encode(handle);

  static DeserializeHandleFunction<THandle>
  _defaultDeserializeHandle<THandle>() =>
      (final handle) => THandle == String
      ? handle as THandle
      : proto.Protocol().deserialize<THandle>(handle);

  @override
  PasswordlessIdp<THandle> build({
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
class PasswordlessIdpConfigFromPasswords<THandle>
    extends PasswordlessIdpConfig<THandle> {
  /// Creates a new [PasswordlessIdpConfigFromPasswords] instance.
  PasswordlessIdpConfigFromPasswords({
    required super.resolveAuthUserId,
    super.fallbackSecretHashPeppers,
    super.secretHashSaltLength,
    super.serializeHandle,
    super.deserializeHandle,
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
