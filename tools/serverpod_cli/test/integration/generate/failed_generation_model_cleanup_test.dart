import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  group(
    'Given a generated project with its stamp written, '
    'when a batch adds a model and breaks an endpoint and incremental generation runs,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File endpointFile;
      late File serverModelFile;
      late File clientModelFile;
      late GenerateResult result;

      const endpointSource = '''
import 'package:serverpod/serverpod.dart';

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async => 'Hello \$name';
}
''';

      bool stampListsModel() {
        final stamp = readGenerationStamp(config);
        return stamp.contains(serverModelFile.path) &&
            stamp.contains(clientModelFile.path);
      }

      Future<GenerateResult> generateIncrementally(Set<String> changed) =>
          analyzeAndGenerate(
            config: config,
            analyzers: analyzers,
            affectedPaths: changed,
            incremental: true,
          );

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);

        endpointFile =
            File(
                p.join(
                  projectDir.path,
                  'lib',
                  'src',
                  'greetings',
                  'greeting_endpoint.dart',
                ),
              )
              ..createSync(recursive: true)
              ..writeAsStringSync(endpointSource);
        serverModelFile = File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'generated',
            'notes',
            'note.dart',
          ),
        );
        clientModelFile = File(
          p.join(
            projectDir.path,
            'test_client',
            'lib',
            'src',
            'protocol',
            'notes',
            'note.dart',
          ),
        );

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.createAndUpdate(config);
        final sources = await enumerateSourceFiles(config);
        await analyzeAndGenerate(
          config: config,
          analyzers: analyzers,
          affectedPaths: sources.keys.toSet(),
          incremental: false,
          verifyStaleness: false,
          sourceStats: sources,
        );

        final modelFile =
            File(
                p.join(projectDir.path, 'lib', 'src', 'notes', 'note.spy.yaml'),
              )
              ..createSync(recursive: true)
              ..writeAsStringSync('''
class: Note
fields:
  text: String
''');
        // A stray brace makes the endpoint file fail to parse.
        endpointFile.writeAsStringSync('$endpointSource}\n');
        result = await generateIncrementally({
          modelFile.path,
          endpointFile.path,
        });
      });

      test('then generation fails.', () {
        expect(result.success, isFalse);
      });

      test('then the model files are written without being stamped.', () {
        expect(serverModelFile.existsSync(), isTrue);
        expect(clientModelFile.existsSync(), isTrue);
        expect(stampListsModel(), isFalse);
      });

      group(
        'when the endpoint is fixed and incremental generation runs again,',
        () {
          setUp(() async {
            endpointFile.writeAsStringSync(endpointSource);
            result = await generateIncrementally({endpointFile.path});
          });

          test('then generation succeeds.', () {
            expect(result.success, isTrue);
          });

          test('then the model files the protocol refers to are kept.', () {
            final protocol = File(
              p.join(
                projectDir.path,
                'lib',
                'src',
                'generated',
                'protocol.dart',
              ),
            ).readAsStringSync();
            expect(protocol, contains("'notes/note.dart'"));
            expect(serverModelFile.existsSync(), isTrue);
            expect(clientModelFile.existsSync(), isTrue);
          });

          test('then the stamp lists the model files.', () {
            expect(stampListsModel(), isTrue);
          });
        },
      );
    },
  );
}
