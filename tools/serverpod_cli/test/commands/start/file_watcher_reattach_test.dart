import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:test/test.dart';
import 'package:watcher/watcher.dart' as w;

/// A file watcher that only starts reporting changes after [startupLatency].
///
/// `package:watcher` never watches a single file natively on Windows; it falls
/// back to polling, which recognizes a change only by comparing it against a
/// baseline read asynchronously once the watcher starts. Substituting this
/// watcher exercises that shape on every platform, and makes the start-up cost
/// explicit rather than dependent on how loaded the machine running the test
/// happens to be.
class _SlowToStartFileWatcher implements w.FileWatcher {
  @override
  final String path;

  final _controller = StreamController<w.WatchEvent>.broadcast();
  final _readyCompleter = Completer<void>();

  _SlowToStartFileWatcher(
    this.path, {
    required Duration startupLatency,
    Duration? pollingDelay,
  }) {
    unawaited(() async {
      await Future<void>.delayed(startupLatency);
      final inner = w.PollingFileWatcher(path, pollingDelay: pollingDelay);
      inner.events.listen(
        _controller.add,
        onError: _controller.addError,
        onDone: _controller.close,
      );
      await inner.ready;
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
    }());
  }

  @override
  Stream<w.WatchEvent> get events => _controller.stream;

  @override
  bool get isReady => _readyCompleter.isCompleted;

  @override
  Future<void> get ready => _readyCompleter.future;
}

