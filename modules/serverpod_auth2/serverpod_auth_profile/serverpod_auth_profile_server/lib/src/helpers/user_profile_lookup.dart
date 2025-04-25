import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';

Future<UserProfile?> findExistingUserByEmail(
  Session session, {
  required String email,
}) async {
  return UserProfile.db
      .findFirstRow(session, where: (t) => t.email.equals(email));
}
