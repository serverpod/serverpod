import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

/// Runs a full generation that does not check for staleness, as retrying a
/// failed start does with the analyzers it already has.
Future<GenerateResult> _forcedFullGeneration(
  GeneratorConfig config,
  Analyzers analyzers,
) async {
  final sources = await enumerateSourceFiles(config);
  return analyzeAndGenerate(
    config: config,
    analyzers: analyzers,
    affectedPaths: sources.keys.toSet(),
    incremental: false,
    verifyStaleness: false,
    sourceStats: sources,
  );
}

void main() {
  late Directory projectDir;
  late GeneratorConfig config;
  late File modelFile;
  late File endpointFile;
  late File generatedModelFile;
  late File generatedEndpointsFile;

  setUp(() async {
    projectDir = Directory.systemTemp.createTempSync('cli_test_');
    addTearDown(() => projectDir.deleteWithRetry(recursive: true));
    await createTestEnvironment(projectDir);

    modelFile =
        File(p.join(projectDir.path, 'lib', 'src', 'models', 'item.spy.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');
    endpointFile =
        File(p.join(projectDir.path, 'lib', 'src', 'endpoints', 'item.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ItemEndpoint extends Endpoint {
  Future<String> first(Session session) async => 'first';
}
''');

    final generated = p.join(projectDir.path, 'lib', 'src', 'generated');
    generatedModelFile = File(p.join(generated, 'item.dart'));
    generatedEndpointsFile = File(p.join(generated, 'endpoints.dart'));

    config = buildTestServerConfig(projectDir);
  });

  void addModelFieldAndEndpointMethod() {
    modelFile.writeAsStringSync('''
class: Item
fields:
  name: String
  count: int
''');
    endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ItemEndpoint extends Endpoint {
  Future<String> first(Session session) async => 'first';

  Future<String> second(Session session) async => 'second';
}
''');
  }

  group('Given analyzers that were not used yet,', () {
    late Analyzers analyzers;

    setUp(() async {
      analyzers = await Analyzers.create(config);
    });

    test(
      'when asked whether they are fresh,'
      'then they are.',
      () async {
        expect(await analyzers.isFresh, isTrue);
      },
    );

    group(
      'when a forced full generation runs,',
      () {
        late GenerateResult result;

        setUp(() async {
          result = await _forcedFullGeneration(config, analyzers);
        });

        test(
          'then the model and the endpoint are generated.',
          () async {
            expect(result.success, isTrue);
            expect(
              generatedModelFile.readAsStringSync(),
              contains('String name'),
            );
            expect(
              generatedEndpointsFile.readAsStringSync(),
              contains("'first'"),
            );
          },
        );

        test(
          'then the analyzers are no longer fresh.',
          () async {
            expect(await analyzers.isFresh, isFalse);
          },
        );
      },
    );
  });

  group(
    'Given analyzers that ran a forced full generation,',
    () {
      late Analyzers analyzers;

      setUp(() async {
        analyzers = await Analyzers.create(config);
        await _forcedFullGeneration(config, analyzers);
      });

      group(
        'when a model field and an endpoint method are added and a forced full generation runs,',
        () {
          late GenerateResult result;

          setUp(() async {
            addModelFieldAndEndpointMethod();
            result = await _forcedFullGeneration(config, analyzers);
          });

          test('then it succeeds.', () {
            expect(result.success, isTrue);
          });

          test('then the generated model has the new field.', () {
            expect(
              generatedModelFile.readAsStringSync(),
              contains('int count'),
            );
          });

          test('then the generated endpoints have the new method.', () {
            expect(
              generatedEndpointsFile.readAsStringSync(),
              contains("'second'"),
            );
          });

          test('then the generated code is recorded as up to date.', () async {
            expect(
              await isGenerationUpToDate(
                config,
                await enumerateSourceFiles(config),
              ),
              isTrue,
            );
          });
        },
      );
    },
  );

  group(
    'Given isolated analyzers primed at start and a model field and an endpoint method added afterwards,',
    () {
      late IsolatedAnalyzers analyzers;

      setUp(() async {
        analyzers = await IsolatedAnalyzers.create(config);
        addTearDown(analyzers.close);
        addModelFieldAndEndpointMethod();
      });

      test('when asked whether they are fresh, then they are not.', () async {
        expect(await analyzers.isFresh, isFalse);
      });

      group(
        'when a forced full generation runs with them,',
        () {
          late GenerateResult result;

          setUp(() async {
            result = await _forcedFullGeneration(config, analyzers);
            expect(result.success, isTrue);
          });

          test(
            'then the generated model has the new field.',
            () async {
              expect(
                generatedModelFile.readAsStringSync(),
                contains('int count'),
              );
            },
          );

          test(
            'then the generated endpoints have the new method.',
            () async {
              expect(
                generatedEndpointsFile.readAsStringSync(),
                contains("'second'"),
              );
            },
          );
        },
      );
    },
  );
}
