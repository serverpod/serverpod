@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  group('Given a serverpod project when generate is called from anywhere', () {
    var projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var serverDir = path.join(projectName, '${projectName}_server');

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
      'then code generation succeeds when running from client directory.',
      () async {
        var clientDir = path.join(projectName, '${projectName}_client');
        var result = await runServerpod(
          ['generate'],
          workingDirectory: path.join(d.sandbox, clientDir),
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
      },
    );

    test(
      'then code generation succeeds when running from server subdirectory.',
      () async {
        var libSrcPath = path.join(d.sandbox, serverDir, 'lib', 'src');

        var result = await runServerpod(
          ['generate'],
          workingDirectory: libSrcPath,
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
      'then code generation succeeds when running from project root.',
      () async {
        var result = await runServerpod(
          ['generate'],
          workingDirectory: path.join(d.sandbox, projectName),
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
  });
}
