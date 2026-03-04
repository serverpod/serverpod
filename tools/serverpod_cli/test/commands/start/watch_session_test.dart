import 'dart:async';

import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/frontend_server_client.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

CompileResult _successResult({String? dillOutput = '/out.dill'}) {
  return CompileResultInternal.create(
    dillOutput: dillOutput,
    compilerOutputLines: [],
    errorCount: 0,
    newSources: [],
  );
}

CompileResult _failResult() {
  return CompileResultInternal.create(
    dillOutput: null,
    compilerOutputLines: ['error: something failed'],
    errorCount: 1,
    newSources: [],
  );
}

class _FakeCompiler extends Fake implements KernelCompiler {
  final List<String> calls = [];
  CompileResult nextCompileResult = _successResult();
  CompileResult nextRecompileResult = _successResult();

  @override
  Future<CompileResult> compile() async {
    calls.add('compile');
    return nextCompileResult;
  }

  @override
  Future<CompileResult> recompile(Set<String> paths) async {
    calls.add('recompile:${paths.toList()..sort()}');
    return nextRecompileResult;
  }

  @override
  void accept() => calls.add('accept');

  @override
  Future<void> reject() async => calls.add('reject');

  @override
  void reset() => calls.add('reset');

  @override
  Future<void> restart() async => calls.add('restart');

  @override
  Future<void> dispose() async => calls.add('dispose');
}

class _FakeServer extends Fake implements ServerProcess {
  final List<String> calls = [];
  final Completer<int> _exitCodeCompleter = Completer<int>();

  bool _vmServiceConnected;
  bool reloadSuccess = true;

  _FakeServer({
    bool vmServiceConnected = true,
  }) : _vmServiceConnected = vmServiceConnected;

  @override
  bool get isVmServiceConnected => _vmServiceConnected;
  set isVmServiceConnected(bool value) => _vmServiceConnected = value;

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  /// Completes [exitCode] with the given code, simulating a crash.
  void simulateExit(int code) => _exitCodeCompleter.complete(code);

  @override
  Future<bool> reload(String dillPath) async {
    calls.add('reload:$dillPath');
    return reloadSuccess;
  }

  @override
  Future<int> stop({Duration timeout = const Duration(seconds: 5)}) async {
    calls.add('stop');
    if (!_exitCodeCompleter.isCompleted) {
      _exitCodeCompleter.complete(0);
    }
    return 0;
  }
}

