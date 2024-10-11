import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given transaction call in test',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
          'when database exception occurs '
          'then should close transaction after test suite and should not fail `dart test` by leaking exceptions',
          () async {
        var future = session.db.transaction((tx) async {
          var data = UniqueData(number: 1, email: 'test@test.com');
          await UniqueData.db.insertRow(session, data);
          await UniqueData.db.insertRow(session, data);
        });

        await expectLater(future, throwsA(isA<DatabaseException>()));
      });

      test(
          'when next test is run '
          'then should still work', () async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        expect(await SimpleData.db.find(session), hasLength(1));
      });
    },
  );
}
