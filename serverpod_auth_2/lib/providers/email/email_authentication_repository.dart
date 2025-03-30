import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

/// Simple provider that supports e-mail backed accounts ("username/password")
class EmailAuthenticationRepository {
  EmailAuthenticationRepository({
    required this.serverpod,
    // Can only be `null` if no mails need to be sent
    required this.mailService,
  }) {
    // This would not register a verify mail endpoint on Relic, as applications should use a deep link themselves and then continue on the API layer
  }

  final Serverpod serverpod;

  final MailService? mailService;

  final _credentials = <EmailCredential>[];
  final _pendingVerifications = <PendingEmailVerification>[];

  static const providerName = 'email';

  /// Returns the user ID for successful login
  int login(
    String email,
    String password, {
    /// Whether the email must be verified to log in
    bool requireVerifiedEmail = true,
  }) {
    return _credentials
        .firstWhere((c) =>
            c.email == email &&
            c.password == password &&
            (c.emailVerifiedAt != null || !requireVerifiedEmail))
        .userId;
  }

  /// Returns the verification flow ID in case the caller wants to store any information with this request
  String startVerificationFlow({
    required String email,
    // TODO: Would some implementors want an optional password here?
    //       Though they could then use some secret string and reset at the end of the flow themselves
    required String password,
    int? userId,
  }) {
    if (_pendingVerifications.any((p) => p.email == email)) {
      throw 'Registration already in progress';
    }

    final pendingVerification = PendingEmailVerification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      email: email,
      password: password,
      createdAt: DateTime.now(),
      verificationToken: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
    );

    mailService!.sendMail(email, pendingVerification.verificationToken);

    _pendingVerifications.add(pendingVerification);

    return pendingVerification.id;
  }

  /// Returns the verification flow ID
  void restartVerificationFlow({
    required String email,
  }) {
    final pendingVerification =
        _pendingVerifications.firstWhere((p) => p.email == email);

    // Depending on the age of the token, we would likely update it
    mailService!.sendMail(email, pendingVerification.verificationToken);
  }

  /// Adds an e-mail authentication to a user
  (String? verificationId,) addEmailAuthenticationForUser({
    required int userId,
    required String email,
    required String password,
    required bool sendVerificationEmail,
  }) {
    if (sendVerificationEmail) {
      if (_pendingVerifications.any((p) => p.email == email)) {
        throw 'Registration already in progress';
      }

      final pendingVerification = PendingEmailVerification(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        email: email,
        password: password,
        createdAt: DateTime.now(),
        verificationToken: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: userId,
      );

      mailService!.sendMail(email, pendingVerification.verificationToken);

      return (pendingVerification.id,);
    } else {
      // create without verification

      if (_credentials.any((c) => c.email == email)) {
        throw 'email is already used for a user';
      }

      var credential = EmailCredential(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: userId,
        createdAt: DateTime.now(),
        email: email,
        password: password,
        emailVerifiedAt: null,
      );

      _credentials.add(credential);
    }

    return (null,);
  }

  /// Returns the verification flow ID, if the mail has been validated
  String verifyEmailWithToken(String token) {
    var verification =
        _pendingVerifications.firstWhere((p) => p.verificationToken == token);

    if (_credentials.any((c) => c.email == verification.email)) {
      throw 'email is already used for a user';
    }

    return verification.id;
  }

  void createVerifiedAccount(String verificationId, int userId) {
    var verification =
        _pendingVerifications.firstWhere((p) => p.id == verificationId);

    if (_credentials.any((c) => c.email == verification.email)) {
      throw 'email is already used for a user';
    }

    _pendingVerifications.remove(verification);

    var credential = EmailCredential(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      createdAt: DateTime.now(),
      email: verification.email,
      password: verification.password,
      emailVerifiedAt: DateTime.now(),
    );

    _credentials.add(credential);
  }

  void requestPasswordReset(String email) {
    // similiar to verification flow, has to store intermediate request etc.
  }

  void changePassword(String passwortResetToken, String newPassword) {
    // similiar to verification flow
  }
}

class EmailCredential {
  EmailCredential({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.email,
    required this.password,
    required this.emailVerifiedAt,
  });

  final String id;

  /// ID of the Serverpod user
  /// (database relation)
  ///
  /// Could be `int` or `UUID` now…
  final int userId;

  final DateTime createdAt;

  final String email;

  final String password;

  final DateTime? emailVerifiedAt;
}

class PendingEmailVerification {
  PendingEmailVerification({
    required this.id,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.verificationToken,
    this.userId,
  });

  final String id;

  final String email;

  final String password;

  final DateTime createdAt;

  // DB: unique constraint
  final String verificationToken;

  /// User ID this credential should be assigned to upon validation
  final int? userId;
}
