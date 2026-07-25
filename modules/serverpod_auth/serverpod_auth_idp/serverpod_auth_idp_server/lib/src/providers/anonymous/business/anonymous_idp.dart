import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'anonymous_idp_config.dart';
import 'anonymous_idp_utils.dart';

/// Main class for the anonymous identity provider.
/// The methods defined here are intended to be called from an endpoint.
class AnonymousIdp implements IdentityProvider {
  /// The method used when authenticating with the anonymous identity provider.
  @override
  String get method => 'anonymous';

  /// The configuration for the anonymous identity provider.
  final AnonymousIdpConfig config;

  /// Utility functions for the anonymous identity provider.
  final AnonymousIdpUtils utils;

  final TokenManager _tokenManager;
  final UserProfiles _userProfiles;

  AnonymousIdp._(
    this.config,
    this.utils,
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
        if (config.onBeforeAnonymousAccountCreated != null) {
          try {
            await config.onBeforeAnonymousAccountCreated!(
              session,
              token: token,
              transaction: transaction,
            );
          } on Exception catch (e, st) {
            session.log(
              'Exception in onBeforeAnonymousAccountCreated',
              exception: e,
              stackTrace: st,
            );
            throw AnonymousAccountBlockedException(
              reason: AnonymousAccountBlockedExceptionReason.denied,
            );
          }
        }

        final result = await utils.createAnonymousAccount(
          session,
          transaction: transaction,
        );
        await _userProfiles.createUserProfile(
          session,
          result.authUserId,
          UserProfileData(),
          transaction: transaction,
        );

        return _tokenManager.issueToken(
          session,
          authUserId: result.authUserId,
          method: method,
          scopes: result.scopes,
          transaction: transaction,
        );
      },
    );
  }

  /// Anonymous accounts do not retain provider data when auth users are
  /// merged. Their database records are removed with the discarded auth user.
  @override
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {}
}

/// Extension to get the EmailIdp instance from the AuthServices.
extension AnonymousIdpGetter on AuthServices {
  /// Returns the EmailIdp instance from the AuthServices.
  AnonymousIdp get anonymousIdp =>
      AuthServices.getIdentityProvider<AnonymousIdp>();
}
