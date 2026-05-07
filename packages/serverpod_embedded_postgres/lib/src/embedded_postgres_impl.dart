import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'binary/binary_store.dart';
import 'binary/maven_url.dart';
import 'cluster/cluster_store.dart';
import 'embedded_postgres.dart';
import 'options.dart';
import 'supervisor/supervisor.dart';
import 'transport.dart';

/// PG's default port - matches `unix_socket_directories` entry name
/// (`.s.PGSQL.5432`) and is the default `port` setting.
const int _pgDefaultPort = 5432;

/// Concrete implementation backing [EmbeddedPostgres.start].
///
/// Orchestrates:
///   1. [BinaryStore.ensure] - download + verify + extract Zonky bundle.
///   2. [ClusterStore.ensureInitialized] - run initdb if PG_VERSION is missing.
///   3. [ClusterStore.requireMajorMatch] - fail loudly on cross-major.
///   4. [ClusterStore.reconcilePostgresConf] - write our managed block.
///   5. [Supervisor.start] - spawn, tail, register signal hooks, await ready.
///   6. First-run only: connect once and `CREATE DATABASE IF NOT EXISTS`
///      (idempotent on subsequent starts).
class EmbeddedPostgresImpl extends EmbeddedPostgres {
  final EmbeddedPostgresOptions _options;
  final Supervisor _supervisor;
  final Directory _runDir;
  final String? _resolvedPassword;

  EmbeddedPostgresImpl._({
    required EmbeddedPostgresOptions options,
    required Supervisor supervisor,
    required Directory runDir,
    String? resolvedPassword,
  }) : _options = options,
       _supervisor = supervisor,
       _runDir = runDir,
       _resolvedPassword = resolvedPassword;

  /// Backs [EmbeddedPostgres.start]. Public only so the abstract class can
  /// delegate; not part of the package's surface API.
  static Future<EmbeddedPostgres> start(
    EmbeddedPostgresOptions options,
  ) async {
    // Layout: <dataDir parent>/pgdata/, <dataDir parent>/run/. Caller
    // typically passes `<project>/.serverpod/pgdata` so the run dir is at
    // `<project>/.serverpod/run`.
    var pgDataDir = options.dataDir;
    var dataRoot = pgDataDir.parent;
    var runDir = Directory(p.join(dataRoot.path, 'run'));
    var pidFile = File(p.join(dataRoot.path, 'postgres.pid'));
    var logFile = File(p.join(dataRoot.path, 'postgres.log'));

    runDir.createSync(recursive: true);
    if (Platform.isLinux || Platform.isMacOS) {
      // 0700 on the socket dir keeps the trust auth honest - only the
      // owner can read the socket. PG enforces this anyway via
      // unix_socket_permissions, but creating the dir 0700 prevents a
      // race where a stale 0755 from a prior run leaks visibility.
      _chmod0700(runDir.path);
    }

    var binaryStore = BinaryStore(cacheRoot: options.binaryCache);
    var artifact = ZonkyArtifact.forCurrentPlatform(version: options.version);
    Directory installDir;
    try {
      installDir = await binaryStore.ensure(
        artifact,
        onProgress: options.onProgress,
      );
    } finally {
      binaryStore.close();
    }

    var cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);
    var hadCluster = cluster.isInitialized;

    if (hadCluster) {
      cluster.requireMajorMatch(options.version.major);
    } else {
      await cluster.ensureInitialized(username: options.username);
    }
    cluster.reconcilePostgresConf(transport: options.transport);

    var transport = options.transport;
    var resolvedPassword = switch (transport) {
      UnixTransport() => null,
      TcpTransport(:final password) => password ?? _generatePassword(),
    };

    var supervisor = await Supervisor.start(
      installDir: installDir,
      dataDir: pgDataDir,
      runDir: runDir,
      transport: transport,
      startTimeout: options.startTimeout,
      pidFile: pidFile,
      logFile: logFile,
      detach: options.detach,
    );

    // Database creation is idempotent: we check existence before issuing
    // CREATE DATABASE. The check itself only runs on first start (when
    // the cluster was uninitialized); subsequent starts skip the round
    // trip, since the database is preserved with the cluster.
    if (!hadCluster) {
      try {
        await _ensureDatabase(
          supervisor: supervisor,
          runDir: runDir,
          transport: transport,
          username: options.username,
          password: resolvedPassword,
          databaseName: options.databaseName,
        );
      } catch (_) {
        await supervisor.stop();
        rethrow;
      }
    }

