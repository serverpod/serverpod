import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/watch_loop.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/frontend_server_client.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
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

class _FakeCompiler extends Fake implements KernelCompiler {
  final List<String> calls = [];

  @override
  String get outputDill => '/tmp/fake.dill';

  @override
  Future<CompileResult> compile({Set<String> changedPaths = const {}}) async {
    return _successResult();
  }

  @override
  void accept() {}

  @override
  Future<void> reject() async {}

  @override
  Future<void> reset() async {}

  @override
  Future<void> restart() async {}

  @override
  Future<void> dispose() async => calls.add('dispose');
}

class _FakeServer extends Fake implements ServerProcess {
  final List<String> calls = [];
  final Completer<int> _exitCodeCompleter = Completer<int>();
  final Completer<void> _vmServiceReadyCompleter = Completer<void>();

  @override
  bool get isVmServiceConnected => false;

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  Future<void> get vmServiceReady => _vmServiceReadyCompleter.future;

  @override
  String? get vmServiceUri => null;

  @override
  Future<int> stop({Duration timeout = const Duration(seconds: 5)}) async {
    calls.add('stop');
    if (!_exitCodeCompleter.isCompleted) _exitCodeCompleter.complete(0);
    return 0;
  }
}

class _FakeProxy extends Fake implements VmServiceProxy {
  int closeCalls = 0;
  @override
  Future<void> close() async => closeCalls++;
}

class _FakeMcpSocket extends Fake implements McpSocketServer {
  int closeCalls = 0;
  @override
  Future<void> close() async => closeCalls++;
}

WatchSession _buildSession(_FakeCompiler compiler, _FakeServer server) {
  return WatchSession(
    compiler: compiler,
    generate: (_, _) async => (success: true, generatedFiles: const <String>{}),
    createServer: (_) async => server,
    initialServer: server,
    generatedDirPaths: const {},
    applyMigrationsAction: () async => const MigrationsApplied(),
  );
}

