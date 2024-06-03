import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  test(
      'Given a model that is part of a relation but has no fields when inserted to the database then insert is successful.',
      () async {
    var data = await EmptyModel.db.insertRow(session, EmptyModel());

    expect(data, isNotNull);
  });
}
