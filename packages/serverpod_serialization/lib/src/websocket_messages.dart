import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Base class for messages sent over a WebSocket connection.
sealed class WebSocketMessage {
  /// Converts a JSON string to a [WebSocketMessage] object.
  ///
  /// Throws an [UnknownMessageException] if the message is not recognized.
  static WebSocketMessage fromJsonString(
    String jsonString,
    SerializationManager serializationManager,
  ) {
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
        case OpenMethodStreamResponse._messageType:
          return OpenMethodStreamResponse(data);
        case CloseMethodStreamCommand._messageType:
          return CloseMethodStreamCommand(data);
        case MethodStreamMessage._messageType:
          return MethodStreamMessage(data, serializationManager);
        case MethodStreamSerializableException._messageType:
          return MethodStreamSerializableException(data, serializationManager);
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

/// The response to an [OpenMethodStreamCommand].
enum OpenMethodStreamResponseType {
  /// The stream was successfully opened.
  success,

  /// The endpoint was not found.
  endpointNotFound,

  /// The user is not authenticated.
  authenticationFailed,

  /// The user is not authorized.
  authorizationDeclined,

  /// The arguments were invalid.
  invalidArguments;

  /// Try to parse a [OpenMethodStreamResponseType] from a string.
  /// Throws an exception if the string is not recognized.
  static OpenMethodStreamResponseType tryParse(String name) {
    return OpenMethodStreamResponseType.values.firstWhere(
      (element) => element.name == name,
    );
  }
}

/// A message sent over a websocket connection to respond to an
/// [OpenMethodStreamCommand].
class OpenMethodStreamResponse extends WebSocketMessage {
  static const String _messageType = 'open_method_stream_response';

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The response type.
  final OpenMethodStreamResponseType responseType;

  /// Creates a new [OpenMethodStreamResponse].
  OpenMethodStreamResponse(Map data)
      : connectionId = UuidValueJsonExtension.fromJson(data['connectionId']),
        responseType = OpenMethodStreamResponseType.tryParse(
          data['responseType'],
        );

  /// Builds a new [OpenMethodStreamResponse] message.
  static String buildMessage({
    required UuidValue connectionId,
    required OpenMethodStreamResponseType responseType,
  }) {
    return SerializationManager.encodeForProtocol({
      'messageType': _messageType,
      'connectionId': connectionId,
      'responseType': responseType.name,
    });
  }

  @override
  String toString() =>
      buildMessage(connectionId: connectionId, responseType: responseType);
}

/// A message sent over a websocket connection to open a websocket stream of
/// data to an endpoint method.
///
/// An [OpenMethodStreamResponse] should be sent in response to this message.
class OpenMethodStreamCommand extends WebSocketMessage {
  static const String _messageType = 'open_method_stream_command';

  /// The endpoint to call.
  final String endpoint;

  /// The method to call.
  final String method;

  /// The arguments to pass to the method.
  final String args;

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The authentication token.
  final String? authentication;

  /// Creates a new [OpenMethodStreamCommand] message.
  OpenMethodStreamCommand(Map data)
      : endpoint = data['endpoint'],
        method = data['method'],
        args = data['args'],
        connectionId = UuidValueJsonExtension.fromJson(data['connectionId']),
        authentication = data['authentication'];

  /// Creates a new [OpenMethodStreamCommand].
  static String buildMessage({
    required String endpoint,
    required String method,
    required Map<String, dynamic> args,
    required UuidValue connectionId,
    String? authentication,
  }) {
    return SerializationManager.encodeForProtocol({
      'messageType': _messageType,
      'endpoint': endpoint,
      'method': method,
      'connectionId': connectionId,
      'args': SerializationManager.encodeForProtocol(args),
      if (authentication != null) 'authentication': authentication,
    });
  }

  @override
  String toString() => {
        'messageType': _messageType,
        'endpoint': endpoint,
        'method': method,
        'connectionId': SerializationManager.encodeForProtocol(connectionId),
        'args': args,
        if (authentication != null) 'authentication': authentication,
      }.toString();
}

/// The reason a stream was closed.
enum CloseReason {
  /// The stream was closed because the method was done.
  done,

  /// The stream was closed because an error occurred.
  error;

  /// Try to parse a [CloseReason] from a string.
  /// Throws an exception if the string is not recognized.
  static CloseReason tryParse(String name) {
    return CloseReason.values.firstWhere(
      (element) => element.name == name,
    );
  }
}

/// A message sent over a websocket connection to close a websocket stream of
/// data to an endpoint method.
class CloseMethodStreamCommand extends WebSocketMessage {
  static const String _messageType = 'close_method_stream_command';

  /// The endpoint associated with the stream.
  final String endpoint;

  /// The method associated with the stream.
  final String method;

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The parameter associated with the stream.
  /// If this is null the close command targets the return stream of the method.
  final String? parameter;

  /// The reason the stream was closed.
  final CloseReason reason;

  /// Creates a new [CloseMethodStreamCommand].
  CloseMethodStreamCommand(Map data)
      : endpoint = data['endpoint'],
        method = data['method'],
        connectionId = UuidValueJsonExtension.fromJson(data['connectionId']),
        parameter = data['parameter'],
        reason = CloseReason.tryParse(data['reason']);

  /// Creates a new [CloseMethodStreamCommand] message.
  static String buildMessage({
    required String endpoint,
    required UuidValue connectionId,
    String? parameter,
    required String method,
    required CloseReason reason,
  }) {
    return SerializationManager.encodeForProtocol({
      'messageType': _messageType,
      'endpoint': endpoint,
      'method': method,
      'connectionId': connectionId,
      if (parameter != null) 'parameter': parameter,
      'reason': reason.name,
    });
  }

  @override
  String toString() => buildMessage(
        endpoint: endpoint,
        connectionId: connectionId,
        parameter: parameter,
        method: method,
        reason: reason,
      );
}

/// A message sent over a websocket connection to check if the connection is
/// still alive. The other end should respond with a [PongCommand].
class PingCommand extends WebSocketMessage {
  static const String _messageType = 'ping_command';

  /// Builds a [PingCommand] message.
  static String buildMessage() {
    return SerializationManager.encodeForProtocol(
        {'messageType': _messageType});
  }

  @override
  String toString() => buildMessage();
}

/// A response to a [PingCommand].
class PongCommand extends WebSocketMessage {
  static const String _messageType = 'pong_command';

  /// Builds a [PongCommand] message.
  static String buildMessage() {
    return SerializationManager.encodeForProtocol(
        {'messageType': _messageType});
  }

  @override
  String toString() => buildMessage();
}

/// A serializable exception sent over a method stream.
class MethodStreamSerializableException extends WebSocketMessage {
  static const String _messageType = 'method_stream_serializable_exception';

  /// The endpoint the message is sent to.
  final String endpoint;

  /// The method the message is sent to.
  final String method;

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The parameter the message is sent to.
  /// If this is null the message is sent to the return stream of the method.
  final String? parameter;

  /// The serializable exception sent.
  final SerializableException exception;

  /// Creates a new [MethodStreamSerializableException].
  /// The [exception] must be a serializable exception processed by the
  /// [SerializationManager.wrapWithClassName] method.
  MethodStreamSerializableException(
    Map data,
    SerializationManager serializationManager,
  )   : endpoint = data['endpoint'],
        method = data['method'],
        connectionId = UuidValueJsonExtension.fromJson(data['connectionId']),
        parameter = data['parameter'],
        exception =
            serializationManager.deserializeByClassName(data['exception']);

  /// Builds a [MethodStreamSerializableException] message.
  /// The [exception] must be a serializable exception processed by the
  /// [SerializationManager.wrapWithClassName] method.
  static String buildMessage({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    String? parameter,
    required dynamic object,
    required SerializationManager serializationManager,
  }) {
    return SerializationManager.encodeForProtocol({
      'messageType': _messageType,
      'endpoint': endpoint,
      'method': method,
      'connectionId': connectionId,
      if (parameter != null) 'parameter': parameter,
      'exception': serializationManager.wrapWithClassName(object),
    });
  }

  @override
  String toString() => {
        'messageType': _messageType,
        'endpoint': endpoint,
        'method': method,
        'connectionId': connectionId,
        if (parameter != null) 'parameter': parameter,
        'exception': exception,
      }.toString();
}

/// A message sent to a method stream.
class MethodStreamMessage extends WebSocketMessage {
  static const String _messageType = 'method_message';

  /// The endpoint the message is sent to.
  final String endpoint;

  /// The method the message is sent to.
  final String method;

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The parameter the message is sent to.
  /// If this is null the message is sent to the return stream of the method.
  final String? parameter;

  /// The object that was sent.
  final dynamic object;

  /// Creates a new [MethodStreamMessage].
  /// The [object] must be an object processed by the
  /// [SerializationManager.wrapWithClassName] method.
  MethodStreamMessage(Map data, SerializationManager serializationManager)
      : endpoint = data['endpoint'],
        method = data['method'],
        connectionId = UuidValueJsonExtension.fromJson(data['connectionId']),
        parameter = data['parameter'],
        object = serializationManager.deserializeByClassName(data['object']);

  /// Builds a [MethodStreamMessage] message.
  static String buildMessage({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    String? parameter,
    required dynamic object,
    required SerializationManager serializationManager,
  }) {
    return SerializationManager.encodeForProtocol({
      'messageType': _messageType,
      'endpoint': endpoint,
      'method': method,
      'connectionId': connectionId,
      if (parameter != null) 'parameter': parameter,
      'object': serializationManager.wrapWithClassName(object),
    });
  }

  @override
  String toString() => {
        'messageType': _messageType,
        'endpoint': endpoint,
        'method': method,
        'connectionId': connectionId,
        if (parameter != null) 'parameter': parameter,
        'object': object,
      }.toString();
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
    return SerializationManager.encodeForProtocol({
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

  @override
  String toString() {
    return 'UnknownMessageException: $jsonString\n$error\n$stackTrace';
  }
}
