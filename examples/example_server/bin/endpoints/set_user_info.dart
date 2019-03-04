import 'package:serverpod/server.dart';

import '../protocol/protocol.dart';

class SetUserInfo extends Endpoint {
  SetUserInfo(Server server) : super(server);

  String get name => 'set_user_info';

  Future<Result> handleCall(UserInfo userInfo) async {
    print('userInfo: $userInfo');

    await database.update(userInfo);

    return ResultSuccess('ok');
  }
}