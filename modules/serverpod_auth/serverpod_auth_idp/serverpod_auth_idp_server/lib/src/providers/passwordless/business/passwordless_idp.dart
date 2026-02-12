import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_server_exceptions.dart';
import 'passwordless_idp_utils.dart';

/// Main class for the passwordless identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
///
/// The `utils` property provides access to [PasswordlessIdpUtils], which contains
/// utility methods for working with passwordless login requests.
class PasswordlessIdp {
  /// The method used when authenticating with the passwordless identity provider.
  static const String method = 'passwordless';

  /// The configuration for the passwordless identity provider.
  final PasswordlessIdpConfig config;

  /// Utility functions for the passwordless identity provider.
  final PasswordlessIdpUtils utils;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;

  PasswordlessIdp._(
    this.config,
    this.utils,
    this._tokenManager,
    this._authUsers,
  );

  /// Creates a new instance of [PasswordlessIdp].
  factory PasswordlessIdp(
    final PasswordlessIdpConfig config, {
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
  }) {
    final utils = PasswordlessIdpUtils(config: config);
    return PasswordlessIdp._(config, utils, tokenManager, authUsers);
  }

  /// Starts the login process.
  ///
  /// Returns the login request ID.
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    final Transaction? transaction,
  }) async {
    if (!config.enableLogin) {
      throw PasswordlessLoginException(
        reason: PasswordlessLoginExceptionReason.invalid,
      );
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          PasswordlessIdpUtils.withReplacedServerPasswordlessException(
            () => utils.login.startLogin(
              session,
              handle: handle,
              transaction: transaction,
            ),
          ),
    );
  }

  /// Verifies the login code.
  ///
  /// Returns a completion token to be used with [finishLogin].
  Future<String> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          PasswordlessIdpUtils.withReplacedServerPasswordlessException(
            () => utils.login.verifyLoginCode(
              session,
              loginRequestId: loginRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          ),
    );
  }

  /// Finishes the login process.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final String loginToken,
    final Transaction? transaction,
  }) async {
    if (!config.enableLogin) {
      throw PasswordlessLoginException(
        reason: PasswordlessLoginExceptionReason.invalid,
      );
    }

    final resolveAuthUserId = config.resolveAuthUserId;
    if (resolveAuthUserId == null) {
      throw StateError(
        'PasswordlessIdpConfig.resolveAuthUserId must be set to use finishLogin.',
      );
    }

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          PasswordlessIdpUtils.withReplacedServerPasswordlessException(
            () async {
              final request = await utils.login.completeLogin(
                session,
                loginToken: loginToken,
                transaction: transaction,
              );

              final authUserId = await resolveAuthUserId(
                session,
                nonce: request.nonce,
                transaction: transaction,
              );

              final authUser = await _authUsers.get(
                session,
                authUserId: authUserId,
                transaction: transaction,
              );

              final isDeleted = await utils.login.deleteRequest(
                session,
                requestId: request.id,
                transaction: transaction,
              );
              if (!isDeleted) {
                throw PasswordlessLoginNotFoundException();
              }

              return _tokenManager.issueToken(
                session,
                authUserId: authUserId,
                method: method,
                scopes: authUser.scopes,
                transaction: transaction,
              );
            },
          ),
    );
  }
}

/// Extension to get the PasswordlessIdp instance from the AuthServices.
extension PasswordlessIdpGetter on AuthServices {
  /// Returns the PasswordlessIdp instance from the AuthServices.
  PasswordlessIdp get passwordlessIdp =>
      AuthServices.getIdentityProvider<PasswordlessIdp>();
}
