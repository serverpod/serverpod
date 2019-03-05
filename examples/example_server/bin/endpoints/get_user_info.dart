import 'package:serverpod/server.dart';

import '../protocol/protocol.dart';

class GetUserInfo extends Endpoint {
  GetUserInfo(Server server) : super(server);

  String get name => 'getUserInfo';

  Future<UserInfo> handleCall(int id) async {
    print('handleCall: $name $id');

    UserInfo userInfo = await database.findById(UserInfo.db, id);
    
    return userInfo;
  }
}