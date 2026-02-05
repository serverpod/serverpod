import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../../../../generated/protocol.dart';
import '../storage/phone_id_store.dart';
import 'sms_idp_config.dart';
import 'sms_idp_server_exceptions.dart';
import 'sms_idp_utils.dart';
import 'utils/sms_idp_login_util.dart';

/// Main class for the SMS identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
///
/// The `utils` property provides access to [SmsIdpUtils], which contains
/// utility methods for working with SMS-backed accounts.
class SmsIdp {
  /// The method used when authenticating with the SMS identity provider.
  static const String method = 'sms';

  /// The configuration for the SMS identity provider.
  final SmsIdpConfig config;

  /// Utility functions for the SMS identity provider.
  final SmsIdpUtils utils;

  final TokenManager _tokenManager;
  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;

  SmsIdp._(
    this.config,
    this.utils,
    this._tokenManager,
    this._authUsers,
    this._userProfiles,
  );

  /// Creates a new instance of [SmsIdp].
  factory SmsIdp(
    SmsIdpConfig config, {
    required TokenManager tokenManager,
    required AuthUsers authUsers,
    required UserProfiles userProfiles,
  }) {
    final utils = SmsIdpUtils(config: config, authUsers: authUsers);
    return SmsIdp._(config, utils, tokenManager, authUsers, userProfiles);
  }

  /// Starts the registration process for a new account.
  ///
  /// Returns the account request ID.
  Future<UuidValue> startRegistration(
    Session session, {
    required String phone,
    Transaction? transaction,
  }) async {
    if (!config.enableRegistration) {
      throw SmsAccountRequestException(
        reason: SmsAccountRequestExceptionReason.invalid,
      );
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(() async {
        try {
          return await utils.accountCreation.startRegistration(
            session,
            phone: phone,
            transaction: transaction,
          );
        } on SmsAccountAlreadyRegisteredException catch (_) {
          session.log(
            'Failed to start registration for phone, reason: already registered',
            level: LogLevel.debug,
          );
          // Return a fake ID to avoid leaking information
          return const Uuid().v7obj();
        }
      }),
    );
  }

