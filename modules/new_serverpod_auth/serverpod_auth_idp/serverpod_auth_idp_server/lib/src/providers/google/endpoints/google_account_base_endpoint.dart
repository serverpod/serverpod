import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

import '../google.dart';

abstract class GoogleAccountBaseEndpoint extends Endpoint {
  static const String _method = 'google';

  Future<AuthSuccess> authenticate(
    Session session, {
    required final String idToken,
  }) async {
    return session.db.transaction((final transaction) async {
      final account = await GoogleAccounts.authenticate(
        session,
        idToken: idToken,
        transaction: transaction,
      );

      if (account.authUserNewlyCreated) {
        await UserProfiles.createUserProfile(
          session,
          account.authUserId,
          UserProfileData(
            fullName: account.details.fullName.trim(),
            email: account.details.email,
          ),
          transaction: transaction,
        );

        if (Uri.tryParse(account.details.image) case Uri imageUri) {
          try {
            await UserProfiles.setUserImageFromUrl(
              session,
              account.authUserId,
              imageUri,
              transaction: transaction,
            );
          } catch (e, stackTrace) {
            session.log(
              'Failed to import profile image from Google account.',
              level: LogLevel.error,
              exception: e,
              stackTrace: stackTrace,
            );
          }
        }
      }

      return _createSession(
        session,
        account.authUserId,
        transaction: transaction,
      );
    });
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
