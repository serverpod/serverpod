import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import '../../utils/default_code_generators.dart';
import 'passwordless_idp.dart';
import 'utils/passwordless_login_request_store.dart';

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

/// Function for converting a handle to a stable serialized string.
typedef SerializeHandleFunction<THandle> = String Function(THandle handle);

/// Function for reading a handle from its serialized representation.
typedef DeserializeHandleFunction<THandle> = THandle Function(String handle);

/// Function for resolving an auth user id from a handle.
typedef ResolveAuthUserIdFunction<THandle> =
    FutureOr<UuidValue> Function(
      Session session, {
      required THandle handle,
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
class PasswordlessIdpConfig<THandle>
    extends IdentityProviderBuilder<PasswordlessIdp<THandle>> {
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

  /// Function for normalizing a login handle before using it.
  ///
  /// Defaults to trimming whitespace.
  final NormalizeHandleFunction normalizeHandle;

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
  final PasswordlessRateLimit loginRequestRateLimit;

  /// Callback for sending login verification codes.
  ///
  /// This is optional. If `null`, no verification code will be delivered.
  final SendPasswordlessVerificationCodeFunction? sendLoginVerificationCode;

  /// Callback for resolving which auth user should be signed in after a login
  /// request has been verified.
  ///
  /// If `null`, calling [PasswordlessIdp.finishLogin] will throw.
  final ResolveAuthUserIdFunction<THandle>? resolveAuthUserId;

  /// Custom request store for passwordless login requests.
  final PasswordlessLoginRequestStore loginRequestStore;

  /// Creates a new passwordless identity provider configuration.
  PasswordlessIdpConfig({
    required this.secretHashPepper,
    this.fallbackSecretHashPeppers = const [],
    this.secretHashSaltLength = 16,
    this.normalizeHandle = _defaultNormalizeHandle,
    final SerializeHandleFunction<THandle>? serializeHandle,
    final DeserializeHandleFunction<THandle>? deserializeHandle,
    this.loginVerificationCodeLifetime = const Duration(minutes: 10),
    this.loginVerificationCodeAllowedAttempts = 3,
    this.loginVerificationCodeGenerator =
        defaultNumericVerificationCodeGenerator,
    this.loginRequestRateLimit = const PasswordlessRateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 10),
    ),
    this.sendLoginVerificationCode,
    this.resolveAuthUserId,
    required this.loginRequestStore,
  }) : serializeHandle = _resolveSerializeHandle(serializeHandle),
       deserializeHandle = _resolveDeserializeHandle(deserializeHandle);

  static String _defaultNormalizeHandle(final String handle) => handle.trim();

  static SerializeHandleFunction<THandle> _resolveSerializeHandle<THandle>(
    final SerializeHandleFunction<THandle>? serializeHandle,
  ) {
    if (serializeHandle != null) return serializeHandle;
    _ensureDefaultHandleTypeIsSupported<THandle>();
    return (final handle) => _serializeDefaultHandle<THandle>(handle);
  }

  static DeserializeHandleFunction<THandle> _resolveDeserializeHandle<THandle>(
    final DeserializeHandleFunction<THandle>? deserializeHandle,
  ) {
    if (deserializeHandle != null) return deserializeHandle;
    _ensureDefaultHandleTypeIsSupported<THandle>();
    return (final handle) => _deserializeDefaultHandle<THandle>(handle);
  }

  static void _ensureDefaultHandleTypeIsSupported<THandle>() {
    if (THandle == String || THandle == int || THandle == UuidValue) return;
    throw ArgumentError(
      'serializeHandle and deserializeHandle must be provided when THandle '
      'is not one of the supported basic types: String, int, UuidValue.',
    );
  }

  static String _serializeDefaultHandle<THandle>(final THandle handle) =>
      switch (handle) {
        String() => handle,
        int() => handle.toString(),
        UuidValue() => handle.uuid,
        _ => throw UnimplementedError(),
      };

  static THandle _deserializeDefaultHandle<THandle>(final String handle) {
    if (THandle == String) {
      return handle as THandle;
    }
    if (THandle == int) {
      return int.parse(handle) as THandle;
    }
    if (THandle == UuidValue) {
      return UuidValue.withValidation(handle) as THandle;
    }
    throw UnimplementedError();
  }

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
    super.fallbackSecretHashPeppers,
    super.secretHashSaltLength,
    super.normalizeHandle,
    super.serializeHandle,
    super.deserializeHandle,
    super.loginVerificationCodeLifetime,
    super.loginVerificationCodeAllowedAttempts,
    super.loginVerificationCodeGenerator,
    super.loginRequestRateLimit,
    super.sendLoginVerificationCode,
    super.resolveAuthUserId,
    required super.loginRequestStore,
  }) : super(
         secretHashPepper: Serverpod.instance.getPasswordOrThrow(
           'passwordlessSecretHashPepper',
         ),
       );
}
