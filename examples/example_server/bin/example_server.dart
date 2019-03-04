import 'package:serverpod/serverpod.dart';

import 'endpoints/get_user_info.dart';
import 'endpoints/set_user_info.dart';

import 'protocol/protocol.dart';

void main(List<String> args) async {
  // Create server
  final server = Server(args, Protocol());

  // Create endpoints
  GetUserInfo(server);
  SetUserInfo(server);

  // Start server
  await server.start();

  UserInfo user = await server.database.findById(UserInfo.db, 1);
  print('table.name: ${user.name} table.id: ${user.id}');

  var objs = await server.database.find(UserInfo.db, UserInfoTable.name.equals(Constant('Anna')));
  for (UserInfo obj in objs) {
    print('table.name: ${obj.name} table.id: ${obj.id}');
  }
}
