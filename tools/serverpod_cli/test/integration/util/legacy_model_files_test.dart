import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/legacy_model_files.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/module_config_builder.dart';

const _modelYaml = '''
class: Example
fields:
  name: String
''';

class _ErrorCapturingLogger extends VoidLogger {
  final List<String> errors = [];

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType? type,
  }) {
    errors.add(message);
  }
}

void main() {
  late _ErrorCapturingLogger logger;

  setUp(() {
    logger = _ErrorCapturingLogger();
    initializeLoggerWith(logger);
  });

  tearDown(() async {
    await closeLogger();
  });

  List<String> serverPathParts() => p.split(p.join(d.sandbox, 'server'));

  group('Given a server package with a bare .yaml model in lib/src/models', () {
    setUp(() async {
      await d.dir('server/lib/src/models', [
        d.file('example.yaml', _modelYaml),
      ]).create();
    });

    test('when finding legacy model files then the file is found.', () async {
      var config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(serverPathParts())
          .withModules([])
          .build();

      var files = await LegacyModelFiles.find(config);

      expect(files, hasLength(1));
      expect(
        files.single.path,
        p.join(d.sandbox, 'server', 'lib', 'src', 'models', 'example.yaml'),
      );
      expect(files.single.moduleNickname, isNull);
    });

    test(
      'when reporting legacy model files '
      'then an error listing the file is logged and true is returned.',
      () async {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(serverPathParts())
            .withModules([])
            .build();

        var reported = await LegacyModelFiles.report(config);

        expect(reported, isTrue);
        expect(logger.errors, hasLength(1));
        expect(
          logger.errors.single,
          contains(p.join('lib', 'src', 'models', 'example.yaml')),
        );
        expect(logger.errors.single, contains('.spy.yaml'));
      },
    );
  });

  group('Given a server package with a bare .yml enum in lib/src/protocol', () {
    setUp(() async {
      await d.dir('server/lib/src/protocol', [
        d.file('example.yml', '''
enum: Example
values:
  - first
'''),
      ]).create();
    });

    test('when finding legacy model files then the file is found.', () async {
      var config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(serverPathParts())
          .withModules([])
          .build();

      var files = await LegacyModelFiles.find(config);

      expect(files.map((f) => p.basename(f.path)), ['example.yml']);
    });
  });

  group('Given a server package with only supported model files', () {
    setUp(() async {
      await d.dir('server/lib/src', [
        d.dir('models', [
          d.file('example.spy.yaml', _modelYaml),
          d.file('other.spy', _modelYaml),
        ]),
        d.file('outside.yaml', _modelYaml),
      ]).create();
    });

    test('when finding legacy model files then nothing is found.', () async {
      var config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(serverPathParts())
          .withModules([])
          .build();

      var files = await LegacyModelFiles.find(config);

      expect(files, isEmpty);
    });

    test(
      'when reporting legacy model files '
      'then nothing is logged and false is returned.',
      () async {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(serverPathParts())
            .withModules([])
            .build();

        var reported = await LegacyModelFiles.report(config);

        expect(reported, isFalse);
        expect(logger.errors, isEmpty);
      },
    );
  });

  group(
    'Given a server package with non-model yaml files in lib/src/models',
    () {
      setUp(() async {
        await d.dir('server/lib/src/models', [
          d.file('analysis_options.yaml', 'include: package:lints/core.yaml\n'),
          d.file('list.yaml', '- a\n- b\n'),
          d.file('broken.yaml', 'class: [\n'),
          d.file('empty.yaml', ''),
        ]).create();
      });

      test('when finding legacy model files then nothing is found.', () async {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(serverPathParts())
            .withModules([])
            .build();

        var files = await LegacyModelFiles.find(config);

        expect(files, isEmpty);
      });
    },
  );

  group('Given a shared package with a bare .yaml model in lib/src/models', () {
    setUp(() async {
      await d.dir('server/packages/shared/lib/src/models', [
        d.file('shared.yaml', _modelYaml),
      ]).create();
    });

    test(
      'when finding legacy model files '
      'then the file is found as a project file.',
      () async {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(serverPathParts())
            .withSharedModelsSourcePathsParts({
              'shared': ['packages', 'shared'],
            })
            .withModules([])
            .build();

        var files = await LegacyModelFiles.find(config);

        expect(files.map((f) => p.basename(f.path)), ['shared.yaml']);
        expect(files.single.moduleNickname, isNull);
      },
    );
  });

  group(
    'Given a dependent module with a bare .yaml model in lib/src/models',
    () {
      setUp(() async {
        await d.dir('module/lib/src/models', [
          d.file('module_model.yaml', _modelYaml),
        ]).create();
      });

      test(
        'when finding legacy model files '
        'then the file is found with the module nickname.',
        () async {
          var config = GeneratorConfigBuilder()
              .withServerPackageDirectoryPathParts(serverPathParts())
              .withModules([
                ModuleConfigBuilder('test_module', 'test_alias')
                    .withServerPackageDirectoryPathParts(
                      p.split(p.join(d.sandbox, 'module')),
                    )
                    .build(),
              ])
              .build();

          var files = await LegacyModelFiles.find(config);

          expect(files.map((f) => p.basename(f.path)), ['module_model.yaml']);
          expect(files.single.moduleNickname, 'test_alias');
        },
      );

      test(
        'when reporting legacy model files '
        'then an error asking to update the module is logged.',
        () async {
          var config = GeneratorConfigBuilder()
              .withServerPackageDirectoryPathParts(serverPathParts())
              .withModules([
                ModuleConfigBuilder('test_module', 'test_alias')
                    .withServerPackageDirectoryPathParts(
                      p.split(p.join(d.sandbox, 'module')),
                    )
                    .build(),
              ])
              .build();

          var reported = await LegacyModelFiles.report(config);

          expect(reported, isTrue);
          expect(logger.errors, hasLength(1));
          expect(logger.errors.single, contains('The module "test_alias"'));
          expect(logger.errors.single, contains('module_model.yaml'));
        },
      );
    },
  );
}
