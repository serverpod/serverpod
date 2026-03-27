import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'passwordless_idp_admin.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_server_exceptions.dart';
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

  PasswordlessIdp._(
    this.config,
    this._loginUtil,
    this.admin,
    this._tokenManager,
    this._authUsers,
  );

  /// Verifies the login code and finishes the login process in one step.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  ///
  /// When [transaction] is `null` (the default, and the path used by
  /// [PasswordlessIdpBaseEndpoint]), the login request is consumed in an
  /// isolated committed transaction *before* the subsequent steps
  /// (handle deserialization, user resolution, token issuance) run in a
  /// separate transaction. This guarantees single-use semantics: even if a
  /// later step fails, the verification code cannot be replayed.
  ///
  /// When a caller-provided [transaction] is given, all steps — including
  /// request consumption — execute within that transaction (or a savepoint).
  /// If the caller's transaction is rolled back, the request deletion is
  /// also rolled back, so the verification code may still be valid.
  /// This is intentional: it allows advanced integrators to compose
  /// `finishLogin` with other operations under a single atomic boundary,
  /// at the cost of managing single-use guarantees themselves.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    if (transaction == null) {
      return _withReplacedServerException(() async {
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
      });
    }

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _withReplacedServerException(
        () => _finishLoginInTransaction(
          session,
          loginRequestId: loginRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      ),
    );
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

  Future<PasswordlessLoginRequestData> _consumeLoginRequest(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    final result = await session.db
        .transaction<
          ({
            PasswordlessLoginRequestData? request,
            PasswordlessLoginServerException? exception,
          })
        >((final transaction) async {
          try {
            return (
              request: await _loginUtil.verifyAndCompleteLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
              exception: null,
            );
          } on PasswordlessLoginServerException catch (exception) {
            return (request: null, exception: exception);
          }
        });

    final exception = result.exception;
    if (exception != null) {
      throw exception;
    }

    return result.request!;
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
