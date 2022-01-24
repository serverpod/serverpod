import 'package:flutter/material.dart';

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
          Text('Failed to connect.'),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: onReconnect,
              child: Text('Try Again'),
            ),
          )
        ],
      )),
    );
  }
}
