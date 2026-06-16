import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/project_metadata_store.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('Given a server directory without metadata, ', () {
    test(
      'when loadOrCreate runs, '
      'then it persists metadata derived from generator.yaml.',
      () async {
        await _deleteIfExists(d.path('metadata_project_a'));
        await d.dir('metadata_project_a', [
          d.dir('myapp_server', [
            d.dir('config', [
              d.file('generator.yaml', 'name: myapp\n'),
            ]),
            d.file('pubspec.yaml', 'name: myapp_server\n'),
          ]),
        ]).create();

        final serverDir = p.join(
          d.sandbox,
          'metadata_project_a',
          'myapp_server',
        );
        final metadata = await ProjectMetadataStore.loadOrCreate(serverDir);

        expect(metadata.projectId, isNotEmpty);
        expect(metadata.generateCallCount, 0);
        expect(
          metadata.projectCreatedAt.isBefore(DateTime.now().toUtc()),
          isTrue,
        );

        expect(
          await File(ProjectMetadataStore.metadataFilePath(serverDir)).exists(),
          isTrue,
        );

        final loaded = await ProjectMetadataStore.loadOrCreate(serverDir);
        expect(loaded.projectId, metadata.projectId);
      },
    );
  });

  group('Given a server directory, ', () {
    test(
      'when generate call count is incremented twice, '
      'then the counter increases.',
      () async {
        await _deleteIfExists(d.path('metadata_project_b'));
        await d.dir('metadata_project_b', [
          d.dir('myapp_server', [
            d.file('pubspec.yaml', 'name: myapp_server\n'),
          ]),
        ]).create();

        final serverDir = p.join(
          d.sandbox,
          'metadata_project_b',
          'myapp_server',
        );
        await _deleteFileIfExists(
          ProjectMetadataStore.metadataFilePath(serverDir),
        );
        final first = await ProjectMetadataStore.incrementGenerateCallCount(
          serverDir,
        );
        final second = await ProjectMetadataStore.incrementGenerateCallCount(
          serverDir,
        );

        expect(first.generateCallCount, 1);
        expect(second.generateCallCount, 2);
      },
    );
  });
}

Future<void> _deleteIfExists(String path) async {
  final directory = Directory(path);
  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }
}

Future<void> _deleteFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
