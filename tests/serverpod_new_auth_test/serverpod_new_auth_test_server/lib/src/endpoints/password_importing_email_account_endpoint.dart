import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart';

/// Endpoint for email-based authentication which imports the legacy passwords.
class PasswordImportingEmailAccountEndpoint extends AuthEmailBaseEndpoint {
  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
  @override
  Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
      session,
      email: email,
      password: password,
    );

    return super.login(session, email: email, password: password);
  }

  /// Starts the registration for a new user account with an email-based login associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to complete the registration.
  @override
  Future<void> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
      session,
      email: email,
      password: password,
    );

    return super.startRegistration(session, email: email, password: password);
  }
}
