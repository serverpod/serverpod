import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'anonymous_idp_config.dart';
import 'anonymous_idp_utils.dart';

/// Main class for the anonymous identity provider.
/// The methods defined here are intended to be called from an endpoint.
class AnonymousIdp {
  /// The method used when authenticating with the anonymous identity provider.
  static const String method = 'anonymous';

  /// The configuration for the anonymous identity provider.
  final AnonymousIdpConfig config;

  /// Utility functions for the anonymous identity provider.
  final AnonymousIdpUtils utils;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;

  AnonymousIdp._(
    this.config,
    this.utils,
    this._authUsers,
    this._userProfiles,
    this._tokenManager,
  );

  /// Creates a new instance of [AnonymousIdp].
  factory AnonymousIdp(
    final AnonymousIdpConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = AnonymousIdpUtils(config: config, authUsers: authUsers);
    return AnonymousIdp._(
      config,
      utils,
      authUsers,
      userProfiles,
      tokenManager,
    );
  }

  /// {@macro anonymous_account_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    final String? token,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        UuidValue? authUserId;
        if (config.onBeforeAnonymousAccountCreated != null) {
          try {
            authUserId = await config.onBeforeAnonymousAccountCreated!(
              session,
              token: token,
              transaction: transaction,
            );
          } catch (e) {
            session.log('onBeforeAnonymousAccountCreated failed: $e');
            throw AnonymousAccountBlockedException(
              reason: AnonymousAccountBlockedExceptionReason.denied,
            );
          }
        }

        late Set<Scope> scopes;
        if (authUserId == null) {
          // This request is not attached to an existing account, so create all
          // new records.
          final result = await utils.createAnonymousAccount(
            session,
            transaction: transaction,
          );
          authUserId = result.authUserId;
          await _userProfiles.createUserProfile(
            session,
            result.authUserId,
            UserProfileData(),
            transaction: transaction,
          );
          scopes = result.scopes;
        } else {
          // By hook or by crook, this request was attached to an existing
          // account, so use existing records.
          final authUser = await _authUsers.get(
            session,
            authUserId: authUserId,
            transaction: transaction,
          );
          authUserId = authUser.id;
          scopes = authUser.scopes;
        }

        return _tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: method,
          scopes: scopes,
          transaction: transaction,
        );
      },
    );
  }
}

/// Extension to get the EmailIdp instance from the AuthServices.
extension AnonymousIdpGetter on AuthServices {
  /// Returns the EmailIdp instance from the AuthServices.
  AnonymousIdp get anonymousIdp =>
      AuthServices.getIdentityProvider<AnonymousIdp>();
}
