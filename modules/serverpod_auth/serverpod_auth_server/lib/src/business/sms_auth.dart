import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:serverpod_auth_server/src/business/user_images.dart';

/// Collection of utility methods when working with SMS authentication.

class SMSs {
  /// Starts the process of authenticating a user with SMS.
  /// Sends an SMS with an OTP to the given phone number And if user doesn't
  /// exist, creates a new user with the given phone number after verifying the
  /// OTP.
  static Future<String> getOTPRequest({required String phoneNumber}) async {
    assert(
      AuthConfig.current.sendValidationEmail != null,
      'The sendValidationEmail property needs to be set in AuthConfig.',
    );

    var otp = _generateOTP();

    var hash = generateHashData(
      phoneNumber: phoneNumber,
      otp: otp,
    );
    await AuthConfig.current.sendSMSAuth!(
      phoneNumber,
      otp,
    );
    return hash;
  }

  /// Verifies that the OTP is correct and that the hash hasn't been tampered
  /// with. If the OTP is correct, the user is logged in and a session is
  /// returned.
  static Future<bool> verifyOTPRequest({
    required String phoneNumber,
    required String otp,
    required String storedHash,
  }) async {
    var verification = verifyHashData(
      hashedData: storedHash,
      phoneNumber: phoneNumber,
      otp: otp,
    );

    if (!verification) {
      return false;
    }

    return true;
  }

  /// Creates a new user with the given phone number.
  static Future<SmsAuth?> createUser(
    Session session,
    String phoneNumber,
  ) async {
    var userInfo = await Users.findUserByPhoneNumber(session, phoneNumber);

    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: phoneNumber,
        phoneNumber: phoneNumber,
        userName: phoneNumber,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );
      session.log('creating user', level: LogLevel.debug);
      userInfo = await Users.createUser(session, userInfo, 'SMS');
      if (userInfo == null) return null;
    }

    session.log('creating SMS auth', level: LogLevel.debug);
    var auth = SmsAuth(
      userId: userInfo.id!,
      phoneNumber: phoneNumber,
    );
    await session.db.insert(auth);

    await UserImages.setDefaultUserImage(session, userInfo.id!);
    await Users.invalidateCacheForUser(session, userInfo.id!);
    userInfo = await Users.findUserByUserId(session, userInfo.id!);
    if (userInfo == null) {
      session.log('failed to find user', level: LogLevel.error);
      return null;
    }

    session.log('returning created user', level: LogLevel.debug);
    return auth;
  }

  /// Generates a new hash from a users phone number, OTP and secret hash key.
  /// This value will be used to verify the OTP when the user sends it without.
  /// Without having the risk of storing the OTP in the database.
  static String generateHashData(
      {required String phoneNumber,
      required String otp,
      DateTime? expirationTime}) {
    var secretHashKey =
        Serverpod.instance.getPassword('SMSHash') ?? 'serverpod SMS hash';
    expirationTime ??= DateTime.now().add(AuthConfig.current.smsExpirationTime);

    var dataToHash = '$phoneNumber$otp$secretHashKey';
    var hmac = Hmac(sha256, utf8.encode(secretHashKey));
    var digest = hmac.convert(utf8.encode(dataToHash));
    var hashedData = digest.toString();

    var hash = '$hashedData@${expirationTime.toIso8601String()}';

    return hash;
  }

  /// Generates a new hash from a users phone number, OTP and secret hash key.
  /// And validates that the hash hasn't been tampered with. And verifies the OTP
  static bool verifyHashData({
    required String hashedData,
    required String phoneNumber,
    required String otp,
  }) {
    /// Split the string data into hash and expiration time
    var parts = hashedData.split('@');
    var storedExpirationTime = DateTime.parse(parts[1]);
    if (parts.length != 2) {
      return false;
    }

    if (!validateExpiry(storedExpirationTime)) {
      return false;
    }

    /// Creates new hash from the data and compares it to the stored hash.
    var hash = generateHashData(
        phoneNumber: phoneNumber,
        otp: otp,
        expirationTime: storedExpirationTime);
    return hash == hashedData;
  }

  /// Validates that the expiration time is in the future.
  static bool validateExpiry(DateTime expirationTime) {
    var currentTime = DateTime.now();
    return currentTime.isBefore(expirationTime);
  }

  /// Generates a new 6 digit OTP.
  static String _generateOTP() {
    return Random().nextString(
      length: 6,
      chars: '0123456789',
    );
  }
}
