import 'package:serverpod_auth_2/providers/email/email_authentication_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

class VerifiedEmailAccountEndpoint {
  VerifiedEmailAccountEndpoint({
    required this.sessionRepository,
    required this.userInfoRepository,
    required this.emailAuthenticationRepository,
  });

  final SessionRepository sessionRepository;

  final UserInfoRepository userInfoRepository;

  final EmailAuthenticationRepository emailAuthenticationRepository;

  void register({
    required String email,
    required String password,
  }) {
    // in our flow, we only want to create the user after they have verified the email

    // This would also be the place to e.g. restrict the emails to some company domain etc.

    emailAuthenticationRepository.startVerificationFlow(
      email: email,
      password: password,
    );
  }

  /// Returns the session ID if the verification was successful
  String verifyEmail(String verificationToken) {
    final verificationId = emailAuthenticationRepository.verifyEmailWithToken(
      verificationToken,
    );

    final user = userInfoRepository.createUser(null, {});

    emailAuthenticationRepository.createVerifiedAccount(
      verificationId,
      user.id!,
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
