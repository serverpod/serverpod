import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:test/test.dart';
import 'package:watcher/watcher.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('serverpod_cli_test_');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('expandDirectoryAddEvents', () {
    test(
      'Given a directory ADD event when the directory contains files '
      'then individual file ADD events are emitted instead.',
      () async {
        var subDir =
            await Directory(p.join(tempDir.path, 'subdir')).create();
        await File(p.join(subDir.path, 'model1.yaml'))
            .writeAsString('content1');
        await File(p.join(subDir.path, 'model2.yaml'))
            .writeAsString('content2');

        var controller = StreamController<WatchEvent>();
        var expandedStream = expandDirectoryAddEvents(controller.stream);

        var events = <WatchEvent>[];
        var subscription = expandedStream.listen(events.add);

        controller.add(WatchEvent(ChangeType.ADD, subDir.path));

        await Future<void>.delayed(const Duration(milliseconds: 200));
        await controller.close();
        await subscription.cancel();

        expect(
          events
              .where((e) => e.type == ChangeType.ADD)
              .map((e) => p.basename(e.path)),
          unorderedEquals(['model1.yaml', 'model2.yaml']),
        );
      },
    );

    test(
      'Given a directory ADD event when the directory contains a nested subtree '
      'then individual file ADD events are emitted for all files recursively.',
      () async {
        var subDir =
            await Directory(p.join(tempDir.path, 'models')).create();
        var nestedDir =
            await Directory(p.join(subDir.path, 'nested')).create();
        await File(p.join(subDir.path, 'top.yaml')).writeAsString('top');
        await File(p.join(nestedDir.path, 'nested.yaml'))
            .writeAsString('nested');

        var controller = StreamController<WatchEvent>();
        var expandedStream = expandDirectoryAddEvents(controller.stream);

        var events = <WatchEvent>[];
        var subscription = expandedStream.listen(events.add);

        controller.add(WatchEvent(ChangeType.ADD, subDir.path));

        await Future<void>.delayed(const Duration(milliseconds: 200));
        await controller.close();
        await subscription.cancel();

        expect(
          events
              .where((e) => e.type == ChangeType.ADD)
              .map((e) => p.basename(e.path)),
          unorderedEquals(['top.yaml', 'nested.yaml']),
        );
      },
    );

    test(
      'Given a file ADD event when the path points to a file '
      'then the event is passed through unchanged.',
      () async {
        var file =
            await File(p.join(tempDir.path, 'model.yaml')).create();

        var controller = StreamController<WatchEvent>();
        var expandedStream = expandDirectoryAddEvents(controller.stream);

        var events = <WatchEvent>[];
        var subscription = expandedStream.listen(events.add);

        controller.add(WatchEvent(ChangeType.ADD, file.path));

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await controller.close();
        await subscription.cancel();

        expect(events, hasLength(1));
        expect(events.single.type, ChangeType.ADD);
        expect(events.single.path, file.path);
      },
    );

    test(
      'Given a REMOVE event when it is emitted '
      'then the event is passed through unchanged.',
      () async {
        var controller = StreamController<WatchEvent>();
        var expandedStream = expandDirectoryAddEvents(controller.stream);

        var events = <WatchEvent>[];
        var subscription = expandedStream.listen(events.add);

        controller.add(WatchEvent(ChangeType.REMOVE, '/some/deleted/path'));

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await controller.close();
        await subscription.cancel();

        expect(events, hasLength(1));
        expect(events.single.type, ChangeType.REMOVE);
        expect(events.single.path, '/some/deleted/path');
      },
    );

    test(
      'Given an ADD event for a non-existent path '
      'then the event is passed through unchanged.',
      () async {
        var controller = StreamController<WatchEvent>();
        var expandedStream = expandDirectoryAddEvents(controller.stream);

        var events = <WatchEvent>[];
        var subscription = expandedStream.listen(events.add);

        controller.add(
          WatchEvent(ChangeType.ADD, p.join(tempDir.path, 'missing.yaml')),
        );

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await controller.close();
        await subscription.cancel();

        expect(events, hasLength(1));
        expect(events.single.type, ChangeType.ADD);
      },
    );
  });

  group('DirectoryWatcher integration', () {
    test(
      'Given a DirectoryWatcher when a new directory tree is created '
      'then file ADD events are emitted for all files in the subtree.',
      () async {
        var watcher = DirectoryWatcher(tempDir.path);
        var receivedEvents = <WatchEvent>[];
        var expandedStream = expandDirectoryAddEvents(watcher.events);
        var subscription = expandedStream.listen(receivedEvents.add);

        await watcher.ready;

        var newDir = Directory(p.join(tempDir.path, 'models'));
        await newDir.create();
        await File(p.join(newDir.path, 'model_a.yaml'))
            .writeAsString('class: A\n');
        await File(p.join(newDir.path, 'model_b.yaml'))
            .writeAsString('class: B\n');

        await Future<void>.delayed(const Duration(milliseconds: 500));
        await subscription.cancel();

        var addedYamlNames = receivedEvents
            .where(
              (e) => e.type == ChangeType.ADD && e.path.endsWith('.yaml'),
            )
            .map((e) => p.basename(e.path))
            .toList();

        expect(addedYamlNames, containsAll(['model_a.yaml', 'model_b.yaml']));
      },
    );

    test(
      'Given a DirectoryWatcher when a directory tree is moved into the watched directory '
      'then file ADD events are emitted for all files in the subtree.',
      () async {
        var srcDir = await Directory.systemTemp
            .createTemp('serverpod_cli_src_test_');
        try {
          var srcSubDir =
              await Directory(p.join(srcDir.path, 'models')).create();
          await File(p.join(srcSubDir.path, 'model_x.yaml'))
              .writeAsString('class: X\n');
          await File(p.join(srcSubDir.path, 'model_y.yaml'))
              .writeAsString('class: Y\n');

          var watcher = DirectoryWatcher(tempDir.path);
          var receivedEvents = <WatchEvent>[];
          var expandedStream = expandDirectoryAddEvents(watcher.events);
          var subscription = expandedStream.listen(receivedEvents.add);

          await watcher.ready;

          // Move the directory tree into the watched directory.
          await srcSubDir.rename(p.join(tempDir.path, 'models'));

          await Future<void>.delayed(const Duration(milliseconds: 500));
          await subscription.cancel();

          var addedYamlNames = receivedEvents
              .where(
                (e) => e.type == ChangeType.ADD && e.path.endsWith('.yaml'),
              )
              .map((e) => p.basename(e.path))
              .toList();

          expect(
            addedYamlNames,
            containsAll(['model_x.yaml', 'model_y.yaml']),
          );
        } finally {
          await srcDir.delete(recursive: true);
        }
      },
    );

    test(
      'Given a DirectoryWatcher when a directory is deleted '
      'then REMOVE events are emitted.',
      () async {
        var subDir = Directory(p.join(tempDir.path, 'models'));
        await subDir.create();
        await File(p.join(subDir.path, 'model.yaml'))
            .writeAsString('class: Model\n');

        var watcher = DirectoryWatcher(tempDir.path);
        var receivedEvents = <WatchEvent>[];
        var expandedStream = expandDirectoryAddEvents(watcher.events);
        var subscription = expandedStream.listen(receivedEvents.add);

        await watcher.ready;

        await subDir.delete(recursive: true);

        await Future<void>.delayed(const Duration(milliseconds: 500));
        await subscription.cancel();

        var removeEvents = receivedEvents
            .where((e) => e.type == ChangeType.REMOVE)
            .toList();

        expect(removeEvents, isNotEmpty);
      },
    );
  });
}
