import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
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
    final RateLimit? perIpAddressRateLimit,
  }) => AnonymousIdpConfig._(
    onBeforeAnonymousAccountCreated: onBeforeAnonymousAccountCreated,
    onAfterAnonymousAccountCreated: onAfterAnonymousAccountCreated,
    perIpAddressRateLimitConfig:
        AnonymousIdpLoginRateLimitingConfig.fromRateLimit(
          rateLimit:
              perIpAddressRateLimit ??
              AnonymousIdpLoginRateLimitingConfig.defaultRateLimit,
        ),
  );

  /// Creates a new [AnonymousIdpConfig] with completely customized rate
  /// limiting.
  factory AnonymousIdpConfig.customRateLimiting({
    required final AnonymousIdpLoginRateLimitingConfig
    perIpAddressRateLimitConfig,
    final BeforeAnonymousAccountCreatedFunction?
    onBeforeAnonymousAccountCreated,
    final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated,
  }) => AnonymousIdpConfig._(
    onBeforeAnonymousAccountCreated: onBeforeAnonymousAccountCreated,
    onAfterAnonymousAccountCreated: onAfterAnonymousAccountCreated,
    perIpAddressRateLimitConfig: perIpAddressRateLimitConfig,
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
  /// Default maximum number of attempts within [defaultTimeframe].
  static const defaultMaxAttempts = 100;

  /// Default window for which attempts are capped to [defaultMaxAttempts].
  static const defaultTimeframe = Duration(hours: 1);

  /// Default [RateLimit].
  static const defaultRateLimit = RateLimit(
    maxAttempts: defaultMaxAttempts,
    timeframe: defaultTimeframe,
  );

  /// Creates an instance of [AnonymousIdpLoginRateLimitingConfig].
  ///
  /// The parameters `nonceToString` and `nonceFromString` are not accepted
  /// because the nonce type is `String`.
  AnonymousIdpLoginRateLimitingConfig({
    super.maxAttempts = defaultMaxAttempts,
    super.timeframe = defaultTimeframe,
    super.defaultExtraData,
    super.onRateLimitExceeded,
  }) : super(
         domain: 'anonymous-idp-login',
         source: 'account-creation',
         nonceToString: (final String nonce) => nonce,
         nonceFromString: (final String nonce) => nonce,
       );

  /// Creates an instance of [AnonymousIdpLoginRateLimitingConfig] from a
  /// [RateLimit] value.
  ///
  /// The parameters `nonceToString` and `nonceFromString` are not accepted
  /// because the nonce type is `String`.
  factory AnonymousIdpLoginRateLimitingConfig.fromRateLimit({
    required final RateLimit rateLimit,
    final Map<String, String>? defaultExtraData,
    final Future<void> Function(Session session, String nonce)?
    onRateLimitExceeded,
  }) => AnonymousIdpLoginRateLimitingConfig(
    maxAttempts: rateLimit.maxAttempts,
    timeframe: rateLimit.timeframe,
    defaultExtraData: defaultExtraData,
    onRateLimitExceeded: onRateLimitExceeded,
  );
}
