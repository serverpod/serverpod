import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';

Future<UserProfile> createUserProfile(
  Session session, {
  required UuidValue userId,
  String? userName,
  String? fullName,
  String? email,
  String? imageUrl,
}) async {
  return UserProfile.db.insertRow(
    session,
    UserProfile(
      userId: userId,
      created: DateTime.now(), // TODO: Keep old date?
      userName: userName,
      fullName: fullName,
      email: email,
      // TODO: Would we need to migrate the existing image (info), so it does not get cleaned up?
      imageUrl: imageUrl,
    ),
  );
}
