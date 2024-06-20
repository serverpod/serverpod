import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

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
        case PingCommand._messageType:
          return PingCommand();
        case PongCommand._messageType:
          return PongCommand();
        case BadRequestMessage._messageType:
          return BadRequestMessage(data);
        case OpenMethodStreamCommand._messageType:
          return OpenMethodStreamCommand(data);
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

/// A message sent over a websocket connection to open a websocket stream of
/// data to an endpoint method.
class OpenMethodStreamCommand extends WebSocketMessage {
  static const String _messageType = 'open_method_stream_command';

  /// The endpoint to call.
  final String endpoint;

  /// The method to call.
  final String method;

  /// The arguments to pass to the method.
  final String args;

  /// The UUID of the stream.
  final String uuid;

  /// The authentication token.
  final String? auth;

  /// Creates a new [OpenMethodStreamCommand] message.
  OpenMethodStreamCommand(Map data)
      : endpoint = data['endpoint'],
        method = data['method'],
        args = data['args'],
        uuid = data['uuid'],
        auth = data['auth'];

  /// Creates a new [OpenMethodStreamCommand].
  static String buildMessage({
    required String endpoint,
    required String method,
    required Map<String, dynamic> args,
    required String uuid,
    String? auth,
  }) {
    return jsonEncode({
      'messageType': _messageType,
      'endpoint': endpoint,
      'method': method,
      'uuid': uuid,
      'args': SerializationManager.encodeForProtocol(args),
      if (auth != null) 'auth': auth,
    });
  }

  @override
  String toString() => {
        'messageType': _messageType,
        'endpoint': endpoint,
        'method': method,
        'uuid': uuid,
        'args': args,
        if (auth != null) 'auth': auth,
      }.toString();
}

/// A message sent over a websocket connection to check if the connection is
/// still alive. The other end should respond with a [PongCommand].
class PingCommand extends WebSocketMessage {
  static const String _messageType = 'ping_command';

  /// Builds a [PingCommand] message.
  static String buildMessage() {
    return jsonEncode({'messageType': _messageType});
  }

  @override
  String toString() => buildMessage();
}

/// A response to a [PingCommand].
class PongCommand extends WebSocketMessage {
  static const String _messageType = 'pong_command';

  /// Builds a [PongCommand] message.
  static String buildMessage() {
    return jsonEncode({'messageType': _messageType});
  }

  @override
  String toString() => buildMessage();
}

/// A message sent when a bad request is received.
class BadRequestMessage extends WebSocketMessage {
  static const String _messageType = 'bad_request_message';

  /// The request that was bad.
  final String request;

  /// Creates a new [BadRequestMessage].
  BadRequestMessage(Map data) : request = data['request'];

  /// Builds a [BadRequestMessage] message.
  static String buildMessage(String request) {
    return jsonEncode({
      'messageType': _messageType,
      'request': request,
    });
  }

  @override
  String toString() => buildMessage(request);
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
