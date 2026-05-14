/// Wraps an arbitrary command with an embedded PostgreSQL postmaster.
///
/// Boots PG, runs the command (typically `dart test`) as a subprocess,
/// stops PG when the subprocess exits or this script is signalled. The
/// child inherits stdio, so test reporters work normally and Ctrl+C
/// propagates cleanly.
///
/// Designed for test runners that need a real PG but don't want Docker.
/// Single VM startup per invocation - much faster than separate
/// `embedded-pg start` / `embedded-pg stop` CLI invocations, which
/// each pay the serverpod_cli build-hook + kernel-compile cost
/// (~25s on cold cache).
///
/// Usage:
///
///   dart run serverpod_embedded_postgres:wrap \
///       --module-dir=path/to/server \
///       --tcp --port=5432 --db-name=mydb --password=secret \
///       -- dart test -t integration
///
/// Anything after `--` is passed to the wrapped command verbatim.
library;

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

Future<void> main(List<String> args) async {
  var parser = ArgParser()
    ..addOption(
      'module-dir',
      help:
          'Working directory for the wrapped command. PGDATA is placed '
          'under <module-dir>/.serverpod/pgdata.',
      mandatory: true,
    )
    ..addOption(
      'db-name',
      help: 'Database to create on first start.',
      mandatory: true,
    )
    ..addFlag(
      'tcp',
      help:
          'Listen on TCP loopback (scram-sha-256). Required when --port '
          'or --password is set.',
      defaultsTo: false,
      negatable: false,
    )
    ..addOption(
      'port',
      help: 'TCP port (--tcp only). Omit for ephemeral.',
    )
    ..addOption(
      'password',
      help: 'TCP password (--tcp only). Omit to auto-generate.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help text.',
      negatable: false,
    );

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(parser.usage);
    exit(64);
  }

  if (parsed['help'] as bool) {
    stdout.writeln('Wrap a command with an embedded PostgreSQL postmaster.');
    stdout.writeln('Anything after `--` is passed to the wrapped command.');
    stdout.writeln(parser.usage);
    return;
  }

  var moduleDir = parsed['module-dir'] as String;
  var dbName = parsed['db-name'] as String;
  var useTcp = parsed['tcp'] as bool;
  var port = parsed['port'] as String?;
  var password = parsed['password'] as String?;
  var rest = parsed.rest;

  if (rest.isEmpty) {
    stderr.writeln('No wrapped command supplied. Pass it after `--`.');
    exit(64);
  }
  if (!useTcp && (port != null || password != null)) {
    stderr.writeln('--port / --password require --tcp.');
    exit(64);
  }

  Transport transport;
  if (useTcp) {
    transport = TcpTransport(
      port: port == null ? 0 : int.parse(port),
      password: password,
    );
  } else {
    transport = const UnixTransport();
  }

  var dataDir = Directory(
    p.absolute(p.join(moduleDir, '.serverpod', 'pgdata')),
  );

  stdout.writeln('Starting embedded PG (data: ${dataDir.path})...');
  var sw = Stopwatch()..start();
  var pg = await EmbeddedPostgres.start(
    EmbeddedPostgresOptions(
      dataDir: dataDir,
      databaseName: dbName,
      transport: transport,
    ),
  );
  sw.stop();
  stdout.writeln('Ready in ${sw.elapsedMilliseconds}ms (pid=${pg.pid}).');
  stdout.writeln('Connection string: ${pg.connectionString}');

  // Embedded PG may bind a different port than the one in the runMode.yaml
  // after an port allocation retry on the requested port. Instead of failing,
  // we override the address and port for Serverpod to pick up when connecting
  // to the database.
  Map<String, String>? childEnvironment;
  if (useTcp) {
    var uri = pg.connectionUri;
    var host = uri.host.isNotEmpty ? uri.host : '127.0.0.1';
    childEnvironment = Map<String, String>.from(Platform.environment)
      ..['SERVERPOD_DATABASE_HOST'] = host
      ..['SERVERPOD_DATABASE_PORT'] = '${uri.port}';
  }

  // Run the wrapped command. inheritStdio makes test reporters and
  // Ctrl+C work as expected.
  var commandExitCode = 1;
  try {
    var process = await Process.start(
      rest.first,
      rest.skip(1).toList(),
      workingDirectory: p.absolute(moduleDir),
      environment: childEnvironment,
      mode: ProcessStartMode.inheritStdio,
    );
    commandExitCode = await process.exitCode;
    // dart test exit 79 means "no tests matched the filters" - non-error.
    if (commandExitCode == 79) commandExitCode = 0;
  } finally {
    stdout.writeln('Stopping embedded PG...');
    await pg.stop();
    stdout.writeln('Stopped.');
  }

  exit(commandExitCode);
}
