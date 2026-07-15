/// Base type for all errors raised by `serverpod_embedded_postgres`.
///
/// Sealed: pattern-match exhaustively in callers. All variants carry a
/// human-readable [message]; the variants relevant to a running postmaster
/// also carry a [logTail] - the last N captured stdout/stderr lines from
/// `postgres`, included verbatim to make production-on-laptop diagnoses
/// possible without rerunning.
sealed class EmbeddedPostgresException implements Exception {
  /// Human-readable explanation of the failure.
  final String message;

  /// Creates an exception with [message].
  const EmbeddedPostgresException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// HTTP failure or unexpected payload while fetching the Zonky JAR or its
/// `.sha256` sidecar from Maven Central.
final class BinaryFetchException extends EmbeddedPostgresException {
  /// HTTP status code when the failure was a non-200 response (else `null`,
  /// e.g. a timeout). `404` means the prebuilt bundle isn't published - the
  /// trigger for the build-from-source fallback in [BinarySource.auto].
  final int? statusCode;

  /// Creates a [BinaryFetchException] with [message] and optional [statusCode].
  const BinaryFetchException(super.message, {this.statusCode});
}

/// SHA-256 mismatch on a downloaded Zonky JAR. The cached download is
/// removed before this is thrown - retrying [EmbeddedPostgres.start] will
/// re-fetch.
final class BinaryVerificationException extends EmbeddedPostgresException {
  /// Creates a [BinaryVerificationException] with [message].
  const BinaryVerificationException(super.message);
}

/// Current `(os, arch)` tuple isn't covered by the binary distribution.
final class UnsupportedPlatformException extends EmbeddedPostgresException {
  /// Creates an [UnsupportedPlatformException] with [message].
  const UnsupportedPlatformException(super.message);
}

/// The requested PostgreSQL version has no published Serverpod bundle
/// specification. Raised before any network access; the remedy is to request
/// one of the published versions (listed in [message]).
final class UnsupportedVersionException extends EmbeddedPostgresException {
  /// Creates an [UnsupportedVersionException] with [message].
  const UnsupportedVersionException(super.message);
}

/// Building the bundle from source failed, or the build toolchain
/// (zig/cmake/make/bison/flex/perl, plus `bash`/MSYS2 on Windows) is missing.
/// Raised when the prebuilt bundle is unavailable and a local build was
/// attempted (or forced via [EmbeddedPostgresOptions.binarySource]).
final class BinaryBuildException extends EmbeddedPostgresException {
  /// Creates a [BinaryBuildException] with [message].
  const BinaryBuildException(super.message);
}

/// `initdb` returned a non-zero exit code. [message] embeds the captured
/// stdout + stderr.
final class InitdbException extends EmbeddedPostgresException {
  /// Creates an [InitdbException] with [message].
  const InitdbException(super.message);
}

/// `postgres` did not become ready within
/// [EmbeddedPostgresOptions.startTimeout].
final class StartupTimeoutException extends EmbeddedPostgresException {
  /// Last captured stdout/stderr lines from the postmaster.
  final List<String> logTail;

  /// Creates a [StartupTimeoutException] with [message] and [logTail].
  const StartupTimeoutException(super.message, this.logTail);

  @override
  String toString() => _withLogTail(runtimeType, message, logTail);
}

/// Postmaster exited unexpectedly while the supervisor was waiting for it
/// to become ready, or after it had become ready.
final class CrashedException extends EmbeddedPostgresException {
  /// OS exit code reported by the postmaster.
  final int exitCode;

  /// Last captured stdout/stderr lines from the postmaster.
  final List<String> logTail;

  /// Creates a [CrashedException] with [message], [exitCode], and
  /// [logTail].
  const CrashedException(super.message, this.exitCode, this.logTail);

  @override
  String toString() => _withLogTail(runtimeType, message, logTail);
}

String _withLogTail(Type type, String message, List<String> logTail) {
  if (logTail.isEmpty) return '$type: $message';
  return '$type: $message\n'
      '--- postgres log tail (${logTail.length} lines) ---\n'
      '${logTail.join('\n')}\n'
      '--- end log tail ---';
}

/// `EmbeddedPostgres.attach()` couldn't find a postmaster to re-attach
/// to. Distinct from [CrashedException]: the postmaster wasn't running
/// in the first place, or the state file written by the original
/// `start()` is missing or malformed. The remedy is to call `start()`
/// instead, not to investigate a crash.
final class AttachException extends EmbeddedPostgresException {
  /// Creates an [AttachException] with [message].
  const AttachException(super.message);
}

/// `postmaster.pid` in the target PGDATA is held by a live postmaster.
///
/// Detected before spawn when possible (locale-independent), or recognised
/// at the supervisor level from PG's own startup error otherwise. Callers
/// can react by re-attaching via [EmbeddedPostgres.attach] instead of
/// retrying [EmbeddedPostgres.start].
final class PostmasterLockBusyException extends EmbeddedPostgresException {
  /// PID found in the existing `postmaster.pid` when known. `null` when the
  /// condition was detected at the supervisor level (race between pre-check
  /// and spawn) and the PID wasn't captured.
  final int? existingPid;

  /// Creates a [PostmasterLockBusyException] with [message] and an optional
  /// [existingPid].
  const PostmasterLockBusyException(super.message, {this.existingPid});
}

/// PG_VERSION inside the data dir doesn't match
/// [EmbeddedPostgresOptions.version]. Cross-major upgrades aren't handled
/// automatically; the caller must `reset()` (and lose the data) or run
/// `pg_upgrade` manually outside this package.
final class StaleClusterException extends EmbeddedPostgresException {
  /// The major version found inside the existing data dir (e.g. `16`).
  final int existingMajor;

  /// The major version requested via [EmbeddedPostgresOptions.version].
  final int requestedMajor;

  /// Creates a [StaleClusterException] with [message] and the version mismatch.
  const StaleClusterException(
    super.message, {
    required this.existingMajor,
    required this.requestedMajor,
  });
}
