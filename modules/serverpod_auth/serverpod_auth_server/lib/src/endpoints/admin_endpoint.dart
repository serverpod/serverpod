import 'package:serverpod/serverpod.dart';
import '../../module.dart';

/// Endpoint for handling admin functions.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => <Scope>{Scope.admin};

  /// Finds a user by its id.
  Future<UserInfo?> getUserInfo(Session session, int userId) async {
    return Users.findUserByUserId(session, userId);
  }
}
