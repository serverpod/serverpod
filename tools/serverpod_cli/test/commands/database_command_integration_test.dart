@Tags(['integration'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

import '../test_util/endpoint_validation_helpers.dart';
import '../test_util/file_system_entity_helpers.dart';

/// A loopback port that was free when checked.
Future<int> freeLoopbackPort() async {
  var socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  var port = socket.port;
  await socket.close();
  return port;
}

/// A server project with an embedded database in a fresh temp directory,
/// deleted after the test or group that wrote it. [databasePassword] lands in
/// `passwords.yaml` verbatim, so `''` means no password.
Directory writeServerProject({
  required String databasePassword,
  required int databasePort,
}) {
  var serverDirectory = Directory.systemTemp.createTempSync('sp_db_start_');
  addTearDown(() => serverDirectory.deleteWithRetry(recursive: true));
  File(p.join(serverDirectory.path, 'pubspec.yaml')).writeAsStringSync('''
name: database_start_test_server
environment:
  sdk: ^3.8.0
dependencies:
  serverpod: any
''');
  var configDirectory = Directory(p.join(serverDirectory.path, 'config'))
    ..createSync();
  File(p.join(configDirectory.path, 'development.yaml')).writeAsStringSync('''
database:
  host: localhost
  port: $databasePort
  name: serverpod_test
  user: postgres
  dataPath: .serverpod/pgdata
''');
  File(p.join(configDirectory.path, 'passwords.yaml')).writeAsStringSync('''
development:
  database: '$databasePassword'
''');
  return serverDirectory;
}

/// Starts the embedded database of the project in [serverDirectory] with
/// [transport], detached as another process would, stopped after the test.
Future<void> startDetachedDatabase(
  Directory serverDirectory,
  Transport transport,
) async {
  var postgres = await EmbeddedPostgres.start(
    EmbeddedPostgresOptions(
      dataDir: Directory(p.join(serverDirectory.path, '.serverpod', 'pgdata')),
      databaseName: 'serverpod_test',
      transport: transport,
      detach: true,
    ),
  );
  addTearDown(postgres.stop);
}

/// Arguments for `dart run` of `serverpod database start` against
/// [serverDirectory], with `--port` when [port] is given.
Future<List<String>> databaseStartArguments(
  Directory serverDirectory, {
  int? port,
}) async => [
  'run',
  await resolveServerpodCliEntrypoint(),
  '--no-analytics',
  '--no-interactive',
  'database',
  'start',
  '--server-dir',
  serverDirectory.path,
  if (port != null) ...['--port', '$port'],
];

/// Runs `serverpod database start` to completion.
Future<ProcessResult> runDatabaseStart(
  Directory serverDirectory, {
  int? port,
}) async => Process.run(
  Platform.resolvedExecutable,
  await databaseStartArguments(serverDirectory, port: port),
);

/// Starts `serverpod database start` against [serverDirectory] and returns
/// everything it printed up to its final "how to stop" line. The command is
/// interrupted after the test or group that started it.
Future<String> startDatabase(Directory serverDirectory) async {
  var output = StringBuffer();
  var ready = Completer<void>();
  var process = await Process.start(
    Platform.resolvedExecutable,
    await databaseStartArguments(serverDirectory),
  );
  var subscriptions = [
    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          output.writeln(line);
          var isLastLine =
              line.contains('to stop.') || line.contains('stops the database.');
          if (isLastLine && !ready.isCompleted) ready.complete();
        }),
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(output.writeln),
  ];
  addTearDown(() => _interrupt(process, subscriptions));
  unawaited(
    process.exitCode.then((exitCode) {
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
    onTimeout: () =>
        throw TestFailure('The database did not become ready.\n$output'),
  );
  return output.toString();
}

/// Interrupts [process] and waits for it to exit.
Future<void> _interrupt(
  Process process,
  List<StreamSubscription<String>> subscriptions,
) async {
  process.kill(
    Platform.isWindows ? ProcessSignal.sigterm : ProcessSignal.sigint,
  );
  try {
    await process.exitCode.timeout(const Duration(seconds: 15));
  } on TimeoutException {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
  }
  for (var subscription in subscriptions) {
    await subscription.cancel();
  }
}

/// [output] with the logger's line wrapping undone.
String unwrapped(String output) =>
    const LineSplitter().convert(output).join(' ');

void main() {
  group(
    'Given a Serverpod project with a database password in passwords.yaml, '
    'when serverpod database start runs without mode or port overrides,',
    () {
      const databasePassword = 'passwords-yaml-database-password';
      late int databasePort;
      late String output;

      setUpAll(() async {
        databasePort = await freeLoopbackPort();
        output = await startDatabase(
          writeServerProject(
            databasePassword: databasePassword,
            databasePort: databasePort,
          ),
        );
      });

      test(
        'then it prints a TCP URI with that password and the configured port',
        () {
          expect(
            unwrapped(output),
            contains(
              'TCP URI: postgres://postgres:$databasePassword@'
              '127.0.0.1:$databasePort/serverpod_test',
            ),
          );
        },
      );

      test(
        'then the database accepts the password from passwords.yaml over TCP',
        () async {
          var connection = await pg.Connection.open(
            pg.Endpoint(
              host: 'localhost',
              port: databasePort,
              database: 'serverpod_test',
              username: 'postgres',
              password: databasePassword,
            ),
            settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
          );
          addTearDown(connection.close);

          var result = await connection.execute('SELECT 1');
          expect(result.first.first, 1);
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  group(
    'Given a Serverpod project without a database password in passwords.yaml, '
    'when serverpod database start runs,',
    () {
      late String output;

      setUpAll(() async {
        output = await startDatabase(
          writeServerProject(
            databasePassword: '',
            databasePort: await freeLoopbackPort(),
          ),
        );
      });

      test('then it prints the Unix socket URI', () {
        expect(
          unwrapped(output),
          contains('Unix socket URI: postgres:///serverpod_test?host='),
        );
      });

      test(
        'then it explains that TCP is off instead of printing a TCP URI',
        () {
          expect(output, isNot(contains('TCP URI:')));
          expect(
            unwrapped(output),
            contains(
              'TCP is off because no database password is configured. Set '
              '`database` for this run mode in config/passwords.yaml to also '
              'listen on the configured port.',
            ),
          );
        },
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a project with a database password and a socket-only database, '
    'when serverpod database start joins it, '
    'then it says the process that started the database did not enable TCP',
    () async {
      var serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: await freeLoopbackPort(),
      );
      await startDetachedDatabase(serverDirectory, const UnixTransport());

      var output = await startDatabase(serverDirectory);

      expect(output, isNot(contains('TCP URI:')));
      expect(
        unwrapped(output),
        contains(
          'TCP is off because the process that started the database did not '
          'enable it. Restart that process to also listen on the configured '
          'port.',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a database started with one password and a passwords.yaml with '
    'another, '
    'when serverpod database start joins it, '
    'then it warns that the configured password is refused over TCP',
    () async {
      var databasePort = await freeLoopbackPort();
      var serverDirectory = writeServerProject(
        databasePassword: 'rotated-password',
        databasePort: databasePort,
      );
      await startDetachedDatabase(
        serverDirectory,
        DualTransport(port: databasePort, password: 'launch-password'),
      );

      var output = await startDatabase(serverDirectory);

      expect(output, isNot(contains('TCP URI:')));
      expect(
        unwrapped(output),
        contains(
          'The embedded database listens on TCP port $databasePort, but the '
          'process that started it set a different password than the one in '
          'config/passwords.yaml, so that password is refused. Restart that '
          'process to apply the current password, or use the Unix socket URI.',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given serverpod database start running with a database password, '
    'when a second serverpod database start passes another --port, '
    'then it exits with an error naming the running port',
    () async {
      var databasePort = await freeLoopbackPort();
      var serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: databasePort,
      );
      await startDatabase(serverDirectory);
      var otherPort = await freeLoopbackPort();

      var second = await runDatabaseStart(serverDirectory, port: otherPort);

      expect(second.exitCode, isNot(0));
      expect(
        unwrapped('${second.stdout}\n${second.stderr}'),
        contains(
          'The embedded database is already running on port $databasePort, '
          'started by another process, so it cannot also listen on port '
          '$otherPort. Stop that process or drop --port.',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a project with a database password and a socket-only database, '
    'when serverpod database start passes --port, '
    'then it exits with an error saying the database runs without TCP',
    () async {
      var databasePort = await freeLoopbackPort();
      var serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: databasePort,
      );
      await startDetachedDatabase(serverDirectory, const UnixTransport());

      var result = await runDatabaseStart(serverDirectory, port: databasePort);

      expect(result.exitCode, isNot(0));
      expect(
        unwrapped('${result.stdout}\n${result.stderr}'),
        contains(
          'The embedded database is already running without TCP, started by '
          'another process, so it cannot also listen on port $databasePort. '
          'Stop that process or drop --port.',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a project whose database port another process holds, '
    'when serverpod database start passes that port with --port, '
    'then it exits with just the error naming the port',
    () async {
      var holder = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(holder.close);
      var serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: holder.port,
      );

      var result = await runDatabaseStart(serverDirectory, port: holder.port);

      expect(result.exitCode, isNot(0));
      var output = unwrapped('${result.stdout}\n${result.stderr}');
      expect(
        output,
        contains(
          'Port ${holder.port} is already in use, so the local database '
          'cannot accept TCP connections there. Stop the other service on '
          'that port (for example a Docker database from an earlier setup), '
          'change `database.port` in the relevant file in `config/`, or leave '
          'the database password in `config/passwords.yaml` empty '
          "(`database: ''`) to serve the local database over its Unix socket "
          'only.',
        ),
      );
      expect(output, isNot(contains('Yikes')));
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
