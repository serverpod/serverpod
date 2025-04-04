// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
// import '../generated/protocol.dart';

class EmailAccountEndpoint extends Endpoint {
  /// Returns the session key
  // TODO: just session or integrate example with "profile" package and return that out of the box?
  Future<String> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    final userId = await EmailAuthentication.login(
      session,
      email: email,
      password: password,
    );

    final sessionKey = await Sessions.create(session, userId: userId);

    return sessionKey;
  }

  Future<void> requestAccount(
    Session session, {
    required String email,
    required String password,
  }) async {
    await EmailAuthentication.requestAccount(session,
        email: email, password: password);
  }

  /// Returns sessions
  Future<String> finishRegistration(
    Session session, {
    required String verificationCode,
  }) async {
    await EmailAuthentication.verifyAccountRequest(
      session,
      verificationCode: verificationCode,
    );

    final userId = await Users.create(session);

    await EmailAuthentication.createAccount(
      session,
      verificationCode: verificationCode,
      userId: userId,
    );

    return await Sessions.create(session, userId: userId);
  }

// this showcase always creates a new user after verification
  // bundled:
  // verifyAccountRequest
  // createAccount

  // requestPasswordReset
  // completePasswordReset
}
