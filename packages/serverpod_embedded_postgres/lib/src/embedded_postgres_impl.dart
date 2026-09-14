import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_shared/process_io.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'binary/binary_source.dart';
import 'binary/binary_store.dart';
import 'binary/bundle_builder.dart';
import 'binary/bundle_spec.dart';
import 'binary/executable.dart';
import 'binary/serverpod_bundle.dart';
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
import 'transport_listeners.dart';

/// Files this package keeps beside PGDATA, relative to the data root.
const _stateFileName = 'embedded_postgres_state.json';
const _pidFileName = 'postgres.pid';
const _logFileName = 'postgres.log';

/// Written by releases before 4.1; nothing reads it now.
const _legacyPasswordFileName = 'postgres.password';

pg.Endpoint _unixEndpointFor(
  Directory runDir,
  Transport transport, {
  required String database,
  required String username,
}) => pg.Endpoint(
  host: shortestPath(
    p.join(runDir.absolute.path, '.s.PGSQL.${transport.postmasterPort}'),
  ),
  isUnixSocket: true,
  database: database,
  username: username,
);

pg.Endpoint _tcpEndpointFor(
  Transport transport, {
  required String database,
  required String username,
}) => pg.Endpoint(
  host: '127.0.0.1',
  port: transport.tcpPort!,
  database: database,
  username: username,
  password: transport.password,
);

