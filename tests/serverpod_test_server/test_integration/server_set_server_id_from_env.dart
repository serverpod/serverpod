import 'dart:convert';

import 'package:serverpod_test_server/test_util/server_test_util.dart';
import 'package:test/test.dart';

/// This test checks if the server starts with the SERVER_ID set from environment variable.
/// Before running this test, ensure that Docker (docker-local) is up and that the server is not running.
void main() {
  test('Server should start with SERVER_ID set', () async {
    const serverId = 'test_server_123';

    var process = await ServerTestUtils.runServerWithServerId(serverId);

    var output = StringBuffer();
    process.stdout.transform(utf8.decoder).listen(output.write);
    process.stderr.transform(utf8.decoder).listen(output.write);

    await Future.delayed(Duration(seconds: 8));
    expect(output.toString().contains('Server $serverId listening on'), isTrue);

    process.kill();
  });
}
