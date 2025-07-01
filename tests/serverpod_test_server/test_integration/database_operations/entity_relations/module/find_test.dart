import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await ObjectUser.db.deleteWhere(session, where: (_) => Constant.bool(true));
    await UserInfo.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
      'Given an object relation to a module model when querying for the object then the module model is included.',
      () async {
    var expectedName = 'John Doe';

    var user = UserInfo(
      userIdentifier: '1234',
      userName: expectedName,
      created: DateTime.now(),
      scopeNames: [],
      blocked: false,
    );
    var insertedUser = await UserInfo.db.insertRow(session, user);

    var objectUser = ObjectUser(
      userInfoId: insertedUser.id!,
      userInfo: insertedUser,
    );
    await ObjectUser.db.insertRow(session, objectUser);

    var result = await ObjectUser.db.findFirstRow(session,
        orderBy: (t) => t.id,
        include: ObjectUser.include(
          userInfo: UserInfo.include(),
        ));

    expect(result?.userInfo?.userName, expectedName);
  });
}
