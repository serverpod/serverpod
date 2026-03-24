import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_server_exceptions.dart';
import 'utils/passwordless_idp_login_util.dart';

/// Main class for the passwordless identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
class PasswordlessIdp<THandle> {
  /// The method used when authenticating with the passwordless identity
  /// provider.
  static const String method = 'passwordless';

  /// The configuration for the passwordless identity provider.
  final PasswordlessIdpConfig<THandle> config;

  final PasswordlessIdpLoginUtil<THandle> _loginUtil;
  final TokenManager _tokenManager;
  final AuthUsers _authUsers;

  PasswordlessIdp._(
    this.config,
    this._loginUtil,
    this._tokenManager,
    this._authUsers,
  );

  /// Creates a new instance of [PasswordlessIdp].
  factory PasswordlessIdp(
    final PasswordlessIdpConfig<THandle> config, {
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
  }) {
    final loginUtil = PasswordlessIdpLoginUtil<THandle>(config: config);
    return PasswordlessIdp._(config, loginUtil, tokenManager, authUsers);
  }

  /// Starts the login process.
  ///
  /// Returns the login request ID.
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _withReplacedServerException(
        () => _loginUtil.startLogin(
          session,
          handle: handle,
          transaction: transaction,
        ),
      ),
    );
  }

  /// Verifies the login code and finishes the login process in one step.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _withReplacedServerException(
        () async {
          final request = await _loginUtil.verifyAndCompleteLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          );

          final THandle handle;
          try {
            handle = config.deserializeHandle(request.serializedHandle);
          } catch (_) {
            throw PasswordlessLoginInvalidException();
          }

          final authUserId = await config.resolveAuthUserId(
            session,
            handle: handle,
            transaction: transaction,
          );

          final authUser = await _authUsers.get(
            session,
            authUserId: authUserId,
            transaction: transaction,
          );

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

  /// {@macro passwordless_idp_login_util.delete_incomplete_login_attempts}
  Future<void> deleteIncompleteLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final String? serializedHandle,
    required final Transaction transaction,
  }) async {
    return _loginUtil.deleteIncompleteLoginAttempts(
      session,
      olderThan: olderThan,
      serializedHandle: serializedHandle,
      transaction: transaction,
    );
  }

  static Future<T> _withReplacedServerException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on PasswordlessLoginServerException catch (e) {
      throw PasswordlessLoginException(reason: e._reason);
    }
  }
}

extension on PasswordlessLoginServerException {
  PasswordlessLoginExceptionReason get _reason {
    switch (this) {
      case PasswordlessLoginInvalidException():
      case PasswordlessLoginNotFoundException():
        return PasswordlessLoginExceptionReason.invalid;
      case PasswordlessLoginTooManyAttemptsException():
        return PasswordlessLoginExceptionReason.tooManyAttempts;
      case PasswordlessLoginExpiredException():
        return PasswordlessLoginExceptionReason.expired;
    }
  }
}

/// Extension to get the PasswordlessIdp instance from the AuthServices.
extension PasswordlessIdpGetter on AuthServices {
  /// Returns the PasswordlessIdp instance from the AuthServices.
  PasswordlessIdp<String> get passwordlessIdp =>
      AuthServices.getIdentityProvider<PasswordlessIdp<String>>();
}
