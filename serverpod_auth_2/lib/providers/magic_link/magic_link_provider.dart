import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';
import 'package:serverpod_auth_2/util/mail_service.dart';

class MagicLinkProvider {
  MagicLinkProvider({
    required this.serverpod,
    required this.mailService,
    required this.userLookupFunc,
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

  // TODO: Would we want to support this here?
  // final bool requiresSecondFactor;

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

  ActiveUserSession logInViaMagicLink(String token) {
    final magicLink = pendingMagicLinks.firstWhere((p) => p.token == token);

    pendingMagicLinks.remove(magicLink);

    final int userId;
    if (magicLink.userId == null) {
      final newUser = serverpod.userInfoRepository.createUser();
      // TODO: Immutable / non-memory user would need to be written back…
      newUser.email = magicLink.email;

      userId = newUser.id!;
      usersByEmail[magicLink.email] = userId;
    } else {
      userId = magicLink.userId!;
    }

    return serverpod.userSessionRepository.createSession(
      userId,
      authProvider: providerName,
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
