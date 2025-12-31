@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  group(
    'Given a serverpod project when generate is called with -d option from a different directory',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var serverDir = path.join(projectName, '${projectName}_server');
      var clientDir = path.join(projectName, '${projectName}_client');

      setUp(() async {
        var result = await runServerpod(
          ['create', projectName, '--mini'],
          workingDirectory: d.sandbox,
        );
        assert(
          result.exitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      test(
        'then code generation succeeds when using absolute path with -d option.',
        () async {
          // Run generate from temp directory (parent of project) using -d with absolute path
          var absoluteServerPath = path.join(d.sandbox, serverDir);
          var result = await runServerpod(
            ['generate', '-d', absoluteServerPath],
            workingDirectory: d.sandbox,
          );

          expect(result.exitCode, equals(0), reason: 'Generate should succeed');

          var allOutput = '${result.stdout}${result.stderr}';
          expect(
            allOutput.contains('Done') || allOutput.contains('success'),
            isTrue,
            reason: 'Should contain success message',
          );

          // Verify that generated files exist
          var generatedEndpointsFile = File(
            path.join(
              d.sandbox,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          );
          expect(
            generatedEndpointsFile.existsSync(),
            isTrue,
            reason: 'Generated endpoints file should exist',
          );

          var generatedProtocolFile = File(
            path.join(
              d.sandbox,
              serverDir,
              'lib',
              'src',
              'generated',
              'protocol.dart',
            ),
          );
          expect(
            generatedProtocolFile.existsSync(),
            isTrue,
            reason: 'Generated protocol file should exist',
          );

          // Verify client files were generated
          var clientProtocolDir = Directory(
            path.join(
              d.sandbox,
              clientDir,
              'lib',
              'src',
              'protocol',
            ),
          );
          expect(
            clientProtocolDir.existsSync(),
            isTrue,
            reason: 'Client protocol directory should exist',
          );
        },
      );

      test(
        'then code generation succeeds when using relative path with -d option.',
        () async {
          // Run generate from temp directory using -d with relative path
          var result = await runServerpod(
            ['generate', '-d', serverDir],
            workingDirectory: d.sandbox,
          );

          expect(result.exitCode, equals(0), reason: 'Generate should succeed');

          var allOutput = '${result.stdout}${result.stderr}';
          expect(
            allOutput.contains('Done') || allOutput.contains('success'),
            isTrue,
            reason: 'Should contain success message',
          );

          // Verify that generated files exist
          var generatedEndpointsFile = File(
            path.join(
              d.sandbox,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          );
          expect(
            generatedEndpointsFile.existsSync(),
            isTrue,
            reason: 'Generated endpoints file should exist',
          );
        },
      );

      test(
        'then code generation fails with proper error when directory does not exist.',
        () async {
          var nonExistentDir = path.join(d.sandbox, 'nonexistent_server');
          var result = await runServerpod(
            ['generate', '-d', nonExistentDir],
            workingDirectory: d.sandbox,
          );

          expect(
            result.exitCode,
            isNot(equals(0)),
            reason: 'Generate should fail',
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('error') || allOutput.contains('failed'),
            isTrue,
            reason: 'Should contain error message',
          );
        },
      );
    },
  );
}
