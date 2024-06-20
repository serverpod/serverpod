import 'dart:convert';

/// Base class for messages sent over a WebSocket connection.
sealed class WebSocketMessage {
  /// Converts a JSON string to a [WebSocketMessage] object.
  ///
  /// Throws an [UnknownMessageException] if the message is not recognized.
  static WebSocketMessage fromJsonString(String jsonString) {
    try {
      Map data = jsonDecode(jsonString) as Map;

      var messageType = data['messageType'];

      switch (messageType) {
        case PingCommand.messageType:
          return PingCommand();
        case PongCommand.messageType:
          return PongCommand();
        case BadRequestMessage.messageType:
          return BadRequestMessage(data);
      }

      throw UnknownMessageException(jsonString);
    } catch (e, stackTrace) {
      throw UnknownMessageException(
        jsonString,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// A message sent over a websocket connection to check if the connection is
/// still alive. The other end should respond with a [PongCommand].
class PingCommand extends WebSocketMessage {
  /// The type of message.
  static const String messageType = 'ping_command';

  /// Builds a [PingCommand] message.
  static String buildMessage() {
    return jsonEncode({'messageType': messageType});
  }
}

/// A response to a [PingCommand].
class PongCommand extends WebSocketMessage {
  /// The type of message.
  static const String messageType = 'pong_command';

  /// Builds a [PongCommand] message.
  static String buildMessage() {
    return jsonEncode({'messageType': messageType});
  }
}

/// A message sent when a bad request is received.
class BadRequestMessage extends WebSocketMessage {
  /// The type of message.
  static const String messageType = 'bad_request_message';

  /// The request that was bad.
  final String request;

  /// Creates a new [BadRequestMessage].
  BadRequestMessage(Map data) : request = data['request'];

  /// Builds a [BadRequestMessage] message.
  static String buildMessage(String request) {
    return jsonEncode({
      'messageType': messageType,
      'request': request,
    });
  }
}

/// Exception thrown when an unknown message is received.
class UnknownMessageException implements Exception {
  /// The JSON string that was not recognized.
  final String jsonString;

  /// An optional error that occurred when parsing the message.
  final Object? error;

  /// An optional stack trace for the error.
  final StackTrace? stackTrace;

  /// Creates a new [UnknownMessageException].
  UnknownMessageException(
    this.jsonString, {
    this.error,
    this.stackTrace,
  });
}
