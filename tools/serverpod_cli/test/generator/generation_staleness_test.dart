import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

import '../test_util/mtime_helpers.dart';

class _FakeConfig extends Fake implements GeneratorConfig {
  final String serverDir;
  final Map<String, List<String>> _sharedModels;

  _FakeConfig(this.serverDir, {Map<String, List<String>>? sharedModels})
    : _sharedModels = sharedModels ?? {};

  @override
  List<String> get serverPackageDirectoryPathParts => [serverDir];

  @override
  List<String> get clientPackagePathParts => [serverDir, '..', 'client'];

  @override
  List<String> get auxiliaryInputPaths => [
    p.join(serverDir, 'config', 'generator.yaml'),
    p.join(serverDir, 'pubspec.yaml'),
    p.join(serverDir, 'pubspec.lock'),
  ];

  @override
  List<String> get libSourcePathParts => [serverDir, 'lib'];

  @override
  List<String> get srcSourcePathParts => [serverDir, 'lib', 'src'];

  @override
  Map<String, List<String>> get sharedModelsSourcePathsParts => _sharedModels;

  @override
  List<String> get sharedModelsLibSourcePaths => [
    for (final pathParts in _sharedModels.values)
      p.joinAll([...serverPackageDirectoryPathParts, ...pathParts, 'lib']),
  ];

  @override
  List<String> get generatedServeModelPathParts => [
    serverDir,
    'lib',
    'src',
    'generated',
  ];

