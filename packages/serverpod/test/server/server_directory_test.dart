import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

/// Regression coverage for the cwd-independence guarantee: when
/// `serverDirectory:` is passed explicitly, [Serverpod] loads
/// `config/<runMode>.yaml` and `config/passwords.yaml` from there
/// regardless of where [Directory.current] points.
void main() {
  group('Given a server package laid out under a temp dir', () {
    Directory? tempServerDir;
    Directory? cwdSentinel;
    late Directory originalCwd;

    setUp(() async {
      originalCwd = Directory.current;
      tempServerDir = await Directory.systemTemp.createTemp('sd_');
      cwdSentinel = await Directory.systemTemp.createTemp('sd_cwd_');

      final configDir = Directory(p.join(tempServerDir!.path, 'config'))
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

      Directory.current = cwdSentinel;
    });

    tearDown(() async {
      Directory.current = originalCwd;
      for (final d in [tempServerDir, cwdSentinel]) {
        try {
          d?.deleteSync(recursive: true);
        } on FileSystemException {
          // Best effort.
        }
      }
      tempServerDir = null;
      cwdSentinel = null;
    });

    test(
      'when Serverpod is constructed with serverDirectory pointing at the '
      'temp dir, then it loads config from there even though cwd is unrelated',
      () async {
        // Pin run mode so SERVERPOD_RUN_MODE in the environment can't
        // redirect the load to a config file that doesn't exist.
        final pod = Serverpod(
          ['--mode', 'development'],
          internal.Protocol(),
          _EmptyEndpoints(),
          serverDirectory: tempServerDir,
        );
        addTearDown(() => pod.shutdown(exitProcess: false));

        // Default would be 8080; our file pins it to 0.
        expect(pod.config.apiServer.port, equals(0));
        expect(pod.serverDirectory.path, equals(tempServerDir!.path));
      },
    );
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
