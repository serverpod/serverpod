import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';
import '../test_util/builders/model_class_definition_builder.dart';
import '../test_util/mtime_helpers.dart';

void main() {
  late Directory tempDirectory;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'serverpod_code_generator_test_',
    );
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  test(
    'does not rewrite an unchanged CRLF file',
    () async {
      final config = buildTestServerConfig(tempDirectory);
      final model = ModelClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build();

      final generatedFiles =
          await ServerpodCodeGenerator.generateSerializableModels(
            models: [model],
            config: config,
          );

      final generatedFilePath = generatedFiles.firstWhere(
        (path) => path.endsWith(p.join('generated', 'example.dart')),
      );
      final generatedFile = File(generatedFilePath);

      final originalContent = await generatedFile.readAsString();
      final crlfContent = originalContent.replaceAll('\n', '\r\n');

      await generatedFile.writeAsBytes(utf8.encode(crlfContent));
      final before = await generatedFile.stat();
      await waitForMtimeAfter(before.modified, tempDirectory);

      await ServerpodCodeGenerator.generateSerializableModels(
        models: [model],
        config: config,
      );

      final after = await generatedFile.stat();

      expect(await generatedFile.readAsString(), crlfContent);
      expect(after.modified, before.modified);
    },
  );

  test(
    'rewrites a generated file when its content changes',
    () async {
      final config = buildTestServerConfig(tempDirectory);

      final originalModel = ModelClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build();

      final generatedFiles =
          await ServerpodCodeGenerator.generateSerializableModels(
            models: [originalModel],
            config: config,
          );

      final generatedFilePath = generatedFiles.firstWhere(
        (path) => path.endsWith(p.join('generated', 'example.dart')),
      );
      final generatedFile = File(generatedFilePath);
      final originalContent = await generatedFile.readAsString();

      final changedModel = ModelClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSimpleField('title', 'String')
          .build();

      final before = await generatedFile.stat();
      await waitForMtimeAfter(before.modified, tempDirectory);

      await ServerpodCodeGenerator.generateSerializableModels(
        models: [changedModel],
        config: config,
      );

      final after = await generatedFile.stat();
      final updatedContent = await generatedFile.readAsString();

      expect(updatedContent, isNot(originalContent));
      expect(updatedContent, contains('title'));
      expect(after.modified, isNot(before.modified));
    },
  );
}
