import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(
    () async => await EmptyModel.db
        .deleteWhere(session, where: (_) => Constant.bool(true)),
  );

  group('Given a model that only has id column when inserted to the database',
      () {
    EmptyModel? data;
    setUp(() async {
      data = await EmptyModel.db.insertRow(session, EmptyModel());
    });

    test('then the model is returned from the insert with an id.', () {
      expect(data, isNotNull);
      expect(data?.id, isNotNull);
    });

    test('then the model can be fetched from the database', () async {
      var fetchedData = await EmptyModel.db.findFirstRow(
        session,
      );

      expect(fetchedData, isNotNull);
      expect(fetchedData?.id, data?.id);
    });
  });
}
