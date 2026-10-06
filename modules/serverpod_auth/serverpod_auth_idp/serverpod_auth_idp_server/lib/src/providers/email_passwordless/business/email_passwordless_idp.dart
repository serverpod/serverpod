import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'email_passwordless_idp_admin.dart';
import 'email_passwordless_idp_config.dart';
import 'email_passwordless_idp_server_exceptions.dart';
import 'email_passwordless_idp_utils.dart';

/// Main class for the passwordless email identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// Users log in with a verification code that is sent to their email address,
/// without a password. An email address without an account is signed up with
/// the first successful login (unless [EmailPasswordlessIdpConfig.allowSignUp]
/// is disabled). See https://github.com/serverpod/serverpod/issues/2100.
///
/// The accounts are `EmailAccount`s, shared with the email and password
/// identity provider (`EmailIdp`): accounts created here have no password, and
/// accounts with a password can log in with a code as well.
///
/// The `admin` property provides access to [EmailPasswordlessIdpAdmin], which
/// contains admin-related methods for managing the accounts and login requests.
///
/// The `utils` property provides access to [EmailPasswordlessIdpUtils], which
/// contains utility methods that can be used to implement custom
/// authentication flows if needed.
///
/// Sessions created through this provider are issued with the method
/// `emailPasswordless`. They are not revoked by a password reset of the same
/// account through `EmailIdp`. To change this, revoke the tokens of the user
/// with the `onAfterLogin` hook or the token manager.
class EmailPasswordlessIdp implements IdentityProvider {
  /// The method used when authenticating with the passwordless email identity
  /// provider.
  @override
  String get method => 'emailPasswordless';

  /// Admin operations to work with passwordless email accounts.
  final EmailPasswordlessIdpAdmin admin;

  /// Utility functions for the passwordless email identity provider.
  final EmailPasswordlessIdpUtils utils;

  /// The configuration for the passwordless email identity provider.
  final EmailPasswordlessIdpConfig config;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;

  EmailPasswordlessIdp._(
    this.config,
    this._authUsers,
    this._userProfiles,
    this._tokenManager,
    this.utils,
    this.admin,
  );

  /// Creates a new instance of [EmailPasswordlessIdp].
  factory EmailPasswordlessIdp(
    final EmailPasswordlessIdpConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = EmailPasswordlessIdpUtils(config: config);
    final admin = EmailPasswordlessIdpAdmin(utils: utils);
    return EmailPasswordlessIdp._(
      config,
      authUsers,
      userProfiles,
      tokenManager,
      utils,
      admin,
    );
  }

  /// {@macro email_passwordless_idp_base_endpoint.start_login}
  Future<UuidValue> startLogin(
    final Session session, {
    required final String email,
    final Transaction? transaction,
  }) async {
    try {
      return await DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (final transaction) =>
            EmailPasswordlessIdpUtils.withReplacedServerException(
              () => utils.login.startLogin(
                session,
                email: email,
                transaction: transaction,
              ),
            ),
      );
    } on DatabaseUniqueViolationException {
      // A concurrent call has just created the login request for the same
      // email address and sent its code. The response is a request ID that can
      // not be completed, as when the resend cooldown has not elapsed.
      return const Uuid().v7obj();
    }
  }

  /// {@macro email_passwordless_idp_base_endpoint.finish_login}
  ///
  /// The verification code is consumed in a transaction of its own that is
  /// committed before the account is resolved, so that a code can only be used
  /// once, and failed attempts are counted whatever happens later. The optional
  /// [transaction] is only used for the account resolution and the issuing of
  /// the token. If one of those fails, the user has to request a new code.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    return EmailPasswordlessIdpUtils.withReplacedServerException(() async {
      final email = await session.db.transaction(
        (final transaction) => utils.login.verifyLoginCode(
          session,
          loginRequestId: loginRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      );

      await utils.login.clearFailedLoginAttempts(session, email: email);

      return DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (final transaction) =>
            _loginOrSignUp(session, email: email, transaction: transaction),
      );
    });
  }

  Future<AuthSuccess> _loginOrSignUp(
    final Session session, {
    required final String email,
    required final Transaction transaction,
  }) async {
    var emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    final accountCreated = emailAccount == null;
    final Set<Scope> scopes;

    if (emailAccount == null) {
      if (!config.allowSignUp) {
        throw EmailPasswordlessSignUpNotAllowedException();
      }

      await config.onBeforeAccountCreated?.call(
        session,
        email: email,
        transaction: transaction,
      );

      final newUser = await _authUsers.create(
        session,
        transaction: transaction,
      );

      emailAccount = await utils.createAccount(
        session,
        authUserId: newUser.id,
        email: email,
        transaction: transaction,
      );

      await _userProfiles.createUserProfile(
        session,
        newUser.id,
        UserProfileData(email: email),
        transaction: transaction,
      );

      await config.onAfterAccountCreated?.call(
        session,
        email: emailAccount.email,
        authUserId: emailAccount.authUserId,
        emailAccountId: emailAccount.id!,
        transaction: transaction,
      );

      scopes = newUser.scopes;
    } else {
      final authUser = await _authUsers.get(
        session,
        authUserId: emailAccount.authUserId,
        transaction: transaction,
      );

      scopes = authUser.scopes;
    }

    await config.onAfterLogin?.call(
      session,
      email: emailAccount.email,
      authUserId: emailAccount.authUserId,
      emailAccountId: emailAccount.id!,
      accountCreated: accountCreated,
      transaction: transaction,
    );

    return _tokenManager.issueToken(
      session,
      authUserId: emailAccount.authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  /// Determines whether the current session has an associated email account.
  Future<bool> hasAccount(final Session session) async =>
      await utils.getAccount(session) != null;

  /// Migrates all [EmailAccount]s from [userToRemoveId] to [userToKeepId].
  ///
  /// The accounts are the same ones that `EmailIdp.mergeAuthUsers` moves, so
  /// merging through both is safe and has no further effect the second time.
  @override
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    await EmailAccount.db.updateWhere(
      session,
      where: (final t) => t.authUserId.equals(userToRemoveId),
      columnValues: (final t) => [
        t.authUserId(userToKeepId),
      ],
      transaction: transaction,
    );
  }
}

/// Extension to get the EmailPasswordlessIdp instance from the AuthServices.
extension EmailPasswordlessIdpGetter on AuthServices {
  /// Returns the EmailPasswordlessIdp instance from the AuthServices.
  EmailPasswordlessIdp get emailPasswordlessIdp =>
      AuthServices.getIdentityProvider<EmailPasswordlessIdp>();
}
