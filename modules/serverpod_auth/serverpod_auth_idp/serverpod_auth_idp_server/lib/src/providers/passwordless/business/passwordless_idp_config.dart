import 'dart:async';
import 'dart:convert' show jsonDecode;

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

/// Function for parsing a handle string into [THandle].
///
/// This is used both for the incoming RPC `String handle` and for reading back
/// persisted handle strings previously produced by [SerializeHandleFunction].
///
/// Throw [FormatException] for invalid handle strings. Other exception types
/// are treated as integrator bugs and are not remapped by the framework.
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

/// Function for sending out passwordless verification codes.
typedef SendPasswordlessVerificationCodeFunction<THandle> =
    FutureOr<void> Function(
      Session session, {
      required THandle handle,
      required UuidValue requestId,
      required String verificationCode,
      required Transaction? transaction,
    });

/// Function for converting a handle to a stable serialized string.
///
/// The returned string must round-trip through [DeserializeHandleFunction],
/// since it is persisted during `startLogin()` and parsed again in
/// `finishLogin()`.
typedef SerializeHandleFunction<THandle> = String Function(THandle handle);

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
  ///
  /// The returned value must remain parseable by [deserializeHandle].
  final SerializeHandleFunction<THandle> serializeHandle;

  /// Function for parsing a handle string.
  ///
  /// This is used for both inbound RPC input and for stored handle strings
  /// previously produced by [serializeHandle].
  final DeserializeHandleFunction<THandle> deserializeHandle;

  /// The lifetime of login verification codes.
  final Duration loginVerificationCodeLifetime;

  /// Maximum number of recorded failed verification attempts allowed per login
  /// request within [loginVerificationCodeLifetime].
  ///
  /// Counting is keyed by the pending login request id. The stored attempt
  /// count is compared to this limit before the rest of verification runs; when
  /// already at the limit, no additional row is recorded.
  ///
  /// A failed attempt is recorded when the code does not match, when the
  /// request or challenge cannot be loaded, or when the request row is missing
  /// after a matching code (for example concurrent completion). Successful
  /// verification and failures due to expiration do not increase the count.
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
  /// for the serialized handle.
  final RateLimit loginRequestRateLimit;

  /// Callback for sending login verification codes.
  ///
  /// Receives the parsed [THandle] that was created from the incoming
  /// `String handle`, before the handle is persisted.
  ///
  /// The same logical handle is later recovered from the persisted serialized
  /// string and passed to [resolveAuthUserId].
  ///
  /// This is optional. If `null`, no verification code will be delivered.
  /// This allows integrators to deliver codes through other channels.
  ///
  /// The callback runs inside the same database transaction as the created
  /// login request. If it throws, that transaction rolls back and no pending
  /// request row is left, but the login attempt recorded for
  /// [loginRequestRateLimit] is **not** rolled back (see [loginRequestRateLimit]).
  final SendPasswordlessVerificationCodeFunction<THandle>?
  sendLoginVerificationCode;

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

  static Object _decodeSerializedHandle(final String handle) {
    try {
      return jsonDecode(handle);
    } on FormatException {
      return handle;
    }
  }

  static DeserializeHandleFunction<THandle>
  _defaultDeserializeHandle<THandle>() => (final handle) {
    if (THandle == String) return handle as THandle;
    // SerializationManager.encode produces JSON (e.g. '42' for int,
    // '"uuid-str"' for UuidValue). Decode the JSON first so that
    // Protocol().deserialize receives the native type it expects.
    // For raw endpoint strings that are not valid JSON (e.g. a bare
    // UUID), fall back to passing the string directly.
    final decodedHandle = _decodeSerializedHandle(handle);
    try {
      return proto.Protocol().deserialize<THandle>(decodedHandle);
    } on FormatException {
      throw FormatException('Invalid passwordless handle.', handle);
    } on TypeError {
      throw FormatException('Invalid passwordless handle.', handle);
    } on DeserializationTypeNotFoundException catch (e) {
      if (e.type == THandle) rethrow;
      throw FormatException('Invalid passwordless handle.', handle);
    }
  };

  static SerializeHandleFunction<THandle> _defaultSerializeHandle<THandle>() =>
      (final handle) {
        if (handle is String) return handle;
        final encoded = SerializationManager.encode(handle);
        // SerializationManager.encode produces JSON, which wraps string-valued
        // types (e.g. UuidValue) in quotes. Unwrap so that the stored value is
        // a plain string suitable for DB equality queries and display.
        final decoded = jsonDecode(encoded);
        return decoded is String ? decoded : encoded;
      };
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
