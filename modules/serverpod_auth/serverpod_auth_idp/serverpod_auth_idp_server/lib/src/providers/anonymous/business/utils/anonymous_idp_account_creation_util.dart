import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../../../providers/email.dart' show RateLimit;
import '../anonymous_idp_config.dart';

/// {@template anonymous_idp_account_creation_util}
/// Bundles utility function for the anonymous identity provider's account
/// creation purposes.
/// {@endtemplate}
class AnonymousIdpAccountCreationUtil {
  final AnonymousIdpAccountCreationUtilsConfig _config;
  final DatabaseRateLimitedRequestAttemptUtil<String>? _rateLimitUtil;
  final AuthUsers _authUsers;

  /// Creates a new [AnonymousIdpAccountCreationUtil] instance.
  AnonymousIdpAccountCreationUtil({
    required final AnonymousIdpAccountCreationUtilsConfig config,
    required final AuthUsers authUsers,
  }) : _config = config,
       _authUsers = authUsers,
       _rateLimitUtil = config.rateLimit != null
           ? DatabaseRateLimitedRequestAttemptUtil(
               RateLimitedRequestAttemptConfig(
                 domain: 'anonymous',
                 source: 'account_creation',
                 maxAttempts: config.rateLimit?.maxAttempts,
                 timeframe: config.rateLimit?.timeframe,
               ),
             )
           : null;

  /// Creates a new anonymous account.
  ///
  /// The optional [RateLimit] is enforced here if non-null.
  Future<AnonymousIdpAccountCreationResult> createAnonymousAccount(
    final Session session, {
    final Transaction? transaction,
  }) async {
    if (_rateLimitUtil != null) {
      await _rateLimitUtil.recordAttempt(
        session,
        nonce: '', // TODO: What to provide here?
        transaction: transaction,
      );

      final attemptCount = await _rateLimitUtil.countAttempts(
        session,
        nonce: '', // TODO: What to provide here?
        transaction: transaction,
      );

      if (attemptCount > _config.rateLimit!.maxAttempts) {
        throw AnonymousAccountBlockedException(
          reason: AnonymousAccountBlockedExceptionReason.throttled,
        );
      }
    }

    final newUser = await _authUsers.create(
      session,
      transaction: transaction,
    );

    await AnonymousAccount.db.insertRow(
      session,
      AnonymousAccount(
        authUserId: newUser.id,
      ),
      transaction: transaction,
    );

    await _config.onAfterAnonymousAccountCreated?.call(
      session,
      authUserId: newUser.id,
      transaction: transaction,
    );

    return AnonymousIdpAccountCreationResult._(
      authUserId: newUser.id,
      scopes: newUser.scopes,
    );
  }
}

/// Configuration for the [AnonymousIdpAccountCreationUtil] class.
class AnonymousIdpAccountCreationUtilsConfig {
  /// {@macro before_anonymous_account_created_function}
  final BeforeAnonymousAccountCreatedFunction? beforeAnonymousAccountCreated;

  /// {@macro after_anonymous_account_created_function}
  final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated;

  /// {@macro anonymous_idp_config.rate_limit}
  final RateLimit? rateLimit;

  /// Creates an [AnonymousIdpAccountCreationUtilsConfig] instance.
  const AnonymousIdpAccountCreationUtilsConfig({
    this.beforeAnonymousAccountCreated,
    this.onAfterAnonymousAccountCreated,
    this.rateLimit,
  });

  /// Creates a new [AnonymousIdpAccountCreationUtilsConfig] instance from an
  /// [AnonymousIdpConfig] instance.
  factory AnonymousIdpAccountCreationUtilsConfig.fromAnonymousIdpConfig(
    final AnonymousIdpConfig config,
  ) {
    return AnonymousIdpAccountCreationUtilsConfig(
      beforeAnonymousAccountCreated: config.beforeAnonymousAccountCreated,
      onAfterAnonymousAccountCreated: config.onAfterAnonymousAccountCreated,
      rateLimit: config.perIpAddressRateLimit,
    );
  }
}

/// The result of the [AnonymousIdpAccountCreationUtil.createAnonymousAccount]
/// operation.
class AnonymousIdpAccountCreationResult {
  /// The ID of the new authentication user.
  final UuidValue authUserId;

  /// The scopes of the new authentication user.
  final Set<Scope> scopes;

  const AnonymousIdpAccountCreationResult._({
    required this.authUserId,
    required this.scopes,
  });
}
