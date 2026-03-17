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
    late FileWatcher watcher;

    setUp(() {
      watcher = FileWatcher(
        watchPaths: [p.join(tempDir.path, 'lib')],
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      'when a .dart file is created, '
      'then it emits a FileChangeEvent with the file in dartFiles',
      () async {
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
  });

  group('Given a FileWatcher with ignored paths', () {
    late FileWatcher watcher;
    late String generatedDir;

    setUp(() async {
      generatedDir = p.join(tempDir.path, 'lib', 'src', 'generated');
      await Directory(generatedDir).create(recursive: true);

      watcher = FileWatcher(
        watchPaths: [p.join(tempDir.path, 'lib')],
        ignorePaths: {generatedDir},
        debounceDelay: const Duration(milliseconds: 200),
      );
    });

    test(
      'when a file in the ignored directory is created, '
      'then no event is emitted',
      () async {
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

  group('Given a list of FileChangeEvents', () {
    test(
      'when merge is called on a single event, '
      'then it returns it unchanged',
      () {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m.spy.yaml'},
          packageConfigChanged: true,
        );
        final result = [event].merge();
        expect(identical(result, event), isTrue);
      },
    );

    test(
      'when merge is called on multiple events, '
      'then it merges all fields',
      () {
        final e1 = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m1.spy.yaml'},
        );
        final e2 = FileChangeEvent(
          dartFiles: {'/lib/b.dart', '/lib/c.dart'},
          staticFilesChanged: true,
        );
        final result = [e1, e2].merge();
        expect(result.dartFiles, {'/lib/a.dart', '/lib/b.dart', '/lib/c.dart'});
        expect(result.modelFiles, {'/models/m1.spy.yaml'});
        expect(result.staticFilesChanged, isTrue);
      },
    );

    test(
      'when merge is called on events with the same file, '
      'then it appears only once',
      () {
        final e1 = FileChangeEvent(dartFiles: {'/lib/a.dart'});
        final e2 = FileChangeEvent(dartFiles: {'/lib/a.dart'});
        final result = [e1, e2].merge();
        expect(result.dartFiles, {'/lib/a.dart'});
      },
    );

    test(
      'when merge is called on events where one has packageConfigChanged, '
      'then result has packageConfigChanged true',
      () {
        final e1 = FileChangeEvent(dartFiles: {});
        final e2 = FileChangeEvent(dartFiles: {}, packageConfigChanged: true);
        final result = [e1, e2].merge();
        expect(result.packageConfigChanged, isTrue);
      },
    );
  });
}
