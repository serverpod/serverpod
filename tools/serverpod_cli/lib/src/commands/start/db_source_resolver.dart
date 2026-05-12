import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Result of [resolveDbSource]. Describes the concrete database source that
/// `serverpod start` should use for the current run plus optional side
/// effects.
class ResolvedDbSource {
  /// The concrete source. Never [DatabaseSource.auto] (which is resolved
  /// to one of the others by the resolver).
  final DatabaseSource source;

  /// Environment-variable overlay to merge into the spawned pod's process
  /// environment. Non-null only when [source] is [DatabaseSource.embedded] -
  /// for [DatabaseSource.config] the pod uses its on-disk config as-is.
  final Map<String, String>? envOverlay;

  /// Cleanup callback. Non-null only when the resolver booted something
  /// that needs to be torn down (currently only the embedded postmaster).
  /// Idempotent; safe to call multiple times.
  final Future<void> Function()? onStop;

  /// Human-readable explanation of how the resolver landed on [source].
  /// Logged by `serverpod start` so users can see "auto resolved to ...".
  final String diagnostic;

  ResolvedDbSource({
    required this.source,
    this.envOverlay,
    this.onStop,
    required this.diagnostic,
  });

  /// Construct a no-op result: the pod will use whatever its on-disk
  /// configuration says. Used for `source: config`, `dialect: sqlite`, and
  /// the "no database section" case.
  ResolvedDbSource.passthrough(this.diagnostic)
    : source = DatabaseSource.config,
      envOverlay = null,
      onStop = null;
}

/// Thrown by [resolveDbSource] when an explicit source/runMode combination
/// is invalid (e.g. `source: auto` outside the `development` run mode).
class DbSourceResolutionException implements Exception {
  final String message;
  const DbSourceResolutionException(this.message);
  @override
  String toString() => 'DbSourceResolutionException: $message';
}

/// Signature for booting an embedded postmaster. The default implementation
/// is [EmbeddedPostgres.start]; tests inject a fake to avoid downloading
/// binaries and spawning real PG processes.
typedef EmbeddedPostgresStarter =
    Future<EmbeddedPostgres> Function(EmbeddedPostgresOptions options);

/// Signature for a fast connectivity probe used by the `auto` resolver.
/// Returns `true` when a connection can be opened within the probe budget.
typedef DatabaseReachabilityProbe =
    Future<bool> Function({
      required String host,
      required int port,
      required bool isUnixSocket,
    });

/// Signature for the interactive first-run prompt.
typedef DbSourcePrompter = Future<bool> Function(String message);

/// Resolves `database.source` against the current project state.
///
/// Three concrete sources are possible after resolution: `embedded`,
/// `config`, or `sqlite-noop` (the dialect=sqlite arm; reported as
/// [DatabaseSource.config] in the result for uniformity, with `envOverlay`
/// left null). `auto` is resolved into one of the others via the probe
/// described in the design spec; the resolver never returns `auto`.
///
/// The resolver boots the embedded postmaster as a side effect when it
/// settles on [DatabaseSource.embedded]; the caller must invoke
/// [ResolvedDbSource.onStop] when the watch session ends.
///
/// [embeddedPostgresStarter] / [reachabilityProbe] / [prompter] are
/// injected for testability; production callers leave them null and get
/// the real implementations.
Future<ResolvedDbSource> resolveDbSource({
  required String serverDir,
  required String runMode,
  required DatabaseDialect? dialect,
  required DatabaseSource? configSource,
  required DatabaseSource? cliOverride,
  required String databaseName,
  required String username,
  String? configuredHost,
  int? configuredPort,
  bool configuredIsUnixSocket = false,
  bool interactive = false,
  EmbeddedPostgresStarter? embeddedPostgresStarter,
  DatabaseReachabilityProbe? reachabilityProbe,
  DbSourcePrompter? prompter,
}) async {
  // SQLite arm: source is informational only. Always passthrough.
  if (dialect == DatabaseDialect.sqlite) {
    return ResolvedDbSource.passthrough(
      'dialect=sqlite; source field ignored',
    );
  }

  final effective = cliOverride ?? configSource ?? DatabaseSource.config;

  // Hard gate: 'auto' is dev-only. Outside development the user must be
  // explicit, because production accidentally booting an embedded PG would
  // be catastrophic.
  if (runMode != 'development' && effective == DatabaseSource.auto) {
    throw DbSourceResolutionException(
      'database.source=auto is only valid in the development run mode '
      '(current: $runMode). Set source: config (or --db-source=config) '
      'for non-development runs.',
    );
  }

  switch (effective) {
    case DatabaseSource.config:
      return ResolvedDbSource.passthrough(
        'source=config; using configured database connection',
      );

    case DatabaseSource.embedded:
      return _bootEmbedded(
        serverDir: serverDir,
        databaseName: databaseName,
        username: username,
        starter: embeddedPostgresStarter ?? EmbeddedPostgres.start,
        diagnostic: 'source=embedded; booted serverpod_embedded_postgres',
      );

    case DatabaseSource.auto:
      return _autoResolve(
        serverDir: serverDir,
        databaseName: databaseName,
        username: username,
        configuredHost: configuredHost,
        configuredPort: configuredPort,
        configuredIsUnixSocket: configuredIsUnixSocket,
        interactive: interactive,
        starter: embeddedPostgresStarter ?? EmbeddedPostgres.start,
        probe: reachabilityProbe ?? _defaultReachabilityProbe,
        prompter: prompter ?? _defaultPrompter,
      );
  }
}

