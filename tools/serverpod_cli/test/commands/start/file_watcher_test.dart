import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('file_watcher_test_');
    // Create the lib directory.
    await Directory(p.join(tempDir.path, 'lib')).create();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('Given a FileWatcher watching a directory', () {
    test(
      'when a .dart file is created, '
      'then it emits a FileChangeEvent with the file in dartFiles',
      () async {
        final watcher = FileWatcher(
          watchPaths: [p.join(tempDir.path, 'lib')],
          ignorePath: p.join(tempDir.path, 'lib', 'src', 'generated'),
          debounceDelay: const Duration(milliseconds: 200),
        );

        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(tempDir.path, 'lib', 'test_file.dart'),
        ).writeAsString('// test');

        final event = await firstEvent;

        expect(event.dartFiles, isNotEmpty);
        expect(event.dartFiles.first, contains('test_file.dart'));
        expect(event.modelFiles, isEmpty);
        expect(event.packageConfigChanged, isFalse);
      },
    );

    test(
      'when a .spy.yaml file is created, '
      'then it emits a FileChangeEvent with the file in modelFiles',
      () async {
        final watcher = FileWatcher(
          watchPaths: [p.join(tempDir.path, 'lib')],
          ignorePath: p.join(tempDir.path, 'lib', 'src', 'generated'),
          debounceDelay: const Duration(milliseconds: 200),
        );

        final firstEvent = watcher.onFilesChanged.first;
        await watcher.ready;

        await File(
          p.join(tempDir.path, 'lib', 'model.spy.yaml'),
        ).writeAsString('class: MyModel');

        final event = await firstEvent;

        expect(event.modelFiles, isNotEmpty);
        expect(event.modelFiles.first, contains('model.spy.yaml'));
        expect(event.dartFiles, isEmpty);
      },
    );

    test(
      'when a file in the ignored directory is created, '
      'then no event is emitted',
      () async {
        final generatedDir = p.join(tempDir.path, 'lib', 'src', 'generated');
        await Directory(generatedDir).create(recursive: true);

        final watcher = FileWatcher(
          watchPaths: [p.join(tempDir.path, 'lib')],
          ignorePath: generatedDir,
          debounceDelay: const Duration(milliseconds: 200),
        );

        // Subscribe and wait for the watcher to be ready.
        final events = <FileChangeEvent>[];
        final subscription = watcher.onFilesChanged.listen(events.add);
        await watcher.ready;

        // Write an ignored file, then a non-ignored sentinel file.
        await File(
          p.join(generatedDir, 'generated.dart'),
        ).writeAsString('// generated');
        await File(
          p.join(tempDir.path, 'lib', 'sentinel.dart'),
        ).writeAsString('// sentinel');

        // Wait for the sentinel event to arrive.
        await watcher.onFilesChanged.first;
        await subscription.cancel();

        // The only event should be the sentinel - the ignored file is filtered.
        expect(events, hasLength(1));
        expect(events.first.dartFiles.first, contains('sentinel.dart'));
      },
    );
  });
}
