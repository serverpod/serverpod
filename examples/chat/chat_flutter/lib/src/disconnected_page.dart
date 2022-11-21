import 'package:flutter/material.dart';

/// Shows a message that the user has been disconnected and offers the option
/// to attempt to reconnect to the server.
class DisconnectedPage extends StatelessWidget {
  final VoidCallback onReconnect;

  const DisconnectedPage({
    required this.onReconnect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to connect.'),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: onReconnect,
              child: const Text('Try Again'),
            ),
          )
        ],
      )),
    );
  }
}
