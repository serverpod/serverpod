import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/anonymous/business/anonymous_idp.dart';
import '../../../../../core.dart';

/// {@template before_anonymous_account_created_function}
/// Function to be called before a new anonymous account is created. This
/// function should throw an exception if a new anonymous account is not allowed
/// to be created for any reason, or return void otherwise. This mechanism is how
/// an application would prevent abuse of the anonymous account creation process.
/// {@endtemplate}
typedef BeforeAnonymousAccountCreatedFunction =
    FutureOr<void> Function(
      Session session, {
      String? token,
      required Transaction? transaction,
    });

/// {@template after_anonymous_account_created_function}
/// Function to be called after a new anonymous account has been created.
/// {@endtemplate}
typedef AfterAnonymousAccountCreatedFunction =
    FutureOr<void> Function(
      Session session, {
      required UuidValue authUserId,
      required Transaction? transaction,
    });

/// {@template anonymous_idp_config}
/// Configuration for the anonymous identity provider.
/// {@endtemplate}
class AnonymousIdpConfig extends IdentityProviderBuilder<AnonymousIdp> {
  /// {@macro before_anonymous_account_created_function}
  final BeforeAnonymousAccountCreatedFunction? onBeforeAnonymousAccountCreated;

  /// {@macro after_anonymous_account_created_function}
  final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated;

  /// {@template anonymous_idp_config.rate_limit}
  /// The maximum rate of anonymous accounts that can be created from a single
  /// IP address.
  /// {@endtemplate}
  final AnonymousIdpLoginRateLimitingConfig? perIpAddressRateLimitConfig;

  /// Creates a new [AnonymousIdpConfig].
  const AnonymousIdpConfig._({
    required this.onBeforeAnonymousAccountCreated,
    required this.onAfterAnonymousAccountCreated,
    required this.perIpAddressRateLimitConfig,
  });

  /// Creates a new [AnonymousIdpConfig] with optional rate limiting. If no
  /// rate limiting value is provided, none will be used and requests will not
  /// be throttled.
  factory AnonymousIdpConfig({
    final BeforeAnonymousAccountCreatedFunction?
    onBeforeAnonymousAccountCreated,
    final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated,
    final AnonymousIdpLoginRateLimitingConfig? perIpAddressRateLimitConfig,
  }) => AnonymousIdpConfig._(
    onBeforeAnonymousAccountCreated: onBeforeAnonymousAccountCreated,
    onAfterAnonymousAccountCreated: onAfterAnonymousAccountCreated,
    perIpAddressRateLimitConfig: perIpAddressRateLimitConfig,
  );

  /// Creates a new [AnonymousIdpConfig] with rate limiting enabled. If no
  /// rate limiting value is provided, a default value will be used.
  factory AnonymousIdpConfig.rateLimited({
    final BeforeAnonymousAccountCreatedFunction?
    onBeforeAnonymousAccountCreated,
    final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated,
    final AnonymousIdpLoginRateLimitingConfig? perIpAddressRateLimitConfig,
  }) => AnonymousIdpConfig(
    onBeforeAnonymousAccountCreated: onBeforeAnonymousAccountCreated,
    onAfterAnonymousAccountCreated: onAfterAnonymousAccountCreated,
    perIpAddressRateLimitConfig:
        perIpAddressRateLimitConfig ??
        AnonymousIdpLoginRateLimitingConfig.defaultConfig(),
  );

  @override
  AnonymousIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return AnonymousIdp(
      this,
      tokenManager: tokenManager,
      userProfiles: userProfiles,
    );
  }
}

/// Rate limiting configuration for anonymous login.
class AnonymousIdpLoginRateLimitingConfig
    extends RateLimitedRequestAttemptConfig<String> {
  /// Creates an instance of [AnonymousIdpLoginRateLimitingConfig].
  ///
  /// The parameters `nonceToString` and `nonceFromString` are not accepted
  /// because the nonce type is `String`.
  AnonymousIdpLoginRateLimitingConfig({
    required super.maxAttempts,
    required super.timeframe,
    super.defaultExtraData,
    super.onRateLimitExceeded,
  }) : super(
         domain: 'anonymous-idp-login',
         source: 'account-creation',
         nonceToString: (final String nonce) => nonce,
         nonceFromString: (final String nonce) => nonce,
       );

  /// Creates an instance of [AnonymousIdpLoginRateLimitingConfig] with default
  /// values.
  ///
  /// The parameters `nonceToString` and `nonceFromString` are not accepted
  /// because the nonce type is `String`.
  factory AnonymousIdpLoginRateLimitingConfig.defaultConfig({
    final Map<String, String>? defaultExtraData,
    final Future<void> Function(Session session, String nonce)?
    onRateLimitExceeded,
  }) => AnonymousIdpLoginRateLimitingConfig(
    maxAttempts: 100,
    timeframe: const Duration(hours: 1),
    defaultExtraData: defaultExtraData,
    onRateLimitExceeded: onRateLimitExceeded,
  );
}