  @override
  List<String> get generatedSharedModelsPaths => [
    for (final pathParts in _sharedModels.values)
      p.joinAll([serverDir, ...pathParts, 'lib', 'src', 'generated']),
  ];
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
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a stamp newer than all sources with matching CLI version', () {
    setUp(() async {
      // Ensure the file system clock has advanced past source file mtimes.
      final srcMtime = (await endpointFile.stat()).modified;
      await waitForMtimeAfter(srcMtime, tempDir);
      await writeGenerationStamp(config, generatedFiles: {});
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns true',
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isTrue);
      },
    );
  });

  group('Given one source file newer than stamp', () {
    setUp(() async {
      await writeGenerationStamp(config, generatedFiles: {});
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
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given config/generator.yaml newer than stamp', () {
    setUp(() async {
      await writeGenerationStamp(config, generatedFiles: {});
      final stampMtime = stampFile.statSync().modified;
      await waitForMtimeAfter(stampMtime, tempDir);
      await configFile.writeAsString('modules: [updated]');
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
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
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a stamp with recorded generated files', () {
    late File generatedFile;

    setUp(() async {
      // Create a generated file that will be recorded in the stamp.
      final genDir = Directory(p.join(tempDir.path, 'lib', 'src', 'generated'));
      await genDir.create(recursive: true);
      generatedFile = File(p.join(genDir.path, 'protocol.dart'));
      await generatedFile.writeAsString('// generated');

      final genMtime = generatedFile.statSync().modified;
      await waitForMtimeAfter(genMtime, tempDir);
      await writeGenerationStamp(
        config,
        generatedFiles: {generatedFile.path},
      );
    });

    test(
      'when all generated files exist, '
      'then isGenerationUpToDate returns true',
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isTrue);
      },
    );

    test(
      'when a recorded generated file is deleted, '
      'then isGenerationUpToDate returns false',
      () async {
        await generatedFile.delete();
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );

    test(
      'when a recorded generated file is hand-edited or reverted, '
      'then isGenerationUpToDate returns false',
      () async {
        // The file still exists, but its mtime changed - a git revert or a
        // manual edit must not be trusted as up to date.
        final genMtime = generatedFile.statSync().modified;
        await waitForMtimeAfter(genMtime, tempDir);
        await generatedFile.writeAsString('// tampered');

        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given the server pubspec changes after the stamp', () {
    late File pubspecFile;

    setUp(() async {
      pubspecFile = File(p.join(tempDir.path, 'pubspec.yaml'));
      await pubspecFile.writeAsString('name: server\ndependencies:\n');

      await writeGenerationStamp(config, generatedFiles: {});
      final stampMtime = stampFile.statSync().modified;
      await waitForMtimeAfter(stampMtime, tempDir);

      // Adding a module dependency changes the generated output even though no
      // file under lib/ changed.
      await pubspecFile.writeAsString(
        'name: server\ndependencies:\n  serverpod_auth: any\n',
      );
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false',
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a source edited after enumeration but before the stamp is '
      'written (the mid-generation race)', () {
    setUp(() async {
      // The walk stamps each source as it reads it.
      final stamps = await enumerateSourceFiles(config);

      // A source is edited while generation is still running.
      final srcMtime = (await endpointFile.stat()).modified;
      await waitForMtimeAfter(srcMtime, tempDir);
      await endpointFile.writeAsString(
        'class MyEndpoint extends Endpoint { /* edited mid-run */ }',
      );

      // The stamp records the pre-edit stamps, not the post-run state. Were it
      // to stat live at write time, the edit would be silently swallowed on the
      // next run.
      await writeGenerationStamp(
        config,
        generatedFiles: {},
        sourceStats: stamps,
      );
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false so the mid-run edit is not silently missed',
      () async {
        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
      },
    );
  });

  group('Given a source whose size changed but mtime did not '
      '(a same-tick edit)', () {
    // A second-aligned mtime so setLastModified round-trips exactly (the
    // filesystem here truncates mtimes to whole seconds).
    final pinnedMtime = DateTime(2026, 1, 1, 12, 0, 0);

    setUp(() async {
      await endpointFile.setLastModified(pinnedMtime);
      await writeGenerationStamp(config, generatedFiles: {});

      // Change the file's length, then pin the mtime back to the same value -
      // simulating an edit landing within a single coarse mtime tick.
      await endpointFile.writeAsString(
        'class MyEndpoint extends Endpoint { /* a noticeably longer body */ }',
      );
      await endpointFile.setLastModified(pinnedMtime);
    });

    test(
      'when isGenerationUpToDate is called, '
      'then it returns false because the size changed',
      () async {
        // Precondition: mtime matches what the stamp recorded, so size is the
        // only signal that changed.
        expect((await endpointFile.stat()).modified, pinnedMtime);

        final sources = await enumerateSourceFiles(config);
        expect(await isGenerationUpToDate(config, sources), isFalse);
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

      await writeGenerationStamp(sharedConfig, generatedFiles: {});
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
      () async {
        final sources = await enumerateSourceFiles(sharedConfig);
        expect(await isGenerationUpToDate(sharedConfig, sources), isFalse);
      },
    );
  });

  group('Given writeGenerationStamp is called', () {
    test(
      'when the stamp file is read, '
      'then it contains the current CLI version',
      () async {
        await writeGenerationStamp(config, generatedFiles: {});

        expect(stampFile.existsSync(), isTrue);

        final content = stampFile.readAsStringSync();
        expect(content, startsWith('$templateVersion\n'));
      },
    );

    test(
      'when generatedFiles are provided, '
      'then the stamp file contains the file paths',
      () async {
        await writeGenerationStamp(
          config,
          generatedFiles: {'/tmp/a.dart', '/tmp/b.dart'},
        );

        final lines = (await stampFile.readAsString()).trim().split('\n');

        // version, fingerprint, then file paths.
        expect(lines.length, 4);
        expect(
          lines.skip(2).toSet(),
          {'/tmp/a.dart', '/tmp/b.dart'},
        );
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

        final sources = await enumerateSourceFiles(config);

        expect(sources.keys, contains(endsWith('endpoint.dart')));
        expect(sources.keys, contains(endsWith('model.spy.yaml')));
      },
    );

    test(
      'when called, '
      'then it does not include non-source files',
      () async {
        await File(
          p.join(tempDir.path, 'lib', 'src', 'readme.md'),
        ).writeAsString('# Readme');

        final sources = await enumerateSourceFiles(config);

        expect(sources.keys.where((s) => s.endsWith('.md')), isEmpty);
      },
    );

    test(
      'when a model lives under lib/ outside lib/src, '
      'then it is still included',
      () async {
        await File(
          p.join(tempDir.path, 'lib', 'top_level.spy.yaml'),
        ).writeAsString('class: TopLevel');

        final sources = await enumerateSourceFiles(config);

        expect(sources.keys, contains(endsWith('top_level.spy.yaml')));
      },
    );

    test(
      'when generated output exists under lib/src/generated, '
      'then it is excluded (outputs are not inputs)',
      () async {
        await File(
          p.join(tempDir.path, 'lib', 'src', 'generated', 'protocol.dart'),
        ).create(recursive: true);

        final sources = await enumerateSourceFiles(config);

        expect(sources.keys.where((s) => s.contains('generated')), isEmpty);
      },
    );
  });

  test(
    'Given stamp file that does not exist, '
    'when calling readGenerationStamp, '
    'then it returns an empty set.',
    () {
      final files = readGenerationStamp(config);
      expect(files, isEmpty);
    },
  );

  test(
    'Given stamp file that exists with only version and fingerprint, '
    'when calling readGenerationStamp, '
    'then it returns an empty set.',
    () async {
      await writeGenerationStamp(
        config,
        generatedFiles: {},
      );

      final files = readGenerationStamp(config);

      expect(files, isEmpty);
    },
  );

  test(
    'Given stamp file that exists with generated files, '
    'when calling readGenerationStamp, '
    'then it returns the file paths.',
    () async {
      await writeGenerationStamp(
        config,
        generatedFiles: {'/tmp/a.dart', '/tmp/b.dart', '/tmp/models/c.dart'},
      );

      final files = readGenerationStamp(config);

      expect(files, contains('/tmp/a.dart'));
      expect(files, contains('/tmp/b.dart'));
      expect(files, contains('/tmp/models/c.dart'));
    },
  );
}
