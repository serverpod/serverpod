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
  CompileResult nextIncrementalResult = _successResult();

  @override
  Future<CompileResult> compile({Set<String> changedPaths = const {}}) async {
    if (changedPaths.isEmpty) {
      calls.add('compile');
      return nextCompileResult;
    }
    calls.add('compile(changed):${changedPaths.toList()..sort()}');
    return nextIncrementalResult;
  }

  @override
  void accept() => calls.add('accept');

  @override
  Future<void> reject() async => calls.add('reject');

  @override
  Future<void> reset() async => calls.add('reset');

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
  Future<void> notifyStaticChange() async {
    calls.add('notifyStaticChange');
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
    );
  });

  group('Given static-only file changes and VM service connected', () {
    test(
      'when static files change, '
      'then it notifies static change without compiling',
      () async {
        final event = FileChangeEvent(
          dartFiles: {},
          staticFilesChanged: true,
        );

        await session.handleFileChange(event);

        expect(server.calls, ['notifyStaticChange']);
        expect(compiler.calls, isEmpty);
        expect(generateCalls, isEmpty);
      },
    );
  });

  group('Given static-only file changes and VM service not connected', () {
    setUp(() {
      server.isVmServiceConnected = false;
    });

    test(
      'when static files change, '
      'then it does nothing',
      () async {
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

  group('Given dart file changes that compile successfully', () {
    test(
      'when file change is handled, '
      'then it runs codegen, does incremental compile, and hot reload',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(generateCalls, [
          {'/lib/a.dart'},
        ]);
        expect(compiler.calls, [
          'compile(changed):[/lib/a.dart]',
          'accept',
        ]);
        expect(server.calls, ['reload:/out.dill']);
      },
    );
  });

  group('Given dart file changes where codegen fails', () {
    setUp(() {
      generateSuccess = false;
    });

    test(
      'when file change is handled, '
      'then it does not compile or reload',
      () async {
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
  });

  group('Given dart file changes where compilation fails', () {
    setUp(() {
      compiler.nextIncrementalResult = _failResult();
    });

    test(
      'when file change is handled, '
      'then it rejects and does not reload',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(compiler.calls, ['compile(changed):[/lib/a.dart]', 'reject']);
        expect(server.calls, isEmpty);
      },
    );
  });

  group('Given dart file changes where hot reload fails', () {
    setUp(() {
      server.reloadSuccess = false;
    });

    test(
      'when file change is handled, '
      'then it does a full compile and restarts the server',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(compiler.calls, [
          'compile(changed):[/lib/a.dart]',
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
      'then it passes all paths to codegen and compiles incrementally',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/endpoint.dart', '/lib/other.dart'},
        );

        await session.handleFileChange(event);

        expect(generateCalls, [
          {'/lib/endpoint.dart', '/lib/other.dart'},
        ]);
        expect(compiler.calls, [
          'compile(changed):[/lib/endpoint.dart, /lib/other.dart]',
          'accept',
        ]);
        expect(server.calls, ['reload:/out.dill']);
      },
    );
  });

  group('Given model file changes that succeed', () {
    test(
      'when file change is handled, '
      'then it runs codegen but skips compile '
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
        // No dart files changed or removed - skip compile.
        // The generated .dart files will be picked up by the file watcher.
        expect(compiler.calls, isEmpty);
        expect(server.calls, isEmpty);
      },
    );
  });

  group('Given model file changes where codegen fails', () {
    setUp(() {
      generateSuccess = false;
    });

    test(
      'when file change is handled, '
      'then it does not compile or reload',
      () async {
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

  group('Given package_config.json changed', () {
    test(
      'when dart files also changed, '
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
    setUp(() {
      server.reloadSuccess = false;
    });

    test(
      'when a dart file changes, '
      'then it does a full compile, stops the old server, '
      'and creates a new server via factory',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(generateCalls, [
          {'/lib/a.dart'},
        ]);
        expect(compiler.calls, [
          'compile(changed):[/lib/a.dart]',
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
      'when the full compile for restart fails, '
      'then it rejects and does not restart the server',
      () async {
        compiler.nextCompileResult = _failResult();

        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(compiler.calls, [
          'compile(changed):[/lib/a.dart]',
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
      'when a subsequent file change occurs, '
      'then the new server is used',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        // First call: hot reload fails, triggers full compile + restart.
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
    setUp(() {
      server.isVmServiceConnected = false;
    });

    test(
      'when dart files change and compile succeeds, '
      'then it does a full compile and restarts',
      () async {
        final event = FileChangeEvent(
          dartFiles: {'/lib/a.dart'},
        );

        await session.handleFileChange(event);

        expect(generateCalls, [
          {'/lib/a.dart'},
        ]);
        expect(compiler.calls, [
          'compile(changed):[/lib/a.dart]',
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
      'when the server crashes, '
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
      'when disposing, '
      'then it stops the server and disposes the compiler',
      () async {
        await session.dispose();

        expect(server.calls, ['stop']);
        expect(compiler.calls, ['dispose']);
      },
    );

    test(
      'when server exit completes from stop, '
      'then done does not complete',
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
}
