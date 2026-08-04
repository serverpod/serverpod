import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';

void main() {
  late Directory tempDirectory;
  late Directory serverDirectory;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'dart_formatters_test_',
    );

    serverDirectory = Directory(
      p.join(tempDirectory.path, 'example_server'),
    );
    await serverDirectory.create(recursive: true);
  });

  tearDown(() async {
    GeneratedDartFormatters.reset();
    await tempDirectory.delete(recursive: true);
  });

  test(
    'Given a target package using Dart 3.12, '
    'when its generated-code formatters are resolved, '
    'then they use the target package language version.',
    () async {
      final dartToolDirectory = Directory(
        p.join(serverDirectory.path, '.dart_tool'),
      );
      await dartToolDirectory.create(recursive: true);
      await File(
        p.join(dartToolDirectory.path, 'package_config.json'),
      ).writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "example_server",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    }
  ]
}
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.languageVersion, Version(3, 12, 0));
    },
  );

  test(
    'Given a target package preserving trailing commas, '
    'when its generated-code formatters are resolved, '
    'then they capture the target trailing-comma setting.',
    () async {
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  trailing_commas: preserve
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.trailingCommas, TrailingCommas.preserve);
    },
  );

  test(
    'Given a target package with page width 120, '
    'when its generated-code formatters are resolved, '
    'then they capture the target page width.',
    () async {
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  page_width: 120
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.pageWidth, 120);
    },
  );

  test(
    'Given a client package with page width 120, '
    'when its client migration formatters are resolved, '
    'then they capture the target page width.',
    () async {
      final clientDirectory = Directory(
        p.join(tempDirectory.path, 'example_client'),
      );
      await clientDirectory.create(recursive: true);
      await File(
        p.join(clientDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  page_width: 120
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .withRelativeDartClientPackagePathParts(['..', 'example_client'])
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll([
          ...config.clientPackagePathParts,
          'lib',
          'migrations',
          'migration_registry.dart',
        ]),
      );

      expect(formatter.pageWidth, 120);
    },
  );
}
