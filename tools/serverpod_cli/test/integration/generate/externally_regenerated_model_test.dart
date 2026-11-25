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
    'Given analyzers primed on a generated project, and a pull of a new field '
    'on a model with its regenerated files and an endpoint using the field,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File modelFile;
      late File endpointFile;

      String endpointSource(String noteArguments) =>
          '''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class NoteEndpoint extends Endpoint {
  Future<Note> getNote(Session session) async => Note($noteArguments);
}
''';

      Future<GenerateResult> generateFully(Analyzers withAnalyzers) async {
        final sources = await enumerateSourceFiles(config);
        return analyzeAndGenerate(
          config: config,
          analyzers: withAnalyzers,
          affectedPaths: sources.keys.toSet(),
          incremental: false,
          verifyStaleness: false,
          sourceStats: sources,
        );
      }

      String generatedEndpoints() => File(
        p.join(projectDir.path, 'lib', 'src', 'generated', 'endpoints.dart'),
      ).readAsStringSync();

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);

        modelFile =
            File(
                p.join(projectDir.path, 'lib', 'src', 'notes', 'note.spy.yaml'),
              )
              ..createSync(recursive: true)
              ..writeAsStringSync('''
class: Note
fields:
  text: String
''');
        endpointFile =
            File(
                p.join(
                  projectDir.path,
                  'lib',
                  'src',
                  'notes',
                  'note_endpoint.dart',
                ),
              )
              ..createSync(recursive: true)
              ..writeAsStringSync(endpointSource("text: 'a'"));

        config = buildTestServerConfig(projectDir);
        final initialCheckout = await Analyzers.createAndUpdate(config);
        addTearDown(initialCheckout.close);
        await generateFully(initialCheckout);

        // As `serverpod start` on an up-to-date project: primed, nothing to
        // generate.
        analyzers = await Analyzers.createAndUpdate(config);
        addTearDown(analyzers.close);

        // The pull: the regenerated files come from a generation these
        // analyzers took no part in, as in another checkout.
        modelFile.writeAsStringSync('''
class: Note
fields:
  text: String
  tag: String?
''');
        final otherCheckout = await Analyzers.createAndUpdate(config);
        addTearDown(otherCheckout.close);
        await generateFully(otherCheckout);
        endpointFile.writeAsStringSync(endpointSource("text: 'a', tag: 'b'"));
      });

      group('when incremental generation runs for the model and endpoint,', () {
        late GenerateResult result;

        setUp(() async {
          result = await analyzeAndGenerate(
            config: config,
            analyzers: analyzers,
            affectedPaths: {modelFile.path, endpointFile.path},
            incremental: true,
          );
        });

        test('then generation succeeds.', () {
          expect(result.success, isTrue);
        });

        test('then the endpoint stays in the generated endpoints.', () {
          expect(generatedEndpoints(), contains('NoteEndpoint()'));
        });
      });

      // The endpoint arriving in an earlier watcher batch than the model file.
      // Only files the analyzers recorded are checked before the first model
      // generation, so this also fails when the seeding stops working.
      group(
        'when incremental generation runs for the endpoint before the model,',
        () {
          late GenerateResult result;

          setUp(() async {
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

          test('then the endpoint stays in the generated endpoints.', () {
            expect(generatedEndpoints(), contains('NoteEndpoint()'));
          });
        },
      );

      group('when a full generation runs with the same analyzers,', () {
        late GenerateResult result;

        setUp(() async {
          result = await generateFully(analyzers);
        });

        test('then generation succeeds.', () {
          expect(result.success, isTrue);
        });

        test('then the endpoint stays in the generated endpoints.', () {
          expect(generatedEndpoints(), contains('NoteEndpoint()'));
        });
      });
    },
  );
}
