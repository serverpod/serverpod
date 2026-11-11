import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  group(
    'Given a generated project with a sealed model and a server-only subclass, '
    'when an endpoint changes and incremental generation runs,',
    () {
      late Directory projectDir;
      late File clientEventFile;
      late File clientInternalEventFile;
      late GenerateResult result;

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);

        final modelsDir = p.join(projectDir.path, 'lib', 'src', 'models');
        File(p.join(modelsDir, 'event.spy.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Event
sealed: true
fields:
  name: String
''');
        File(p.join(modelsDir, 'internal_event.spy.yaml')).writeAsStringSync('''
class: InternalEvent
extends: Event
serverOnly: true
fields:
  secret: String
''');
        final endpointFile =
            File(
                p.join(
                  projectDir.path,
                  'lib',
                  'src',
                  'endpoints',
                  'event_endpoint.dart',
                ),
              )
              ..createSync(recursive: true)
              ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class EventEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async => 'Hello \$name';
}
''');
        final clientProtocolDir = p.join(
          projectDir.path,
          'test_client',
          'lib',
          'src',
          'protocol',
        );
        clientEventFile = File(p.join(clientProtocolDir, 'event.dart'));
        clientInternalEventFile = File(
          p.join(clientProtocolDir, 'internal_event.dart'),
        );

        final config = buildTestServerConfig(projectDir);
        final analyzers = await Analyzers.createAndUpdate(config);
        final sources = await enumerateSourceFiles(config);
        await analyzeAndGenerate(
          config: config,
          analyzers: analyzers,
          affectedPaths: sources.keys.toSet(),
          incremental: false,
          verifyStaleness: false,
          sourceStats: sources,
        );

        endpointFile.writeAsStringSync(
          endpointFile.readAsStringSync().replaceFirst('Hello', 'Hi'),
        );
        result = await analyzeAndGenerate(
          config: config,
          analyzers: analyzers,
          affectedPaths: {endpointFile.path},
          incremental: true,
        );
      });

      test('then generation succeeds.', () {
        expect(result.success, isTrue);
      });

      test(
        'then the client part file of the server-only subclass is kept.',
        () {
          expect(
            clientEventFile.readAsStringSync(),
            contains("part 'internal_event.dart';"),
          );
          expect(clientInternalEventFile.existsSync(), isTrue);
        },
      );
    },
  );
}
