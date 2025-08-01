import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

Future<UuidValue> createAuthUser(final Session session) async {
  final authUser = await AuthUsers.create(session);

  return authUser.id;
}