void main() {
  setUpAll(() {
    initializeLogger();
  });

  tearDownAll(() async {
    await closeLogger();
  });

  group('Given a ServerArgsRef', () {
    test(
      'when the value is mutated after a closure captured the ref, '
      'then the closure observes the new value',
      () {
        final ref = ServerArgsRef(['initial']);
        List<String> reader() => ref.value;

        expect(reader(), ['initial']);

        ref.value = ['mutated'];

        expect(reader(), ['mutated']);
      },
    );

    test(
      'when the same closure is invoked multiple times across mutations, '
      'then each invocation sees the current value',
      () {
        final ref = ServerArgsRef([]);
        final readings = <List<String>>[];
        void capture() => readings.add(List.of(ref.value));

        capture();
        ref.value = ['a'];
        capture();
        ref.value = ['a', 'b'];
        capture();

        expect(readings, [
          <String>[],
          ['a'],
          ['a', 'b'],
        ]);
      },
    );
  });

  group('Given a WatchLoopContext', () {
    late _FakeCompiler compiler;
    late _FakeServer server;
    late _FakeProxy proxy;
    late _FakeMcpSocket mcp;
    late int closeAnalyzersCalls;
    late int stopDockerCalls;
    late int stopFlutterProcessCalls;
    late int fileSubCancelCalls;
    late StreamSubscription<void> fileSub;
    late Directory tempDir;
    late String vmServiceInfoFile;

    setUp(() {
      compiler = _FakeCompiler();
      server = _FakeServer();
      proxy = _FakeProxy();
      mcp = _FakeMcpSocket();
      closeAnalyzersCalls = 0;
      stopDockerCalls = 0;
      stopFlutterProcessCalls = 0;
      fileSubCancelCalls = 0;

      // A real StreamSubscription whose cancel we count via a wrapper
      // controller; cancelling the inner sub increments the counter.
      final controller = StreamController<void>();
      fileSub = controller.stream.listen((_) {});
      controller.onCancel = () {
        fileSubCancelCalls++;
      };

      tempDir = Directory.systemTemp.createTempSync('watch_loop_test_');
      vmServiceInfoFile = p.join(tempDir.path, 'vm-service-info.json');
      File(vmServiceInfoFile).writeAsStringSync('{}');
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } on FileSystemException {
        // Already gone.
      }
    });

    WatchLoopContext build({
      bool startedDocker = false,
      bool startedFlutterProcess = false,
    }) {
      return WatchLoopContext(
        session: _buildSession(compiler, server),
        proxy: proxy,
        mcpSocket: mcp,
        fileChangeSub: fileSub,
        closeAnalyzers: () async {
          closeAnalyzersCalls++;
        },
        stopDocker: startedDocker
            ? () async {
                stopDockerCalls++;
              }
            : null,
        stopFlutterProcess: startedFlutterProcess
            ? () async {
                stopFlutterProcessCalls++;
              }
            : null,
        vmServiceInfoFile: vmServiceInfoFile,
      );
    }

    test(
      'when dispose is called once, '
      'then every member close is invoked',
      () async {
        final ctx = build(startedDocker: true, startedFlutterProcess: true);

        await ctx.dispose();

        expect(fileSubCancelCalls, 1);
        expect(mcp.closeCalls, 1);
        expect(closeAnalyzersCalls, 1);
        expect(server.calls, contains('stop'));
        expect(compiler.calls, contains('dispose'));
        expect(proxy.closeCalls, 1);
        expect(File(vmServiceInfoFile).existsSync(), isFalse);
        expect(stopDockerCalls, 1);
        expect(stopFlutterProcessCalls, 1);
        expect(ctx.isDisposed, isTrue);
      },
    );

    test(
      'when dispose is called twice, '
      'then the second call is a no-op',
      () async {
        final ctx = build(startedDocker: true, startedFlutterProcess: true);

        await ctx.dispose();
        await ctx.dispose();

        expect(fileSubCancelCalls, 1, reason: 'fileChangeSub.cancel');
        expect(mcp.closeCalls, 1, reason: 'mcpSocket.close');
        expect(closeAnalyzersCalls, 1, reason: 'closeAnalyzers');
        expect(
          server.calls.where((c) => c == 'stop').length,
          1,
          reason: 'server.stop',
        );
        expect(
          compiler.calls.where((c) => c == 'dispose').length,
          1,
          reason: 'compiler.dispose',
        );
        expect(proxy.closeCalls, 1, reason: 'proxy.close');
        expect(stopDockerCalls, 1, reason: 'stopDocker');
        expect(stopFlutterProcessCalls, 1, reason: 'stopFlutterProcess');
      },
    );

    test(
      'when stopDocker is null (Docker was not started), '
      'then dispose skips the Docker step',
      () async {
        final ctx = build(startedDocker: false);

        await ctx.dispose();

        expect(stopDockerCalls, 0);
        // Other steps still run.
        expect(closeAnalyzersCalls, 1);
        expect(server.calls, contains('stop'));
      },
    );

    test(
      'when stopFlutterProcess is null, '
      'then dispose skips the Flutter process step',
      () async {
        final ctx = build(startedFlutterProcess: false);

        await ctx.dispose();

        expect(stopFlutterProcessCalls, 0);
        // Other steps still run.
        expect(closeAnalyzersCalls, 1);
        expect(server.calls, contains('stop'));
      },
    );

    test(
      'when the vm-service-info file is already missing, '
      'then dispose succeeds without throwing',
      () async {
        File(vmServiceInfoFile).deleteSync();
        final ctx = build();

        await expectLater(ctx.dispose(), completes);
      },
    );

    test(
      'when proxy and mcpSocket and fileChangeSub are null, '
      'then dispose skips them and runs the rest',
      () async {
        final ctx = WatchLoopContext(
          session: _buildSession(compiler, server),
          proxy: null,
          mcpSocket: null,
          fileChangeSub: null,
          closeAnalyzers: () async {
            closeAnalyzersCalls++;
          },
          stopFlutterProcess: null,
          stopDocker: null,
          vmServiceInfoFile: vmServiceInfoFile,
        );

        await ctx.dispose();

        expect(closeAnalyzersCalls, 1);
        expect(server.calls, contains('stop'));
      },
    );
  });
}
