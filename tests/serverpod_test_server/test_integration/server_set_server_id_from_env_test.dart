import 'dart:convert';

import 'package:serverpod_test_server/test_util/server_test_util.dart';
import 'package:test/test.dart';

/// This test checks if the server starts with the SERVER_ID set from environment variable.
/// Before running this test, ensure that Docker (docker-local) is up and that the server is not running.
void main() {
  group('Server Start Tests', () {
    test(
        'Server should start with SERVERPOD_SERVER_ID from environment variable',
        () async {
      const serverId = 'test_server_123';

      var process =
          await ServerTestUtils.runServerWithServerIdFromEnvironment(serverId);

      var output = StringBuffer();
      process.stdout.transform(utf8.decoder).listen(output.write);
      process.stderr.transform(utf8.decoder).listen(output.write);

      await Future.delayed(Duration(seconds: 8));
      expect(
          output.toString().contains('Server $serverId listening on'), isTrue);

      process.kill();
    });

    test('Server should start with serverId from command line argument',
        () async {
      const serverId = 'test_server_456';

      var process =
          await ServerTestUtils.runServerWithServerIdFromCommandLineArg(
              serverId);

      var output = StringBuffer();
      process.stdout.transform(utf8.decoder).listen(output.write);
      process.stderr.transform(utf8.decoder).listen(output.write);

      await Future.delayed(Duration(seconds: 8));
      expect(
          output.toString().contains('Server $serverId listening on'), isTrue);

      process.kill();
    });

    test('Server should start without serverId and use default value',
        () async {
      var process = await ServerTestUtils.runServerWithOutServerId();

      var output = StringBuffer();
      process.stdout.transform(utf8.decoder).listen(output.write);
      process.stderr.transform(utf8.decoder).listen(output.write);

      await Future.delayed(Duration(seconds: 8));
      expect(output.toString().contains('Server default listening on'), isTrue);

      process.kill();
    });

    test(
        'Server should start with serverId from both command line and environment variable, using command line',
        () async {
      const commandLineServerId = 'test_server_789';
      const envServerId = 'test_server_env_123';

      var process = await ServerTestUtils
          .runServerWithServerIdFromBothCommandLineArgAndEnvironment(
              commandLineServerId, envServerId);

      var output = StringBuffer();
      process.stdout.transform(utf8.decoder).listen(output.write);
      process.stderr.transform(utf8.decoder).listen(output.write);

      await Future.delayed(Duration(seconds: 8));
      expect(
          output
              .toString()
              .contains('Server $commandLineServerId listening on'),
          isTrue);

      process.kill();
    });
  });
}
