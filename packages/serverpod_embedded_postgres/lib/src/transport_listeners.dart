import 'transport.dart';

/// PostgreSQL's default `port`, which names the socket file without TCP.
const int _pgDefaultPort = 5432;

/// The listeners a [Transport] describes, derived for this package's own use.
///
/// Not exported, so the public variants carry only their configured fields.
extension TransportListeners on Transport {
  /// Whether the postmaster serves a Unix socket with trust authentication.
  bool get servesUnixSocket => switch (this) {
    UnixTransport() || DualTransport() => true,
    TcpTransport() => false,
  };

  /// Loopback TCP port, `null` without a TCP listener, `0` for ephemeral.
  int? get tcpPort => switch (this) {
    UnixTransport() => null,
    TcpTransport(:final port) || DualTransport(:final port) => port,
  };

  /// Superuser password for TCP, `null` without a TCP listener or when one is
  /// generated for this launch.
  String? get password => switch (this) {
    UnixTransport() => null,
    TcpTransport(:final password) || DualTransport(:final password) => password,
  };

  /// The postmaster's `port` setting, which also names the socket file.
  int get postmasterPort => tcpPort ?? _pgDefaultPort;

  /// This transport with its TCP listener resolved to [port] and [password].
  Transport withTcp({required int port, required String password}) =>
      switch (this) {
        UnixTransport() => throw StateError(
          'UnixTransport has no TCP listener',
        ),
        TcpTransport() => TcpTransport(port: port, password: password),
        DualTransport() => DualTransport(port: port, password: password),
      };
}
