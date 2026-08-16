import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Endpoint for handling admin functions.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  /// Finds a user by its id.
  Future<UserInfo?> getUserInfo(Session session, int userId) async =>
      Users.findUserByUserId(session, userId);

  /// Marks a user as blocked so that they can't log in, and invalidates their
  /// auth key so that they can't keep calling endpoints through their current
  /// session.
  Future<void> blockUser(Session session, int userId) async =>
      Users.blockUser(session, userId);

  /// Unblocks a user so that they can log in again.
  Future<void> unblockUser(Session session, int userId) async =>
      Users.unblockUser(session, userId);
}
