import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/auth_user/auth_user.dart';

Future<UuidValue> createAuthUser(final Session session) async {
  final authUser = await AuthUsers.create(session);

  return authUser.id;
}
