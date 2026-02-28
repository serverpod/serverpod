import 'dart:async';
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

        final events = <FileChangeEvent>[];
        final subscription = watcher.onFilesChanged.listen(events.add);

        // Allow watcher to initialize.
        await Future.delayed(const Duration(milliseconds: 500));

        // Create a dart file.
        await File(
          p.join(tempDir.path, 'lib', 'test_file.dart'),
        ).writeAsString('// test');

        // Wait for debounce + processing.
        await Future.delayed(const Duration(milliseconds: 1000));

        await subscription.cancel();

        expect(events, hasLength(1));
        expect(events.first.dartFiles, isNotEmpty);
        expect(events.first.dartFiles.first, contains('test_file.dart'));
        expect(events.first.modelFiles, isEmpty);
        expect(events.first.packageConfigChanged, isFalse);
      },
      timeout: const Timeout(Duration(seconds: 10)),
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

        final events = <FileChangeEvent>[];
        final subscription = watcher.onFilesChanged.listen(events.add);

        await Future.delayed(const Duration(milliseconds: 500));

        await File(
          p.join(tempDir.path, 'lib', 'model.spy.yaml'),
        ).writeAsString('class: MyModel');

        await Future.delayed(const Duration(milliseconds: 1000));

        await subscription.cancel();

        expect(events, hasLength(1));
        expect(events.first.modelFiles, isNotEmpty);
        expect(events.first.modelFiles.first, contains('model.spy.yaml'));
        expect(events.first.dartFiles, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 10)),
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

        final events = <FileChangeEvent>[];
        final subscription = watcher.onFilesChanged.listen(events.add);

        await Future.delayed(const Duration(milliseconds: 500));

        await File(
          p.join(generatedDir, 'generated.dart'),
        ).writeAsString('// generated');

        await Future.delayed(const Duration(milliseconds: 1000));

        await subscription.cancel();

        expect(events, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });
}
