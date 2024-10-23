import 'dart:math';

import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/phone_secrets.dart';
import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:serverpod_auth_server/src/business/user_authentication.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';

/// The default generate password hash, using argon2id.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<String> defaultPhoneGeneratePasswordHash(String password) =>
    PasswordHash.argon2id(
      password,
      pepper: PhoneSecrets.pepper,
      allowUnsecureRandom: AuthConfig.current.allowUnsecureRandom,
    );

/// The default validation password hash.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<bool> defaultPhoneValidatePasswordHash(
  String password,
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
      legacySalt: PhoneSecrets.legacySalt,
      pepper: PhoneSecrets.pepper,
    ).validate(password, onValidationFailure: onValidationFailure);
  } catch (e) {
    onError?.call(e);
    return false;
  }
}

/// Collection of utility methods when working with phone authentication.
class Phones {
  /// Generates a password hash from a users password and phone number. This value
  /// can safely be stored in the database without the risk of exposing
  /// passwords.
  static Future<String> generatePasswordHash(String password) async =>
      AuthConfig.current.phonePasswordHashGenerator(
        password,
      );

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
    String hash, {
    void Function({
      required String passwordHash,
      required String storedHash,
    })? onValidationFailure,
    void Function(Object e)? onError,
  }) =>
      AuthConfig.current.phonePasswordHashValidator(
        password,
        hash,
        onError: onError,
        onValidationFailure: onValidationFailure,
      );

  /// Creates a new user. Either password or hash needs to be provided.
  static Future<UserInfo?> createUser(
    Session session,
    String userName,
    String phoneNumber,
    String? password, [
    String? hash,
  ]) async {
    if (password == null && hash == null) {
      throw Exception('Either password or hash needs to be provided');
    }

    String? validatedPhoneNumber = _validatePhoneNumber(session, phoneNumber);
    if (validatedPhoneNumber == null) {
      throw Exception('Phone number is invalid');
    }

    var userInfo =
        await Users.findUserByPhoneNumber(session, validatedPhoneNumber);

    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: validatedPhoneNumber,
        phoneNumber: validatedPhoneNumber,
        userName: userName,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      session.log('creating user', level: LogLevel.debug);
      userInfo = await Users.createUser(session, userInfo, 'phone');
      if (userInfo == null) return null;
    }

    // Check if there is phone number authentication in place already
    var oldAuth = await PhoneAuth.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfo?.id!),
    );
    if (oldAuth != null) {
      return userInfo;
    }

    session.log('creating phone number auth', level: LogLevel.debug);
    hash = hash ?? await generatePasswordHash(password!);
    var auth = PhoneAuth(
      userId: userInfo.id!,
      phoneNumber: validatedPhoneNumber,
      hash: hash,
    );

    await PhoneAuth.db.insertRow(session, auth);

    await UserImages.setDefaultUserImage(session, userInfo.id!);
    await Users.invalidateCacheForUser(session, userInfo.id!);
    userInfo = await Users.findUserByUserId(session, userInfo.id!);

    session.log('returning created user', level: LogLevel.debug);
    return userInfo;
  }

  /// Updates the password of a user.
  static Future<bool> changePassword(
    Session session,
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    var auth = await PhoneAuth.db.findFirstRow(
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
    await PhoneAuth.db.updateRow(session, auth);

    return true;
  }

  /// Initiates the password reset procedure. Will send an sms to the provided
  /// phone number with a reset code.
  static Future<bool> initiatePasswordReset(
    Session session,
    String phoneNumber,
  ) async {
    if (AuthConfig.current.sendPasswordResetSms == null) {
      session.log(
        'ResetPasswordSms is not configured, cannot send sms.',
        level: LogLevel.debug,
      );
      return false;
    }

    String? validatedPhoneNumber = _validatePhoneNumber(session, phoneNumber);
    if (validatedPhoneNumber == null) {
      return false;
    }

    var userInfo =
        await Users.findUserByPhoneNumber(session, validatedPhoneNumber);
    if (userInfo == null) {
      session.log(
        "User with phoneNumber: '$validatedPhoneNumber' is not found!",
        level: LogLevel.debug,
      );
      return false;
    }

    var verificationCode = _generateVerificationCode();
    var phoneReset = PhoneReset(
      userId: userInfo.id!,
      verificationCode: verificationCode,
      expiration: DateTime.now()
          .add(
            AuthConfig.current.passwordResetExpirationTime,
          )
          .toUtc(),
    );
    await PhoneReset.db.insertRow(session, phoneReset);

    return AuthConfig.current.sendPasswordResetSms!(
      session,
      userInfo,
      verificationCode,
    );
  }

  /// Resets a users password using a password reset verification code.
  static Future<bool> resetPassword(
    Session session,
    String verificationCode,
    String password,
  ) async {
    var passwordResets = await PhoneReset.db.deleteWhere(
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

    var phoneAuth = await PhoneAuth.db.findFirstRow(session, where: (t) {
      return t.userId.equals(passwordReset.userId);
    });

    if (phoneAuth == null) {
      session.log(
        "User with id: '${passwordReset.userId}' has no phone authentication!",
        level: LogLevel.debug,
      );
      return false;
    }

    phoneAuth.hash = await generatePasswordHash(password);
    await PhoneAuth.db.updateRow(session, phoneAuth);

    return true;
  }

  /// Creates a request for creating an account associated with the specified
  /// phone number. An sms with a validation code will be sent.
  static Future<bool> createAccountRequest(
    Session session,
    String userName,
    String phoneNumber,
    String password,
  ) async {
    if (AuthConfig.current.sendValidationSms == null) {
      session.log(
        'SendValidationSms is not configured, cannot send sms.',
        level: LogLevel.debug,
      );
      return false;
    }
    String? validatedPhoneNumber = _validatePhoneNumber(session, phoneNumber);
    if (validatedPhoneNumber == null) {
      return false;
    }

    try {
      // Check if user already has an account
      var userInfo =
          await Users.findUserByPhoneNumber(session, validatedPhoneNumber);
      if (userInfo != null) {
        session.log(
          "Phone number: '$validatedPhoneNumber' already taken!",
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

      var accountRequest =
          await findAccountRequest(session, validatedPhoneNumber);
      if (accountRequest == null) {
        accountRequest = PhoneCreateAccountRequest(
          userName: userName,
          phoneNumber: validatedPhoneNumber,
          hash: await generatePasswordHash(password),
          verificationCode: _generateVerificationCode(),
        );
        await PhoneCreateAccountRequest.db.insertRow(session, accountRequest);
      } else {
        accountRequest.userName = userName;
        accountRequest.verificationCode = _generateVerificationCode();
        await PhoneCreateAccountRequest.db.updateRow(session, accountRequest);
      }

      return await AuthConfig.current.sendValidationSms!(
        session,
        validatedPhoneNumber,
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

  /// Returns an [PhoneCreateAccountRequest] if one exists for the provided
  /// phone number, null otherwise.
  static Future<PhoneCreateAccountRequest?> findAccountRequest(
    Session session,
    String phoneNumber,
  ) async {
    String? validatedPhoneNumber = _validatePhoneNumber(session, phoneNumber);
    if (validatedPhoneNumber == null) {
      return null;
    }
    return await PhoneCreateAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(validatedPhoneNumber),
    );
  }

  /// Authenticates a user with phone number and password. Returns an
  /// [AuthenticationResponse] with the users information.
  static Future<AuthenticationResponse> authenticate(
    Session session,
    String phoneNumber,
    String password,
  ) async {
    password = password.trim();

    session.log('authenticate $phoneNumber / XXXXXXXX', level: LogLevel.debug);

    String? validatedPhoneNumber = _validatePhoneNumber(session, phoneNumber);
    if (validatedPhoneNumber == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    // Fetch password entry
    var entry = await PhoneAuth.db.findFirstRow(session, where: (t) {
      return t.phoneNumber.equals(validatedPhoneNumber);
    });

    if (entry == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    if (await _hasTooManyFailedSignIns(session, validatedPhoneNumber)) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.tooManyFailedAttempts,
      );
    }

    session.log(' - found entry ', level: LogLevel.debug);

    // Check that password is correct
    if (!await Phones.validatePasswordHash(
      password,
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
      await _logFailedSignIn(session, validatedPhoneNumber);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - password is correct, userId: ${entry.userId})',
        level: LogLevel.debug);

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
      'phone',
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

  static String _generateVerificationCode() {
    return Random().nextString(
      length: AuthConfig.current.validationCodeLength,
    );
  }

  static Future<bool> _hasTooManyFailedSignIns(
      Session session, String phoneNumber) async {
    var numFailedSignIns = await PhoneFailedSignIn.db.count(
      session,
      where: (t) =>
          t.phoneNumber.equals(phoneNumber) &
          (t.time >
              DateTime.now()
                  .toUtc()
                  .subtract(AuthConfig.current.phoneSignInFailureResetTime)),
    );
    return numFailedSignIns >= AuthConfig.current.maxAllowedPhoneSignInAttempts;
  }

  static Future<void> _logFailedSignIn(
      Session session, String phoneNumber) async {
    session as MethodCallSession;
    var failedSignIn = PhoneFailedSignIn(
      phoneNumber: phoneNumber,
      time: DateTime.now(),
      ipAddress: session.httpRequest.remoteIpAddress,
    );
    await PhoneFailedSignIn.db.insertRow(session, failedSignIn);
  }

  static String? _validatePhoneNumber(Session session, String phoneNumber) {
    var parsedPhoneNumber = PhoneNumber.parse(phoneNumber);
    if (!parsedPhoneNumber.isValid()) {
      session.log(
        "Phone number: '$phoneNumber' is not valid!",
        level: LogLevel.debug,
      );
      return null;
    }
    return parsedPhoneNumber.international;
  }
}
