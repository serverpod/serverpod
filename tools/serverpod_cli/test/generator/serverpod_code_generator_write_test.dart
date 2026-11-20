import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:test/test.dart';

import '../test_util/builders/enum_definition_builder.dart';
import '../test_util/builders/generator_config_builder.dart';

/// A server-only enum, which the generator writes exactly one file for.
EnumDefinition _model(int index, {List<String> values = const ['first']}) =>
    EnumDefinitionBuilder()
        .withClassName('Status$index')
        .withFileName('status_$index')
        .withServerOnly(true)
        .withValues([
          for (final value in values) ProtocolEnumValueDefinition(value),
        ])
        .build();

void main() {
  late Directory tempDirectory;
  late GeneratorConfig config;

  String generatedPath(int index) => p.joinAll([
    ...config.generatedServeModelPathParts,
    'status_$index.dart',
  ]);

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'code_generator_write_test_',
    );
    final serverDirectory = Directory(
      p.join(tempDirectory.path, 'example_server'),
    );
    await serverDirectory.create(recursive: true);
    config = GeneratorConfigBuilder()
        .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
        .build();
    // The models are server only, but cleaning up looks at the generated
    // client directory too, which every project has.
    await Directory(
      p.joinAll(config.generatedDartClientModelPathParts),
    ).create(recursive: true);
    await GeneratedDartFormatters.resolve(config);
  });

  tearDown(() async {
    GeneratedDartFormatters.reset();
    await tempDirectory.delete(recursive: true);
  });

  // One file more than the generator writes at a time, which makes one full
  // batch and a last one holding a single file.
  const modelCount = ServerpodCodeGenerator.writeBatchSize + 1;

  group(
    'Given one more model than fits a write batch,',
    () {
      late List<EnumDefinition> models;

      setUp(() {
        models = [for (var i = 0; i < modelCount; i++) _model(i)];
      });

      group('when they are generated,', () {
        late GeneratedFilePaths result;

        setUp(() async {
          result = await ServerpodCodeGenerator.generateSerializableModels(
            models: models,
            config: config,
          );
        });

        test('then every file is reported as generated.', () {
          expect(
            result.all,
            unorderedEquals(List.generate(modelCount, generatedPath)),
          );
        });

        test('then every file is reported as written.', () {
          expect(
            result.written,
            unorderedEquals(List.generate(modelCount, generatedPath)),
          );
        });

        test('then every file exists with its generated content.', () {
          for (var i = 0; i < modelCount; i++) {
            final file = File(generatedPath(i));

            expect(file.existsSync(), isTrue, reason: file.path);
            expect(file.readAsStringSync(), contains('enum Status$i'));
          }
        });
      });
    },
  );

  group('Given one more generated model than fits a write batch,', () {
    // One in the first batch and the one in the last batch. A set, since the
    // two are the same file when a batch holds a single one. The first file
    // is left alone, so there is always one that does not change.
    final modified = {1, modelCount - 1};
    const added = modelCount;
    late Map<int, DateTime> modifiedAtBefore;

    setUp(() async {
      await ServerpodCodeGenerator.generateSerializableModels(
        models: [for (var i = 0; i < modelCount; i++) _model(i)],
        config: config,
      );
      modifiedAtBefore = {
        for (var i = 0; i < modelCount; i++)
          i: File(generatedPath(i)).lastModifiedSync(),
      };
      // File systems can keep modification times to the second, so a rewrite
      // right away could leave a time unchanged.
      await Future<void>.delayed(const Duration(milliseconds: 1100));
    });

    group(
      'when they are generated again with two of them modified and one added,',
      () {
        late GeneratedFilePaths result;

        setUp(() async {
          result = await ServerpodCodeGenerator.generateSerializableModels(
            models: [
              for (var i = 0; i < modelCount; i++)
                _model(
                  i,
                  values: modified.contains(i)
                      ? ['first', 'second']
                      : ['first'],
                ),
              _model(added),
            ],
            config: config,
          );
        });

        test('then every file is reported as generated.', () {
          expect(
            result.all,
            unorderedEquals(List.generate(modelCount + 1, generatedPath)),
          );
        });

        test(
          'then only the modified and the added files are reported as written.',
          () {
            expect(
              result.written,
              unorderedEquals([
                for (final index in [...modified, added]) generatedPath(index),
              ]),
            );
          },
        );

        test('then the modified files have their new content.', () {
          for (final index in modified) {
            expect(
              File(generatedPath(index)).readAsStringSync(),
              contains('second'),
            );
          }
        });

        test('then the added file exists.', () {
          expect(File(generatedPath(added)).existsSync(), isTrue);
        });

        test('then the unchanged files keep their modification time.', () {
          for (var i = 0; i < modelCount; i++) {
            if (modified.contains(i)) continue;

            expect(
              File(generatedPath(i)).lastModifiedSync(),
              modifiedAtBefore[i],
            );
          }
        });

        test('then the modified files have a later modification time.', () {
          for (final index in modified) {
            expect(
              File(
                generatedPath(index),
              ).lastModifiedSync().isAfter(modifiedAtBefore[index]!),
              isTrue,
            );
          }
        });

        test(
          'when previously generated files are cleaned up with every generated file,'
          'then all files remain including the unchanged ones.',
          () async {
            await ServerpodCodeGenerator.cleanPreviouslyGeneratedFiles(
              generatedFiles: result.all.toSet(),
              protocolDefinition: const ProtocolDefinition(
                endpoints: [],
                models: [],
                futureCalls: [],
              ),
              config: config,
            );

            for (var i = 0; i <= added; i++) {
              expect(
                File(generatedPath(i)).existsSync(),
                isTrue,
              );
            }
          },
        );

        test(
          'when previously generated files are cleaned up with only the written files,'
          'then the unchanged files are removed.',
          () async {
            // This is what reporting only the written files as generated
            // would do, and why the two are kept apart.
            await ServerpodCodeGenerator.cleanPreviouslyGeneratedFiles(
              generatedFiles: result.written,
              protocolDefinition: const ProtocolDefinition(
                endpoints: [],
                models: [],
                futureCalls: [],
              ),
              config: config,
            );

            expect(File(generatedPath(0)).existsSync(), isFalse);
            expect(File(generatedPath(modified.first)).existsSync(), isTrue);
            expect(File(generatedPath(added)).existsSync(), isTrue);
          },
        );
      },
    );
  });
}
