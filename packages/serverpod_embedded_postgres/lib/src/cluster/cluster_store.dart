import 'dart:convert';
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
  /// `~/Library/Caches/serverpod/pg-binaries/16.13.0-r1/macos-x64`.
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
  /// [password], when set, seeds the superuser password via
  /// `initdb --pwfile`. UDS connections use trust auth and ignore it.
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

      await _runOrThrow(initdb, args, what: 'initdb');
    } finally {
      if (pwFile != null && pwFile.existsSync()) {
        pwFile.deleteSync();
      }
    }
  }

  /// Sets the superuser [username]'s password to [password] on an
  /// initialised cluster with no postmaster running.
  ///
  /// Runs `postgres --single`, which executes SQL straight against PGDATA
  /// without any listener, so it works for every transport and completes
  /// before a client could connect. Called on every start of an existing
  /// cluster that binds TCP: `initdb` only seeds the password once, so this
  /// is what makes a rotated password, or a cluster initialised without one,
  /// authenticate over scram-sha-256. Bounded by [timeout] because single
  /// user mode replays WAL first, like any backend.
  Future<void> setSuperuserPassword({
    required String username,
    required String password,
    required Duration timeout,
  }) async {
    if (password.contains('\n') || password.contains('\r')) {
      throw ArgumentError.value(
        password,
        'password',
        'must not contain line breaks',
      );
    }
    // ALTER ROLE doesn't accept parameters. Identifier and literal quoting
    // is by doubling, and standard_conforming_strings (on by default) keeps
    // backslashes literal. Single-user mode takes one statement per line.
    var role = username.replaceAll('"', '""');
    var literal = password.replaceAll("'", "''");
    await _runOrThrow(
      binExecutable(installDir, 'postgres'),
      [
        '--single',
        // Single-user mode survives SQL errors and exits 0 without this.
        '-c', 'exit_on_error=true',
        // Keeps the failing statement, and so the password, out of stderr.
        '-c', 'log_min_error_statement=panic',
        '-D', dataDir.path,
        'postgres',
      ],
      stdin: 'ALTER ROLE "$role" PASSWORD \'$literal\'\n',
      what: 'postgres --single (setting the superuser password)',
      timeout: timeout,
    );
  }

  /// Runs [executable] to completion, feeding it [stdin] when given, and
  /// throws [InitializeDatabaseException] carrying both output streams on a
  /// non-zero exit or when [timeout] elapses.
  Future<void> _runOrThrow(
    String executable,
    List<String> args, {
    String? stdin,
    required String what,
    Duration? timeout,
  }) async {
    var process = await Process.start(executable, args);
    if (stdin != null) process.stdin.write(stdin);
    await process.stdin.close();
    var stdout = process.stdout.transform(utf8.decoder).join();
    var stderr = process.stderr.transform(utf8.decoder).join();

    var exitCode = process.exitCode;
    if (timeout != null) {
      exitCode = exitCode.timeout(
        timeout,
        onTimeout: () {
          process.kill();
          throw InitializeDatabaseException(
            '$what did not finish within ${timeout.inSeconds}s',
          );
        },
      );
    }
    var code = await exitCode;
    if (code != 0) {
      throw InitializeDatabaseException(
        '$what exit $code\n'
        '--- stdout ---\n${await stdout}\n'
        '--- stderr ---\n${await stderr}',
      );
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