  /// Verifies the registration code.
  ///
  /// Returns a completion token to be used with [finishRegistration].
  Future<String> verifyRegistrationCode(
    Session session, {
    required UuidValue accountRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(
        () => utils.accountCreation.verifyRegistrationCode(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      ),
    );
  }

  /// Finishes the registration process and creates the account.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  Future<AuthSuccess> finishRegistration(
    Session session, {
    required String registrationToken,
    required String phone,
    required String password,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(() async {
        final result = await utils.accountCreation.completeAccountCreation(
          session,
          registrationToken: registrationToken,
          phone: phone,
          password: password,
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
      }),
    );
  }

  /// Starts the login process.
  ///
  /// Returns the login request ID.
  Future<UuidValue> startLogin(
    Session session, {
    required String phone,
    Transaction? transaction,
  }) async {
    if (!config.enableLogin) {
      throw SmsLoginException(reason: SmsLoginExceptionReason.invalid);
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(
        () => utils.login.startLogin(
          session,
          phone: phone,
          transaction: transaction,
        ),
      ),
    );
  }

  /// Verifies the login code.
  ///
  /// Returns a [SmsVerifyLoginResult] with completion token and whether password is needed.
  Future<SmsVerifyLoginResult> verifyLoginCode(
    Session session, {
    required UuidValue loginRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(
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
    Session session, {
    required String loginToken,
    required String phone,
    String? password,
    Transaction? transaction,
  }) async {
    if (!config.enableLogin) {
      throw SmsLoginException(reason: SmsLoginExceptionReason.invalid);
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(() async {
        final request = await utils.login.completeLogin(
          session,
          loginToken: loginToken,
          transaction: transaction,
        );

        final normalized = config.phoneIdStore.normalizePhone(phone);
        final phoneHash = config.phoneIdStore.hashPhone(normalized);
        if (phoneHash != request.phoneHash) {
          throw SmsLoginInvalidCredentialsException();
        }

        final existingAuthUserId = await config.phoneIdStore
            .findAuthUserIdByPhoneHash(
              session,
              phoneHash: phoneHash,
              transaction: transaction,
            );

        if (existingAuthUserId != null) {
          // Existing user - just log in
          final authUser = await _authUsers.get(
            session,
            authUserId: existingAuthUserId,
            transaction: transaction,
          );
          await SmsLoginRequest.db.deleteRow(
            session,
            request,
            transaction: transaction,
          );
          return _tokenManager.issueToken(
            session,
            authUserId: authUser.id,
            method: method,
            scopes: authUser.scopes,
            transaction: transaction,
          );
        }

        // New user - create account
        if (config.requirePasswordOnUnregisteredLogin &&
            (password == null || password.isEmpty)) {
          throw SmsLoginPasswordRequiredException();
        }

        if (!config.passwordValidationFunction(password ?? '')) {
          throw SmsLoginPasswordPolicyViolationException();
        }

        final authUser = await _authUsers.create(
          session,
          transaction: transaction,
        );

        final passwordHash = await utils.hashUtil.createHashFromString(
          secret: password ?? '',
        );
        await SmsAccount.db.insertRow(
          session,
          SmsAccount(authUserId: authUser.id, passwordHash: passwordHash),
          transaction: transaction,
        );

        try {
          await config.phoneIdStore.bindPhone(
            session,
            authUserId: authUser.id,
            phone: normalized,
            allowRebind: config.allowPhoneRebind,
            transaction: transaction,
          );
        } on PhoneAlreadyBoundException {
          throw SmsLoginInvalidCredentialsException();
        } on PhoneRebindNotAllowedException {
          throw SmsLoginInvalidCredentialsException();
        }

        await config.onAfterAccountCreated?.call(
          session,
          authUserId: authUser.id,
          transaction: transaction,
        );
        await config.onAfterPhoneBound?.call(
          session,
          authUserId: authUser.id,
          transaction: transaction,
        );

        await _userProfiles.createUserProfile(
          session,
          authUser.id,
          UserProfileData(),
          transaction: transaction,
        );

        await SmsLoginRequest.db.deleteRow(
          session,
          request,
          transaction: transaction,
        );

        return _tokenManager.issueToken(
          session,
          authUserId: authUser.id,
          method: method,
          scopes: authUser.scopes,
          transaction: transaction,
        );
      }),
    );
  }

  /// Starts the phone binding process.
  ///
  /// Returns the bind request ID.
  Future<UuidValue> startBindPhone(
    Session session, {
    required UuidValue authUserId,
    required String phone,
    Transaction? transaction,
  }) async {
    if (!config.enableBind) {
      throw SmsPhoneBindException(reason: SmsPhoneBindExceptionReason.invalid);
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(
        () => utils.bind.startBind(
          session,
          authUserId: authUserId,
          phone: phone,
          transaction: transaction,
        ),
      ),
    );
  }

  /// Verifies the bind code.
  ///
  /// Returns a completion token to be used with [finishBindPhone].
  Future<String> verifyBindCode(
    Session session, {
    required UuidValue bindRequestId,
    required String verificationCode,
    Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(
        () => utils.bind.verifyBindCode(
          session,
          bindRequestId: bindRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      ),
    );
  }

  /// Finishes the phone binding process.
  Future<void> finishBindPhone(
    Session session, {
    required UuidValue authUserId,
    required String bindToken,
    required String phone,
    Transaction? transaction,
  }) async {
    if (!config.enableBind) {
      throw SmsPhoneBindException(reason: SmsPhoneBindExceptionReason.invalid);
    }
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) => SmsIdpUtils.withReplacedServerSmsException(() async {
        final request = await utils.bind.completeBind(
          session,
          bindToken: bindToken,
          transaction: transaction,
        );

        if (request.authUserId != authUserId) {
          throw SmsPhoneBindInvalidException();
        }

        final normalized = config.phoneIdStore.normalizePhone(phone);
        final phoneHash = config.phoneIdStore.hashPhone(normalized);
        if (phoneHash != request.phoneHash) {
          throw SmsPhoneBindInvalidException();
        }

        try {
          await config.phoneIdStore.bindPhone(
            session,
            authUserId: authUserId,
            phone: normalized,
            allowRebind: config.allowPhoneRebind,
            transaction: transaction,
          );
        } on PhoneAlreadyBoundException {
          throw SmsPhoneAlreadyBoundException();
        } on PhoneRebindNotAllowedException {
          throw SmsPhoneAlreadyBoundException();
        }

        await SmsBindRequest.db.deleteRow(
          session,
          request,
          transaction: transaction,
        );

        await config.onAfterPhoneBound?.call(
          session,
          authUserId: authUserId,
          transaction: transaction,
        );
      }),
    );
  }

  /// Returns true if the user has a phone number bound.
  Future<bool> isPhoneBound(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    return config.phoneIdStore.isPhoneBoundForUser(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );
  }
}

/// Extension to get SMS IDP from AuthServices.
extension SmsIdpGetter on AuthServices {
  /// Gets the configured [SmsIdp] instance.
  SmsIdp get smsIdp => AuthServices.getIdentityProvider<SmsIdp>();
}
