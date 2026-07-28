import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/project_metadata.dart';
import 'package:serverpod_cli/src/analytics/project_metadata_store.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('Given a server directory without metadata, ', () {
    late String serverDir;
    late ProjectMetadata metadata;

    setUp(() async {
      await _deleteIfExists(d.path('metadata_project_a'));
      // Anchor git-dir resolution inside the sandbox so metadata never
      // escapes to an ambient repo (e.g. a stray /tmp/.git).
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('metadata_project_a', [
        d.dir('myapp_server', [
          d.dir('config', [
            d.file('generator.yaml', 'name: myapp\n'),
          ]),
          d.file('pubspec.yaml', 'name: myapp_server\n'),
        ]),
      ]).create();

      serverDir = p.join(
        d.sandbox,
        'metadata_project_a',
        'myapp_server',
      );
      metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
    });

    test(
      'when loadOrCreate runs, '
      'then it persists metadata derived from generator.yaml.',
      () async {
        expect(metadata.checkoutId, isNotEmpty);
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
        expect(loaded.checkoutId, metadata.checkoutId);
      },
    );
  });

  group('Given a server directory, ', () {
    late String serverDir;

    setUp(() async {
      await _deleteIfExists(d.path('metadata_project_b'));
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('metadata_project_b', [
        d.dir('myapp_server', [
          d.file('pubspec.yaml', 'name: myapp_server\n'),
        ]),
      ]).create();

      serverDir = p.join(
        d.sandbox,
        'metadata_project_b',
        'myapp_server',
      );
      await _deleteFileIfExists(
        ProjectMetadataStore.metadataFilePath(serverDir),
      );
    });

    test(
      'when generate call count is incremented twice, '
      'then the counter increases.',
      () async {
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

  group('Given metadata already accumulated in a checkout, ', () {
    late String serverDir;
    late ProjectMetadata before;

    setUp(() async {
      await _deleteIfExists(d.path('metadata_project_reuse'));
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('metadata_project_reuse', [
        d.dir('myapp_server', [
          d.file('pubspec.yaml', 'name: myapp_server'),
        ]),
      ]).create();

      serverDir = p.join(
        d.sandbox,
        'metadata_project_reuse',
        'myapp_server',
      );

      before = await ProjectMetadataStore.incrementCommandInvocation(
        serverDir,
        'generate',
      );
    });

    test(
      'when a new project is scaffolded in the same checkout, '
      'then the checkout id and counters survive.',
      () async {
        // The metadata file is keyed by git clone, so a second project created
        // in the same checkout must not wipe the first project's history.
        final after = await ProjectMetadataStore.initializeNewProject(
          serverDir,
          projectCreatedAt: DateTime.utc(2026, 1, 1),
        );

        expect(after.checkoutId, before.checkoutId);
        expect(after.commandInvocations, {'generate': 1});
        expect(after.projectCreatedAt, DateTime.utc(2026, 1, 1));

        final reloaded = await ProjectMetadataStore.loadOrCreate(serverDir);
        expect(reloaded.checkoutId, before.checkoutId);
        expect(reloaded.commandInvocations, {'generate': 1});
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
