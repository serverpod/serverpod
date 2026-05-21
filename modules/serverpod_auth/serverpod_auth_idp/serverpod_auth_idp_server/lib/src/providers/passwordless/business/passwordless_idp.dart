import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'passwordless_idp_admin.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_utils.dart';
import 'utils/passwordless_idp_login_util.dart';
import 'utils/passwordless_login_request_store.dart';

/// Main class for the passwordless identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [PasswordlessIdpAdmin], which
/// contains admin-related methods.
class PasswordlessIdp {
  /// The method used when authenticating with the passwordless identity
  /// provider.
  static const String method = 'passwordless';

  /// Administrative methods for working with passwordless login state.
  final PasswordlessIdpAdmin admin;

  /// The configuration for the passwordless identity provider.
  final PasswordlessIdpConfig config;

  final PasswordlessIdpLoginUtil _loginUtil;

  final TokenManager _tokenManager;

  final AuthUsers _authUsers;

  PasswordlessIdp._(
    this.config,
    this._loginUtil,
    this.admin,
    this._tokenManager,
    this._authUsers,
  );

  /// Creates a new instance of [PasswordlessIdp].
  factory PasswordlessIdp(
    final PasswordlessIdpConfig config, {
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
  }) {
    final loginUtil = PasswordlessIdpLoginUtil(config: config);
    final admin = PasswordlessIdpAdmin(loginUtil: loginUtil);
    return PasswordlessIdp._(
      config,
      loginUtil,
      admin,
      tokenManager,
      authUsers,
    );
  }

  /// {@macro passwordless_idp_base_endpoint.finish_login}
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return PasswordlessIdpUtils.withReplacedServerPasswordlessException(
      () async {
        final request = await session.db.transaction(
          (final transaction) => _loginUtil.verifyAndCompleteLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        return session.db.transaction(
          (final transaction) => _finishLoginFromVerifiedRequest(
            session,
            request: request,
            transaction: transaction,
          ),
        );
      },
    );
  }

  /// {@macro passwordless_idp_base_endpoint.start_login}
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    final String handleType = PasswordlessIdpConfig.defaultHandleType,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          PasswordlessIdpUtils.withReplacedServerPasswordlessException(
            () => _loginUtil.startLogin(
              session,
              handle: handle,
              handleType: handleType,
              transaction: transaction,
            ),
          ),
    );
  }

  Future<AuthSuccess> _finishLoginFromVerifiedRequest(
    final Session session, {
    required final PasswordlessLoginRequestData request,
    required final Transaction transaction,
  }) async {
    final authUserId = await config.resolveAuthUserId(
      session,
      handle: request.handle,
      handleType: request.handleType,
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
  }
}
