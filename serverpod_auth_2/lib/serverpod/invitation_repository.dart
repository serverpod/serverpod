import 'package:serverpod_auth_2/serverpod/serverpod.dart';

// hook for before/after user creation with invitation
// -> But account is not always created, maybe user is already logged it
// -> Before / after login user?

// 2FA package Ruby/Django

abstract class InvitationRepository {
  // A subclass might then implement something like `Future<String> createInvite(…)` however it sees fit
  //
  // For many implementations this can only ever be called once, as the code will then become invalid
  // Thus authentication provider should make sure to only call this once all pre-conditions are fulfilled and the will link their authentication method with this in the next step
  //
  // TODO: Maybe this would need to be extended into 2 APIs, so app's could show some info "about the invitation"
  //       But we should be careful to not make it harder to use correctly (such that each code can only be redeemed once for those "single user invites")
  (bool isValid, int? userId) resolveInvitation(String invitationCode,
      [int? userId]);
}

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
class NewUserInvitationRepository implements InvitationRepository {
  NewUserInvitationRepository({
    required this.serverpod,
  });

  final Serverpod serverpod;

  final _invitations = <String, int>{};

  (String invitationCode, int userId) createInvitation() {
    final user = serverpod.userInfoRepository.createUser();

    final code = DateTime.now().millisecondsSinceEpoch.toString();

    _invitations[code] = user.id!;

    return (code, user.id!);
  }

  @override
  (bool, int?) resolveInvitation(String invitationCode) {
    final userId = _invitations.remove(invitationCode);

    if (userId == null) {
      // this one always expect having created a user beforehand
      return (false, null);
    }

    return (true, userId);
  }
}
