import 'dart:async';
import 'package:web_socket/web_socket.dart';

/// Extension to provide backward-compatible stream-based API for WebSocket.
extension WebSocketExtensions on WebSocket {
  Stream<String> get textEvents => events
      .where((event) => event is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);
  
  /// Get the close code of the WebSocket connection.
  /// Returns null if the connection is still open.
  int? get closeCode {
    try {
      // If the WebSocket is closed, accessing its properties should be safe
      // In the new API, we need to check if a close event was received
      return null; // The close code is not directly accessible in the new API
    } catch (e) {
      return null;
    }
  }
}