import 'dart:io';

import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';

import 'binary/binary_store.dart' show BinaryStore;
import 'binary/maven_url.dart' show ZonkyArtifact;
import 'embedded_postgres_impl.dart';
import 'options.dart';

/// A managed PostgreSQL postmaster running as a child process of this Dart
/// VM (or detached, if [EmbeddedPostgresOptions.detach] was set).
///
/// One Dart call boots a real PG instance, persistent across restarts, with
/// no Docker dependency and (by default) no TCP port allocation. See the
/// design doc at `docs/design/serverpod_embedded_postgres_spec.md`.
abstract class EmbeddedPostgres {
  /// Boot or attach to a postmaster for [opts.dataDir].
  ///
  /// Idempotent: if the data dir's pidfile points at our live postmaster,
  /// the existing handle is returned (cmdline + cwd verified to avoid
  /// PID-recycling false positives).
  ///
  /// Phases on cold first run: download Zonky binaries (if not cached) ->
  /// `initdb` -> spawn `postgres` -> wait for ready -> `CREATE DATABASE`.
  /// Network download is gated by [opts.onProgress], not [opts.startTimeout].
  ///
  /// Set [EmbeddedPostgresOptions.repairStaleLocks] to remove stale pidfiles
  /// and recover a postmaster that survived after its original Dart parent
  /// died abruptly.
  static Future<EmbeddedPostgres> start(EmbeddedPostgresOptions opts) =>
      EmbeddedPostgresImpl.start(opts);

  /// Reattach to a postmaster started with [EmbeddedPostgresOptions.detach]
  /// = true. Reads the supervisor pidfile, validates the process is still
  /// our postmaster, returns a handle.
  ///
  /// Throws [CrashedException] if the pidfile points at a dead process or
  /// at a foreign one.
  static Future<EmbeddedPostgres> attach(Directory dataDir) =>
      EmbeddedPostgresImpl.attach(dataDir);

  /// Pre-populate the per-user binary cache for [version] without booting
  /// a postmaster. Useful for CI warm-up and offline prep.
  ///
  /// If [target] is omitted, downloads the artifact for the current host
  /// platform. CI hosts can pass a different target to populate caches
  /// for other platforms.
  static Future<void> prefetch(Version version, {String? target}) async {
    var platform =
        target ?? ZonkyArtifact.forCurrentPlatform(version: version).platform;
    var artifact = ZonkyArtifact(version: version, platform: platform);
    var store = BinaryStore();
    try {
      await store.ensure(artifact);
    } finally {
      store.close();
    }
  }

  /// Default per-user binary cache location for the current platform.
  static Directory defaultBinaryCache() => BinaryStore.defaultCacheRoot();

  /// libpq-style URI. Suitable for `psql`, `pg_dump`, etc. Dart consumers
  /// using `package:postgres` should prefer [endpoint].
  String get connectionString;

  /// Same as [connectionString] but typed.
  Uri get connectionUri;

  /// Drop-in for `package:postgres` consumers. For UDS, [pg.Endpoint.host]
  /// is the socket *file* path (passed through `shortestPath()`), not the
  /// directory - `package:postgres` does not auto-append `.s.PGSQL.<port>`
  /// the way libpq does.
  pg.Endpoint get endpoint;

  /// Resolved PostgreSQL version (major.minor.patch) backing this handle.
  Version get version;

  /// OS PID of the running postmaster, or `null` if the process has exited
  /// or was never started.
  int? get pid;

  /// `true` once `start()` has resolved the handle and `stop()` hasn't
  /// completed.
  bool get isRunning;

  /// Smart shutdown: SIGINT -> after `timeout/2` SIGTERM -> after `timeout`
  /// SIGKILL. Removes the supervisor pidfile. Does NOT delete `dataDir`.
  Future<void> stop({Duration timeout = const Duration(seconds: 10)});

  /// Stop, wipe data dir + run dir + pidfile + log, fresh `initdb`.
  /// Caller is responsible for re-creating any application databases.
  Future<void> reset();
}
