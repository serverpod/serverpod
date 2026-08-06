@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

void main() {
  group(
    'Given a Serverpod project configured with an embedded PostgreSQL password in passwords.yaml,',
    () {
      const databasePassword = 'passwords-yaml-database-password';
      late Directory serverDirectory;
      late int databasePort;
      Process? cliProcess;
      pg.Connection? connection;
      StreamSubscription<String>? stdoutSubscription;
      StreamSubscription<String>? stderrSubscription;

      setUp(() async {
        serverDirectory = Directory.systemTemp.createTempSync(
          'serverpod_cli_database_start_',
        );
        var portReservation = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        databasePort = portReservation.port;
        await portReservation.close();

        File(p.join(serverDirectory.path, 'pubspec.yaml')).writeAsStringSync('''
name: database_start_test_server
environment:
  sdk: ^3.8.0
dependencies:
  serverpod: any
''');
        var configDirectory = Directory(
          p.join(serverDirectory.path, 'config'),
        )..createSync();
        File(
          p.join(configDirectory.path, 'development.yaml'),
        ).writeAsStringSync('''
database:
  host: localhost
  port: $databasePort
  name: serverpod_test
  user: postgres
  dataPath: .serverpod/pgdata
''');
        File(p.join(configDirectory.path, 'passwords.yaml')).writeAsStringSync(
          '''
development:
  database: $databasePassword
''',
        );
      });

      tearDown(() async {
        await connection?.close();
        if (cliProcess case var process?) {
          process.kill(
            Platform.isWindows ? ProcessSignal.sigterm : ProcessSignal.sigint,
          );
          try {
            await process.exitCode.timeout(const Duration(seconds: 15));
          } on TimeoutException {
            process.kill(ProcessSignal.sigkill);
            await process.exitCode;
          }
        }
        await stdoutSubscription?.cancel();
        await stderrSubscription?.cancel();
        if (serverDirectory.existsSync()) {
          serverDirectory.deleteSync(recursive: true);
        }
      });

      test(
        'when serverpod database start runs without mode or port overrides, '
        'then the database accepts the password from passwords.yaml.',
        () async {
          var output = StringBuffer();
          var ready = Completer<void>();
          cliProcess = await Process.start(
            Platform.resolvedExecutable,
            [
              'run',
              p.join(Directory.current.path, 'bin', 'serverpod_cli.dart'),
              '--no-analytics',
              '--no-interactive',
              'database',
              'start',
              '--server-dir',
              serverDirectory.path,
            ],
            workingDirectory: Directory.current.path,
          );
          stdoutSubscription = cliProcess!.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .listen((line) {
                output.writeln(line);
                if (line.contains('Embedded PostgreSQL is ready.') &&
                    !ready.isCompleted) {
                  ready.complete();
                }
              });
          stderrSubscription = cliProcess!.stderr
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .listen(output.writeln);
          unawaited(
            cliProcess!.exitCode.then((exitCode) {
              if (!ready.isCompleted) {
                ready.completeError(
                  TestFailure(
                    'The command exited with code $exitCode before the '
                    'database became ready.\n$output',
                  ),
                );
              }
            }),
          );

          await ready.future.timeout(
            const Duration(seconds: 180),
            onTimeout: () => throw TestFailure(
              'The database did not become ready.\n$output',
            ),
          );

          connection = await pg.Connection.open(
            pg.Endpoint(
              host: 'localhost',
              port: databasePort,
              database: 'serverpod_test',
              username: 'postgres',
              password: databasePassword,
            ),
            settings: const pg.ConnectionSettings(
              sslMode: pg.SslMode.disable,
            ),
          );
          var result = await connection!.execute('SELECT 1');

          expect(result.first.first, 1);
        },
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
