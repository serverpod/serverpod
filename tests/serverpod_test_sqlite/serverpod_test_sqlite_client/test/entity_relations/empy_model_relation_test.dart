import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';

void main() {
  initTestClientSession();

  group(
    'Given a model that only has id column when inserted to the database',
    () {
      RelationEmptyModel? data;
      setUp(() async {
        data = await RelationEmptyModel.db.insertRow(
          session,
          RelationEmptyModel(),
        );
      });

      test('then the model is returned from the insert with an id.', () {
        expect(data, isNotNull);
        expect(data?.id, isNotNull);
      });

      test('then the model can be fetched from the database', () async {
        var fetchedData = await RelationEmptyModel.db.findFirstRow(
          session,
        );

        expect(fetchedData, isNotNull);
        expect(fetchedData?.id, data?.id);
      });
    },
  );
}