/// Concrete implementation backing [EmbeddedPostgres.start].
///
/// Orchestrates:
///   1. [BinaryStore.ensure] - download + verify + extract Serverpod bundle.
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

  /// The launched listeners: a concrete port, and the password when TCP is
  /// served.
  final Transport _resolvedTransport;

  EmbeddedPostgresImpl._({
    required EmbeddedPostgresOptions options,
    required SupervisedProcess supervisor,
    required Directory runDir,
    required Transport resolvedTransport,
  }) : _options = options,
       _supervisor = supervisor,
       _runDir = runDir,
       _resolvedTransport = resolvedTransport;

  /// Backs [EmbeddedPostgres.startOrAttach].
  static Future<EmbeddedStartResult> startOrAttach(
    EmbeddedPostgresOptions options,
  ) async {
    try {
      var handle = await start(options);
      return EmbeddedStartResult(handle: handle, launched: true);
    } on PostmasterLockBusyException catch (exc, stackTrace) {
      try {
        var attached = await attach(
          options.dataDir,
          password: options.transport.password,
        );
        return EmbeddedStartResult(handle: attached, launched: false);
      } on AttachException {
        // The postmaster vanished between start()'s lock check and attach().
        Error.throwWithStackTrace(exc, stackTrace);
      }
    }
  }

  /// Backs [EmbeddedPostgres.attach]. Public only so the abstract class
  /// can delegate.
  static Future<EmbeddedPostgres> attach(
    Directory dataDir, {
    String? password,
  }) async {
    var dataRoot = dataDir.parent;
    var runDir = Directory(p.join(dataRoot.path, 'run'));
    var stateFile = File(p.join(dataRoot.path, _stateFileName));

    var attached = AttachedSupervisor.tryAttach(
      pidFile: File(p.join(dataRoot.path, _pidFileName)),
      logFile: File(p.join(dataRoot.path, _logFileName)),
    );
    if (attached == null) {
      throw const AttachException(
        'No live postmaster found at the recorded pidfile. Either the '
        'previous start used detach: false (so the postmaster died with '
        'its parent), or the OS recycled the PID to a foreign process. '
        'Call EmbeddedPostgres.start to spawn a fresh postmaster.',
      );
    }

    var state = EmbeddedPostgresState.read(stateFile, tcpPassword: password);
    if (state == null) {
      throw const AttachException(
        'embedded_postgres_state.json missing or malformed. attach() '
        'cannot reconstruct the public-API surface without it.',
      );
    }

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

    ensureSecureDirectorySync(runDir.path);

    // Serialize launches for this data directory: one caller initializes the
    // cluster and starts the postmaster; the rest wait, then attach below.
    // A held lock is heartbeated so a slow cold launch (binary download +
    // initdb) is not mistaken for a leak; a dead holder is reclaimed by PID.
    final launchLock = await InterProcessLock.acquire(
      p.join(dataRoot.path, 'postgres.launch.lock'),
      staleWhen: const StaleLockPolicy.processLiveness(
        staleAfter: Duration(minutes: 2),
      ),
      timeout: const Duration(minutes: 60), // may require rebuild
      heartbeatInterval: const Duration(seconds: 30),
    );
    try {
      return await _startLocked(
        options: options,
        pgDataDir: pgDataDir,
        dataRoot: dataRoot,
        runDir: runDir,
      );
    } finally {
      await launchLock.release();
    }
  }

  static Future<EmbeddedPostgres> _startLocked({
    required EmbeddedPostgresOptions options,
    required Directory pgDataDir,
    required Directory dataRoot,
    required Directory runDir,
  }) async {
    var pidFile = File(p.join(dataRoot.path, _pidFileName));
    var logFile = File(p.join(dataRoot.path, _logFileName));
    _deleteIfExists(File(p.join(dataRoot.path, _legacyPasswordFileName)));

    var binaryStore = BinaryStore(cacheRoot: options.binaryCache);
    var artifact = ServerpodBundleArtifact.forCurrentPlatform(
      spec: bundleSpecFor(options.version),
    );
    Directory installDir;
    try {
      installDir = await binaryStore.ensure(
        artifact,
        onProgress: options.onProgress,
        source: resolveBinarySource(explicit: options.binarySource),
        builder: const BundleBuilder(),
      );
    } finally {
      binaryStore.close();
    }

    var cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);
    var hadCluster = cluster.isInitialized;

    var resolvedTransport = await _resolveTransport(options.transport);

    if (hadCluster) {
      cluster.requireMajorMatch(options.version.major);
    } else {
      await cluster.ensureInitialized(
        username: options.username,
        password: resolvedTransport.password,
      );
    }

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

    // postmaster.pid (above) is removed early in PG's shutdown, but the Unix
    // socket lock outlives it until the postmaster has fully exited. A previous
    // postmaster still finishing shutdown therefore reads as startable here yet
    // would crash the launch with "lock file ... already exists". Wait for that
    // holder to exit so the launch lands on a free socket. The socket lock uses
    // the same first-line-PID format, so readPostmasterPidFile parses it too.
    var socketLock = '.s.PGSQL.${resolvedTransport.postmasterPort}.lock';
    var socketLockPid = readPostmasterPidFile(
      File(p.join(runDir.path, socketLock)),
    );
    if (socketLockPid != null && isProcessAlive(socketLockPid)) {
      var exited = await waitForPidExit(socketLockPid, options.startTimeout);
      if (!exited) {
        throw PostmasterLockBusyException(
          '$socketLock in ${runDir.path} is still held by live PID '
          '$socketLockPid after ${options.startTimeout.inSeconds}s',
          existingPid: socketLockPid,
        );
      }
    }

    // Only now is no other postmaster running on this cluster, so rewriting
    // its conf can no longer change a live instance under its owner.
    cluster.reconcilePostgresConf(
      transport: resolvedTransport,
      maxConnections: options.maxConnections,
    );

    // A pinned port someone else holds is a configuration problem. Find out
    // before paying for a password rewrite and a postmaster crash.
    var pinnedPort = options.transport.tcpPort;
    if (pinnedPort != null && pinnedPort != 0) {
      await _requireFreePort(pinnedPort);
    }

    // Fresh clusters were seeded by initdb above. Existing ones get the
    // password this launch was configured with, so TCP auth follows the
    // caller's configuration rather than whatever initdb saw years ago.
    var password = resolvedTransport.password;
    if (hadCluster && password != null) {
      await cluster.setSuperuserPassword(
        username: options.username,
        password: password,
        timeout: options.startTimeout,
      );
    }

    var supervisor = await _startSupervisorWithPortRetry(
      installDir: installDir,
      dataDir: pgDataDir,
      runDir: runDir,
      transport: resolvedTransport,
      ephemeralPort: pinnedPort == 0,
      startTimeout: options.startTimeout,
      pidFile: pidFile,
      logFile: logFile,
      detach: options.detach,
      onResolveTransport: (newTransport) {
        resolvedTransport = newTransport;
        cluster.reconcilePostgresConf(
          transport: newTransport,
          maxConnections: options.maxConnections,
        );
      },
    );

    if (!hadCluster) {
      try {
        await _ensureDatabase(
          runDir: runDir,
          transport: resolvedTransport,
          username: options.username,
          databaseName: options.databaseName,
        );
      } catch (_) {
        await supervisor.stop();
        rethrow;
      }
    }

    EmbeddedPostgresState.writeAtomic(
      File(p.join(dataRoot.path, _stateFileName)),
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
    );
  }

  @override
  Version get version => _options.version;

  @override
  int? get pid => _supervisor.pid;

  @override
  bool get isRunning => _supervisor.isRunning;

  @override
  pg.Endpoint get endpoint =>
      _resolvedTransport.servesUnixSocket ? _unixEndpoint : tcpEndpoint!;

  @override
  pg.Endpoint? get tcpEndpoint => _resolvedTransport.tcpPort == null
      ? null
      : _tcpEndpointFor(
          _resolvedTransport,
          database: _options.databaseName,
          username: _options.username,
        );

  pg.Endpoint get _unixEndpoint => _unixEndpointFor(
    _runDir,
    _resolvedTransport,
    database: _options.databaseName,
    username: _options.username,
  );

  @override
  String get connectionString => connectionUri.toString();

  @override
  Uri get connectionUri => _resolvedTransport.servesUnixSocket
      ? _unixConnectionUri
      : tcpConnectionUri!;

  @override
  Uri? get tcpConnectionUri {
    var tcp = tcpEndpoint;
    if (tcp == null) return null;
    var pw = tcp.password;
    return Uri(
      scheme: 'postgres',
      userInfo: pw == null ? tcp.username : '${tcp.username}:$pw',
      host: tcp.host,
      port: tcp.port,
      path: '/${_options.databaseName}',
    );
  }

  // libpq form: postgres:///<db>?host=<socket-file-or-dir>&port=..&user=<u>
  // host: '' is required to get the three-slash empty-authority URI
  // (postgres:///db); otherwise the Uri ctor produces postgres:/db
  // which libpq rejects.
  Uri get _unixConnectionUri => Uri(
    scheme: 'postgres',
    host: '',
    path: '/${_options.databaseName}',
    queryParameters: {
      'host': _unixEndpoint.host,
      'port': '${_resolvedTransport.postmasterPort}',
      'user': _options.username,
    },
  );

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) =>
      _supervisor.stop(timeout: timeout);

  @override
  Future<void> reset() async {
    await stop();

    var dataRoot = _options.dataDir.parent;
    for (var dir in [
      _options.dataDir,
      Directory(p.join(dataRoot.path, 'run')),
    ]) {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    }
    for (var name in [
      _pidFileName,
      _logFileName,
      '$_logFileName.1',
      _stateFileName,
      _legacyPasswordFileName,
    ]) {
      _deleteIfExists(File(p.join(dataRoot.path, name)));
    }
  }
}