void main() {
  setUpAll(() {
    initializeLogger();
  });

  tearDownAll(() {
    resetLogger();
  });

  group('Given a WatchSession', () {
    late _FakeCompiler compiler;
    late _FakeServer server;
    late _FakeServer factoryServer;
    late List<String> factoryCalls;
    late List<Set<String>> generateCalls;
    late bool generateSuccess;
    late WatchSession session;

    setUp(() {
      compiler = _FakeCompiler();
      server = _FakeServer();
      factoryServer = _FakeServer();
      factoryCalls = [];
      generateCalls = [];
      generateSuccess = true;

      session = WatchSession(
        compiler: compiler,
        generate: (affectedPaths) async {
          generateCalls.add(affectedPaths);
          return generateSuccess;
        },
        createServer: (dillPath) async {
          factoryCalls.add('createServer:$dillPath');
          return factoryServer;
        },
        initialServer: server,
        initialDill: '/initial.dill',
      );
    });

    group('Given static-only file changes', () {
      test(
        'when VM service is connected, '
        'then it reloads for browser refresh without compiling',
        () async {
          final event = FileChangeEvent(
            dartFiles: {},
            staticFilesChanged: true,
          );

          await session.handleFileChange(event);

          expect(server.calls, ['reload:/initial.dill']);
          expect(compiler.calls, isEmpty);
          expect(generateCalls, isEmpty);
        },
      );

      test(
        'when VM service is not connected, '
        'then it does nothing',
        () async {
          server.isVmServiceConnected = false;

          final event = FileChangeEvent(
            dartFiles: {},
            staticFilesChanged: true,
          );

          await session.handleFileChange(event);

          expect(server.calls, isEmpty);
          expect(compiler.calls, isEmpty);
          expect(generateCalls, isEmpty);
        },
      );
    });

    group('Given dart file changes', () {
      test(
        'when files compile successfully, '
        'then it runs codegen, does incremental recompile, and hot reload',
        () async {
          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/a.dart'},
          ]);
          expect(compiler.calls, [
            'recompile:[/lib/a.dart]',
            'accept',
          ]);
          expect(server.calls, ['reload:/out.dill']);
        },
      );

      test(
        'when codegen fails, '
        'then it does not compile or reload',
        () async {
          generateSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/a.dart'},
          ]);
          expect(compiler.calls, isEmpty);
          expect(server.calls, isEmpty);
        },
      );

      test(
        'when compilation fails, '
        'then it rejects and does not reload',
        () async {
          compiler.nextRecompileResult = _failResult();

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(compiler.calls, ['recompile:[/lib/a.dart]', 'reject']);
          expect(server.calls, isEmpty);
        },
      );

      test(
        'when hot reload fails, '
        'then it does a full recompile and restarts the server',
        () async {
          server.reloadSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(compiler.calls, [
            'recompile:[/lib/a.dart]',
            'accept',
            'reset',
            'compile',
            'accept',
          ]);
          expect(server.calls, ['reload:/out.dill', 'stop']);
          expect(factoryCalls, ['createServer:/out.dill']);
        },
      );
    });

    group('Given multiple dart file changes', () {
      test(
        'when codegen succeeds and compilation succeeds, '
        'then it passes all paths to codegen and recompiles',
        () async {
          final event = FileChangeEvent(
            dartFiles: {'/lib/endpoint.dart', '/lib/other.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/endpoint.dart', '/lib/other.dart'},
          ]);
          expect(compiler.calls, [
            'recompile:[/lib/endpoint.dart, /lib/other.dart]',
            'accept',
          ]);
          expect(server.calls, ['reload:/out.dill']);
        },
      );
    });

    group('Given model file changes', () {
      test(
        'when codegen succeeds, '
        'then it runs codegen but skips recompile '
        '(generated files will trigger a new cycle)',
        () async {
          final event = FileChangeEvent(
            dartFiles: {},
            modelFiles: {'/models/user.spy.yaml'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/models/user.spy.yaml'},
          ]);
          // No dart files changed or removed - skip recompile.
          // The generated .dart files will be picked up by the file watcher.
          expect(compiler.calls, isEmpty);
          expect(server.calls, isEmpty);
        },
      );

      test(
        'when codegen fails, '
        'then it does not compile or reload',
        () async {
          generateSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {},
            modelFiles: {'/models/user.spy.yaml'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/models/user.spy.yaml'},
          ]);
          expect(compiler.calls, isEmpty);
          expect(server.calls, isEmpty);
        },
      );
    });

    group('Given removed dart file changes', () {
      test(
        'then it runs codegen and recompiles with the removed paths',
        () async {
          final event = FileChangeEvent(
            dartFiles: {'/lib/removed.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/removed.dart'},
          ]);
          expect(compiler.calls, [
            'recompile:[/lib/removed.dart]',
            'accept',
          ]);
          expect(server.calls, ['reload:/out.dill']);
        },
      );
    });

    group('Given package_config.json changed', () {
      test(
        'then it runs codegen, restarts compiler, and does a full compile',
        () async {
          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
            packageConfigChanged: true,
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/a.dart'},
          ]);
          expect(compiler.calls, ['restart', 'compile', 'accept']);
        },
      );

      test(
        'when both package_config and model files changed, '
        'then it runs codegen and restarts compiler',
        () async {
          final event = FileChangeEvent(
            dartFiles: {},
            modelFiles: {'/models/user.spy.yaml'},
            packageConfigChanged: true,
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/models/user.spy.yaml'},
          ]);
          expect(compiler.calls, ['restart', 'compile', 'accept']);
        },
      );
    });

    group('Given hot reload fails', () {
      test(
        'then it does a full recompile, stops the old server, '
        'and creates a new server via factory',
        () async {
          server.reloadSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/a.dart'},
          ]);
          expect(compiler.calls, [
            'recompile:[/lib/a.dart]',
            'accept',
            'reset',
            'compile',
            'accept',
          ]);
          expect(server.calls, ['reload:/out.dill', 'stop']);
          expect(factoryCalls, ['createServer:/out.dill']);
        },
      );

      test(
        'when the full recompile for restart fails, '
        'then it rejects and does not restart the server',
        () async {
          server.reloadSuccess = false;
          compiler.nextCompileResult = _failResult();

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(compiler.calls, [
            'recompile:[/lib/a.dart]',
            'accept',
            'reset',
            'compile',
            'reject',
          ]);
          expect(server.calls, ['reload:/out.dill']);
          expect(factoryCalls, isEmpty);
        },
      );

      test(
        'then the new server is used for subsequent calls',
        () async {
          server.reloadSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          // First call: hot reload fails, triggers full recompile + restart.
          await session.handleFileChange(event);
          expect(factoryCalls, hasLength(1));

          // Second call: should use factoryServer, not the old server.
          server.calls.clear();
          factoryServer.calls.clear();
          compiler.calls.clear();
          generateCalls.clear();

          final event2 = FileChangeEvent(
            dartFiles: {'/lib/b.dart'},
          );

          await session.handleFileChange(event2);

          // Old server should have no new calls.
          expect(server.calls, isEmpty);
          // New server should receive the reload.
          expect(factoryServer.calls, ['reload:/out.dill']);
        },
      );
    });

    group('Given VM service is not connected', () {
      test(
        'when dart files change and compile succeeds, '
        'then it does a full recompile and restarts',
        () async {
          server.isVmServiceConnected = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          await session.handleFileChange(event);

          expect(generateCalls, [
            {'/lib/a.dart'},
          ]);
          expect(compiler.calls, [
            'recompile:[/lib/a.dart]',
            'accept',
            'reset',
            'compile',
            'accept',
          ]);
          // No reload attempt, straight to restart.
          expect(server.calls, ['stop']);
          expect(factoryCalls, ['createServer:/out.dill']);
        },
      );
    });

    group('Given the server exits unexpectedly', () {
      test(
        'then done completes with the exit code',
        () async {
          server.simulateExit(1);

          await expectLater(session.done, completion(1));
        },
      );

      test(
        'when a restart replaces the server and the new server crashes, '
        'then done completes with the new server exit code',
        () async {
          server.reloadSuccess = false;

          final event = FileChangeEvent(
            dartFiles: {'/lib/a.dart'},
          );

          // Restart: stop() completes server.exitCode internally.
          await session.handleFileChange(event);

          // The initial server was stopped intentionally - done should
          // not have completed.
          var doneCompleted = false;
          unawaited(session.done.then((_) => doneCompleted = true));
          await Future<void>.delayed(Duration.zero);
          expect(doneCompleted, isFalse);

          // New server crashes.
          factoryServer.simulateExit(42);

          await expectLater(session.done, completion(42));
        },
      );
    });

    group('Given dispose is called', () {
      test(
        'then it stops the server and disposes the compiler',
        () async {
          await session.dispose();

          expect(server.calls, ['stop']);
          expect(compiler.calls, ['dispose']);
        },
      );

      test(
        'then done does not complete from server exit',
        () async {
          // dispose() calls stop(), which completes initialExitCode.
          await session.dispose();

          var doneCompleted = false;
          unawaited(session.done.then((_) => doneCompleted = true));
          await Future<void>.delayed(Duration.zero);

          expect(doneCompleted, isFalse);
        },
      );
    });
  });

  group('Given mergeEvents', () {
    test(
      'when single event, '
      'then returns it unchanged',
      () {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m.spy.yaml'},
          packageConfigChanged: true,
        );

        final result = mergeEvents([event]);

        expect(identical(result, event), isTrue);
      },
    );

    test(
      'when multiple events, '
      'then merges all fields',
      () {
        final e1 = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
          modelFiles: {'/models/m1.spy.yaml'},
        );
        final e2 = FileChangeEvent(
          dartFiles: {'/lib/b.dart', '/lib/c.dart'},
          staticFilesChanged: true,
        );

        final result = mergeEvents([e1, e2]);

        expect(result.dartFiles, {'/lib/a.dart', '/lib/b.dart', '/lib/c.dart'});
        expect(result.modelFiles, {'/models/m1.spy.yaml'});
        expect(result.staticFilesChanged, isTrue);
      },
    );

    test(
      'when multiple events have the same file, '
      'then it appears only once',
      () {
        final e1 = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );
        final e2 = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        final result = mergeEvents([e1, e2]);

        expect(result.dartFiles, {'/lib/a.dart'});
      },
    );

    test(
      'when multiple events have packageConfigChanged, '
      'then result has packageConfigChanged true',
      () {
        final e1 = FileChangeEvent(dartFiles: {});
        final e2 = FileChangeEvent(
          dartFiles: {},
          packageConfigChanged: true,
        );

        final result = mergeEvents([e1, e2]);

        expect(result.packageConfigChanged, isTrue);
      },
    );
  });
}
