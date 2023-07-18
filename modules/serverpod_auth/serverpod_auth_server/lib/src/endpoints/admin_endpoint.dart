import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

/// Endpoint for handling admin functions.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  /// Finds a user by its id.
  Future<UserInfo?> getUserInfo(Session session, int userId) async =>
      Users.findUserByUserId(session, userId);

  /// Marks a user as banned so that they can't log in, and invalidates their
  /// auth key so that they can't keep calling endpoints through their current
  /// session.
  Future<void> banUser(Session session, int userId) async =>
      Users.banUser(session, userId);

  /// Unblocks a user so that they can log in again.
  Future<void> unbanUser(Session session, int userId) async =>
      Users.unbanUser(session, userId);
}
