import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  // TODO: implement requiredScopes
  Set<Scope> get requiredScopes => {Scope.admin};

  Future<UserInfo?> getUserInfo(Session session, int userId) async {
    return Users.findUserByUserId(session, userId);
  }
}
