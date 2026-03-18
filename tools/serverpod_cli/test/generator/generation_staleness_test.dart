import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class _FakeConfig extends Fake implements GeneratorConfig {
  final String serverDir;
  final Map<String, List<String>> _sharedModels;

  _FakeConfig(this.serverDir, {Map<String, List<String>>? sharedModels})
    : _sharedModels = sharedModels ?? {};

  @override
  List<String> get serverPackageDirectoryPathParts => [serverDir];

  @override
  List<String> get srcSourcePathParts => [serverDir, 'lib', 'src'];

  @override
  Map<String, List<String>> get sharedModelsSourcePathsParts => _sharedModels;
}

/// Waits until the file system reports an mtime strictly after [reference].
///
/// This avoids hard-coded delays that may be too short on platforms with
/// coarse timestamp resolution (e.g. Windows).
Future<void> waitForMtimeAfter(DateTime reference, [Directory? dir]) async {
  dir ??= await Directory.systemTemp.createTemp();
  final probe = File(p.join(dir.path, '.mtime_probe'));
  try {
    for (var i = 0; i < 100; i++) {
      await probe.writeAsString('$i');
      if (probe.statSync().modified.isAfter(reference)) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    throw StateError('File system mtime did not advance after 5 seconds');
  } finally {
    if (probe.existsSync()) await probe.delete();
  }
}

void main() {
  late Directory tempDir;
  late _FakeConfig config;
  late File endpointFile;
  late File configFile;
  late File stampFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('staleness_test_');
    config = _FakeConfig(tempDir.path);

    endpointFile = File(p.join(tempDir.path, 'lib', 'src', 'endpoint.dart'));
    await endpointFile.create(recursive: true);
    await endpointFile.writeAsString('class MyEndpoint extends Endpoint {}');

    configFile = File(p.join(tempDir.path, 'config', 'generator.yaml'));
    await configFile.create(recursive: true);
    await configFile.writeAsString('modules: []');

    stampFile = File(
      p.joinAll([tempDir.path, '.dart_tool', 'serverpod', 'generation.stamp']),
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('Given no stamp file', () {
    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () {
        final sources = enumerateSourceFiles(config);
        expect(isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a stamp newer than all sources with matching CLI version', () {
    setUp(() async {
      // Wait a moment so stamp mtime is strictly after source files.
      final srcMtime = (await endpointFile.stat()).modified;
      await waitForMtimeAfter(srcMtime, tempDir);
      await writeGenerationStamp(config);
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns true',
      () {
        final sources = enumerateSourceFiles(config);
        expect(isGenerationUpToDate(config, sources), isTrue);
      },
    );
  });

  group('Given one source file newer than stamp', () {
    setUp(() async {
      await writeGenerationStamp(config);
      final stampMtime = stampFile.statSync().modified;
      await waitForMtimeAfter(stampMtime, tempDir);
      // Touch a source file after stamp.
      await endpointFile.writeAsString(
        'class MyEndpoint extends Endpoint { /* modified */ }',
      );
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () {
        final sources = enumerateSourceFiles(config);
        expect(isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given config/generator.yaml newer than stamp', () {
    setUp(() async {
      await writeGenerationStamp(config);
      final stampMtime = stampFile.statSync().modified;
      await waitForMtimeAfter(stampMtime, tempDir);
      await configFile.writeAsString('modules: [updated]');
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () {
        final sources = enumerateSourceFiles(config);
        expect(isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given stamp has old CLI version', () {
    setUp(() async {
      // Write stamp with a different version.
      await stampFile.create(recursive: true);
      await stampFile.writeAsString(
        '0.0.0\n${DateTime.now().toIso8601String()}\n',
      );
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () {
        final sources = enumerateSourceFiles(config);
        expect(isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a shared model package with a newer file', () {
    late _FakeConfig sharedConfig;

    setUp(() async {
      // Create shared package directory with a model file.
      final sharedDir = Directory(
        p.join(tempDir.path, 'shared_pkg', 'lib'),
      );
      await sharedDir.create(recursive: true);
      await File(
        p.join(sharedDir.path, 'model.spy.yaml'),
      ).writeAsString('class: SharedModel');

      sharedConfig = _FakeConfig(
        tempDir.path,
        sharedModels: {
          'shared_pkg': ['shared_pkg'],
        },
      );

      await writeGenerationStamp(sharedConfig);
      final stampMtime = stampFile.statSync().modified;
      await waitForMtimeAfter(stampMtime, tempDir);

      // Touch the shared model file after stamp.
      await File(
        p.join(sharedDir.path, 'model.spy.yaml'),
      ).writeAsString('class: SharedModel\nfields:\n  name: String');
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () {
        final sources = enumerateSourceFiles(sharedConfig);
        expect(isGenerationUpToDate(sharedConfig, sources), isFalse);
      },
    );
  });

  group('Given writeGenerationStamp is called', () {
    test(
      'when the stamp file is read, '
      'then it contains the current CLI version',
      () async {
        await writeGenerationStamp(config);

        expect(stampFile.existsSync(), isTrue);

        final content = stampFile.readAsStringSync();
        expect(content, startsWith('$templateVersion\n'));
      },
    );
  });

  group('Given enumerateSourceFiles', () {
    test(
      'when called, '
      'then it returns dart and model files from source directories',
      () async {
        // Add a model file.
        await File(
          p.join(tempDir.path, 'lib', 'src', 'model.spy.yaml'),
        ).writeAsString('class: Test');

        final sources = enumerateSourceFiles(config);

        expect(sources, contains(endsWith('endpoint.dart')));
        expect(sources, contains(endsWith('model.spy.yaml')));
      },
    );

    test(
      'when called, '
      'then it does not include non-source files',
      () async {
        await File(
          p.join(tempDir.path, 'lib', 'src', 'readme.md'),
        ).writeAsString('# Readme');

        final sources = enumerateSourceFiles(config);

        expect(sources.where((s) => s.endsWith('.md')), isEmpty);
      },
    );
  });
}
