import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/mtime_helpers.dart';

void main() {
  group('Given a generated project with a stamp', () {
    late Directory projectDir;
    late GeneratorConfig config;
    late File stampFile;
    late File modelFile;

    tearDownAll(() => projectDir.deleteIfExists(recursive: true));

    setUpAll(() async {
      projectDir = Directory.systemTemp.createTempSync('cli_oneshot_test_');
      await createTestEnvironment(projectDir);

      modelFile = File(
        p.join(projectDir.path, 'lib', 'src', 'protocol', 'my_model.spy.yaml'),
      )..createSync(recursive: true);
      modelFile.writeAsStringSync('''
class: MyModel
fields:
  name: String
''');

      config = buildTestServerConfig(projectDir);
      stampFile = File(
        p.joinAll(
          [projectDir.path, '.dart_tool', 'serverpod', 'generation.stamp'],
        ),
      );

      // Prime the project so a generation stamp exists for the skip tests.
      final success = await performOneShotGenerate(config: config);
      expect(success, isTrue);
      expect(stampFile.existsSync(), isTrue);
    });

    test(
      'when performOneShotGenerate runs again with no changes '
      'then it skips generation and leaves the stamp untouched',
      () async {
        final stampMtime = stampFile.statSync().modified;
        await waitForMtimeAfter(stampMtime, projectDir);

        final success = await performOneShotGenerate(config: config);

        expect(success, isTrue);
        // A skipped run does not rewrite the stamp.
        expect(stampFile.statSync().modified, stampMtime);
      },
    );

    test(
      'when a source file changes after the stamp '
      'then performOneShotGenerate regenerates and updates the stamp',
      () async {
        final stampMtime = stampFile.statSync().modified;
        await waitForMtimeAfter(stampMtime, projectDir);

        // Modify a model source file so it is newer than the stamp.
        modelFile.writeAsStringSync('''
class: MyModel
fields:
  name: String
  count: int
''');

        final success = await performOneShotGenerate(config: config);

        expect(success, isTrue);
        // A regeneration rewrites the stamp with a newer mtime.
        expect(stampFile.statSync().modified.isAfter(stampMtime), isTrue);
      },
    );

    test(
      'when a model source file is deleted '
      'then performOneShotGenerate regenerates and cleans up its output',
      () async {
        final orphanModel =
            File(
              p.join(
                projectDir.path,
                'lib',
                'src',
                'protocol',
                'orphan.spy.yaml',
              ),
            )..writeAsStringSync('''
class: Orphan
fields:
  value: String
''');
        await performOneShotGenerate(config: config);

        bool hasOrphanOutput() =>
            Directory(p.join(projectDir.path, 'lib', 'src', 'generated'))
                .listSync(recursive: true)
                .whereType<File>()
                .any((f) => f.path.contains('orphan'));
        expect(hasOrphanOutput(), isTrue);

        // Deleting a source file leaves no mtime to compare; the source-set
        // fingerprint is what flags it as stale.
        orphanModel.deleteSync();
        final success = await performOneShotGenerate(config: config);

        expect(success, isTrue);
        expect(hasOrphanOutput(), isFalse);
      },
    );

    test(
      'when a non-model source is touched without a relevant change '
      'then the stamp is refreshed so it does not re-analyze every run',
      () async {
        // A plain Dart file: editing it does not require generation, but the
        // stamp must still advance or every later run re-spins the analyzer.
        final plainFile = File(
          p.join(projectDir.path, 'lib', 'src', 'helper.dart'),
        )..writeAsStringSync('class Helper {}');
        await performOneShotGenerate(config: config);

        final stampMtime = stampFile.statSync().modified;
        await waitForMtimeAfter(stampMtime, projectDir);
        plainFile.writeAsStringSync('class Helper {} // touched');

        await performOneShotGenerate(config: config);

        // The stamp advanced past the touched file, so a fresh check passes.
        expect(
          await isGenerationUpToDate(
            config,
            await enumerateSourceFiles(config),
          ),
          isTrue,
        );
      },
    );
  });
}
