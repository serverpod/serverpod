import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

// This would be entirely implemented by the developer
//
// Potentially the "Email authentication provider" could offer some support here by having "passwordless accounts", but that would probably make that interface worse,
// and also the concept of "email verification" does not apply directly, since that happens in each login.
class MagicLinkEndpoint {
  MagicLinkEndpoint({
    required this.serverpod,
    required this.mailService,

    // Parametesr like these 2 are optional, depending on whether the developer wants to support logins into existing account
    // (which then should be looked up through the repositories, as the user info can not expected to hold the current and valid email)
    required this.userLookupFunc,
    // For the developer, this would likely not be a flag, but rather the implicit behavior of their "login"/send link function
    required this.accountMustExist,
  });

  final Serverpod serverpod;

  final MailService mailService;

  /// Accounts created by or used through magic links (would be DB persisted, with relation to user table)
  final usersByEmail = <String, int>{};

  final pendingMagicLinks = <PendingMagicLink>[];

  /// Gives the magic link the ability to look up existing users by e-mail,
  /// in order to log "into them" instead of creating new ones
  final Set<int> Function(String email) userLookupFunc;

  /// Whether magic links can only be created for existing accounts,
  /// or whether they could also be used to create an account implicitly
  final bool accountMustExist;

  static const providerName = 'magic_link';

  /// Send out a magic link mail, or throws in case of error
  void sendMagicLink(String email) {
    var userId = usersByEmail[email];
    if (userId == null) {
      final usersWithSameMail = userLookupFunc(email);

      if (usersWithSameMail.length > 1) {
        throw Exception(
            'found ${usersWithSameMail.length} different accounts for $email');
      }

      if (usersWithSameMail.isNotEmpty) {
        userId = usersWithSameMail.single;
      }
    }

    if (userId == null && accountMustExist) {
      throw Exception(
          'Did not find an existing user with $email, and creating new ones this way is disabled');
    }

    final magicLink = PendingMagicLink(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      email: email,
      token: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
    );

    // keep this here, or should we be using a pending session?
    // We just have to be careful, that the session is not "upgraded" via an unwanted path, so maybe we should make the other one explicit about 2FA.
    pendingMagicLinks.add(magicLink);

    mailService.sendMail(email, magicLink.token);
  }

  String logInViaMagicLink(String token) {
    final magicLink = pendingMagicLinks.firstWhere((p) => p.token == token);

    pendingMagicLinks.remove(magicLink);

    final int userId;
    if (magicLink.userId == null) {
      final newUser = serverpod.userInfoRepository.createUser(
        UserInfo()..email = magicLink.email,
        null,
      );

      userId = newUser.id!;
      usersByEmail[magicLink.email] = userId;
    } else {
      userId = magicLink.userId!;
    }

    return serverpod.userSessionRepository.createSession(
      userId,
      authProvider: providerName,
      additionalData: null,
    );
  }
}

class PendingMagicLink {
  PendingMagicLink({
    required this.id,
    required this.token,
    required this.userId,
    required this.email,
    required this.createdAt,
  });

  final String id;

  final String token;

  /// If the account already exists
  final int? userId;

  final String email;

  final DateTime createdAt;
}

// TODO: In addition to sending out magic links, it's also often supported to get a "PIN" and enter that in the app (which might be easier than deep linking and/or opening the link on the correct device)
