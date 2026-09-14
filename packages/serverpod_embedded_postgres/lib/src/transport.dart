/// How the embedded PostgreSQL postmaster listens.
///
/// Each variant holds only what the caller configures for it. The running
/// [EmbeddedPostgres] reports the resolved listeners through its endpoints.
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
/// project lives on disk. No password is involved; a later start with a TCP
/// listener sets one on the role.
final class UnixTransport extends Transport {
  /// Creates a UDS transport. The socket directory is derived from the
  /// [EmbeddedPostgresOptions.dataDir] option.
  const UnixTransport();
}

/// Connection over loopback TCP only. Authentication is `scram-sha-256`.
final class TcpTransport extends Transport {
  /// TCP port to bind. `0` selects an ephemeral port; the supervisor will
  /// pre-bind a `ServerSocket` on `127.0.0.1:0`, read the chosen port,
  /// close, and pass it to `postgres`, retrying once on `EADDRINUSE` to
  /// cover the close-then-rebind race.
  final int port;

  /// Superuser password for `scram-sha-256` over loopback. The role is set
  /// to this value on every start, so the caller's configuration is the only
  /// place it lives; nothing is written to disk by this package. If null, a
  /// cryptographically random password is generated for this launch (other
  /// processes then cannot attach over TCP). Serverpod passes
  /// `config/passwords.yaml` `database` here.
  final String? password;

  /// Creates a TCP transport bound to `127.0.0.1`. Pass [port] to pin a
  /// specific port (`0` = ephemeral) and [password] to pin a known password
  /// (otherwise a random one is generated).
  const TcpTransport({this.port = 0, this.password});
}

/// Unix Domain Socket plus loopback TCP on the same postmaster.
///
/// Local processes that can reach the socket directory keep trust
/// authentication over the socket; everything arriving on `127.0.0.1` must
/// authenticate with `scram-sha-256`. Use this when external tools (psql, a
/// database GUI) need a host and port while the owning process keeps the
/// filesystem-gated socket. [EmbeddedPostgres.endpoint] prefers the socket;
/// [EmbeddedPostgres.tcpEndpoint] exposes the TCP coordinates. The socket
/// file is named after the TCP port, as PostgreSQL does.
final class DualTransport extends Transport {
  /// TCP port to bind on `127.0.0.1`, see [TcpTransport.port].
  final int port;

  /// Superuser password for `scram-sha-256` over loopback, see
  /// [TcpTransport.password].
  final String? password;

  /// Creates a transport bound to the socket and to `127.0.0.1:[port]`.
  const DualTransport({this.port = 0, this.password});
}
