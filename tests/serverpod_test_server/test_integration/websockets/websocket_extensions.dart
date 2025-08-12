import 'dart:async';
import 'package:web_socket/web_socket.dart';

/// Extension to provide backward-compatible stream-based API for WebSocket.
extension WebSocketExtensions on WebSocket {
  Stream<String> get textEvents => events
      .where((event) => event is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);
}
