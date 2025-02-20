import 'dart:io';

/// Represents the connection information of a network request.
/// Can be HTTP but also other types of network connections.
class ConnectionInfo {
  /// The internet address of the connected client.
  final InternetAddress remoteAddress;

  /// The remote network port of the connected client.
  final int remotePort;

  /// The local network port of the client connection.
  final int localPort;

  /// Creates a [ConnectionInfo] object.
  const ConnectionInfo({
    required this.remoteAddress,
    required this.remotePort,
    required this.localPort,
  });

  /// Creates a [ConnectionInfo] object representing an unknown connection.
  ConnectionInfo.empty()
      : this(
          remoteAddress: InternetAddress.anyIPv4,
          remotePort: 0,
          localPort: 0,
        );

  @override
  String toString() {
    return 'remote: $remoteAddress:$remotePort local port:$localPort)';
  }
}

/// Extension on [HttpConnectionInfo]
/// that adds a [toConnectionInfo] converter method.
extension ConnectionInfoExtension on HttpConnectionInfo {
  /// Converts this [HttpConnectionInfo] to a [ConnectionInfo].
  ConnectionInfo toConnectionInfo() => ConnectionInfo(
        remoteAddress: remoteAddress,
        remotePort: remotePort,
        localPort: localPort,
      );
}
