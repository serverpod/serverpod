import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/2fa/sms/sms.dart';
import 'package:serverpod_auth_2/providers/email/email_account_provider.dart';
import 'package:serverpod_auth_2/serverpod/invitation_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';
import 'package:serverpod_auth_2/util/sms_service.dart';

void main() {
  test('E-mail based registration without verification and subsequent login',
      () {
    final serverpod = Serverpod();
    // registers itself with serverpod
    final emailProvider = EmailAccountProvider(
      serverpod: serverpod,
      mailService: null, // would be needed for reset though
      requiresVerifiedEmails: false,
    );

    // For simplicity we currently call directly into the `emailProvider`,
    // but in practice the API endpoints of the module would be exposed via the generated client,
    // (and available via `serverpod.api.handleCall` in this demo setup)

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
    );

    expect(registerResult, isA<ActiveUserSession>());
  });

  test('E-mail based registration with verification and subsequent login', () {
    final serverpod = Serverpod();
    final mailService = MailService();
    // registers itself with serverpod
    final emailProvider = EmailAccountProvider(
      serverpod: serverpod,
      mailService: mailService,
    );

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
    );

    expect(registerResult, isNull);

    expect(mailService.sentMails, hasLength(1));

    final verificationResult = emailProvider.verifyEmail(
      mailService.sentMails.last.$2,
    );

    expect(verificationResult, isA<ActiveUserSession>());
  });

  test(
      'E-mail based registration with verification, 2FA enrollment, and subsequent login',
      () {
    final serverpod = Serverpod();
    final mailService = MailService();
    final smsService = SmsService();
    // registers itself with serverpod
    final emailProvider = EmailAccountProvider(
      serverpod: serverpod,
      mailService: mailService,
      requiresSecondFactor: true,
    );
    final sms2FaProvider = SMS2FAProvider(
      serverpod: serverpod,
      smsService: smsService,
    );

    final registerResult =
        emailProvider.register(null, 'timm@lunaone.de', 'admin');

    expect(registerResult, isNull);

    expect(mailService.sentMails, hasLength(1));

    final verificationResult = emailProvider.verifyEmail(
      mailService.sentMails.last.$2,
    );

    expect(verificationResult, isA<UserSessionPendingSecondFactor>());

    final pendingSessionId =
        (verificationResult as UserSessionPendingSecondFactor).id;

    sms2FaProvider.setupDuringRegistration(
      pendingSessionId: pendingSessionId,
      phoneNumber: '0123',
    );

    expect(smsService.sentTexts, hasLength(1));

    final secondFactorVerificationResponse =
        sms2FaProvider.verifyTokenWhenLoggingIn(
      pendingSessionId: pendingSessionId,
      token: smsService.sentTexts.last.$2,
    );

    expect(secondFactorVerificationResponse, isA<ActiveUserSession>());
  });

  test('E-mail based registration with invitation code', () async {
    final serverpod = Serverpod();
    final mailService = MailService();
    final invitationRepository = NewUserInvitationRepository(
      serverpod: serverpod,
    );
    final emailProvider = EmailAccountProvider(
      serverpod: serverpod,
      mailService: mailService,
      requiresSecondFactor: false,
      requiresVerifiedEmails: false,
      invitationRepository: invitationRepository,
      // TODO: Provider could use parameter like "require invitation" to prevent unwanted registrations
    );

    final (invitationToken, invitedUserId) =
        invitationRepository.createInvitation();

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
      additionalData: {},
      // invitationToken: invitationToken,
    );

    expect(
      registerResult,
      isA<ActiveUserSession>().having((s) => s.userId, 'userId', invitedUserId),
    );
  });

  test('E-mail registration onto existing session', () async {
    final serverpod = Serverpod();
    final mailService = MailService();

    final emailProvider = EmailAccountProvider(
      serverpod: serverpod,
      mailService: mailService,
      requiresSecondFactor: false,
      requiresVerifiedEmails: false,
    );

    final registerResult = emailProvider.register(
      null,
      'timm@lunaone.de',
      'admin',
    );

    expect(
      registerResult,
      isA<ActiveUserSession>(),
    );

    final secondAuthenticationMethod = emailProvider.register(
      (registerResult as ActiveUserSession).id,
      'timm+2@lunaone.de',
      'admin',
    );

    expect(
      secondAuthenticationMethod,
      isA<ActiveUserSession>()
          .having((s) => s.userId, 'userId', registerResult.userId),
    );
  });

  // TODO: 2FA: Enrollment (during registration?) and usage
}
