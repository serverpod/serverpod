import 'dart:io';

import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

void main() {
  group('Given an invalid project name', () {
    late CreateResult result;

    group('when performing create', () {
      setUp(() async {
        result = await performCreate(
          '1-invalid-name',
          false,
          interactive: false,
          context: TemplateContext(),
        );
      });

      test('then the result is a failure.', () {
        expect(result, isA<CreateFailure>());
      });

      test('then nothing was written so no setup instructions show.', () {
        expect(result.serverDirAbsolute, isNull);
      });
    });
  });

  group('Given a directory that already holds a Serverpod project', () {
    late Directory tempDir;
    late CreateResult result;

    group('when performing create', () {
      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp('create_result_test');
        final projectDir = await Directory(
          '${tempDir.path}/my_app',
        ).create(recursive: true);
        await File(
          '${projectDir.path}/pubspec.yaml',
        ).writeAsString('name: my_app');

        result = await performCreate(
          'my_app',
          false,
          interactive: false,
          context: TemplateContext(),
          workingDirectory: tempDir,
        );
      });

      tearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });

      test('then the result is a failure.', () {
        expect(result, isA<CreateFailure>());
      });

      test('then nothing was written so no setup instructions show.', () {
        expect(result.serverDirAbsolute, isNull);
      });
    });
  });

  group('Given a fresh project directory', () {
    late Directory tempDir;
    late CreateResult result;

    group('when performing a dry run', () {
      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp('create_result_test');
        result = await performCreate(
          'my_app',
          false,
          dryRun: true,
          interactive: false,
          context: TemplateContext(),
          workingDirectory: tempDir,
        );
      });

      tearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });

      test('then it reports success so the TUI may proceed.', () {
        expect(result, isA<CreateSuccess>());
        expect((result as CreateSuccess).projectPath, 'my_app');
      });

      test('then no files were written so no server dir is reported.', () {
        expect(result.serverDirAbsolute, isNull);
      });
    });
  });
}
