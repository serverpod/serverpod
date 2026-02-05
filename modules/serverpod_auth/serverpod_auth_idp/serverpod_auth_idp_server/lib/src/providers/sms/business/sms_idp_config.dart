import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../storage/phone_id_crypto_store.dart';
import '../storage/phone_id_hash_store.dart';
import '../storage/phone_id_store.dart';
import '../util/default_code_generators.dart';
import '../util/registration_password_policy.dart';
import 'sms_idp.dart';

export '../util/default_code_generators.dart';

/// Phone storage strategy for SMS authentication.
enum PhoneStorageStrategy {
  /// Store only a hash of the phone number (maximum privacy, cannot retrieve phone).
  hashOnly,

  /// Store encrypted phone number (can retrieve phone when needed).
  encrypted,
}

/// Function for sending out SMS verification codes.
typedef SendSmsVerificationCodeFunction = FutureOr<void> Function(
  Session session, {
  required String phone,
  required UuidValue requestId,
  required String verificationCode,
  required Transaction? transaction,
});

/// Function to check if a password meets the requirements.
typedef PasswordValidationFunction = bool Function(String password);

/// Function called after a new account is created.
typedef AfterAccountCreatedFunction = FutureOr<void> Function(
  Session session, {
  required UuidValue authUserId,
  required Transaction? transaction,
});

/// Function called after a phone is bound to a user.
typedef AfterPhoneBoundFunction = FutureOr<void> Function(
  Session session, {
  required UuidValue authUserId,
  required Transaction? transaction,
});

/// A rolling rate limit configuration.
class SmsRateLimit {
  /// The maximum number of attempts allowed within the timeframe.
  final int maxAttempts;

  /// The timeframe within which the attempts are allowed.
  final Duration timeframe;

  /// Creates a new [SmsRateLimit] instance.
  const SmsRateLimit({required this.maxAttempts, required this.timeframe});
}

/// {@template sms_idp_config}
/// Configuration options for the SMS identity provider.
/// {@endtemplate}
class SmsIdpConfig extends IdentityProviderBuilder<SmsIdp> {
  /// The pepper used for hashing passwords and verification codes.
  final String secretHashPepper;

  /// Optional fallback peppers for validating passwords created with previous peppers.
  final List<String> fallbackSecretHashPeppers;

  /// The length of the random salt in bytes for password hashing.
  final int secretHashSaltLength;

  /// The phone ID storage implementation.
  final PhoneIdStore phoneIdStore;

  /// Whether registration via SMS is enabled.
  final bool enableRegistration;

  /// Whether login via SMS is enabled.
  final bool enableLogin;

  /// Whether phone binding is enabled.
  final bool enableBind;

  /// Whether a password is required when logging in with an unregistered phone.
  final bool requirePasswordOnUnregisteredLogin;

  /// Whether users can change their bound phone number.
  final bool allowPhoneRebind;

  /// The lifetime of registration verification codes.
  final Duration registrationVerificationCodeLifetime;

  /// The number of allowed attempts for registration verification codes.
  final int registrationVerificationCodeAllowedAttempts;

  /// Function to generate registration verification codes.
  final String Function() registrationVerificationCodeGenerator;

  /// Rate limit for registration requests.
  final SmsRateLimit registrationRequestRateLimit;

  /// The lifetime of login verification codes.
  final Duration loginVerificationCodeLifetime;

  /// The number of allowed attempts for login verification codes.
  final int loginVerificationCodeAllowedAttempts;

  /// Function to generate login verification codes.
  final String Function() loginVerificationCodeGenerator;

  /// Rate limit for login requests.
  final SmsRateLimit loginRequestRateLimit;

  /// The lifetime of bind verification codes.
  final Duration bindVerificationCodeLifetime;

  /// The number of allowed attempts for bind verification codes.
  final int bindVerificationCodeAllowedAttempts;

  /// Function to generate bind verification codes.
  final String Function() bindVerificationCodeGenerator;

  /// Rate limit for bind requests.
  final SmsRateLimit bindRequestRateLimit;

  /// Callback for sending registration verification codes.
  final SendSmsVerificationCodeFunction? sendRegistrationVerificationCode;

  /// Callback for sending login verification codes.
  final SendSmsVerificationCodeFunction? sendLoginVerificationCode;

  /// Callback for sending bind verification codes.
  final SendSmsVerificationCodeFunction? sendBindVerificationCode;

  /// Function to validate passwords during registration.
  final PasswordValidationFunction passwordValidationFunction;

