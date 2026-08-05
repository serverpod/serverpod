import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
import 'package:test/test.dart';

import '../test_util/builders/enum_definition_builder.dart';
import '../test_util/builders/generator_config_builder.dart';

const _generator = DartServerCodeGenerator();

void main() {
  group(
    'Given an enum model and a target package configured with "trailing_commas: preserve",',
    () {
      late Directory tempDirectory;
      late GeneratorConfig config;
      late EnumDefinition chatRole;

      setUp(() async {
        chatRole = EnumDefinitionBuilder()
            .withClassName('ChatRole')
            .withFileName('chat_role')
            .withValues([
              ProtocolEnumValueDefinition('user'),
              ProtocolEnumValueDefinition('assistant'),
              ProtocolEnumValueDefinition('system'),
            ])
            .build();

        tempDirectory = await Directory.systemTemp.createTemp(
          'code_generator_test_',
        );
        final serverDirectory = Directory(
          p.join(tempDirectory.path, 'example_server'),
        );
        await serverDirectory.create(recursive: true);
        await File(
          p.join(serverDirectory.path, 'analysis_options.yaml'),
        ).writeAsString('''
formatter:
  page_width: 80
  trailing_commas: preserve
''');

        config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
            .build();
        await GeneratedDartFormatters.resolve(config);
      });

      tearDown(() async {
        GeneratedDartFormatters.reset();
        await tempDirectory.delete(recursive: true);
      });

      test(
        'when code is generated, '
        'then the enum terminator preserves the trailing comma.',
        () {
          final path = p.joinAll([
            ...config.generatedServeModelPathParts,
            'chat_role.dart',
          ]);
          final code = _generator.generateSerializableModelsCode(
            models: [chatRole],
            config: config,
          )[path]!;

          expect(code, contains('  assistant,\n  system,\n  ;'));
        },
      );

      test(
        'when the generated enum is formatted twice, '
        'then it is unchanged.',
        () {
          final path = p.joinAll([
            ...config.generatedServeModelPathParts,
            'chat_role.dart',
          ]);
          final code = _generator.generateSerializableModelsCode(
            models: [chatRole],
            config: config,
          )[path]!;
          final formatter = GeneratedDartFormatters.of(path);

          expect(formatter.format(code), code);
        },
      );
    },
  );

  group(
    'Given an enum model and a target package configured with "trailing_commas: automate",',
    () {
      late Directory tempDirectory;
      late GeneratorConfig config;
      late EnumDefinition chatRole;

      setUp(() async {
        chatRole = EnumDefinitionBuilder()
            .withClassName('ChatRole')
            .withFileName('chat_role')
            .withValues([
              ProtocolEnumValueDefinition('user'),
              ProtocolEnumValueDefinition('assistant'),
              ProtocolEnumValueDefinition('system'),
            ])
            .build();

        tempDirectory = await Directory.systemTemp.createTemp(
          'code_generator_test_',
        );
        final serverDirectory = Directory(
          p.join(tempDirectory.path, 'example_server'),
        );
        await serverDirectory.create(recursive: true);
        await File(
          p.join(serverDirectory.path, 'analysis_options.yaml'),
        ).writeAsString('''
formatter:
  page_width: 80
  trailing_commas: automate
''');

        config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
            .build();
        await GeneratedDartFormatters.resolve(config);
      });

      tearDown(() async {
        GeneratedDartFormatters.reset();
        await tempDirectory.delete(recursive: true);
      });

      test(
        'when code is generated, '
        'then the enum terminator omits the trailing comma.',
        () {
          final path = p.joinAll([
            ...config.generatedServeModelPathParts,
            'chat_role.dart',
          ]);
          final code = _generator.generateSerializableModelsCode(
            models: [chatRole],
            config: config,
          )[path]!;

          expect(code, contains('  assistant,\n  system;'));
        },
      );

      test(
        'when the generated enum is formatted twice, '
        'then it is unchanged.',
        () {
          final path = p.joinAll([
            ...config.generatedServeModelPathParts,
            'chat_role.dart',
          ]);
          final code = _generator.generateSerializableModelsCode(
            models: [chatRole],
            config: config,
          )[path]!;
          final formatter = GeneratedDartFormatters.of(path);

          expect(formatter.format(code), code);
        },
      );
    },
  );

  group(
    'Given an enum model and a target package configured with no "trailing_commas" key,',
    () {
      late Directory tempDirectory;
      late GeneratorConfig config;
      late EnumDefinition chatRole;

      setUp(() async {
        chatRole = EnumDefinitionBuilder()
            .withClassName('ChatRole')
            .withFileName('chat_role')
            .withValues([
              ProtocolEnumValueDefinition('user'),
              ProtocolEnumValueDefinition('assistant'),
              ProtocolEnumValueDefinition('system'),
            ])
            .build();

        tempDirectory = await Directory.systemTemp.createTemp(
          'code_generator_test_',
        );
        final serverDirectory = Directory(
          p.join(tempDirectory.path, 'example_server'),
        );
        await serverDirectory.create(recursive: true);
        await File(
          p.join(serverDirectory.path, 'analysis_options.yaml'),
        ).writeAsString('''
formatter:
  page_width: 80
''');

        config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
            .build();
        await GeneratedDartFormatters.resolve(config);
      });

      tearDown(() async {
        GeneratedDartFormatters.reset();
        await tempDirectory.delete(recursive: true);
      });

      test(
        'when code is generated, '
        'then the enum terminator follows the default of "automate" and omits the trailing comma.',
        () {
          final path = p.joinAll([
            ...config.generatedServeModelPathParts,
            'chat_role.dart',
          ]);
          final code = _generator.generateSerializableModelsCode(
            models: [chatRole],
            config: config,
          )[path]!;

          expect(code, contains('  assistant,\n  system;'));
        },
      );
    },
  );
}
