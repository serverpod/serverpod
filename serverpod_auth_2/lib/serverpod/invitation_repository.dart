import 'package:serverpod_auth_2/additional_data.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';

// hook for before/after user creation with invitation
// -> But account is not always created, maybe user is already logged it
// -> Before / after login user?

// 2FA package Ruby/Django

/// We could image 3 approaches outright:
///  - Invitation code (either static, or DB-counted with a limit), allowing "closed" registrations so that no public endpoints can be used (if the providers check this)
///  - A "token based" approached, that returns a signed information with some user info to use post-registration (this could be tricky to ensure that it's only used once (or n times), but some systems might want this)
///  - An invitation code that refers to a previously created user which does not yet have an authentication-mechanism ("login") assigned to it
///    - The drawback of this approach would of course be, that if the user already has an account and you just want to invite them to a certain work team, for example, then they could not accept this with their existing account, but rather would have to create a new one (hoping that they still have another authentication mechanism available)
///    - So developer should probably beforehand check if the user does not exist already, and allow looking them up
///      - Would this be even trickier in a multi-tenant way? Where the user account might exist, but the user (from another tenant) should not be able to see it?

// TODO: In order to solve the last point above (that the invited user might already have an account), we might need to use a "deferred user creation" by default

/// Demo implementation of what an invitation flow could look like which creates a new user
///
/// This user can then already be used in the app (e.g. assigned to a team),
/// and the link to an authentication will be done when one is registered with the return code.
class NewUserInvitationRepository {
  NewUserInvitationRepository({
    required this.serverpod,
  });

  final Serverpod serverpod;

  final _invitations = <String, int>{};

  (String, int userId) createInvitation() {
    final user = serverpod.userInfoRepository.createUser(null, null);

    final code = DateTime.now().millisecondsSinceEpoch.toString();

    _invitations[code] = user.id!;

    return (code, user.id!);
  }

  /// Key used in `AdditionalData`
  static const newUserInvitationKey = "new_user_invitation";

  UserInfo? useExistingUserIfInvited(
    UserInfo? user,
    AdditionalData? additionalData,
  ) {
    if (additionalData?[newUserInvitationKey] != null) {
      assert(user == null);
      // tricky, but how would we handle having both at this point?
      // or maybe create user must always be a 2 step operation with the repostory creating an empty one (such that middleware could even overwrite)
      final userId = _invitations[additionalData![newUserInvitationKey]!]!;
      return serverpod.userInfoRepository.getUser(userId);
    }

    return null;
  }
}
