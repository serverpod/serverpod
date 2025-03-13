import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/magic_link/magic_link_provider.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

void main() {
  test('Register via magic link', () {
    final serverpod = Serverpod();
    final mailService = MailService();
    final magicLinkProvider = MagicLinkProvider(
      serverpod: serverpod,
      mailService: mailService,
      accountMustExist: false,
      userLookupFunc: (email) => {},
    );

    magicLinkProvider.sendMagicLink('timm@lunaone.de');

    expect(mailService.sentMails, hasLength(1));

    final session = magicLinkProvider.logInViaMagicLink(
      mailService.sentMails.last.$2,
    );

    expect(session, isA<ActiveUserSession>());
    expect(serverpod.userInfoRepository.users, hasLength(1));
    expect(serverpod.userSessionRepository.activeSessions, hasLength(1));
  });

  test('Use magic link to log into an existing account', () {
    // TODO: Should we required 2FA if the original provider likely used that?
    // Otherwise you could possibly sign in with only the e-mail password for
    // an account that was using the verified & double-checked Apple ID beforehand

    final serverpod = Serverpod();
    final existingUser = serverpod.userInfoRepository.createUser();
    final mailService = MailService();
    final magicLinkProvider = MagicLinkProvider(
      serverpod: serverpod,
      mailService: mailService,
      accountMustExist: true,
      userLookupFunc: (email) {
        // in practice the developer would have to pass in the helpers from the EmailProvider, GoogleProvider, etc. in here
        // Maybe even also a `UserInfo` query
        // Care should be taken to only look at verified e-mail addresses (by default), so as not to allow mail access
        // to an account that was somehow created with an unverified mail address (and maybe is used by someone else)
        if (email == 'timm@lunaone.de') {
          return {existingUser.id!};
        }

        return {};
      },
    );

    magicLinkProvider.sendMagicLink('timm@lunaone.de');

    expect(mailService.sentMails, hasLength(1));

    final session = magicLinkProvider.logInViaMagicLink(
      mailService.sentMails.last.$2,
    );

    expect(session, isA<ActiveUserSession>());
    expect(serverpod.userInfoRepository.users, hasLength(1));
    expect(serverpod.userSessionRepository.activeSessions, hasLength(1));
  });
}