  /// Callback invoked after a new account is created.
  final AfterAccountCreatedFunction? onAfterAccountCreated;

  /// Callback invoked after a phone is bound.
  final AfterPhoneBoundFunction? onAfterPhoneBound;

  /// Creates a new SMS identity provider configuration.
  const SmsIdpConfig({
    required this.secretHashPepper,
    required this.phoneIdStore,
    this.fallbackSecretHashPeppers = const [],
    this.secretHashSaltLength = 16,
    this.enableRegistration = true,
    this.enableLogin = true,
    this.enableBind = true,
    this.requirePasswordOnUnregisteredLogin = true,
    this.allowPhoneRebind = false,
    this.registrationVerificationCodeLifetime = const Duration(minutes: 15),
    this.registrationVerificationCodeAllowedAttempts = 3,
    this.registrationVerificationCodeGenerator =
        defaultSmsVerificationCodeGenerator,
    this.registrationRequestRateLimit = const SmsRateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 15),
    ),
    this.loginVerificationCodeLifetime = const Duration(minutes: 10),
    this.loginVerificationCodeAllowedAttempts = 3,
    this.loginVerificationCodeGenerator = defaultSmsVerificationCodeGenerator,
    this.loginRequestRateLimit = const SmsRateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 10),
    ),
    this.bindVerificationCodeLifetime = const Duration(minutes: 10),
    this.bindVerificationCodeAllowedAttempts = 3,
    this.bindVerificationCodeGenerator = defaultSmsVerificationCodeGenerator,
    this.bindRequestRateLimit = const SmsRateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 10),
    ),
    this.sendRegistrationVerificationCode,
    this.sendLoginVerificationCode,
    this.sendBindVerificationCode,
    this.passwordValidationFunction =
        defaultSmsRegistrationPasswordValidationFunction,
    this.onAfterAccountCreated,
    this.onAfterPhoneBound,
  });

  @override
  SmsIdp build({
    required TokenManager tokenManager,
    required AuthUsers authUsers,
    required UserProfiles userProfiles,
  }) {
    return SmsIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [SmsIdpConfig] instance from passwords.yaml configuration.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class SmsIdpConfigFromPasswords extends SmsIdpConfig {
  /// Creates a new [SmsIdpConfigFromPasswords] instance.
  ///
  /// The [phoneStorageStrategy] determines how phone numbers are stored:
  /// - [PhoneStorageStrategy.hashOnly]: Only stores a hash (default, maximum privacy)
  /// - [PhoneStorageStrategy.encrypted]: Stores encrypted phone for retrieval
  SmsIdpConfigFromPasswords({
    PhoneStorageStrategy phoneStorageStrategy = PhoneStorageStrategy.hashOnly,
    super.fallbackSecretHashPeppers,
    super.secretHashSaltLength,
    super.enableRegistration,
    super.enableLogin,
    super.enableBind,
    super.requirePasswordOnUnregisteredLogin,
    super.allowPhoneRebind,
    super.registrationVerificationCodeLifetime,
    super.registrationVerificationCodeAllowedAttempts,
    super.registrationVerificationCodeGenerator,
    super.registrationRequestRateLimit,
    super.loginVerificationCodeLifetime,
    super.loginVerificationCodeAllowedAttempts,
    super.loginVerificationCodeGenerator,
    super.loginRequestRateLimit,
    super.bindVerificationCodeLifetime,
    super.bindVerificationCodeAllowedAttempts,
    super.bindVerificationCodeGenerator,
    super.bindRequestRateLimit,
    super.sendRegistrationVerificationCode,
    super.sendLoginVerificationCode,
    super.sendBindVerificationCode,
    super.passwordValidationFunction,
    super.onAfterAccountCreated,
    super.onAfterPhoneBound,
  }) : super(
          secretHashPepper: _getPasswordOrThrow('smsSecretHashPepper'),
          phoneIdStore: _createPhoneIdStore(phoneStorageStrategy),
        );

  static String _getPasswordOrThrow(String key) {
    final value = Serverpod.instance.getPassword(key);
    if (value == null || value.isEmpty) {
      throw StateError('$key must be configured in passwords.');
    }
    return value;
  }

  static PhoneIdStore _createPhoneIdStore(PhoneStorageStrategy strategy) {
    switch (strategy) {
      case PhoneStorageStrategy.hashOnly:
        return PhoneIdHashStore.fromPasswords(Serverpod.instance);
      case PhoneStorageStrategy.encrypted:
        return PhoneIdCryptoStore.fromPasswords(Serverpod.instance);
    }
  }
}
