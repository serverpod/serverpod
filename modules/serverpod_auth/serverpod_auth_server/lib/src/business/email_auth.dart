import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/email_secrets.dart';
import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:serverpod_auth_server/src/business/user_authentication.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';

/// The default generate password hash, using argon2id.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<String> defaultGeneratePasswordHash(String password) =>
    PasswordHash.argon2id(
      password,
      pepper: EmailSecrets.pepper,
      allowUnsecureRandom: AuthConfig.current.allowUnsecureRandom,
    );

/// The default validation password hash.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<bool> defaultValidatePasswordHash(
  String password,
  String email,
  String hash, {
  void Function({
    required String passwordHash,
    required String storedHash,
  })? onValidationFailure,
  void Function(Object e)? onError,
}) async {
  try {
    return await PasswordHash(
      hash,
      legacySalt: EmailSecrets.legacySalt,
      legacyEmail: AuthConfig.current.extraSaltyHash ? email : null,
      pepper: EmailSecrets.pepper,
    ).validate(password, onValidationFailure: onValidationFailure);
  } catch (e) {
    onError?.call(e);
    return false;
  }
}

/// Collection of utility methods when working with email authentication.
class Emails {
  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  static Future<AuthenticationResponse> authenticate(
    Session session,
    String email,
    String password,
  ) async {
    email = email.toLowerCase();
    password = password.trim();

    session.log('authenticate $email / XXXXXXXX', level: LogLevel.debug);

    // Fetch password entry
    var entry = await EmailAuth.db.findFirstRow(session, where: (t) {
      return t.email.equals(email);
    });

    if (entry == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    if (await _hasTooManyFailedSignIns(session, email)) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.tooManyFailedAttempts,
      );
    }

    session.log(' - found entry ', level: LogLevel.debug);

