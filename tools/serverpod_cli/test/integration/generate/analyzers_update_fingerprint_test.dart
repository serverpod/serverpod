import 'dart:io';

import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

/// An endpoints analyzer that records which files it was asked to look at, and
/// can do something to the project right before it looks.
///
/// [Analyzers.update] only hands the analyzers the files it could not rule out
/// as unchanged, so the record shows whether a file was skipped. It reads the
/// content of the files before it calls the analyzers, so [beforeNextUpdate]
/// is where a file can change while an update is under way.
class _RecordingEndpointsAnalyzer extends EndpointsAnalyzer {
  _RecordingEndpointsAnalyzer(
    super.directory, {
    super.extraClasses,
    super.collection,
    super.generatedDirPaths,
  });

  final examined = <Set<String>>[];
  void Function()? beforeNextUpdate;

  @override
  Future<bool> updateFileContexts(Set<String> filePaths) {
    beforeNextUpdate?.call();
    beforeNextUpdate = null;
    examined.add(filePaths);
    return super.updateFileContexts(filePaths);
  }
}

void main() {
  late Directory projectDir;
  late GeneratorConfig config;
  late Analyzers analyzers;
  late _RecordingEndpointsAnalyzer endpoints;

  File sourceFile(List<String> path) =>
      File(p.joinAll([projectDir.path, 'lib', 'src', ...path]));

  File writeSource(List<String> path, String content) => sourceFile(path)
    ..createSync(recursive: true)
    ..writeAsStringSync(content);

  String generatedEndpoints() => File(
    p.join(projectDir.path, 'lib', 'src', 'generated', 'endpoints.dart'),
  ).readAsStringSync();

  /// Builds analyzers the way [Analyzers.create] does, around a recording
  /// endpoints analyzer, primes them with every source and generates.
  Future<void> createPrimedAnalyzersAndGenerate() async {
    final libDirectory = Directory(p.joinAll(config.libSourcePathParts));
    final overlay = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
    final collection = createAnalysisContextCollection(
      libDirectory,
      resourceProvider: overlay,
    );
    endpoints = _RecordingEndpointsAnalyzer(
      libDirectory,
      collection: collection,
      extraClasses: config.extraClasses,
      generatedDirPaths: config.generatedDirPaths,
    );
    analyzers = Analyzers(
      endpoints: endpoints,
      models: StatefulAnalyzer(
        config,
        await ModelHelper.loadProjectYamlModelsFromDisk(config),
      ),
      futureCalls: FutureCallsAnalyzer(
        directory: libDirectory,
        collection: collection,
        generatedDirPaths: config.generatedDirPaths,
      ),
      overlay: overlay,
    );
    await analyzers.update(
      config: config,
      affectedPaths: (await enumerateSourceFiles(config)).keys.toSet(),
    );
    await analyzers.performGenerate(config: config);
    endpoints.examined.clear();
  }

  Future<GenerationRequirements> update(File file) =>
      analyzers.update(config: config, affectedPaths: {file.path});

  /// Updates the analyzers with [file] and generates what they require.
  Future<GenerationRequirements> updateAndGenerate(File file) async {
    final requirements = await update(file);
    await analyzers.performGenerate(
      config: config,
      requirements: requirements,
      affectedPaths: {file.path},
    );
    return requirements;
  }

  /// Writes [file] again with the content it already has.
  void saveUnchanged(File file) =>
      file.writeAsBytesSync(file.readAsBytesSync());

  const plainSource = 'class Helper {}\n';
  const endpointSource = '''
import 'package:serverpod/serverpod.dart';

class HelperEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'hi';
}
''';

  setUp(() async {
    projectDir = Directory.systemTemp.createTempSync('cli_test_');
    addTearDown(() => projectDir.deleteWithRetry(recursive: true));
    await createTestEnvironment(projectDir);
    config = buildTestServerConfig(projectDir);
  });

  group('Given primed analyzers and a plain Dart file they examined,', () {
    late File helperFile;

    setUp(() async {
      helperFile = writeSource(['helper.dart'], plainSource);
      await createPrimedAnalyzersAndGenerate();
    });

    test(
      'when the file is saved twice without changes and the analyzers are updated each time, '
      'then they require no generation and do not examine the file again.',
      () async {
        saveUnchanged(helperFile);
        final first = await update(helperFile);
        saveUnchanged(helperFile);
        final second = await update(helperFile);

        expect(first.generateProtocol, isFalse);
        expect(second.generateProtocol, isFalse);
        expect(endpoints.examined, isEmpty);
      },
    );

    test(
      'when the content of the file changes without declaring anything and the analyzers are updated,'
      'then they examine the file and require no generation.',
      () async {
        helperFile.writeAsStringSync('$plainSource// A comment.\n');

        final requirements = await update(helperFile);

        expect(requirements.generateProtocol, isFalse);
        expect(endpoints.examined, [
          {helperFile.path},
        ]);
      },
    );

    group(
      'when the file is changed to declare an endpoint and incremental generation runs for it,',
      () {
        late GenerationRequirements requirements;

        setUp(() async {
          helperFile.writeAsStringSync(endpointSource);
          requirements = await updateAndGenerate(helperFile);
        });

        test('then the analyzers require protocol generation.', () {
          expect(requirements.generateProtocol, isTrue);
        });

        test('then the endpoint is generated.', () {
          expect(generatedEndpoints(), contains('HelperEndpoint'));
        });
      },
    );

    group('when the file is deleted and the analyzers are updated,', () {
      late GenerationRequirements requirements;

      setUp(() async {
        helperFile.deleteSync();
        requirements = await update(helperFile);
      });

      test('then they require no generation.', () {
        expect(requirements.generateProtocol, isFalse);
      });

      test(
        'when the file is recreated with its previous content and the analyzers are updated,'
        'then they examine it again and require no generation.',
        () async {
          endpoints.examined.clear();
          helperFile.writeAsStringSync(plainSource);

          final requirements = await update(helperFile);

          expect(requirements.generateProtocol, isFalse);
          expect(endpoints.examined, [
            {helperFile.path},
          ]);
        },
      );

      test(
        'when the file is recreated declaring an endpoint and incremental generation runs for it,'
        'then the endpoint is generated.',
        () async {
          helperFile.writeAsStringSync(endpointSource);

          final requirements = await updateAndGenerate(helperFile);

          expect(requirements.generateProtocol, isTrue);
          expect(generatedEndpoints(), contains('HelperEndpoint'));
        },
      );
    });

    test(
      'when the file changes while an update is examining it, and is then given the content the update started from,'
      'then the next update examines it and requires what that content declares.',
      () async {
        // The update reads the endpoint content to tell whether the file
        // changed, but by the time the analyzers look, the file is plain. What
        // they find must not be remembered for the endpoint content.
        helperFile.writeAsStringSync(endpointSource);
        endpoints.beforeNextUpdate = () =>
            helperFile.writeAsStringSync('$plainSource// Mid-update.\n');
        final interrupted = await update(helperFile);
        endpoints.examined.clear();

        helperFile.writeAsStringSync(endpointSource);
        final requirements = await updateAndGenerate(helperFile);

        expect(interrupted.generateProtocol, isFalse);
        expect(endpoints.examined, [
          {helperFile.path},
        ]);
        expect(requirements.generateProtocol, isTrue);
        expect(generatedEndpoints(), contains('HelperEndpoint'));
      },
    );
  });

  group(
    'Given primed analyzers and a class that extends a base class which is not an endpoint,',
    () {
      late File baseFile;
      late File subclassFile;

      setUp(() async {
        baseFile = writeSource(['base.dart'], 'abstract class Base {}\n');
        subclassFile = writeSource(
          ['greeting.dart'],
          '''
import 'package:serverpod/serverpod.dart';

import 'base.dart';

class GreetingEndpoint extends Base {
  Future<String> hello(Session session) async => 'hi';
}
''',
        );
        await createPrimedAnalyzersAndGenerate();
      });

      test(
        'when the base class is changed to extend Endpoint, the analyzers are updated with it, and incremental generation runs for the unchanged class file,'
        'then the analyzers examine the class file and its endpoint is generated.',
        () async {
          baseFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

abstract class Base extends Endpoint {}
''');
          await update(baseFile);
          endpoints.examined.clear();
          saveUnchanged(subclassFile);

          final requirements = await updateAndGenerate(subclassFile);

          expect(endpoints.examined, [
            {subclassFile.path},
          ]);
          expect(requirements.generateProtocol, isTrue);
          expect(generatedEndpoints(), contains('GreetingEndpoint'));
        },
      );
    },
  );

  group('Given primed analyzers and a generated endpoint file,', () {
    late File endpointFile;

    setUp(() async {
      endpointFile = writeSource(['endpoints', 'helper.dart'], endpointSource);
      await createPrimedAnalyzersAndGenerate();
    });

    test(
      'when the file is saved without changes and the analyzers are updated,'
      'then they examine it and require protocol generation.',
      () async {
        saveUnchanged(endpointFile);

        final requirements = await update(endpointFile);

        expect(requirements.generateProtocol, isTrue);
        expect(endpoints.examined, [
          {endpointFile.path},
        ]);
      },
    );

    group('when the file is deleted and incremental generation runs for it,', () {
      late GenerationRequirements requirements;

      setUp(() async {
        endpointFile.deleteSync();
        requirements = await updateAndGenerate(endpointFile);
      });

      test('then the analyzers require protocol generation.', () {
        expect(requirements.generateProtocol, isTrue);
      });

      test('then the endpoint is no longer generated.', () {
        expect(generatedEndpoints(), isNot(contains('HelperEndpoint')));
      });

      test(
        'when the file is recreated with its previous content and incremental generation runs for it,'
        'then the endpoint is generated again.',
        () async {
          endpointFile.writeAsStringSync(endpointSource);

          final requirements = await updateAndGenerate(endpointFile);

          expect(requirements.generateProtocol, isTrue);
          expect(generatedEndpoints(), contains('HelperEndpoint'));
        },
      );
    });
  });
}
