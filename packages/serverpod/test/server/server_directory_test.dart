import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

/// Regression coverage for the cwd-independence guarantee:
/// when `serverDirectory:` is passed explicitly, [Serverpod] loads
/// `config/<runMode>.yaml` and `config/passwords.yaml` from there
/// regardless of where [Directory.current] points.
void main() {
  group('Given a server package laid out under a temp dir', () {
    late Directory tempServerDir;
    late Directory cwdSentinel;
    late Directory originalCwd;

    setUp(() async {
      originalCwd = Directory.current;
      tempServerDir = await Directory.systemTemp.createTemp('sd_');
      cwdSentinel = await Directory.systemTemp.createTemp('sd_cwd_');

      final configDir = Directory(p.join(tempServerDir.path, 'config'))
        ..createSync(recursive: true);
      File(p.join(configDir.path, 'development.yaml')).writeAsStringSync('''
apiServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http
webServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http
''');
      File(p.join(configDir.path, 'passwords.yaml')).writeAsStringSync(
        'development: {}\n',
      );

      // Point cwd somewhere that contains no `config/` so anything that
      // still reads cwd-relative paths fails loudly (test would either
      // fall back to defaults or throw on missing file).
      Directory.current = cwdSentinel;
    });

    tearDown(() async {
      Directory.current = originalCwd;
      try {
        tempServerDir.deleteSync(recursive: true);
      } on FileSystemException {
        // Best effort.
      }
      try {
        cwdSentinel.deleteSync(recursive: true);
      } on FileSystemException {
        // Best effort.
      }
    });

    test(
      'when Serverpod is constructed with serverDirectory pointing at the '
      'temp dir, then it loads config from there even though cwd is unrelated',
      () async {
        final pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          serverDirectory: tempServerDir,
        );
        addTearDown(() => pod.shutdown(exitProcess: false));

        // If config had been loaded cwd-relative, ServerpodConfig.load would
        // not find development.yaml and the api server would default to port
        // 8080 (the hardcoded default). Our file pins it to 0.
        expect(pod.config.apiServer.port, equals(0));
        expect(pod.serverDirectory.path, equals(tempServerDir.path));
      },
    );
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
