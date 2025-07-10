import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_google_account_server/serverpod_auth_google_account_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

abstract class GoogleAccountBaseEndpoint extends Endpoint {
  static const String _method = 'google';

  Future<AuthSuccess> authenticate(
    Session session, {
    required final String idToken,
  }) async {
    final account = await GoogleAccounts.authenticate(
      session,
      idToken: idToken,
    );

    if (account.authUserNewlyCreated) {
      await UserProfiles.createUserProfile(
        session,
        account.authUserId,
        UserProfileData(
          fullName: account.details.fullName,
          userName: account.details.name,
          email: account.details.email,
        ),
      );
    }

    return _createSession(session, account.authUserId);
  }

  Future<AuthSuccess> _createSession(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    final sessionKey = await AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: _method,
      scopes: authUser.scopes,
      transaction: transaction,
    );

    return sessionKey;
  }
}