Future<ResolvedDbSource> _autoResolve({
  required String serverDir,
  required String databaseName,
  required String username,
  required String? configuredHost,
  required int? configuredPort,
  required bool configuredIsUnixSocket,
  required bool interactive,
  required EmbeddedPostgresStarter starter,
  required DatabaseReachabilityProbe probe,
  required DbSourcePrompter prompter,
}) async {
  final pgVersionFile = File(
    p.join(serverDir, '.serverpod', 'pgdata', 'PG_VERSION'),
  );
  if (pgVersionFile.existsSync()) {
    return _bootEmbedded(
      serverDir: serverDir,
      databaseName: databaseName,
      username: username,
      starter: starter,
      diagnostic:
          'source=auto; resolved to embedded ('
          '.serverpod/pgdata exists from prior run)',
    );
  }

  // Connectivity probe: covers both the compose-managed-PG case (when
  // --docker brought up the stack) and any external host. We don't
  // distinguish - functionally identical, both => passthrough.
  if (configuredHost != null && configuredPort != null) {
    final reachable = await probe(
      host: configuredHost,
      port: configuredPort,
      isUnixSocket: configuredIsUnixSocket,
    );
    if (reachable) {
      return ResolvedDbSource.passthrough(
        'source=auto; resolved to config '
        '($configuredHost:$configuredPort is reachable)',
      );
    }
  }

  // Last resort: prompt interactively, or default to embedded headless.
  if (interactive) {
    final accepted = await prompter(
      'No PostgreSQL reachable. Boot embedded PG? (y/N) - '
      'downloads ~30 MB once.',
    );
    if (!accepted) {
      throw const DbSourceResolutionException(
        'No PostgreSQL reachable and embedded PG was declined. '
        'Configure database.host in the config (or pass '
        '--db-source=embedded) and retry.',
      );
    }
  } else {
    log.info(
      'No PostgreSQL reachable; non-interactive run defaulting to embedded '
      'PG (downloads ~30 MB once).',
    );
  }

  return _bootEmbedded(
    serverDir: serverDir,
    databaseName: databaseName,
    username: username,
    starter: starter,
    diagnostic: 'source=auto; resolved to embedded (no reachable PG)',
  );
}

Future<ResolvedDbSource> _bootEmbedded({
  required String serverDir,
  required String databaseName,
  required String username,
  required EmbeddedPostgresStarter starter,
  required String diagnostic,
}) async {
  final dataDir = Directory(p.join(serverDir, '.serverpod', 'pgdata'));
  final pg = await starter(
    EmbeddedPostgresOptions(
      dataDir: dataDir,
      databaseName: databaseName,
      username: username,
      detach: false,
    ),
  );

  final overlay = envOverlayForEmbeddedPostgres(
    endpoint: pg.endpoint,
    databaseName: databaseName,
    username: username,
  );

  return ResolvedDbSource(
    source: DatabaseSource.embedded,
    envOverlay: overlay,
    onStop: pg.stop,
    diagnostic: diagnostic,
  );
}

/// Default connectivity probe. Opens a socket (UDS or TCP), times out
/// after 200 ms. Any failure (timeout, refused, malformed host, etc.) is
/// reported as "not reachable" - the probe must never crash the start
/// command. 200 ms is plenty for loopback / LAN; remote DBs are not the
/// audience for `source: auto`.
Future<bool> _defaultReachabilityProbe({
  required String host,
  required int port,
  required bool isUnixSocket,
}) async {
  const timeout = Duration(milliseconds: 200);
  try {
    final socket = isUnixSocket
        ? await connectUnixSocket(host).timeout(timeout)
        : await Socket.connect(host, port, timeout: timeout);
    socket.destroy();
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> _defaultPrompter(String message) async {
  stdout.write('$message ');
  final reply = stdin.readLineSync()?.trim().toLowerCase() ?? '';
  return reply == 'y' || reply == 'yes';
}