void _deleteIfExists(File file) {
  if (file.existsSync()) file.deleteSync();
}

/// Throws [PortInUseException] when [port] cannot be bound on loopback.
Future<void> _requireFreePort(int port) async {
  try {
    var probe = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    await probe.close();
  } on SocketException catch (e) {
    throw PortInUseException(
      'port $port on 127.0.0.1 is held by another process: ${e.message}',
      port: port,
    );
  }
}

/// Resolves the user-supplied [transport] into the concrete listeners to
/// launch: a kernel-assigned port for an ephemeral request, and a password
/// generated for this launch when none was given. Without a TCP listener
/// there is nothing to resolve.
Future<Transport> _resolveTransport(Transport requested) async {
  var tcpPort = requested.tcpPort;
  if (tcpPort == null) return requested;
  return requested.withTcp(
    port: tcpPort == 0 ? await _allocateEphemeralPort() : tcpPort,
    password: requested.password ?? generateRandomString(),
  );
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

/// Wraps [Supervisor.start] with a single port-race retry. When PG fails to
/// bind with EADDRINUSE (read from the captured log tail of the crashed
/// postmaster) and the port was [ephemeralPort], a new port is allocated and
/// the launch attempted once more. A pinned port that is busy throws
/// [PortInUseException]: that is the user's configuration to fix.
///
/// [onResolveTransport] is invoked when the transport changes so the
/// caller can re-reconcile postgresql.conf with the new value.
Future<Supervisor> _startSupervisorWithPortRetry({
  required Directory installDir,
  required Directory dataDir,
  required Directory runDir,
  required Transport transport,
  required bool ephemeralPort,
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
    var portRace =
        transport.tcpPort != null &&
        e.logTail.any(
          (line) =>
              line.contains('Address already in use') ||
              line.contains('could not bind'),
        );
    if (!portRace) rethrow;
    if (!ephemeralPort) {
      throw PortInUseException(
        'port ${transport.tcpPort} on 127.0.0.1 is held by another process; '
        'postgres log tail: ${e.logTail.join('\n')}',
        port: transport.tcpPort!,
      );
    }
    var retryWith = transport.withTcp(
      port: await _allocateEphemeralPort(),
      password: transport.password!,
    );
    onResolveTransport(retryWith);
    return attempt(retryWith);
  }
}

/// Connects as superuser via the local socket / TCP and `CREATE DATABASE`s
/// [databaseName] if absent. Skipped on subsequent starts because we only
/// run this when the cluster was just initialized.
Future<void> _ensureDatabase({
  required Directory runDir,
  required Transport transport,
  required String username,
  required String databaseName,
}) async {
  var conn = await _openMaintenanceConnection(
    runDir: runDir,
    transport: transport,
    username: username,
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

/// Opens a superuser connection to the `postgres` maintenance database,
/// over the socket when [transport] has one and over TCP otherwise.
Future<pg.Connection> _openMaintenanceConnection({
  required Directory runDir,
  required Transport transport,
  required String username,
}) {
  var endpoint = transport.servesUnixSocket
      ? _unixEndpointFor(
          runDir,
          transport,
          database: 'postgres',
          username: username,
        )
      : _tcpEndpointFor(transport, database: 'postgres', username: username);
  return pg.Connection.open(
    endpoint,
    settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
  );
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
