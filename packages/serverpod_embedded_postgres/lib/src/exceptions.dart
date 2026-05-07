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
  /// Creates a [BinaryFetchException] with [message].
  const BinaryFetchException(super.message);
}

/// SHA-256 mismatch on a downloaded Zonky JAR. The cached download is
/// removed before this is thrown - retrying [EmbeddedPostgres.start] will
/// re-fetch.
final class BinaryVerificationException extends EmbeddedPostgresException {
  /// Creates a [BinaryVerificationException] with [message].
  const BinaryVerificationException(super.message);
}

/// Current `(os, arch)` tuple isn't covered by Zonky's binary distribution.
final class UnsupportedPlatformException extends EmbeddedPostgresException {
  /// Creates an [UnsupportedPlatformException] with [message].
  const UnsupportedPlatformException(super.message);
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
}

/// `stop()` escalated through SIGINT -> SIGTERM -> SIGKILL without the
/// process exiting in time.
final class StopTimeoutException extends EmbeddedPostgresException {
  /// Creates a [StopTimeoutException] with [message].
  const StopTimeoutException(super.message);
}

/// Computed `sun_path` would exceed the platform cap (104 bytes on macOS,
/// 108 on Linux/Windows). With the spec's relative-path bind strategy this
/// is only triggered by pathological custom `dataDir` values; the normal
/// `<project>/.serverpod/pgdata` layout always fits.
final class SocketPathTooLongException extends EmbeddedPostgresException {
  /// Creates a [SocketPathTooLongException] with [message].
  const SocketPathTooLongException(super.message);
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
