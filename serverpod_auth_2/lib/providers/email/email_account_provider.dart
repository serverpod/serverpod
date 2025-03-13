import 'package:serverpod_auth_2/serverpod/invitation_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

/// Simple provider that supports e-mail backed accounts ("username/password")
class EmailAccountProvider {
  EmailAccountProvider({
    required this.serverpod,
    // Can only be `null` if no mails need to be sent
    required this.mailService,

    // should really always be true, but maybe somebody wants to test initially and does not have a "mailService"
    this.requiresVerifiedEmails = true,
    this.requiresSecondFactor = false,
    this.invitationRepository,
  }) {
    // serverpod.relic.registerEndpoint(path, handler);

    serverpod.api.registerEndpoint('email_account_provider', {
      // todo
    });
  }

  final Serverpod serverpod;

  final MailService? mailService;

  final bool requiresVerifiedEmails;

  final bool requiresSecondFactor;

  final NewUserInvitationRepository? invitationRepository;

  final _credentials = <EmailCredential>[];
  final _pendingVerification = <PendingEmailVerification>[];

  static const providerName = 'email';

  /// Returns `null` if the user needs to verify their mail
  /// (Response would be more explict in real case)
  ///
  /// Throws in all error cases
  UserSession? register(
    /// If given, then the this will add another authentication pass for the given user
    /// (This should be supported by all providers, maybe providers themselves would want to set a limit of how many accounts are allowed)
    String? sessionId,
    String email,
    String password, {
    String? invitationToken,
  }) {
    // TODO: normalize email, maybe even remove `+` part etc.

    if (_credentials.any((c) => c.email == email)) {
      throw Exception('Email "$email" is already in use.');
    }

    if (_pendingVerification.any((c) => c.email == email)) {
      throw Exception('Email "$email" is already pending verification.');
    }

    if (requiresVerifiedEmails) {
      _pendingVerification.add(
        PendingEmailVerification(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          email: email,
          password: password,
          createdAt: DateTime.now(),
          verificationToken: DateTime.now().microsecondsSinceEpoch.toString(),
          invitationToken: invitationToken,
        ),
      );

      mailService!.sendMail(email, _pendingVerification.last.verificationToken);

      return null;
    }

    // can only support one, as both might refer to a user and we can not merge them
    assert(invitationToken == null || sessionId == null);
    final user = _getOrCreateUser(
      invitationToken: invitationToken,
      sessionId: sessionId,
    );

    var credential = EmailCredential(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userInfoId: user.id!.toString(),
      createdAt: DateTime.now(),
      email: email,
      password: password,
      emailVerifiedAt: null,
    );

    _credentials.add(credential);

    if (requiresSecondFactor) {
      return serverpod.userSessionRepository
          .createSessionPendingSecondFactorVerification(
        user.id!,
        authProvider: providerName,
      );
    }

    return serverpod.userSessionRepository
        .createSession(user.id!, authProvider: providerName);
  }

  UserSession? verifyEmail(String token) {
    final verification =
        _pendingVerification.firstWhere((v) => v.verificationToken == token);

    if (verification.createdAt
        .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      throw Exception('Verification token has expired');
    }

    // just a sanity check that no user has been created in another way yet
    if (_credentials.any((c) => c.email == verification.email)) {
      throw Exception('Email "$verification.email" is already in use.');
    }

    final user = _getOrCreateUser(
      invitationToken: verification.invitationToken,
    );

    var credential = EmailCredential(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userInfoId: user.id!.toString(),
      createdAt: verification.createdAt,
      email: verification.email,
      password: verification.password,
      emailVerifiedAt: DateTime.now(),
    );

    // TODO: Update new user's email?

    _credentials.add(credential);

    if (requiresSecondFactor) {
      // TODO: Should the user even be created already if the 2FA is pending?
      //       For this provider probably fine, especially if the mail has been verified, but will that always be the case?

      return serverpod.userSessionRepository
          .createSessionPendingSecondFactorVerification(
        user.id!,
        authProvider: providerName,
      );
    }

    return serverpod.userSessionRepository
        .createSession(user.id!, authProvider: providerName);
  }

  UserSession login(
    String email,
    String password, {
    Map<String, dynamic>? additionalData,
  }) {
    final credential = _credentials
        .firstWhere((c) => c.email == email && c.password == password);

    final user = serverpod.userInfoRepository.getUser(credential.userInfoId);

    if (requiresSecondFactor) {
      return serverpod.userSessionRepository
          .createSessionPendingSecondFactorVerification(
        user.id!,
        authProvider: providerName,
      );
    }

    return serverpod.userSessionRepository
        .createSession(user.id!, authProvider: providerName);
  }

  void requestPasswordReset(String email) {
    // similiar to verification flow, has to store intermediate request etc.
  }

  void changePassword(String passwortResetToken, String newPassword) {
    // similiar to verification flow
  }

  UserInfo _getOrCreateUser({String? invitationToken, String? sessionId}) {
    if (sessionId != null) {
      final session = serverpod.userSessionRepository.getSessionById(sessionId);
      return serverpod.userInfoRepository.getUser(session.userId.toString());
    }

    if (invitationToken != null) {
      final (valid, userId) =
          invitationRepository!.resolveInvitation(invitationToken);
      if (!valid) {
        throw Exception('Invitation token "$invitationToken" is not valid');
      }

      if (userId != null) {
        return serverpod.userInfoRepository.getUser(userId.toString());
      }
    }

    return serverpod.userInfoRepository.createUser();
  }
}

class EmailCredential {
  EmailCredential({
    required this.id,
    required this.userInfoId,
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
  final String userInfoId;

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
    required this.invitationToken,
  });

  final String id;

  final String email;

  final String password;

  final DateTime createdAt;

  // DB: unique constraint
  final String verificationToken;

  final String? invitationToken;
}
