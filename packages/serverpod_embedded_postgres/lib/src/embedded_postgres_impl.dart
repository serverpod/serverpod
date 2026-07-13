import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_shared/process_io.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'binary/binary_store.dart';
import 'binary/executable.dart';
import 'binary/maven_url.dart';
import 'cluster/cluster_store.dart';
import 'embedded_postgres.dart';
import 'exceptions.dart';
import 'options.dart';
import 'state_file.dart';
import 'supervisor/attached_supervisor.dart';
import 'supervisor/process_identity.dart';
import 'supervisor/stale_lock_repair.dart';
import 'supervisor/supervised_process.dart';
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
  final SupervisedProcess _supervisor;
  final Directory _runDir;
  final Transport _resolvedTransport;
  final String? _resolvedPassword;

  EmbeddedPostgresImpl._({
    required EmbeddedPostgresOptions options,
    required SupervisedProcess supervisor,
    required Directory runDir,
    required Transport resolvedTransport,
    String? resolvedPassword,
  }) : _options = options,
       _supervisor = supervisor,
       _runDir = runDir,
       _resolvedTransport = resolvedTransport,
       _resolvedPassword = resolvedPassword;

  /// Backs [EmbeddedPostgres.attach]. Public only so the abstract class
  /// can delegate.
  static Future<EmbeddedPostgres> attach(Directory dataDir) async {
    var dataRoot = dataDir.parent;
    var runDir = Directory(p.join(dataRoot.path, 'run'));
    var pidFile = File(p.join(dataRoot.path, 'postgres.pid'));
    var logFile = File(p.join(dataRoot.path, 'postgres.log'));
    var pwFile = File(p.join(dataRoot.path, 'postgres.password'));
    var stateFile = File(
      p.join(dataRoot.path, 'embedded_postgres_state.json'),
    );

    var attached = AttachedSupervisor.tryAttach(
      pidFile: pidFile,
      logFile: logFile,
    );
    if (attached == null) {
      throw const AttachException(
        'No live postmaster found at the recorded pidfile. Either the '
        'previous start used detach: false (so the postmaster died with '
        'its parent), or the OS recycled the PID to a foreign process. '
        'Call EmbeddedPostgres.start to spawn a fresh postmaster.',
      );
    }

    var tcpPassword = pwFile.existsSync() ? pwFile.readAsStringSync() : null;
    var state = EmbeddedPostgresState.read(stateFile, tcpPassword: tcpPassword);
    if (state == null) {
      throw const AttachException(
        'embedded_postgres_state.json missing or malformed. attach() '
        'cannot reconstruct the public-API surface without it.',
      );
    }

    var resolvedPassword = switch (state.transport) {
      UnixTransport() => null,
      TcpTransport(:final password) => password,
    };

    return EmbeddedPostgresImpl._(
      options: EmbeddedPostgresOptions(
        dataDir: dataDir,
        databaseName: state.databaseName,
        username: state.username,
        transport: state.transport,
        version: state.version,
        detach: true,
      ),
      supervisor: attached,
      runDir: runDir,
      resolvedTransport: state.transport,
      resolvedPassword: resolvedPassword,
    );
  }

  /// Backs [EmbeddedPostgres.start]. Public only so the abstract class can
  /// delegate; not part of the package's surface API.
  static Future<EmbeddedPostgres> start(
    EmbeddedPostgresOptions options,
  ) async {
    // Validate up front so a bad name fails before we download ~30 MB of
    // binaries or initdb a cluster we can't use.
    _validateDatabaseName(options.databaseName);

    // Layout: <dataDir parent>/pgdata/, <dataDir parent>/run/. Caller
    // typically passes `<project>/.serverpod/pgdata` so the run dir is at
    // `<project>/.serverpod/run`.
    var pgDataDir = options.dataDir;
    var dataRoot = pgDataDir.parent;
    var runDir = Directory(p.join(dataRoot.path, 'run'));
    var pidFile = File(p.join(dataRoot.path, 'postgres.pid'));
    var logFile = File(p.join(dataRoot.path, 'postgres.log'));
    var pwFile = File(p.join(dataRoot.path, 'postgres.password'));

    ensureSecureDirectorySync(runDir.path);

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

    var (resolvedTransport, resolvedPassword) = await _resolveTransport(
      options.transport,
      pwFile: pwFile,
      hadCluster: hadCluster,
    );

    if (hadCluster) {
      cluster.requireMajorMatch(options.version.major);
    } else {
      await cluster.ensureInitialized(
        username: options.username,
        password: resolvedPassword,
      );
    }
    cluster.reconcilePostgresConf(transport: resolvedTransport);

    if (options.repairStaleLocks) {
      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgDataDir,
        serverpodPidFile: pidFile,
        pgCtlExecutable: File(binExecutable(installDir, 'pg_ctl')),
      );
    }

    // Avoid spawning a child that would crash with PG's localised
    // "lock file already exists" message.
    var existingPid = readPostmasterPidFile(
      File(p.join(pgDataDir.path, 'postmaster.pid')),
    );
    if (existingPid != null && isProcessAlive(existingPid)) {
      throw PostmasterLockBusyException(
        'postmaster.pid in ${pgDataDir.path} is held by live PID $existingPid',
        existingPid: existingPid,
      );
    }

    var supervisor = await _startSupervisorWithPortRetry(
      installDir: installDir,
      dataDir: pgDataDir,
      runDir: runDir,
      transport: resolvedTransport,
      startTimeout: options.startTimeout,
      pidFile: pidFile,
      logFile: logFile,
      detach: options.detach,
      onResolveTransport: (newTransport) {
        resolvedTransport = newTransport;
        cluster.reconcilePostgresConf(transport: newTransport);
      },
    );

    if (!hadCluster) {
      try {
        await _ensureDatabase(
          runDir: runDir,
          transport: resolvedTransport,
          username: options.username,
          password: resolvedPassword,
          databaseName: options.databaseName,
        );
      } catch (_) {
        await supervisor.stop();
        rethrow;
      }
    }

    EmbeddedPostgresState.writeAtomic(
      File(p.join(dataRoot.path, 'embedded_postgres_state.json')),
      EmbeddedPostgresState(
        version: options.version,
        username: options.username,
        databaseName: options.databaseName,
        transport: resolvedTransport,
      ),
    );

    return EmbeddedPostgresImpl._(
      options: options,
      supervisor: supervisor,
      runDir: runDir,
      resolvedTransport: resolvedTransport,
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
    switch (_resolvedTransport) {
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
          port: port,
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
    switch (_resolvedTransport) {
      case UnixTransport():
        var sockPath = p.join(
          _runDir.absolute.path,
          '.s.PGSQL.$_pgDefaultPort',
        );
        // libpq form: postgres:///<db>?host=<socket-file-or-dir>&user=<u>
        // host: '' is required to get the three-slash empty-authority URI
        // (postgres:///db); otherwise the Uri ctor produces postgres:/db
        // which libpq rejects.
        return Uri(
          scheme: 'postgres',
          host: '',
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
          port: port,
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

/// Resolves the user-supplied [transport] into a concrete one ready to
/// pass to ClusterStore + Supervisor:
///
///   - For fresh clusters, always generates and persists a superuser
///     password (written to [pwFile]) so a later switch to [TcpTransport]
///     works without re-init. Unix connections still use trust auth.
///   - For [TcpTransport] with `port == 0`, allocates an ephemeral port
///     by binding `127.0.0.1:0` and reading the kernel-assigned port.
///   - For warm TCP restarts, reads the persisted password sidecar so
///     the endpoint matches whatever `initdb --pwfile` seeded.
Future<(Transport, String?)> _resolveTransport(
  Transport requested, {
  required File pwFile,
  required bool hadCluster,
}) async {
  String? initPassword;
  if (!hadCluster) {
    initPassword = switch (requested) {
      TcpTransport(:final password) => password ?? _generatePassword(),
      UnixTransport() => _generatePassword(),
    };
    pwFile.parent.createSync(recursive: true);
    pwFile.writeAsStringSync(initPassword);
  }

  switch (requested) {
    case UnixTransport():
      // Password is passed to initdb on fresh clusters only; trust auth
      // does not use it for Unix connections.
      return (requested, initPassword);
    case TcpTransport(:final port, :final password):
      final String resolvedPw;
      if (hadCluster && pwFile.existsSync()) {
        // Warm restart: the cluster's stored hash matches whatever was
        // initdb'd. Trust the persisted password unless the caller
        // explicitly provides one (in which case we assume they know
        // they aligned both sides).
        resolvedPw = password ?? pwFile.readAsStringSync();
      } else if (hadCluster) {
        // Legacy cluster without a password sidecar. Out of scope to
        // backfill the role; generate a file for the endpoint only.
        resolvedPw = password ?? _generatePassword();
        pwFile.parent.createSync(recursive: true);
        pwFile.writeAsStringSync(resolvedPw);
      } else {
        resolvedPw = initPassword!;
      }

      var resolvedPort = port == 0 ? await _allocateEphemeralPort() : port;
      return (
        TcpTransport(port: resolvedPort, password: resolvedPw),
        resolvedPw,
      );
  }
}

Future<int> _allocateEphemeralPort() async {
  // Standard pre-bind dance: bind :0, read kernel-assigned port, close,
  // hand to PG. There's a small race where another process can grab the
  // port between close and PG binding; the retry loop in
  // [_startSupervisorWithPortRetry] handles that.
  var server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  try {
    return server.port;
  } finally {
    await server.close();
  }
}

/// Wraps [Supervisor.start] with a single port-race retry. If [transport] is
/// a TCP transport with an ephemerally-allocated port and PG fails to bind
/// with EADDRINUSE (we read this from the captured log tail of the crashed
/// postmaster), we re-allocate the port and try once more.
///
/// [onResolveTransport] is invoked when we re-allocate a port so the
/// caller can re-reconcile postgresql.conf with the new value.
Future<Supervisor> _startSupervisorWithPortRetry({
  required Directory installDir,
  required Directory dataDir,
  required Directory runDir,
  required Transport transport,
  required Duration startTimeout,
  required File pidFile,
  required File logFile,
  required bool detach,
  required void Function(Transport newTransport) onResolveTransport,
}) async {
  Future<Supervisor> attempt(Transport t) => Supervisor.start(
    installDir: installDir,
    dataDir: dataDir,
    runDir: runDir,
    transport: t,
    startTimeout: startTimeout,
    pidFile: pidFile,
    logFile: logFile,
    detach: detach,
  );

  try {
    return await attempt(transport);
  } on CrashedException catch (e) {
    var t = transport;
    if (t is! TcpTransport) rethrow;
    var portRace = e.logTail.any(
      (line) =>
          line.contains('Address already in use') ||
          line.contains('could not bind'),
    );
    if (!portRace) rethrow;
    var newPort = await _allocateEphemeralPort();
    var reallocated = TcpTransport(port: newPort, password: t.password);
    onResolveTransport(reallocated);
    return attempt(reallocated);
  }
}

/// Connects as superuser via the local socket / TCP and `CREATE DATABASE`s
/// [databaseName] if absent. Skipped on subsequent starts because we only
/// run this when the cluster was just initialized.
Future<void> _ensureDatabase({
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
      port: port,
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
