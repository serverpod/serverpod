import 'package:serverpod/server.dart';

import '../generated/protocol.dart';

class GetUserInfo extends Endpoint {
  GetUserInfo(Server server) : super(server);

  String get name => 'getUserInfo';

  Future<CompanyInfo> handleCall(int id, String name) async {
    print('handleCall: $name $id');

    UserInfo userInfo = await database.findById(UserInfo.db, id);
    
    return CompanyInfo(
      employee: [userInfo, UserInfo(id: null, name: 'Fake')],
      numEmployees: 1,
      address: 'Norrsken house',
      name: 'Newsvoice',
    );
  }
}