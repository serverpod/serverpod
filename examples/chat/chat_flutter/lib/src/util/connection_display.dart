import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';

/// Shows the connection state of a streaming connection.
class ConnectionDisplay extends StatelessWidget {
  final Widget child;
  final StreamingConnectionHandlerState connectionState;

  const ConnectionDisplay({
    required this.child,
    required this.connectionState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String connectionStateDescription;
    Color connectionStateColor;
    switch (connectionState.status) {
      case StreamingConnectionStatus.connected:
        connectionStateDescription = 'Connected';
        connectionStateColor = Colors.green;
        break;
      case StreamingConnectionStatus.connecting:
        connectionStateDescription = 'Connecting';
        connectionStateColor = Colors.orange[800]!;
        break;
      case StreamingConnectionStatus.disconnected:
        connectionStateDescription = 'Disconnected';
        connectionStateColor = Colors.red;
        break;
      case StreamingConnectionStatus.waitingToRetry:
        connectionStateDescription =
            'Retrying in ${connectionState.retryInSeconds} seconds';
        connectionStateColor = Colors.orange[800]!;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        Container(
          padding: const EdgeInsets.all(8),
          color: connectionStateColor,
          child: Text(
            connectionStateDescription,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
