import 'dart:async';
import 'package:relic/relic.dart';
import 'package:web_socket/web_socket.dart';

/// Extension to provide backward-compatible stream-based API for WebSocket.
extension WebSocketExtensions on WebSocket {
  Stream<String> get textEvents => events
      .where((event) => event is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);

  Future<void> tryClose([int? code, String? reason]) async {
    try {
      await close(code, reason);
    } on WebSocketConnectionClosed {
      // Connection is already closed
    }
  }
}

/// Extension to provide backward-compatible stream-based API for RelicWebSocket.
extension RelicWebSocketExtensions on RelicWebSocket {
  Stream<String> get textEvents => events
      .where((event) => event is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);
}
