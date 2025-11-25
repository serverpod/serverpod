import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../../providers/email.dart';

/// AuthServices factory for creating [EmailIDP] instances.
class EmailIdentityProviderFactory extends IdentityProviderFactory<EmailIDP> {
  /// The configuration that will be used to create the [EmailIDP].
  final EmailIDPConfig config;

  /// Creates a new [EmailIdentityProviderFactory].
  EmailIdentityProviderFactory(
    this.config,
  );

  @override
  EmailIDP construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
    final Serverpod? pod,
  }) {
    return EmailIDP(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }

  /// Creates a new [EmailIdentityProviderFactory] from keys.
  factory EmailIdentityProviderFactory.fromKeys(
    final String? Function(String key) getConfig, {
    final Duration registrationVerificationCodeLifetime = const Duration(
      minutes: 15,
    ),
    final int registrationVerificationCodeAllowedAttempts = 3,
    final String Function() registrationVerificationCodeGenerator =
        defaultVerificationCodeGenerator,
    final Duration passwordResetVerificationCodeLifetime = const Duration(
      minutes: 15,
    ),
    final int passwordResetVerificationCodeAllowedAttempts = 3,
    final String Function() passwordResetVerificationCodeGenerator =
        defaultVerificationCodeGenerator,
    final SendRegistrationVerificationCodeFunction?
    sendRegistrationVerificationCode,
    final SendPasswordResetVerificationCodeFunction?
    sendPasswordResetVerificationCode,
    final OnPasswordResetCompletedFunction? onPasswordResetCompleted,
    final RateLimit failedLoginRateLimit = const RateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 5),
    ),
    final PasswordValidationFunction passwordValidationFunction =
        defaultRegistrationPasswordValidationFunction,
    final RateLimit maxPasswordResetAttempts = const RateLimit(
      timeframe: Duration(hours: 1),
      maxAttempts: 3,
    ),
    final int secretHashSaltLength = 16,
  }) {
    const secretHashPepperKey = 'emailSecretHashPepper';

    final secretHashPepper = getConfig(secretHashPepperKey);
    if (secretHashPepper == null) {
      throw StateError(
        'Missing required keys for Email IDP configuration: "$secretHashPepperKey".',
      );
    }

    return EmailIdentityProviderFactory(
      EmailIDPConfig(
        secretHashPepper: secretHashPepper,
        registrationVerificationCodeLifetime:
            registrationVerificationCodeLifetime,
        registrationVerificationCodeAllowedAttempts:
            registrationVerificationCodeAllowedAttempts,
        registrationVerificationCodeGenerator:
            registrationVerificationCodeGenerator,
        passwordResetVerificationCodeLifetime:
            passwordResetVerificationCodeLifetime,
        passwordResetVerificationCodeAllowedAttempts:
            passwordResetVerificationCodeAllowedAttempts,
        passwordResetVerificationCodeGenerator:
            passwordResetVerificationCodeGenerator,
        sendRegistrationVerificationCode: sendRegistrationVerificationCode,
        sendPasswordResetVerificationCode: sendPasswordResetVerificationCode,
        onPasswordResetCompleted: onPasswordResetCompleted,
        failedLoginRateLimit: failedLoginRateLimit,
        passwordValidationFunction: passwordValidationFunction,
        maxPasswordResetAttempts: maxPasswordResetAttempts,
        secretHashSaltLength: secretHashSaltLength,
      ),
    );
  }
}

/// Extension to get the EmailIDP instance from the AuthServices.
extension EmailIDPGetter on AuthServices {
  /// Returns the EmailIDP instance from the AuthServices.
  EmailIDP get emailIDP => AuthServices.getIdentityProvider<EmailIDP>();
}
