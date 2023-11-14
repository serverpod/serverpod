import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
      'Given a list of entries when finding the first row by ordering and offsetting the query then the correct row is returned.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
      UniqueData(number: 3, email: 'career@serverpod.dev'),
    ];

    await UniqueData.db.insert(session, data);

    var dev = await UniqueData.db.findFirstRow(
      session,
      orderBy: (t) => t.number,
      orderDescending: true,
      offset: 1,
    );

    expect(dev?.email, 'dev@serverpod.dev');
  });
}
