import 'dart:async';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/frontend_server_client.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

CompileResult _successResult() {
  return CompileResultInternal.create(
    dillOutput: '/out.dill',
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

  @override
  Future<CompileResult> compile({
    Set<String> changedPaths = const {},
    bool invalidatePackageConfig = false,
  }) async {
    calls.add('compile');
    return nextCompileResult;
  }

  @override
  Future<void> accept() async => calls.add('accept');

  @override
  Future<void> reject() async => calls.add('reject');

  @override
  Future<void> reset() async => calls.add('reset');

  @override
  Future<void> invalidateCachedDill() async => calls.add('invalidate');
}

class _FakeServer extends Fake implements ServerProcess {
  _FakeServer.running()
    : isRunning = true,
      vmServiceUri = 'http://127.0.0.1:1/';

  _FakeServer.crashed(int code) : isRunning = false, vmServiceUri = null {
    _exitCode.complete(code);
  }

  /// Exited non-zero, but after the VM service came up (an app-level crash).
  _FakeServer.crashedAfterVmService(int code)
    : isRunning = false,
      vmServiceUri = 'http://127.0.0.1:1/' {
    _exitCode.complete(code);
  }

  @override
  final bool isRunning;

  @override
  final String? vmServiceUri;

  final _exitCode = Completer<int>();

  @override
  Future<int> get exitCode => _exitCode.future;
}

void main() {
  setUpAll(() {
    initializeLoggerWith(VoidLogger());
  });

  tearDownAll(() async {
    await closeLogger();
  });

  late _FakeCompiler compiler;
  late List<_FakeServer> bootedServers;
  late List<_FakeServer> serverQueue;

  Future<ServerProcess> startServer(String? dillPath) async {
    final server = serverQueue.removeAt(0);
    bootedServers.add(server);
    return server;
  }

  setUp(() {
    compiler = _FakeCompiler();
    bootedServers = [];
    serverQueue = [];
  });

  test(
    'Given a healthy initial boot, '
    'when bootInitialServer runs, '
    'then it returns the server without touching the compiler',
    () async {
      serverQueue = [_FakeServer.running()];

      final server = await bootInitialServer(
        initialDill: '/tmp/server.dill',
        startServer: startServer,
        compiler: compiler,
      );

      expect(server, same(bootedServers.single));
      expect(compiler.calls, isEmpty);
    },
  );

  group('Given a server that dies before publishing its VM service URI', () {
    // 0xC0000409: a Windows-style abort code; the predicate must not
    // enumerate exit codes.
    const abortCode = 3221226505;

    setUp(() {
      serverQueue = [_FakeServer.crashed(abortCode)];
    });

    test(
      'when bootInitialServer runs, '
      'then it invalidates the cache, recompiles, and boots again',
      () async {
        serverQueue.add(_FakeServer.running());

        final server = await bootInitialServer(
          initialDill: '/tmp/server.dill',
          startServer: startServer,
          compiler: compiler,
        );

        expect(compiler.calls, ['invalidate', 'reset', 'compile', 'accept']);
        expect(bootedServers, hasLength(2));
        expect(server, same(bootedServers[1]));
      },
    );

    test(
      'when the recovery recompile fails, '
      'then it returns null and rejects the compile',
      () async {
        compiler.nextCompileResult = _failResult();

        final server = await bootInitialServer(
          initialDill: '/tmp/server.dill',
          startServer: startServer,
          compiler: compiler,
        );

        expect(server, isNull);
        expect(bootedServers, hasLength(1));
        expect(compiler.calls, ['invalidate', 'reset', 'compile', 'reject']);
      },
    );

    test(
      'when the retry boot also crashes, '
      'then the dead server is returned without a second retry',
      () async {
        serverQueue.add(_FakeServer.crashed(abortCode));

        final server = await bootInitialServer(
          initialDill: '/tmp/server.dill',
          startServer: startServer,
          compiler: compiler,
        );

        expect(bootedServers, hasLength(2));
        expect(server, same(bootedServers[1]));
      },
    );

    test(
      'when no compiler is available (non-watch mode), '
      'then the dead server is returned without a retry',
      () async {
        final server = await bootInitialServer(
          initialDill: null,
          startServer: startServer,
          compiler: null,
        );

        expect(server, same(bootedServers.single));
      },
    );
  });

  test(
    'Given a server that crashes after the VM service came up, '
    'when bootInitialServer runs, '
    'then the crash is not treated as a corrupt cache',
    () async {
      serverQueue = [_FakeServer.crashedAfterVmService(1)];

      final server = await bootInitialServer(
        initialDill: '/tmp/server.dill',
        startServer: startServer,
        compiler: compiler,
      );

      expect(server, same(bootedServers.single));
      expect(compiler.calls, isEmpty);
    },
  );
}
