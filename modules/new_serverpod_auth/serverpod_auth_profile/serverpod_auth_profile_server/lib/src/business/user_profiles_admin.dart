part of 'user_profiles.dart';

/// Admin operations complementing the end-user [UserProfilesAdmin] functionality.
///
/// An instance of this class is available at [UserProfiles.admin].
final class UserProfilesAdmin {
  UserProfilesAdmin._();

  /// Returns all user profiles that match the specified criteria.
  ///
  /// For a direct look-up by auth user ID use [findUserProfileByUserId].
  Future<List<UserProfileModel>> listUserProfiles(
    final Session session, {
    final String? email,
    final String? userName,
    final String? fullName,

    /// How many items to return at most. Must be <= 1000.
    final int limit = 100,
    final int offset = 0,
    final Transaction? transaction,
  }) async {
    if (limit <= 0 || limit > 1000) {
      throw ArgumentError.value(limit, 'limit', 'Must be between 1 and 1000');
    }
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Must be >= 0');
    }

    final profiles = await UserProfile.db.find(
      session,
      where: (final t) {
        Expression<dynamic> expression = Constant.bool(true);

        if (email != null) {
          expression &= t.email.equals(email);
        }

        if (userName != null) {
          expression &= t.userName.equals(userName);
        }

        if (fullName != null) {
          expression &= t.fullName.equals(fullName);
        }

        return expression;
      },
      limit: limit,
      offset: offset,
      orderBy: (final t) => t.id,
      transaction: transaction,
    );

    return profiles.map((final p) => p.toModel()).toList();
  }
}
