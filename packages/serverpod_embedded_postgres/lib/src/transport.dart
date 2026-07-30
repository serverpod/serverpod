/// How the embedded PostgreSQL postmaster listens.
///
/// Mode-specific configuration lives on the variants so [EmbeddedPostgresOptions]
/// stays free of fields that only apply to one transport.
sealed class Transport {
  const Transport();
}

/// Connection over a Unix Domain Socket inside the project's data directory.
///
/// The default when the platform supports Unix sockets. Authentication is
/// `trust` - the project directory already gates filesystem access to the
/// socket; a 0700 socket adds nothing. The socket directory is
/// `<dataDir>/../run`, so PG can bind via the relative path `../run` (after its
/// `chdir(PGDATA)`) and keep `sun_path` ~20 bytes regardless of how deep the
/// project lives on disk.
final class UnixTransport extends Transport {
  /// Superuser password seeded at `initdb` time. Unix connections use trust
  /// auth and ignore this; it is persisted to `postgres.password` in the data
  /// directory parent so a later switch to [TcpTransport] works without
  /// re-init. If null, a random password is generated on first init.
  final String? initialPassword;

  /// Creates a UDS transport. The socket directory is derived from the
  /// [EmbeddedPostgresOptions.dataDir] option.
  const UnixTransport({this.initialPassword});
}

/// Connection over loopback TCP. Authentication is `scram-sha-256`.
final class TcpTransport extends Transport {
  /// TCP port to bind. `0` selects an ephemeral port; the supervisor will
  /// pre-bind a `ServerSocket` on `127.0.0.1:0`, read the chosen port,
  /// close, and pass it to `postgres`. Up to 3 retries on `EADDRINUSE` to
  /// cover the close-then-rebind race.
  final int port;

  /// Superuser password for `scram-sha-256` over loopback. Seeded at `initdb`
  /// on fresh clusters and persisted to `<dataDir parent>/postgres.password`.
  /// If null, a cryptographically random password is generated. Serverpod
  /// passes `config/passwords.yaml` `database` here.
  final String? password;

  /// Creates a TCP transport bound to `127.0.0.1`. Pass [port] to pin a
  /// specific port (`0` = ephemeral) and [password] to pin a known password
  /// (otherwise a random one is generated).
  const TcpTransport({this.port = 0, this.password});
}
