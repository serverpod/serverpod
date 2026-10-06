import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email_passwordless.dart';

/// The default code that the fixture generates for every login request.
const fixtureVerificationCode = '123456';

/// A verification code that was passed to one of the send callbacks.
final class SentLoginCode {
  final String email;
  final UuidValue loginRequestId;
  final String verificationCode;

  SentLoginCode({
    required this.email,
    required this.loginRequestId,
    required this.verificationCode,
  });
}

final class EmailPasswordlessIdpTestFixture {
  late final EmailPasswordlessIdp idp;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers authUsers = const AuthUsers();

  /// The codes sent for email addresses without an account.
  final List<SentLoginCode> signUpCodes = [];

  /// The codes sent for email addresses with an account.
  final List<SentLoginCode> signInCodes = [];

  EmailPasswordlessIdpTestFixture({
    final bool allowSignUp = true,
    final String Function() loginVerificationCodeGenerator = _defaultGenerator,
    final Duration loginVerificationCodeLifetime = const Duration(minutes: 10),
    final int loginVerificationCodeAllowedAttempts = 3,
    final RateLimit failedLoginRateLimit = const RateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 5),
    ),
    final RateLimit loginRequestRateLimit = const RateLimit(
      maxAttempts: 5,
      timeframe: Duration(minutes: 5),
    ),
    final Duration resendCooldown = Duration.zero,
    final BeforePasswordlessAccountCreatedFunction? onBeforeAccountCreated,
    final AfterAccountCreatedFunction? onAfterAccountCreated,
    final AfterPasswordlessLoginFunction? onAfterLogin,
    final SendPasswordlessLoginVerificationCodeFunction? sendSignUpOverride,
    final SendPasswordlessLoginVerificationCodeFunction? sendSignInOverride,
    TokenManager? tokenManager,
  }) {
    tokenManager ??= AuthServices(
      authUsers: authUsers,
      userProfiles: userProfiles,
      primaryTokenManagerBuilder: ServerSideSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
      identityProviderBuilders: [],
    ).tokenManager;

    this.tokenManager = tokenManager;

    idp = EmailPasswordlessIdp(
      EmailPasswordlessIdpConfig(
        secretHashPepper: 'pepper',
        allowSignUp: allowSignUp,
        loginVerificationCodeGenerator: loginVerificationCodeGenerator,
        loginVerificationCodeLifetime: loginVerificationCodeLifetime,
        loginVerificationCodeAllowedAttempts:
            loginVerificationCodeAllowedAttempts,
        failedLoginRateLimit: failedLoginRateLimit,
        loginRequestRateLimit: loginRequestRateLimit,
        resendCooldown: resendCooldown,
        onBeforeAccountCreated: onBeforeAccountCreated,
        onAfterAccountCreated: onAfterAccountCreated,
        onAfterLogin: onAfterLogin,
        sendSignUpVerificationCode:
            sendSignUpOverride ?? _recordingSender(signUpCodes),
        sendSignInVerificationCode:
            sendSignInOverride ?? _recordingSender(signInCodes),
      ),
      tokenManager: tokenManager,
    );
  }

  static String _defaultGenerator() => fixtureVerificationCode;

  static SendPasswordlessLoginVerificationCodeFunction _recordingSender(
    final List<SentLoginCode> sentCodes,
  ) {
    return (
      final Session session, {
      required final String email,
      required final UuidValue loginRequestId,
      required final String verificationCode,
      required final Transaction? transaction,
    }) {
      sentCodes.add(
        SentLoginCode(
          email: email,
          loginRequestId: loginRequestId,
          verificationCode: verificationCode,
        ),
      );
    };
  }

  Future<EmailAccount> createEmailAccount(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    final String passwordHash = '',
  }) async {
    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.toLowerCase().trim(),
        passwordHash: passwordHash,
      ),
    );
  }

  Future<void> tearDown(final Session session) async {
    await session.db.transaction((final transaction) async {
      await Future.wait([
        EmailAccount.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        EmailAccountLoginRequest.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        RateLimitedRequestAttempt.db.deleteWhere(
          session,
          where: (final t) => t.domain.equals('email_passwordless'),
          transaction: transaction,
        ),
        SecretChallenge.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
        AuthUser.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
          transaction: transaction,
        ),
      ]);
    });
  }
}