    return EmbeddedPostgresImpl._(
      options: options,
      supervisor: supervisor,
      runDir: runDir,
      resolvedPassword: resolvedPassword,
    );
  }

  @override
  Version get version => _options.version;

  @override
  int? get pid => _supervisor.pid;

  @override
  bool get isRunning => _supervisor.isRunning;

  @override
  pg.Endpoint get endpoint {
    var transport = _options.transport;
    switch (transport) {
      case UnixTransport():
        var sockPath = p.join(
          _runDir.absolute.path,
          '.s.PGSQL.$_pgDefaultPort',
        );
        return pg.Endpoint(
          host: shortestPath(sockPath),
          isUnixSocket: true,
          database: _options.databaseName,
          username: _options.username,
        );
      case TcpTransport(:final port):
        return pg.Endpoint(
          host: '127.0.0.1',
          port: port == 0 ? _pgDefaultPort : port,
          database: _options.databaseName,
          username: _options.username,
          password: _resolvedPassword,
        );
    }
  }

  @override
  String get connectionString => connectionUri.toString();

  @override
  Uri get connectionUri {
    var transport = _options.transport;
    switch (transport) {
      case UnixTransport():
        var sockPath = p.join(
          _runDir.absolute.path,
          '.s.PGSQL.$_pgDefaultPort',
        );
        // libpq form: postgres:///<db>?host=<socket-file-or-dir>&user=<u>
        return Uri(
          scheme: 'postgres',
          path: '/${_options.databaseName}',
          queryParameters: {
            'host': shortestPath(sockPath),
            'user': _options.username,
          },
        );
      case TcpTransport(:final port):
        var pw = _resolvedPassword;
        return Uri(
          scheme: 'postgres',
          userInfo: pw == null ? _options.username : '${_options.username}:$pw',
          host: '127.0.0.1',
          port: port == 0 ? _pgDefaultPort : port,
          path: '/${_options.databaseName}',
        );
    }
  }

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) =>
      _supervisor.stop(timeout: timeout);

  @override
  Future<void> reset() async {
    await stop();

    var dataRoot = _options.dataDir.parent;
    var pgData = _options.dataDir;
    var runDir = Directory(p.join(dataRoot.path, 'run'));
    var pidFile = File(p.join(dataRoot.path, 'postgres.pid'));
    var logFile = File(p.join(dataRoot.path, 'postgres.log'));
    var rotatedLog = File('${logFile.path}.1');

    for (var entity in [pgData, runDir]) {
      if (entity.existsSync()) entity.deleteSync(recursive: true);
    }
    for (var f in [pidFile, logFile, rotatedLog]) {
      if (f.existsSync()) f.deleteSync();
    }
  }
}

/// Connects as superuser via the local socket / TCP and `CREATE DATABASE`s
/// [databaseName] if absent. Skipped on subsequent starts because we only
/// run this when the cluster was just initialized.
Future<void> _ensureDatabase({
  required Supervisor supervisor,
  required Directory runDir,
  required Transport transport,
  required String username,
  required String? password,
  required String databaseName,
}) async {
  var endpoint = switch (transport) {
    UnixTransport() => pg.Endpoint(
      host: shortestPath(
        p.join(runDir.absolute.path, '.s.PGSQL.$_pgDefaultPort'),
      ),
      isUnixSocket: true,
      database: 'postgres',
      username: username,
    ),
    TcpTransport(:final port) => pg.Endpoint(
      host: '127.0.0.1',
      port: port == 0 ? _pgDefaultPort : port,
      database: 'postgres',
      username: username,
      password: password,
    ),
  };

  var conn = await pg.Connection.open(
    endpoint,
    settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
  );
  try {
    var rows = await conn.execute(
      pg.Sql.named('SELECT 1 FROM pg_database WHERE datname = @name'),
      parameters: {'name': databaseName},
    );
    if (rows.isEmpty) {
      // CREATE DATABASE doesn't accept parameters; rely on the database
      // name being a SQL identifier (caller-validated).
      _validateDatabaseName(databaseName);
      await conn.execute('CREATE DATABASE "$databaseName"');
    }
  } finally {
    await conn.close();
  }
}

/// Defensive identifier check so a misspelled databaseName can't pass a
/// quoted-identifier injection (`"; DROP TABLE..."`) into `CREATE DATABASE`.
void _validateDatabaseName(String name) {
  if (name.isEmpty || name.length > 63) {
    throw ArgumentError.value(
      name,
      'databaseName',
      'must be 1-63 chars (PG identifier limit)',
    );
  }
  // PG identifiers: allow ASCII letters, digits, underscore, dollar sign.
  // First char must be a letter or underscore.
  var ok = RegExp(r'^[A-Za-z_][A-Za-z0-9_$]*$').hasMatch(name);
  if (!ok) {
    throw ArgumentError.value(
      name,
      'databaseName',
      'must match [A-Za-z_][A-Za-z0-9_\$]* (PG identifier rule)',
    );
  }
}

String _generatePassword() {
  var rand = Random.secure();
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(32, (_) => chars[rand.nextInt(chars.length)]).join();
}

void _chmod0700(String path) {
  // Cheap shell-out; FFI to chmod(2) is overkill for a one-shot dir-perm
  // tweak. Windows skips this entirely.
  Process.runSync('chmod', ['0700', path]);
}
