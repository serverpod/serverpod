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

/// A server project with an embedded database in a fresh temp directory.
/// [databasePassword] lands in `passwords.yaml` verbatim, so `''` means no
/// password.
Directory writeServerProject({
  required String databasePassword,
  required int databasePort,
}) {
  var serverDirectory = Directory.systemTemp.createTempSync(
    'sp_db_start_',
  );
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

/// `serverpod database start` running against a project, with everything it
/// printed up to its final "how to stop" line (which follows the ready line
/// and the connection URIs).
class DatabaseStartRun {
  final Process _process;
  final List<StreamSubscription<String>> _subscriptions;

  /// Everything the command printed before reporting how to stop it.
  final String output;

  DatabaseStartRun._(this._process, this._subscriptions, this.output);

  static Future<DatabaseStartRun> start(Directory serverDirectory) async {
    var output = StringBuffer();
    var ready = Completer<void>();
    var process = await Process.start(Platform.resolvedExecutable, [
      'run',
      await resolveServerpodCliEntrypoint(),
      '--no-analytics',
      '--no-interactive',
      'database',
      'start',
      '--server-dir',
      serverDirectory.path,
    ]);
    var subscriptions = [
      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            output.writeln(line);
            var isLastLine =
                line.contains('to stop.') ||
                line.contains('stops the database.');
            if (isLastLine && !ready.isCompleted) ready.complete();
          }),
      process.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(output.writeln),
    ];
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
    return DatabaseStartRun._(process, subscriptions, output.toString());
  }

  /// Interrupts the command and waits for it to exit.
  Future<void> dispose() async {
    _process.kill(
      Platform.isWindows ? ProcessSignal.sigterm : ProcessSignal.sigint,
    );
    try {
      await _process.exitCode.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      _process.kill(ProcessSignal.sigkill);
      await _process.exitCode;
    }
    for (var subscription in _subscriptions) {
      await subscription.cancel();
    }
  }
}

void main() {
  late int databasePort;
  Directory? serverDirectory;
  DatabaseStartRun? run;
  pg.Connection? connection;

  setUp(() async {
    var portReservation = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    databasePort = portReservation.port;
    await portReservation.close();
  });

  tearDown(() async {
    await connection?.close();
    connection = null;
    await run?.dispose();
    run = null;
    serverDirectory?.deleteSync(recursive: true);
    serverDirectory = null;
  });

  test(
    'Given a Serverpod project with a database password in passwords.yaml, '
    'when serverpod database start runs without mode or port overrides, '
    'then it prints a TCP URI with that password and the configured port',
    () async {
      const databasePassword = 'passwords-yaml-database-password';
      serverDirectory = writeServerProject(
        databasePassword: databasePassword,
        databasePort: databasePort,
      );

      run = await DatabaseStartRun.start(serverDirectory!);

      // The logger wraps long lines, so the label and URI are asserted
      // separately.
      expect(run!.output, contains('TCP URI:'));
      expect(
        run!.output,
        contains(
          'postgres://postgres:$databasePassword@'
          '127.0.0.1:$databasePort/serverpod_test',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a Serverpod project with a database password in passwords.yaml, '
    'when serverpod database start runs without mode or port overrides, '
    'then the database accepts the password from passwords.yaml over TCP',
    () async {
      const databasePassword = 'passwords-yaml-database-password';
      serverDirectory = writeServerProject(
        databasePassword: databasePassword,
        databasePort: databasePort,
      );

      run = await DatabaseStartRun.start(serverDirectory!);

      connection = await pg.Connection.open(
        pg.Endpoint(
          host: 'localhost',
          port: databasePort,
          database: 'serverpod_test',
          username: 'postgres',
          password: databasePassword,
        ),
        settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
      );
      var result = await connection!.execute('SELECT 1');
      expect(result.first.first, 1);
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a Serverpod project without a database password in passwords.yaml, '
    'when serverpod database start runs, '
    'then it prints the Unix socket URI',
    () async {
      serverDirectory = writeServerProject(
        databasePassword: '',
        databasePort: databasePort,
      );

      run = await DatabaseStartRun.start(serverDirectory!);

      expect(run!.output, contains('Unix socket URI:'));
      expect(run!.output, contains('postgres:///serverpod_test?host='));
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a Serverpod project without a database password in passwords.yaml, '
    'when serverpod database start runs, '
    'then it explains that TCP is off instead of printing a TCP URI',
    () async {
      serverDirectory = writeServerProject(
        databasePassword: '',
        databasePort: databasePort,
      );

      run = await DatabaseStartRun.start(serverDirectory!);

      expect(run!.output, isNot(contains('TCP URI:')));
      expect(
        run!.output,
        contains('TCP is off because no database password is configured.'),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given a project with a database password and a socket-only database, '
    'when serverpod database start joins it, '
    'then it says the process that started the database did not enable TCP',
    () async {
      serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: databasePort,
      );
      var socketOnly = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: Directory(
            p.join(serverDirectory!.path, '.serverpod', 'pgdata'),
          ),
          databaseName: 'serverpod_test',
          transport: const UnixTransport(),
          detach: true,
        ),
      );
      addTearDown(socketOnly.stop);

      run = await DatabaseStartRun.start(serverDirectory!);

      expect(run!.output, isNot(contains('TCP URI:')));
      // The logger wraps long lines, so only the opening of the message is
      // asserted.
      expect(
        run!.output,
        contains('TCP is off because the process that started the database'),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  test(
    'Given serverpod database start running with a database password, '
    'when a second serverpod database start passes another --port, '
    'then it exits with an error naming the running port',
    () async {
      serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: databasePort,
      );
      run = await DatabaseStartRun.start(serverDirectory!);
      var otherPortReservation = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      var otherPort = otherPortReservation.port;
      await otherPortReservation.close();

      var second = await Process.run(Platform.resolvedExecutable, [
        'run',
        await resolveServerpodCliEntrypoint(),
        '--no-analytics',
        '--no-interactive',
        'database',
        'start',
        '--server-dir',
        serverDirectory!.path,
        '--port',
        '$otherPort',
      ]);

      expect(second.exitCode, isNot(0));
      // The logger wraps long lines, so only the opening of the message is
      // asserted.
      expect(
        '${second.stdout}${second.stderr}',
        contains(
          'The embedded database is already running on port $databasePort,',
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
      serverDirectory = writeServerProject(
        databasePassword: 'passwords-yaml-database-password',
        databasePort: databasePort,
      );
      var socketOnly = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: Directory(
            p.join(serverDirectory!.path, '.serverpod', 'pgdata'),
          ),
          databaseName: 'serverpod_test',
          transport: const UnixTransport(),
          detach: true,
        ),
      );
      addTearDown(socketOnly.stop);

      var result = await Process.run(Platform.resolvedExecutable, [
        'run',
        await resolveServerpodCliEntrypoint(),
        '--no-analytics',
        '--no-interactive',
        'database',
        'start',
        '--server-dir',
        serverDirectory!.path,
        '--port',
        '$databasePort',
      ]);

      expect(result.exitCode, isNot(0));
      // The logger wraps long lines, so only the opening of the message is
      // asserted.
      expect(
        '${result.stdout}${result.stderr}',
        contains('The embedded database is already running without TCP,'),
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
