import 'dart:io';

import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';

import 'binary/binary_source.dart' show BinarySource, resolveBinarySource;
import 'binary/binary_store.dart' show BinaryStore;
import 'binary/bundle_builder.dart' show BundleBuilder;
import 'binary/bundle_spec.dart' show bundleSpecFor;
import 'binary/serverpod_bundle.dart'
    show ServerpodBundleArtifact, serverpodPlatformSuffixes;
import 'embedded_postgres_impl.dart';
import 'exceptions.dart' show UnsupportedPlatformException;
import 'options.dart';

/// A managed PostgreSQL postmaster running as a child process of this Dart
/// VM (or detached, if [EmbeddedPostgresOptions.detach] was set).
///
/// One Dart call boots a real PG instance, persistent across restarts, with
/// no Docker dependency and (by default) no TCP port allocation. See the
/// package README for the runtime and lifecycle contract.
abstract class EmbeddedPostgres {
  /// Boot a fresh postmaster supervised by this process for [opts.dataDir].
  ///
  /// Throws [PostmasterLockBusyException] if a live postmaster already holds
  /// [opts.dataDir].
  ///
  /// Phases on cold first run: download the PG bundle (if not cached) ->
  /// `initdb` -> spawn `postgres` -> wait for ready -> `CREATE DATABASE`.
  /// Network download is gated by [opts.onProgress], not [opts.startTimeout].
  ///
  /// Set [EmbeddedPostgresOptions.repairStaleLocks] to remove stale pidfiles
  /// and recover a postmaster that survived after its original Dart parent
  /// died abruptly.
  static Future<EmbeddedPostgres> start(EmbeddedPostgresOptions opts) =>
      EmbeddedPostgresImpl.start(opts);

  /// Boot a fresh postmaster, or attach to one that already supervises
  /// [opts.dataDir].
  ///
  /// [EmbeddedStartResult.launched] reports which path was taken, so callers
  /// know whether they own the postmaster's lifecycle. Only the launcher
  /// should [stop] it; an attached client calling [stop] would tear down a
  /// postmaster another process owns.
  ///
  /// Rethrows [start]'s [PostmasterLockBusyException] if the live postmaster
  /// disappears before [attach] can latch onto it.
  static Future<EmbeddedStartResult> startOrAttach(
    EmbeddedPostgresOptions opts,
  ) => EmbeddedPostgresImpl.startOrAttach(opts);

  /// Reattach to a postmaster started with [EmbeddedPostgresOptions.detach]
  /// set. Reads the supervisor pidfile, validates the process is still
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
  /// [source] selects download vs. build-from-source (defaults to the
  /// `SERVERPOD_PG_SOURCE` env, else [BinarySource.download]); pass
  /// [BinarySource.build] to force a local build (CI warm-up before publish).
  ///
  /// Throws [UnsupportedVersionException] when no bundle is published for
  /// [version] - before any network access.
  static Future<void> prefetch(
    Version version, {
    String? target,
    BinarySource? source,
  }) async {
    if (target != null && !serverpodPlatformSuffixes.contains(target)) {
      throw UnsupportedPlatformException(
        "Unknown prefetch target '$target'. Expected one of: "
        '${serverpodPlatformSuffixes.join(', ')}.',
      );
    }
    var spec = bundleSpecFor(version);
    var platform =
        target ??
        ServerpodBundleArtifact.forCurrentPlatform(spec: spec).platform;
    var artifact = ServerpodBundleArtifact(
      spec: spec,
      platform: platform,
    );
    var store = BinaryStore();
    try {
      await store.ensure(
        artifact,
        source: resolveBinarySource(explicit: source),
        builder: const BundleBuilder(),
      );
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

/// Outcome of [EmbeddedPostgres.startOrAttach].
class EmbeddedStartResult {
  /// The resolved postmaster handle, whether freshly launched or attached.
  final EmbeddedPostgres handle;

  /// `true` if this call spawned the postmaster (so [handle] supervises it and
  /// [EmbeddedPostgres.stop] shuts it down); `false` if it attached to a
  /// postmaster another supervisor already owns (stopping [handle] would tear
  /// down a process this caller does not own).
  final bool launched;

  /// Creates an [EmbeddedStartResult].
  const EmbeddedStartResult({required this.handle, required this.launched});
}
