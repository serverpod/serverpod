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
      group(
        'when calling performCreate with a valid name and dryRun set to true',
        () {
          String? result;
          final projectName = 'test';

          setUp(() async {
            result = await performCreate(
              projectName,
              ServerpodTemplateType.server,
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
            );
          });

          test('then returns relative project directory path', () {
            expect(result, projectName);
          });
        },
      );

      group(
        'when calling performCreate with invalid name and dryRun set to true',
        () {
          String? result;

          setUp(() async {
            result = await performCreate(
              '1test',
              ServerpodTemplateType.server,
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
            );
          });

          test('then returns null', () {
            expect(result, isNull);
          });
        },
      );

      group(
        'when calling performCreate with an existing project name and dryRun set to true',
        () {
          late Directory projectDir;
          String? result;
          final projectName =
              'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

          setUp(() async {
            projectDir = Directory(projectName);
            projectDir.create();

            final pubspecFile = File(p.join(projectName, 'pubspec.yaml'));
            await pubspecFile.create();

            result = await performCreate(
              projectName,
              ServerpodTemplateType.server,
              false,
              dryRun: true,
              interactive: false,
              context: TemplateContext(),
            );
          });

          tearDown(() {
            try {
              projectDir.delete(recursive: true);
            } on FileSystemException {
              // Gone.
            }
          });

          test('then returns null', () {
            expect(result, isNull);
          });
        },
      );
    },
  );
}
