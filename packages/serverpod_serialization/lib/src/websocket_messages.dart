import 'dart:convert';

/// Base class for messages sent over a WebSocket connection.
sealed class WebSocketMessage {
  /// Converts a JSON string to a [WebSocketMessage] object.
  static WebSocketMessage fromJsonString(String jsonString) {
    Map data;
    try {
      data = jsonDecode(jsonString) as Map;
    } catch (e) {
      return UnknownMessage(jsonString);
    }

    var messageType = data['messageType'];

    switch (messageType) {
      case PingCommand.messageType:
        return PingCommand();
      case PongCommand.messageType:
        return PongCommand();
      default:
        return UnknownMessage(jsonString);
    }
  }
}

/// A message sent over a websocket connection to check if the connection is
/// still alive. The other end should respond with a [PongCommand].
class PingCommand extends WebSocketMessage {
  /// The type of message.
  static const String messageType = 'ping_command';

  /// Creates a new [PingCommand].
  static String buildMessage() {
    return jsonEncode({'messageType': messageType});
  }
}

/// A response to a [PingCommand].
class PongCommand extends WebSocketMessage {
  /// The type of message.
  static const String messageType = 'pong_command';

  /// Creates a new [PongCommand].
  static String buildMessage() {
    return jsonEncode({'messageType': messageType});
  }
}

/// A message that is not recognized.
class UnknownMessage extends WebSocketMessage {
  /// The JSON string that was not recognized.
  final String jsonString;

  /// Creates a new [UnknownMessage].
  UnknownMessage(this.jsonString);
}
