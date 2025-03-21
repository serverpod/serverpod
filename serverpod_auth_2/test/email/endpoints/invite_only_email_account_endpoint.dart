import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/providers/email/email_account_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

class InviteOnlyEmailAccountEndpoint {
  InviteOnlyEmailAccountEndpoint({
    required this.sessionRepository,
    required this.userInfoRepository,
    required this.emailAuthenticationRepository,
    required this.mailService,
  });

  final SessionRepository sessionRepository;

  final UserInfoRepository userInfoRepository;

  final EmailAuthenticationRepository emailAuthenticationRepository;

  final MailService mailService;

  @visibleForTesting
  final pendingInvites = <String>{};

  void invite(
    String sessionId,
    String email,
  ) {
    // would check that session is active and user has permissions etc.

    final inviteCode = DateTime.now().microsecondsSinceEpoch.toString();

    pendingInvites.add(inviteCode);

    mailService.sendMail(email, inviteCode);
  }

  String register({
    required String inviteCode,
    required String email,
    required String password,
  }) {
    if (!pendingInvites.remove(inviteCode)) {
      throw 'Invite does not exist';
    }

    final user = userInfoRepository.createUser(null, null);

    emailAuthenticationRepository.addEmailAuthenticationForUser(
      userId: user.id!,
      email: email,
      password: password,
      sendVerificationEmail: false,
    );

    return sessionRepository.createSession(
      user.id!,
      authProvider: 'email',
      additionalData: null,
    );
  }

  String login(String email, String password) {
    final userId = emailAuthenticationRepository.login(email, password);

    return sessionRepository.createSession(
      userId,
      authProvider: 'email',
      additionalData: null,
    );
  }
}
