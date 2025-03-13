/// Default Serverpod UserInfo class
///
/// Concrete fields TBD, but we probably have to at least retain all current fields
class UserInfo {
  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  late String userIdentifier;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  String? email;

  /// The time when this user was created.
  late DateTime created;

  /// A URL to the user's avatar.
  String? imageUrl;

  /// List of scopes that this user can access.
  late List<String> scopeNames;

  /// True if the user is blocked from signing in.
  late bool blocked;
}
