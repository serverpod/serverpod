import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  test('passing db call test', () async {
    var customers = await Customer.db.find(
      session,
    );

    expect(customers, []);
  });
}
