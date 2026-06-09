import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(
    'Given a clean state',
    () {
      late Directory workingDir;

      setUp(() {
        workingDir = Directory.systemTemp.createTempSync('sp_perform_create_');
      });

      tearDown(() {
        try {
          workingDir.deleteSync(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      group(
        'when calling performCreate with a valid name and dryRun set to true',
        () {
          CreateResult? result;
          final projectName = 'test';

          setUp(() async {
            result = await performCreate(
              projectName,
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
              workingDirectory: workingDir,
            );
          });

          test('then returns a success with the relative project path', () {
            expect(result, isA<CreateSuccess>());
            expect((result! as CreateSuccess).projectPath, projectName);
          });
        },
      );

      group(
        'when calling performCreate with invalid name and dryRun set to true',
        () {
          CreateResult? result;

          setUp(() async {
            result = await performCreate(
              '1test',
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
              workingDirectory: workingDir,
            );
          });

          test('then returns a failure', () {
            expect(result, isA<CreateFailure>());
          });
        },
      );

      group(
        'when calling performCreate with an existing project name and dryRun set to true',
        () {
          CreateResult? result;
          final projectName =
              'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

          setUp(() async {
            final projectDir = Directory(p.join(workingDir.path, projectName))
              ..createSync(recursive: true);
            await File(p.join(projectDir.path, 'pubspec.yaml')).create();

            result = await performCreate(
              projectName,
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
              workingDirectory: workingDir,
            );
          });

          test('then returns a failure', () {
            expect(result, isA<CreateFailure>());
          });
        },
      );
    },
  );
}
