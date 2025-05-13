// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Endpoint for creating anonymous accounts which may or may not be upgraded to
/// use a real identity provider at a later time.
class AnonymousEndpoint extends Endpoint {
  /// Creates a new account.
  Future<UserInfo?> createAccount(
    Session session, {
    required String password,
  }) async {
    return await Anonymous.createAccount(session, password);
  }

  /// Authenticates an anonymous user with their userId and password (which was
  /// generated on behalf of the user by the client). Returns an
  /// [AuthenticationResponse] with the user's information.
  Future<AuthenticationResponse> authenticate(
    Session session, {
    required int userId,
    required String password,
  }) async {
    return Anonymous.authenticate(session, userId, password);
  }
}
