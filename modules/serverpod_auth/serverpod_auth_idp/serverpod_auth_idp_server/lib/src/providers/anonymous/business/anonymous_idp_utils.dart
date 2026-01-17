import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/utils/session_extension.dart';

import '../../../../../core.dart';
import 'anonymous_idp_config.dart';

/// Anonymous account management functions.
class AnonymousIdpUtils {
  final DatabaseRateLimitedRequestAttemptUtil<String>? _rateLimitUtil;

  /// {@macro anonymous_idp_config}
  final AnonymousIdpConfig config;

  /// {@macro auth_users}
  final AuthUsers _authUsers;

  /// Creates a new instance of [AnonymousIdpUtils].
  AnonymousIdpUtils({
    required this.config,
    final AuthUsers authUsers = const AuthUsers(),
  }) : _authUsers = authUsers,
       _rateLimitUtil = config.perIpAddressRateLimit != null
           ? DatabaseRateLimitedRequestAttemptUtil(
               RateLimitedRequestAttemptConfig(
                 domain: 'anonymous',
                 source: 'account_creation',
                 maxAttempts: config.perIpAddressRateLimit?.maxAttempts,
                 timeframe: config.perIpAddressRateLimit?.timeframe,
                 onRateLimitExceeded: (final session, final nonce) {
                   throw AnonymousAccountBlockedException(
                     reason:
                         AnonymousAccountBlockedExceptionReason.tooManyAttempts,
                   );
                 },
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
    // Check rate limit and either throw or proceed.
    await _rateLimitUtil?.hasTooManyAttempts(
      session,
      nonce: session.remoteIpAddress.toString(),
    );

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

    await config.onAfterAnonymousAccountCreated?.call(
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
