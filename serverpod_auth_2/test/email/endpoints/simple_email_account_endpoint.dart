import 'package:serverpod_auth_2/providers/email/email_authentication_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

class SimpleEmailAccountEndpoint {
  SimpleEmailAccountEndpoint({
    required this.sessionRepository,
    required this.userInfoRepository,
    required this.emailAuthenticationRepository,
  });

  final SessionRepository sessionRepository;

  final UserInfoRepository userInfoRepository;

  final EmailAuthenticationRepository emailAuthenticationRepository;

  String register({
    required String email,
    required String password,
  }) {
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
    final userId = emailAuthenticationRepository.login(
      email,
      password,
      requireVerifiedEmail: false,
    );

    return sessionRepository.createSession(
      userId,
      authProvider: 'email',
      additionalData: null,
    );
  }
}
