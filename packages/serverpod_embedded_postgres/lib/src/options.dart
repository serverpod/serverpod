import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

import 'binary/binary_source.dart';
import 'cluster/postgres_conf_builder.dart';
import 'transport.dart';

/// Default PostgreSQL major.minor version. Tracks Serverpod Cloud and the
/// `pgvector/pgvector:pg16` image used by the project templates.
final Version defaultPostgresVersion = Version(16, 13, 0);

/// Default username for the embedded cluster. Matches the existing
/// docker-compose convention used across Serverpod's tests and templates.
const String defaultUsername = 'postgres';

/// Configuration for [EmbeddedPostgres.start].
///
/// All fields except [dataDir] and [databaseName] have safe dev defaults.
class EmbeddedPostgresOptions {
  /// Project-local PGDATA. Survives across restarts; never cleaned on
  /// [EmbeddedPostgres.stop]. Conventionally `<project>/.serverpod/pgdata`.
  ///
  /// MUST be inside a directory that is gitignored.
  final Directory dataDir;

  /// Database to create on first run. Idempotent: if the database already
  /// exists from a previous start, no re-creation is attempted.
  final String databaseName;

  /// Default: 'postgres' (matches existing Serverpod conventions).
  final String username;

  /// How the postmaster listens. Defaults to [UnixTransport] - no port
  /// allocation, no firewall prompts, no clash between two open Serverpod
  /// projects.
  final Transport transport;

  /// PostgreSQL major.minor.patch version. Defaults to
  /// [defaultPostgresVersion]; bump in lockstep with Serverpod Cloud.
  ///
  /// Must match a published Serverpod bundle - [EmbeddedPostgres.start]
  /// throws [UnsupportedVersionException] (before any network access) for
  /// versions without one.
  final Version version;

  /// Override the per-user binary cache root. Defaults to:
  ///   - Linux: `$XDG_CACHE_HOME/serverpod` or `~/.cache/serverpod`
  ///   - macOS: `~/Library/Caches/serverpod`
  ///   - Windows: `%LOCALAPPDATA%\serverpod\Cache`
  final Directory? binaryCache;

  /// Cap on `initdb` + start-to-ready. Network download (first run only) is
  /// reported separately via [onProgress] and is NOT subject to this cap.
  ///
  /// Default: 60s. Spike measurements: warm-binary cold-cluster ~2.5s, full
  /// warm ~0.9s. The 60s budget is generous for typical hardware.
  final Duration startTimeout;

  /// If `true`, the postmaster survives parent process exit (no shutdown
  /// hooks registered). Reattach later via [EmbeddedPostgres.attach].
  ///
  /// Use case: long-lived dev DB across many short `dart test` invocations.
  /// Default: `false`.
  final bool detach;

  /// When `true`, before spawning the postmaster, best-effort recovery:
  /// - Removes Serverpod `postgres.pid` when it references a dead PID.
  /// - Removes PostgreSQL `postmaster.pid` when its PID is dead.
  /// - **POSIX:** if both pidfiles still reference our recorded postmaster and
  ///   that postmaster no longer has its original Dart supervisor as parent,
  ///   prefers `pg_ctl stop` from the same bundle `bin/` (passed from
  ///   [EmbeddedPostgres.start]) so backends and **SysV shared memory** are
  ///   torn down cleanly; then kills any remaining subtree on Linux (`/proc`).
  ///   Skipped on Windows and older pidfiles without supervisor metadata.
  ///
  /// Default: `false`.
  final bool repairStaleLocks;

  /// Optional callback for binary download / extraction progress on the
  /// very first run. Receives `(fraction, stage)` where `stage` is one of
  /// 'download', 'verify', 'extract'.
  ///
  /// `serverpod_cli start` wires this into the existing CLI progress UI.
  final void Function(double fraction, String stage)? onProgress;

  /// The cluster's `max_connections`. Defaults to [defaultMaxConnections],
  /// sized for parallel test suites sharing one postmaster.
  final int maxConnections;

  /// Where the PostgreSQL bundle comes from: [BinarySource.download] (the
  /// default), [BinarySource.build], or [BinarySource.auto] (download,
  /// falling back to a local build when the prebuilt bundle isn't
  /// published). `null` defers to the `SERVERPOD_PG_SOURCE` env var, else
  /// [BinarySource.download].
  ///
  /// Building requires the toolchain (zig/cmake/make/bison/flex/perl, plus
  /// bash/MSYS2 on Windows); see `tool/build_postgres/`.
  final BinarySource? binarySource;

  /// Creates options for [EmbeddedPostgres.start]. Only [dataDir] and
  /// [databaseName] are required; the rest have safe dev defaults.
  EmbeddedPostgresOptions({
    required this.dataDir,
    required this.databaseName,
    this.username = defaultUsername,
    this.transport = const UnixTransport(),
    Version? version,
    this.binaryCache,
    this.startTimeout = const Duration(seconds: 60),
    this.detach = false,
    this.repairStaleLocks = false,
    this.onProgress,
    this.maxConnections = defaultMaxConnections,
    this.binarySource,
  }) : version = version ?? defaultPostgresVersion;
}