void main() {
  late Directory tempDir;
  late File packageGraph;
  late w.FileWatcher Function(String path, Duration? pollingDelay)
  createPlatformWatcher;

  // `package:watcher` picks the platform's file watcher for a path. Route that
  // choice to whatever the running scenario installed. The registration is
  // global and permanent, so it is made once for the whole file.
  w.registerCustomWatcher(
    'scenario-double',
    null,
    (path, {pollingDelay}) => createPlatformWatcher(path, pollingDelay),
  );

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('file_watcher_reattach_');
    await Directory(p.join(tempDir.path, '.dart_tool')).create();

    packageGraph = File(
      p.join(tempDir.path, '.dart_tool', 'package_graph.json'),
    );
    await packageGraph.writeAsString('{"roots":[],"packages":[]}');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group(
    'Given a FileWatcher configured with a 30 ms missing-file polling delay, '
    'when it starts tracking a pub artifact that already exists,',
    () {
      late List<Duration?> requestedPollingDelays;
      late StreamSubscription<FileChangeEvent> subscription;

      setUp(() async {
        // The delay is named for a file that is absent, but it governs the
        // watcher attached to the artifact while it exists too. Without it
        // that watcher falls back to the watcher package's one second default.
        requestedPollingDelays = [];
        createPlatformWatcher = (path, pollingDelay) {
          requestedPollingDelays.add(pollingDelay);
          return _SlowToStartFileWatcher(
            path,
            startupLatency: Duration.zero,
            pollingDelay: pollingDelay,
          );
        };

        final watcher = FileWatcher(
          watchPaths: [packageGraph.path],
          packageGraphPaths: [packageGraph.path],
          debounceDelay: const Duration(milliseconds: 50),
          missingFilePollingDelay: const Duration(milliseconds: 30),
        );
        subscription = watcher.onFilesChanged.listen((_) {});
        await watcher.ready;
      });

      tearDown(() async {
        await subscription.cancel();
      });

      test(
        'then it opens a watcher for the artifact with a 30 ms polling delay.',
        () {
          expect(requestedPollingDelays, [const Duration(milliseconds: 30)]);
        },
      );
    },
  );

  group('Given a FileWatcher tracking an existing pub artifact,', () {
    late StreamSubscription<FileChangeEvent> subscription;
    late StreamQueue<FileChangeEvent> events;

    setUp(() async {
      // The platform watcher takes longer to start than the debounce below,
      // so an event reaches the test while a watcher announced before it
      // started would still be blind to further changes.
      createPlatformWatcher = (path, pollingDelay) => _SlowToStartFileWatcher(
        path,
        startupLatency: const Duration(milliseconds: 150),
        pollingDelay: pollingDelay,
      );

      final watcher = FileWatcher(
        watchPaths: [packageGraph.path],
        packageGraphPaths: [packageGraph.path],
        debounceDelay: const Duration(milliseconds: 50),
        missingFilePollingDelay: const Duration(milliseconds: 20),
      );
      // Buffer the events, so one emitted before the next read is awaited is
      // not missed.
      final received = StreamController<FileChangeEvent>();
      subscription = watcher.onFilesChanged.listen(received.add);
      events = StreamQueue(received.stream);
      await watcher.ready;
    });

    tearDown(() async {
      // Cancel immediately: a plain cancel waits for a request still pending
      // from a failed expectation, which would hang the suite instead of
      // reporting the failure.
      await events.cancel(immediate: true);
      await subscription.cancel();
    });

    test(
      'when the artifact is deleted, '
      'then it emits a Flutter dependency change.',
      () async {
        await packageGraph.delete();

        final event = await events.next.timeout(const Duration(seconds: 3));
        expect(event.flutterDependenciesChanged, isTrue);
      },
    );
  });

  group('Given a FileWatcher tracking a pub artifact that was deleted,', () {
    late StreamSubscription<FileChangeEvent> subscription;
    late StreamQueue<FileChangeEvent> events;

    setUp(() async {
      // The platform watcher takes longer to start than the debounce below,
      // so an event reaches the test while a watcher announced before it
      // started would still be blind to further changes.
      createPlatformWatcher = (path, pollingDelay) => _SlowToStartFileWatcher(
        path,
        startupLatency: const Duration(milliseconds: 150),
        pollingDelay: pollingDelay,
      );

      final watcher = FileWatcher(
        watchPaths: [packageGraph.path],
        packageGraphPaths: [packageGraph.path],
        debounceDelay: const Duration(milliseconds: 50),
        missingFilePollingDelay: const Duration(milliseconds: 20),
      );
      // Buffer the events, so one emitted before the next read is awaited is
      // not missed.
      final received = StreamController<FileChangeEvent>();
      subscription = watcher.onFilesChanged.listen(received.add);
      events = StreamQueue(received.stream);
      await watcher.ready;

      await packageGraph.delete();
      await events.next.timeout(const Duration(seconds: 3));
    });

    tearDown(() async {
      // Cancel immediately: a plain cancel waits for a request still pending
      // from a failed expectation, which would hang the suite instead of
      // reporting the failure.
      await events.cancel(immediate: true);
      await subscription.cancel();
    });

    test(
      'when the artifact is recreated, '
      'then it emits a Flutter dependency change.',
      () async {
        await packageGraph.writeAsString('{"roots":[],"packages":[]}');

        final event = await events.next.timeout(const Duration(seconds: 3));
        expect(event.flutterDependenciesChanged, isTrue);
      },
    );
  });

  group(
    'Given a FileWatcher tracking a pub artifact that was deleted and '
    'recreated,',
    () {
      late StreamSubscription<FileChangeEvent> subscription;
      late StreamQueue<FileChangeEvent> events;

      setUp(() async {
        // The platform watcher takes longer to start than the debounce below,
        // so an event reaches the test while a watcher announced before it
        // started would still be blind to further changes.
        createPlatformWatcher = (path, pollingDelay) => _SlowToStartFileWatcher(
          path,
          startupLatency: const Duration(milliseconds: 150),
          pollingDelay: pollingDelay,
        );

        final watcher = FileWatcher(
          watchPaths: [packageGraph.path],
          packageGraphPaths: [packageGraph.path],
          debounceDelay: const Duration(milliseconds: 50),
          missingFilePollingDelay: const Duration(milliseconds: 20),
        );
        // Buffer the events, so one emitted before the next read is awaited is
        // not missed.
        final received = StreamController<FileChangeEvent>();
        subscription = watcher.onFilesChanged.listen(received.add);
        events = StreamQueue(received.stream);
        await watcher.ready;

        await packageGraph.delete();
        await events.next.timeout(const Duration(seconds: 3));

        await packageGraph.writeAsString('{"roots":[],"packages":[]}');
        await events.next.timeout(const Duration(seconds: 3));
      });

      tearDown(() async {
        // Cancel immediately: a plain cancel waits for a request still pending
        // from a failed expectation, which would hang the suite instead of
        // reporting the failure.
        await events.cancel(immediate: true);
        await subscription.cancel();
      });

      test(
        'when the artifact changes again, '
        'then it emits a Flutter dependency change.',
        () async {
          await packageGraph.writeAsString(
            '{"roots":[],"packages":[{"name":"new_dependency"}]}',
          );

          final event = await events.next.timeout(const Duration(seconds: 3));
          expect(event.flutterDependenciesChanged, isTrue);
        },
      );
    },
  );
}
