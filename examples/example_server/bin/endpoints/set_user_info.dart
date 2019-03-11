import 'package:serverpod/server.dart';

import '../generated/protocol.dart';

class SetUserInfo extends Endpoint {
  SetUserInfo(Server server) : super(server);

  String get name => 'setUserInfo';

  Future<String> handleCall(UserInfo userInfo, String firstName, [String lastName, int number]) async {
    print('userInfo: $userInfo');

    await database.update(userInfo);

    return 'ok';
  }
}