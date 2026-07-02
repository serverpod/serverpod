import 'dart:io';

import 'package:path/path.dart' as p;

import '../binary/executable.dart';
import '../exceptions.dart';
import '../transport.dart';
import 'postgres_conf_builder.dart';

/// Owns the lifecycle of a single PG cluster on disk: `initdb` invocation,
/// PG_VERSION sanity check, and idempotent rewrites of the managed block
/// in `postgresql.conf`.
///
/// `pg_hba.conf` is NOT rewritten - the spec's authentication policy
/// (trust on UDS, scram-sha-256 on TCP) is exactly what initdb produces
/// when we pass `--auth-local=trust --auth-host=scram-sha-256`. Anything
/// else would be churn.
class ClusterStore {
  /// PG install dir from [BinaryStore.ensure], e.g.
  /// `~/Library/Caches/serverpod/pg-binaries/16.13.0/darwin-amd64`.
  final Directory installDir;

  /// PGDATA - per-project, persistent across restarts.
  final Directory dataDir;

  /// Creates a cluster store rooted at [installDir] for [dataDir].
  ClusterStore({required this.installDir, required this.dataDir});

  /// True when `<dataDir>/PG_VERSION` exists.
  bool get isInitialized =>
      File(p.join(dataDir.path, 'PG_VERSION')).existsSync();

  /// Reads `<dataDir>/PG_VERSION` and returns the major version, or null
  /// when the file is absent. Trims whitespace; returns null on a malformed
  /// (non-integer) value rather than throwing.
  int? get existingMajor {
    var f = File(p.join(dataDir.path, 'PG_VERSION'));
    if (!f.existsSync()) return null;
    return int.tryParse(f.readAsStringSync().trim());
  }

  /// Throws [StaleClusterException] if [dataDir] holds a cluster of a
  /// different major version than [requestedMajor]. No-op when uninitialized
  /// or when versions match.
  void requireMajorMatch(int requestedMajor) {
    var existing = existingMajor;
    if (existing == null || existing == requestedMajor) return;
    throw StaleClusterException(
      'Cluster at ${dataDir.path} is PG $existing but PG $requestedMajor '
      'was requested. Cross-major upgrades are not handled here; either '
      'reset() the cluster (data loss) or run pg_upgrade externally.',
      existingMajor: existing,
      requestedMajor: requestedMajor,
    );
  }

  /// Initialises the cluster on disk if [isInitialized] is false. No-op
  /// otherwise.
  ///
  /// Uses `--no-locale --encoding=UTF8` (byte-stable collation across
  /// machines, no Zonky-locale availability surprises) and seeds the
  /// auth methods so we never need to rewrite `pg_hba.conf`.
  ///
  /// [password] is required for TCP transport (scram-sha-256 over the
  /// host loopback): without a stored password the role can't be
  /// authenticated via scram. Passed via `initdb --pwfile`. For UDS
  /// (trust auth) [password] should be null.
  Future<void> ensureInitialized({
    required String username,
    String? password,
  }) async {
    if (isInitialized) return;

    dataDir.parent.createSync(recursive: true);

    File? pwFile;
    if (password != null) {
      pwFile = File(p.join(dataDir.parent.path, '.initdb-pwfile.tmp'));
      pwFile.writeAsStringSync(password);
    }

    try {
      var initdb = binExecutable(installDir, 'initdb');
      var args = [
        '--pgdata=${dataDir.path}',
        '--username=$username',
        '--encoding=UTF8',
        '--no-locale',
        '--auth-local=trust',
        '--auth-host=scram-sha-256',
        '--no-sync',
        if (pwFile != null) '--pwfile=${pwFile.path}',
      ];

      var result = await Process.run(initdb, args);
      if (result.exitCode != 0) {
        throw InitdbException(
          'initdb exit ${result.exitCode}\n'
          '--- stdout ---\n${result.stdout}\n'
          '--- stderr ---\n${result.stderr}',
        );
      }
    } finally {
      if (pwFile != null && pwFile.existsSync()) {
        pwFile.deleteSync();
      }
    }
  }

  /// Idempotent rewrite of the managed block in `<dataDir>/postgresql.conf`.
  ///
  /// Builds the block body from [transport] and the layout convention
  /// (`run/` is a sibling of PGDATA), then merges into the file: if our
  /// markers exist, the block between them is replaced; otherwise the
  /// block is appended. Lines outside the block are preserved.
  ///
  /// No-op when the rewrite would produce identical content.
  void reconcilePostgresConf({
    required Transport transport,
    int maxConnections = defaultMaxConnections,
  }) {
    var conf = File(p.join(dataDir.path, 'postgresql.conf'));
    if (!conf.existsSync()) {
      throw StateError(
        'postgresql.conf missing at ${conf.path}; call ensureInitialized first.',
      );
    }
    var original = conf.readAsStringSync();
    var body = buildPostgresConfBody(
      transport: transport,
      pgDataDir: dataDir,
      maxConnections: maxConnections,
    );
    var rewritten = rewriteManagedBlock(original, body);
    if (rewritten != original) {
      conf.writeAsStringSync(rewritten);
    }
  }
}
