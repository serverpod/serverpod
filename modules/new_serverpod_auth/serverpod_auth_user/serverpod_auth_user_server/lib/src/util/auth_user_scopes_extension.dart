import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Scopes extension for [AuthUserModel].
extension AuthUserScopes on AuthUserModel {
  /// Returns the `Scope`s for this auth user.
  Set<Scope> get scopes {
    return scopeNames.map(Scope.new).toSet();
  }
}
