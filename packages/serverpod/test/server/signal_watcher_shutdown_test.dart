import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/serverpod.dart';
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

/// Stands in for the process-wide `ProcessSignal.watch()` streams.
///
/// Real signal streams cannot be used here: `dart test` runs every test file
/// in the same process, so a subscription taken out by one test is observable
/// by all the others. Handing [Serverpod] its own streams keeps the assertions
/// below independent of everything else running in the process.
class _FakeProcessSignals {
  final _controllers = <ProcessSignal, List<StreamController<ProcessSignal>>>{};

  Stream<ProcessSignal> watch(ProcessSignal signal) {
    var controller = StreamController<ProcessSignal>();
    (_controllers[signal] ??= []).add(controller);
    return controller.stream;
  }

  /// The number of streams for [signal] that currently have a subscription.
  int watcherCount(ProcessSignal signal) =>
      _controllers[signal]?.where((c) => c.hasListener).length ?? 0;

  /// The number of streams handed out for [signal], subscribed or not.
  int streamCount(ProcessSignal signal) => _controllers[signal]?.length ?? 0;
}

void main() {
  var portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  var watchedSignals = [
    ProcessSignal.sigint,
    if (!Platform.isWindows) ProcessSignal.sigterm,
  ];

  late _FakeProcessSignals signals;
  late Serverpod pod;

  setUp(() {
    signals = _FakeProcessSignals();
    pod = Serverpod(
      [],
      internal.Protocol(),
      EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: portZeroConfig,
        webServer: portZeroConfig,
      ),
    );
    pod.setSignalStreamFactoryForTesting(signals.watch);
  });

  group('Given a started Serverpod', () {
    setUp(() async {
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when inspecting the watched process signals, '
      'then each of them has exactly one watcher.',
      () {
        for (var signal in watchedSignals) {
          expect(
            signals.watcherCount(signal),
            1,
            reason: '${signal.name} should be watched while running',
          );
        }
      },
    );
  });

  group('Given a started Serverpod that has been shut down', () {
    setUp(() async {
      await pod.start();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when inspecting the watched process signals, '
      'then none of them has a watcher left.',
      () {
        for (var signal in watchedSignals) {
          expect(
            signals.watcherCount(signal),
            0,
            reason:
                '${signal.name} watcher should be cancelled by the shutdown',
          );
        }
      },
    );
  });

  group('Given a Serverpod that is started and shut down repeatedly', () {
    setUp(() async {
      for (var i = 0; i < 3; i++) {
        await pod.start();
        await pod.shutdown(exitProcess: false);
      }
    });

    test(
      'when inspecting the watched process signals, '
      'then no watcher is left behind.',
      () {
        for (var signal in watchedSignals) {
          expect(
            signals.watcherCount(signal),
            0,
            reason: '${signal.name} watchers should not accumulate',
          );
        }
      },
    );

    test(
      'when inspecting the streams handed to the Serverpod, '
      'then each start took out a new watcher.',
      () {
        for (var signal in watchedSignals) {
          expect(
            signals.streamCount(signal),
            3,
            reason: '${signal.name} should be watched again by every start',
          );
        }
      },
    );
  });
}
