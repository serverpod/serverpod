import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'passwordless_idp_admin.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_server_exceptions.dart';
import 'passwordless_idp_utils.dart';
import 'utils/passwordless_idp_login_util.dart';
import 'utils/passwordless_login_request_store.dart';

/// Main class for the passwordless identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [PasswordlessIdpAdmin], which
/// contains admin-related methods.
class PasswordlessIdp<THandle> {
  /// The method used when authenticating with the passwordless identity
  /// provider.
  static const String method = 'passwordless';

  /// Administrative methods for working with passwordless login state.
  final PasswordlessIdpAdmin<THandle> admin;

  /// The configuration for the passwordless identity provider.
  final PasswordlessIdpConfig<THandle> config;

  final PasswordlessIdpLoginUtil<THandle> _loginUtil;

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
    final PasswordlessIdpConfig<THandle> config, {
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
  }) {
    final loginUtil = PasswordlessIdpLoginUtil<THandle>(config: config);
    final admin = PasswordlessIdpAdmin<THandle>(loginUtil: loginUtil);
    return PasswordlessIdp._(
      config,
      loginUtil,
      admin,
      tokenManager,
      authUsers,
    );
  }

  /// {@macro passwordless_idp_base_endpoint.finish_login}
  /// When [transaction] is `null`, the verification code is consumed in a
  /// separate committed transaction before the remaining steps, ensuring
  /// single-use semantics even if a later step fails.
  /// When a [transaction] is provided, all steps run within it (or a
  /// savepoint), so single-use guarantees depend on the caller's commit.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    if (transaction == null) {
      return PasswordlessIdpUtils.withReplacedServerPasswordlessException(
        () async {
          final request = await _consumeLoginRequest(
            session,
            loginRequestId: loginRequestId,
            verificationCode: verificationCode,
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

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) =>
          PasswordlessIdpUtils.withReplacedServerPasswordlessException(
            () => _finishLoginInTransaction(
              session,
              loginRequestId: loginRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          ),
    );
  }

  /// {@macro passwordless_idp_base_endpoint.start_login}
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    final String? handleType,
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

  Future<PasswordlessLoginRequestData> _consumeLoginRequest(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return session.db.transaction(
      (final transaction) => _loginUtil.verifyAndCompleteLogin(
        session,
        loginRequestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  Future<AuthSuccess> _finishLoginFromVerifiedRequest(
    final Session session, {
    required final PasswordlessLoginRequestData request,
    required final Transaction transaction,
  }) async {
    final THandle handle;
    try {
      handle = config.deserializeHandle(request.serializedHandle);
    } on FormatException {
      throw PasswordlessLoginInvalidException();
    }

    final authUserId = await config.resolveAuthUserId(
      session,
      handle: handle,
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

  Future<AuthSuccess> _finishLoginInTransaction(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final request = await _loginUtil.verifyAndCompleteLogin(
      session,
      loginRequestId: loginRequestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return _finishLoginFromVerifiedRequest(
      session,
      request: request,
      transaction: transaction,
    );
  }
}
