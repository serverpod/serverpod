/// How the embedded PostgreSQL postmaster listens.
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
  /// Creates a UDS transport. The socket directory is derived from the
  /// [EmbeddedPostgresOptions.dataDir] option.
  const UnixTransport();
}

/// Connection over loopback TCP only. Authentication is `scram-sha-256`.
final class TcpTransport extends Transport {
  /// TCP port to bind, or `0` for an ephemeral one.
  final int port;

  /// Superuser password for `scram-sha-256` over loopback, or `null` for a
  /// generated one.
  ///
  /// Every start sets it on the role. Only a generated password is stored, in
  /// `<dataDir parent>/postgres.password`, and later starts reuse it.
  final String? password;

  /// Creates a TCP transport bound to `127.0.0.1`. Pass [port] to pin a
  /// specific port (`0` = ephemeral) and [password] to pin a known password
  /// (otherwise a random one is generated).
  const TcpTransport({this.port = 0, this.password});
}

/// Unix Domain Socket plus loopback TCP on the same postmaster.
///
/// The socket keeps trust authentication, and `127.0.0.1` requires
/// `scram-sha-256`. The socket file is named after the TCP port.
final class DualTransport extends Transport {
  /// See [TcpTransport.port].
  final int port;

  /// See [TcpTransport.password].
  final String? password;

  /// Creates a transport bound to the socket and to `127.0.0.1:[port]`.
  const DualTransport({this.port = 0, this.password});
}
