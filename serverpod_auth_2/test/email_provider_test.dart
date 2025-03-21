import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/2fa/sms/sms.dart';
import 'package:serverpod_auth_2/providers/email/email_account_repository.dart';
import 'package:serverpod_auth_2/serverpod/invitation_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';
import 'package:serverpod_auth_2/util/sms_service.dart';

// Now that the provider modules would not provide ready to use endpoints
// (as integrations between for example session and other components like 2FA just became too opaque)
// a developer would create their own endpoint where they can make use of the building blocks
// but gain the ability to clearly define the flow they want to enforce in their app
class EmailRegistrationEndpoint {
  EmailRegistrationEndpoint({
    required this.sessionRepository,
    required this.emailAuthenticationRepository,
  });

  final SessionRepository sessionRepository;

  final EmailAuthenticationRepository emailAuthenticationRepository;

  /// In practice a Serverpod project would only implement 1 registration function
  /// from either
  /// - [registerDirectly]
  /// - [registerWithVerification]
  /// - [registerWithVerificationAnd2FA]
  ///
  /// Or they might for example build one that is akin to [registerWithVerificationAnd2FA],
  /// but then has custom rules where some users might also get to enter without 2FA (e.g. it might only be enforced for "admins")
  void registerDirectly() {}

  void registerWithVerification() {}

  void registerWithVerificationAnd2FA() {}

  void verifyEmail(String verificationToken) {}

  void login(String email, String password) {}

  void verify2FA() {}
}

void main() {
  // test('E-mail based registration without verification and subsequent login',
  //     () {
  //   final serverpod = Serverpod();
  //   // registers itself with serverpod
  //   final emailProvider = EmailAccountProvider(
  //     serverpod: serverpod,
  //     mailService: null, // would be needed for reset though
  //     requiresVerifiedEmails: false,
  //   );

  //   // For simplicity we currently call directly into the `emailProvider`,
  //   // but in practice the API endpoints of the module would be exposed via the generated client,
  //   // (and available via `serverpod.api.handleCall` in this demo setup)

  //   final registerResult = emailProvider.register(
  //     null,
  //     'timm@lunaone.de',
  //     'admin',
  //   );

  //   expect(registerResult, isA<ActiveUserSession>());
  // });

  // test('E-mail based registration with verification and subsequent login', () {
  //   final serverpod = Serverpod();
  //   final mailService = MailService();
  //   // registers itself with serverpod
  //   final emailProvider = EmailAccountProvider(
  //     serverpod: serverpod,
  //     mailService: mailService,
  //   );

  //   final registerResult = emailProvider.register(
  //     null,
  //     'timm@lunaone.de',
  //     'admin',
  //   );

  //   expect(registerResult, isNull);

  //   expect(mailService.sentMails, hasLength(1));

  //   final verificationResult = emailProvider.verifyEmail(
  //     mailService.sentMails.last.$2,
  //   );

  //   expect(verificationResult, isA<ActiveUserSession>());
  // });

  test(
      'E-mail based registration with verification, 2FA enrollment, and subsequent login',
      () {
    final serverpod = Serverpod();
    final mailService = MailService();
    final smsService = SmsService();
    // registers itself with serverpod
    final emailProvider = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: mailService,
      requiresSecondFactor: true,
    );
    final sms2FaProvider = SMS2FAProvider(
      serverpod: serverpod,
      smsService: smsService,
    );

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
      additionalData: null,
    );

    expect(registerResult, isNull);

    expect(mailService.sentMails, hasLength(1));

    final postVerificationSession = emailProvider.verifyEmail(
      mailService.sentMails.last.$2,
    );

    expect(
      serverpod.userSessionRepository
          .resolveSessionToUserId(postVerificationSession)
          .$2,
      isTrue, // still needs second factor
    );

    sms2FaProvider.setupDuringRegistration(
      pendingSessionId: postVerificationSession,
      phoneNumber: '0123',
    );

    expect(smsService.sentTexts, hasLength(1));

    final secondFactorVerificationResponse =
        sms2FaProvider.verifyTokenWhenLoggingIn(
      pendingSessionId: postVerificationSession,
      token: smsService.sentTexts.last.$2,
    );

    expect(
      serverpod.userSessionRepository
          .resolveSessionToUserId(secondFactorVerificationResponse)
          .$2,
      isFalse, // second factor verified
    );
  });

  test('E-mail based registration with invitation code', () async {
    final serverpod = Serverpod();
    final invitationRepository = NewUserInvitationRepository(
      serverpod: serverpod,
    );

    serverpod.userInfoRepository.onBeforeUserCreate =
        invitationRepository.useExistingUserIfInvited;

    final mailService = MailService();
    final emailProvider = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: mailService,
      requiresSecondFactor: false,
      requiresVerifiedEmails: false,
      // invitationRepository: invitationRepository,
      // TODO: Provider could use parameter like "require invitation" to prevent unwanted registrations
    );

    final (invitationToken, createdUserId) =
        invitationRepository.createInvitation();
    // Code could not use the user id, e.g. assigning to a team etc.

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
      additionalData: {
        NewUserInvitationRepository.newUserInvitationKey: invitationToken,
      },
    );

    expect(
      serverpod.userSessionRepository
          .resolveSessionToUserId(registerResult!)
          .$1,
      createdUserId,
    );
  });

  // test('E-mail registration onto existing session', () async {
  //   final serverpod = Serverpod();
  //   final mailService = MailService();

  //   final emailProvider = EmailAccountProvider(
  //     serverpod: serverpod,
  //     mailService: mailService,
  //     requiresSecondFactor: false,
  //     requiresVerifiedEmails: false,
  //   );

  //   final registerResult = emailProvider.register(
  //     null,
  //     'timm@lunaone.de',
  //     'admin',
  //   );

  //   expect(
  //     registerResult,
  //     isA<ActiveUserSession>(),
  //   );

  //   final secondAuthenticationMethod = emailProvider.register(
  //     (registerResult as ActiveUserSession).id,
  //     'timm+2@lunaone.de',
  //     'admin',
  //   );

  //   expect(
  //     secondAuthenticationMethod,
  //     isA<ActiveUserSession>()
  //         .having((s) => s.userId, 'userId', registerResult.userId),
  //   );
  // });

  // TODO: 2FA: Enrollment (during registration?) and usage
}