    // Check that password is correct
    if (!await Emails.validatePasswordHash(
      password,
      email,
      entry.hash,
      onValidationFailure: ({
        required String passwordHash,
        required String storedHash,
      }) =>
          session.log(
        ' - $passwordHash saved: $storedHash',
        level: LogLevel.debug,
      ),
      onError: (e) {
        session.log(
          ' - error when validating password hash: $e',
          level: LogLevel.error,
        );
      },
    )) {
      await _logFailedSignIn(session, email);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - password is correct, userId: ${entry.userId})',
        level: LogLevel.debug);

    if (AuthConfig.current.passwordHashGenerator.hashCode ==
            defaultGeneratePasswordHash.hashCode &&
        AuthConfig.current.passwordHashValidator.hashCode ==
            defaultValidatePasswordHash.hashCode) {
      var migratedAuth = await Emails.tryMigrateAuthEntry(
        password: password,
        entry: entry,
      );
      if (migratedAuth != null) {
        session.log(' - migrating authentication entry', level: LogLevel.debug);
        try {
          await EmailAuth.db.updateRow(session, migratedAuth);
        } catch (e) {
          session.log(
            ' - failed to update migrated auth: $e',
            level: LogLevel.error,
          );
        }
      }
    }

    var userInfo = await Users.findUserByUserId(session, entry.userId);
    if (userInfo == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    } else if (userInfo.blocked) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.blocked,
      );
    }

    session.log(' - user found', level: LogLevel.debug);

    // Sign in user and return user info
    var auth = await UserAuthentication.signInUser(
      session,
      entry.userId,
      'email',
      scopes: userInfo.scopes,
    );

    session.log(' - user signed in', level: LogLevel.debug);

    return AuthenticationResponse(
      success: true,
      userInfo: userInfo,
      key: auth.key,
      keyId: auth.id,
    );
  }

  /// Updates the password of a user.
  static Future<bool> changePassword(
    Session session,
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    var auth = await EmailAuth.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (auth == null) {
      session.log(
        "userId: '$userId' is invalid!",
        level: LogLevel.debug,
      );
      return false;
    }

    // Check old password
    if (!await validatePasswordHash(
      oldPassword,
      auth.email,
      auth.hash,
      onError: (e) {
        session.log(
          ' - error when validating password hash: $e',
          level: LogLevel.error,
        );
      },
    )) {
      session.log(
        'Invalid password!',
        level: LogLevel.debug,
      );
      return false;
    }

    // Update password
    auth.hash = await generatePasswordHash(newPassword);
    await EmailAuth.db.updateRow(session, auth);

    return true;
  }

  /// Creates a request for creating an account associated with the specified
  /// email address. An email with a validation code will be sent.
  static Future<bool> createAccountRequest(
    Session session,
    String userName,
    String email,
    String password,
  ) async {
    if (AuthConfig.current.sendValidationEmail == null) {
      session.log(
        'SendValidationEmail is not configured, cannot send email.',
        level: LogLevel.debug,
      );
      return false;
    }

    try {
      // Check if user already has an account
      var userInfo = await Users.findUserByEmail(session, email);
      if (userInfo != null) {
        session.log(
          "Email: '$email' already taken!",
          level: LogLevel.debug,
        );
        return false;
      }

      email = email.trim().toLowerCase();
      if (!EmailValidator.validate(email)) {
        session.log(
          "Email: '$email' is not valid!",
          level: LogLevel.debug,
        );
        return false;
      }

      userName = userName.trim();
      if (userName.isEmpty) {
        session.log(
          'Invalid userName!'
          "'userName' must not be empty.",
          level: LogLevel.debug,
        );
        return false;
      }

      if (password.length < AuthConfig.current.minPasswordLength ||
          password.length > AuthConfig.current.maxPasswordLength) {
        session.log(
          'Invalid password!\n'
          'Password length must be >= ${AuthConfig.current.minPasswordLength}'
          ' and '
          '<= ${AuthConfig.current.maxPasswordLength}',
          level: LogLevel.debug,
        );
        return false;
      }

      var accountRequest = await findAccountRequest(session, email);
      if (accountRequest == null) {
        accountRequest = EmailCreateAccountRequest(
          userName: userName,
          email: email,
          hash: await generatePasswordHash(password),
          verificationCode: _generateVerificationCode(),
        );
        await EmailCreateAccountRequest.db.insertRow(session, accountRequest);
      } else {
        accountRequest.userName = userName;
        accountRequest.verificationCode = _generateVerificationCode();
        await EmailCreateAccountRequest.db.updateRow(session, accountRequest);
      }

      return await AuthConfig.current.sendValidationEmail!(
        session,
        email,
        accountRequest.verificationCode,
      );
    } catch (e) {
      session.log(
        '$e',
        level: LogLevel.debug,
      );
      return false;
    }
  }

  /// Creates a new user. Either password or hash needs to be provided.
  static Future<UserInfo?> createUser(
    Session session,
    String userName,
    String email,
    String? password, [
    String? hash,
  ]) async {
    if (password == null && hash == null) {
      throw Exception('Either password or hash needs to be provided');
    }
    var userInfo = await Users.findUserByEmail(session, email);

    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: email,
        email: email,
        userName: userName,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      session.log('creating user', level: LogLevel.debug);
      userInfo = await Users.createUser(session, userInfo, 'email');
      if (userInfo == null) return null;
    }

    // Check if there is email authentication in place already
    var oldAuth = await EmailAuth.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfo?.id!),
    );
    if (oldAuth != null) {
      return userInfo;
    }

    session.log('creating email auth', level: LogLevel.debug);
    hash = hash ?? await generatePasswordHash(password!);
    var auth = EmailAuth(
      userId: userInfo.id!,
      email: email,
      hash: hash,
    );

    await EmailAuth.db.insertRow(session, auth);

    await UserImages.setDefaultUserImage(session, userInfo.id!);
    await Users.invalidateCacheForUser(session, userInfo.id!);
    userInfo = await Users.findUserByUserId(session, userInfo.id!);

    session.log('returning created user', level: LogLevel.debug);
    return userInfo;
  }

  /// Returns an [EmailCreateAccountRequest] if one exists for the provided
  /// email, null otherwise.
  static Future<EmailCreateAccountRequest?> findAccountRequest(
    Session session,
    String email,
  ) async {
    return await EmailCreateAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

  /// Generates a password hash from a users password and email. This value
  /// can safely be stored in the database without the risk of exposing
  /// passwords.
  static Future<String> generatePasswordHash(String password) async =>
      AuthConfig.current.passwordHashGenerator(
        password,
      );

  /// Initiates the password reset procedure. Will send an email to the provided
  /// address with a reset code.
  static Future<bool> initiatePasswordReset(
    Session session,
    String email,
  ) async {
    if (AuthConfig.current.sendPasswordResetEmail == null) {
      session.log(
        'ResetPasswordEmail is not configured, cannot send email.',
        level: LogLevel.debug,
      );
      return false;
    }

    email = email.trim().toLowerCase();

    var userInfo = await Users.findUserByEmail(session, email);
    if (userInfo == null) {
      session.log(
        "User with email: '$email' is not found!",
        level: LogLevel.debug,
      );
      return false;
    }

    var verificationCode = _generateVerificationCode();
    var emailReset = EmailReset(
      userId: userInfo.id!,
      verificationCode: verificationCode,
      expiration: DateTime.now()
          .add(
            AuthConfig.current.passwordResetExpirationTime,
          )
          .toUtc(),
    );
    await EmailReset.db.insertRow(session, emailReset);

    return AuthConfig.current.sendPasswordResetEmail!(
      session,
      userInfo,
      verificationCode,
    );
  }

  /// Migrates legacy password hashes to the latest hash algorithm.
  ///
  ///[batchSize] is the number of entries to migrate in each batch.
  ///
  /// [maxMigratedEntries] is the maximum number of entries that will be
  /// migrated. If null, all entries in the database will be migrated.
  ///
  /// Returns the number of migrated entries.
  ///
  /// Warning: This migration method is designed for password hashes generated
  /// by the framework's default algorithm. Hashes stored with a custom
  /// generator or different algorithm may produce unexpected results.
  static Future<int> migrateLegacyPasswordHashes(
    Session session, {
    int batchSize = 100,
    int? maxMigratedEntries,
  }) async {
    if (AuthConfig.current.passwordHashGenerator.hashCode !=
            defaultGeneratePasswordHash.hashCode ||
        AuthConfig.current.passwordHashValidator.hashCode !=
            defaultValidatePasswordHash.hashCode) {
      throw Exception(
          'Legacy password hash migration not supported when using custom password hash algorithm.');
    }
    var updatedEntries = 0;
    int lastEntryId = 0;

    while (true) {
      var entries = await EmailAuth.db.find(
        session,
        where: (t) => t.hash.notLike(r'%$%') & (t.id > lastEntryId),
        orderBy: (t) => t.id,
        limit: batchSize,
      );

      if (entries.isEmpty) {
        return updatedEntries;
      }

      if (maxMigratedEntries != null) {
        if (maxMigratedEntries == updatedEntries) {
          return updatedEntries;
        }

        var entrySurplus =
            (updatedEntries + entries.length) - maxMigratedEntries;
        if (entrySurplus > 0) {
          entries = entries.sublist(0, entries.length - entrySurplus);
        }
      }

      lastEntryId = entries.last.id!;

      var migratedEntries = await Future.wait(entries.where((entry) {
        try {
          return PasswordHash(
            entry.hash,
            legacySalt: EmailSecrets.legacySalt,
          ).isLegacyHash();
        } catch (e) {
          session.log(
            'Error when checking if hash is legacy: $e',
            level: LogLevel.error,
          );
          return false;
        }
      }).map((entry) async {
        return entry.copyWith(
          hash: await PasswordHash.migratedLegacyToArgon2idHash(
            entry.hash,
            legacySalt: EmailSecrets.legacySalt,
            pepper: EmailSecrets.pepper,
            allowUnsecureRandom: AuthConfig.current.allowUnsecureRandom,
          ),
        );
      }).toList());

      try {
        await EmailAuth.db.update(session, migratedEntries);
        updatedEntries += migratedEntries.length;
      } catch (e) {
        session.log(
          'Failed to update migrated entries: $e',
          level: LogLevel.error,
        );
      }
    }
  }

  /// Resets a users password using a password reset verification code.
  static Future<bool> resetPassword(
    Session session,
    String verificationCode,
    String password,
  ) async {
    var passwordResets = await EmailReset.db.deleteWhere(
      session,
      where: (t) => t.verificationCode.equals(verificationCode),
    );

    if (passwordResets.isEmpty) {
      session.log(
        'Verification code is invalid!',
        level: LogLevel.debug,
      );
      return false;
    }

    var passwordReset = passwordResets.first;

    if (passwordReset.expiration.isBefore(DateTime.now().toUtc())) {
      session.log(
        'Verification code has expired!',
        level: LogLevel.debug,
      );
      return false;
    }

    var emailAuth = await EmailAuth.db.findFirstRow(session, where: (t) {
      return t.userId.equals(passwordReset.userId);
    });

    if (emailAuth == null) {
      session.log(
        "User with id: '${passwordReset.userId}' has no email authentication!",
        level: LogLevel.debug,
      );
      return false;
    }

    emailAuth.hash = await generatePasswordHash(password);
    await EmailAuth.db.updateRow(session, emailAuth);

    return true;
  }

  /// Try to create an account using a verification code.
  /// Returns the [UserInfo] object if successful, null otherwise.
  static Future<UserInfo?> tryCreateAccount(
    Session session, {
    required String email,
    required String verificationCode,
  }) async {
    var request = await Emails.findAccountRequest(session, email);
    if (request == null) {
      return null;
    }
    if (request.verificationCode != verificationCode) {
      return null;
    }

    // Email is verified, create a new user
    var userInfo = await Emails.createUser(
      session,
      request.userName,
      email,
      null,
      request.hash,
    );

    if (userInfo != null) {
      await EmailCreateAccountRequest.db.deleteRow(session, request);
    }

    return userInfo;
  }

  /// Migrates an EmailAuth entry if required.
  ///
  /// Returns the new [EmailAuth] object if a migration was required,
  /// null otherwise.
  static Future<EmailAuth?> tryMigrateAuthEntry({
    required String password,
    required EmailAuth entry,
  }) async {
    if (!PasswordHash(entry.hash, legacySalt: EmailSecrets.legacySalt)
        .shouldUpdateHash()) {
      return null;
    }

    var newHash = await PasswordHash.argon2id(
      password,
      pepper: EmailSecrets.pepper,
      allowUnsecureRandom: AuthConfig.current.allowUnsecureRandom,
    );

    return entry.copyWith(hash: newHash);
  }

  /// Generates a password hash from the password using the provided hash
  /// algorithm and validates that they match.
  ///
  /// If the password hash does not match the provided hash, the
  /// [onValidationFailure] function is called with the hash and the password
  /// hash as arguments.
  ///
  /// If an error occurs, the [onError] function is called with the error as
  /// argument.
  static Future<bool> validatePasswordHash(
    String password,
    String email,
    String hash, {
    void Function({
      required String passwordHash,
      required String storedHash,
    })? onValidationFailure,
    void Function(Object e)? onError,
  }) =>
      AuthConfig.current.passwordHashValidator(
        password,
        email,
        hash,
        onError: onError,
        onValidationFailure: onValidationFailure,
      );

  static String _generateVerificationCode() {
    return Random().nextString(
      length: AuthConfig.current.validationCodeLength,
    );
  }

  static Future<bool> _hasTooManyFailedSignIns(
      Session session, String email) async {
    var numFailedSignIns = await EmailFailedSignIn.db.count(
      session,
      where: (t) =>
          t.email.equals(email) &
          (t.time >
              DateTime.now()
                  .toUtc()
                  .subtract(AuthConfig.current.emailSignInFailureResetTime)),
    );
    return numFailedSignIns >= AuthConfig.current.maxAllowedEmailSignInAttempts;
  }

  static Future<void> _logFailedSignIn(Session session, String email) async {
    var failedSignIn = EmailFailedSignIn(
      email: email,
      time: DateTime.now(),
      ipAddress: session is MethodCallSession
          ? session.httpRequest.remoteIpAddress
          : '',
    );
    await EmailFailedSignIn.db.insertRow(session, failedSignIn);
  }
}
