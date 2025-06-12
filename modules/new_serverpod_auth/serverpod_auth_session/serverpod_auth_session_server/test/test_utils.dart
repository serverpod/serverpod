import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

Future<UuidValue> createAuthUser(final Session session) async {
  final authUser = await AuthUsers.createAuthUser(session);

  return authUser.id;
}
