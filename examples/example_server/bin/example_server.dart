import 'package:serverpod/serverpod.dart';

import 'endpoints/get_user_info.dart';
import 'endpoints/set_user_info.dart';

import 'generated/protocol.dart';

void main(List<String> args) async {
  // Create server
  final server = Server(args, Protocol());

  // Create endpoints
  GetUserInfo(server);
  SetUserInfo(server);

  // Start server
  await server.start();
}
