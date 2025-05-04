import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Collection of utility methods when working with anonymous authentication.
class Anonymous {
  /// Creates a new user off a password generated on the client without
  /// requiring any action on behalf of the user.
  static Future<UserInfo?> createAccount(
    Session session,
    String password,
  ) async {
    session.log('creating anonymous account', level: LogLevel.debug);

    UserInfo? userInfo = UserInfo(
      blocked: false,
      created: DateTime.now().toUtc(),
      scopeNames: [],
      // TODO: Is this sufficiently random for anonymous accounts? Will this
      // play nicely with account upgrades later?
      userIdentifier: Random().nextString(),
    );

    userInfo = await Users.createUser(session, userInfo, 'anonymous');

    if (userInfo == null) {
      session.log(' - failed to create UserInfo ', level: LogLevel.error);
      return null;
    }

    final auth = AnonymousAuth(
      userId: userInfo.id!,
      hash: await AuthConfig.current.passwordHashGenerator(password),
    );
    await AnonymousAuth.db.insertRow(session, auth);

    return userInfo;
  }

  /// Authenticates an anonymous user with their generated password. Returns an
  /// [AuthenticationResponse] with the user's information.
  static Future<AuthenticationResponse> authenticate(
    Session session,
    int userId,
    String password,
  ) async {
    password = password.trim();
    session.log('authenticate anon $userId / XXXXXXXX', level: LogLevel.debug);

    // Fetch AnonymousUser entry
    var entry = await AnonymousAuth.db.findFirstRow(session, where: (t) {
      return t.userId.equals(userId);
    });

    if (entry == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - found entry ', level: LogLevel.debug);

    if (await _hasTooManyFailedSignIns(session, userId)) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.tooManyFailedAttempts,
      );
    }

    if (!await Anonymous.validatePasswordHash(
      password,
      userId,
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
      await _logFailedSignIn(session, userId);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - password is correct, userId: $userId)',
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
      'anonymous',
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
    int userId,
    String hash, {
    void Function({
      required String passwordHash,
      required String storedHash,
    })? onValidationFailure,
    void Function(Object e)? onError,
  }) =>
      AuthConfig.current.passwordHashValidator(
        password,
        userId.toString(),
        hash,
        onError: onError,
        onValidationFailure: onValidationFailure,
      );

  static Future<void> _logFailedSignIn(Session session, int userId) async {
    session as MethodCallSession;
    var failedSignIn = AnonymousFailedSignIn(
      userId: userId,
      time: DateTime.now(),
      ipAddress: session.httpRequest.remoteIpAddress,
    );
    await AnonymousFailedSignIn.db.insertRow(session, failedSignIn);
  }

  static Future<bool> _hasTooManyFailedSignIns(
      Session session, int userId) async {
    var numFailedSignIns = await AnonymousFailedSignIn.db.count(
      session,
      where: (t) =>
          t.id.equals(userId) &
          (t.time >
              DateTime.now()
                  .toUtc()
                  .subtract(AuthConfig.current.emailSignInFailureResetTime)),
    );
    return numFailedSignIns >= AuthConfig.current.maxAllowedEmailSignInAttempts;
  }
}
