import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/2fa/sms/sms.dart';
import 'package:serverpod_auth_2/providers/email/email_account_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';
import 'package:serverpod_auth_2/util/sms_service.dart';

import 'endpoints/invite_only_email_account_endpoint.dart';
import 'endpoints/simple_email_account_endpoint.dart';
import 'endpoints/two_factor_email_account_endpoint.dart';
import 'endpoints/verified_email_account_endpoint.dart';

// Now that the provider modules would not provide ready to use endpoints
// (as integrations between for example session and other components like 2FA just became too opaque)
// a developer would create their own endpoint where they can make use of the building blocks
// but gain the ability to clearly define the flow they want to enforce in their app

/// In practice a Serverpod project would only implement 1 registration function
/// from either
/// - [registerDirectly]
/// - [registerWithVerification]
/// - [registerWithVerificationAnd2FA]
///
/// Or they might for example build one that is akin to [registerWithVerificationAnd2FA],
/// but then has custom rules where some users might also get to enter without 2FA (e.g. it might only be enforced for "admins")
///
/// Additional the `register*` endpoints may include a session to allow adding the e-mail login as an additional method

void main() {
  test('E-mail based registration without verification and subsequent login',
      () {
    final serverpod = Serverpod();
    final emailAuthenticationRepository = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: null,
    );
    final emailAccountEndpoint = SimpleEmailAccountEndpoint(
      sessionRepository: serverpod.userSessionRepository,
      userInfoRepository: serverpod.userInfoRepository,
      emailAuthenticationRepository: emailAuthenticationRepository,
    );

    // registration
    {
      final sessionKey = emailAccountEndpoint.register(
        email: 'timm@lunaone.de',
        password: 'admin',
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }

    // login
    {
      final sessionKey = emailAccountEndpoint.login(
        'timm@lunaone.de',
        'admin',
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }
  });

  test('E-mail based registration with verification and subsequent login', () {
    final serverpod = Serverpod();
    final mailService = MailService();
    final emailAuthenticationRepository = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: mailService,
    );
    final emailAccountEndpoint = VerifiedEmailAccountEndpoint(
      sessionRepository: serverpod.userSessionRepository,
      userInfoRepository: serverpod.userInfoRepository,
      emailAuthenticationRepository: emailAuthenticationRepository,
    );

    // registration with verification
    {
      emailAccountEndpoint.register(
        email: 'timm@lunaone.de',
        password: 'admin',
      );

      expect(mailService.sentMails, hasLength(1));
      final sessionKey = emailAccountEndpoint.verifyEmail(
        mailService.sentMails.last.$2,
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }

    // login
    {
      final sessionKey = emailAccountEndpoint.login(
        'timm@lunaone.de',
        'admin',
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }
  });

  test(
      'E-mail based registration with verification, 2FA enrollment, and subsequent login',
      () {
    final serverpod = Serverpod();
    final mailService = MailService();
    final smsService = SmsService();
    // registers itself with serverpod
    final emailAuthenticationRepository = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: mailService,
    );
    final sms2FaRepository = SMS2FARepository(
      serverpod: serverpod,
      smsService: smsService,
    );
    final emailAccountEndpoint = TwoFactorEmailRegistrationEndpoint(
      sessionRepository: serverpod.userSessionRepository,
      userInfoRepository: serverpod.userInfoRepository,
      emailAuthenticationRepository: emailAuthenticationRepository,
      sms2faRepository: sms2FaRepository,
    );

    // registration
    {
      emailAccountEndpoint.register(
        'timm@lunaone.de',
        'admin',
      );

      expect(mailService.sentMails, hasLength(1));

      final secondFactorProcessId = emailAccountEndpoint.verifyEmail(
        mailService.sentMails.last.$2,
      );

      emailAccountEndpoint.setupSMS2FA(secondFactorProcessId, '0123456');

      expect(sms2FaRepository.pendingRegistrationsByProcessId, hasLength(1));

      final sessionKey = emailAccountEndpoint.verify2FA(
          sms2FaRepository.pendingRegistrationsByProcessId.values.last.token);

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }

    // login (with 2FA)
    {
      emailAccountEndpoint.login(
        'timm@lunaone.de',
        'admin',
      );

      expect(sms2FaRepository.inProgressLogins, hasLength(1));

      final sessionKey = emailAccountEndpoint
          .verifyLogin(sms2FaRepository.inProgressLogins.values.last.token);

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
    }
  });

  test('E-mail based registration with invitation code', () async {
    final serverpod = Serverpod();

    final emailAuthenticationRepository = EmailAuthenticationRepository(
      serverpod: serverpod,
      mailService: null,
    );
    final mailService = MailService();
    final emailAccountEndpoint = InviteOnlyEmailAccountEndpoint(
        sessionRepository: serverpod.userSessionRepository,
        userInfoRepository: serverpod.userInfoRepository,
        emailAuthenticationRepository: emailAuthenticationRepository,
        mailService: mailService);

    emailAccountEndpoint.invite('session_id_tbd', 'timm@lunaone.de');

    expect(mailService.sentMails, hasLength(1));

    final inviteCode = mailService.sentMails.last.$2;

    final sessionKey = emailAccountEndpoint.register(
      inviteCode: inviteCode,
      email: 'timm@lunaone.de',
      password: 'admin',
    );

    expect(
      serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
      isNotNull,
    );
  });

  // TODO: Currently not shown, but basically all of the email account endpoints could support an "authentication session ID"
  // and then add the user to that one, instead of creating a new user themselves
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
}
