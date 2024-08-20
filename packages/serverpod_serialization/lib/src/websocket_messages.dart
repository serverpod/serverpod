import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_serialization/src/websocket_message_keys.dart';

/// Base class for messages sent over a WebSocket connection.
sealed class WebSocketMessage {
  /// The keyword used for the message type in the websocket message.
  static const String _messageTypeKeyword = WebSocketMessageKey.messageTypeKey;

  /// The keyword used for the message data in the websocket message.
  static const String _messageDataKeyword = WebSocketMessageKey.messageDataKey;

  static String _buildMessage(
    String messageType, [
    Map<String, dynamic>? data,
  ]) {
    return SerializationManager.encodeForProtocol({
      _messageTypeKeyword: messageType,
      if (data != null) _messageDataKeyword: data,
    });
  }

  /// Converts a JSON string to a [WebSocketMessage] object.
  ///
  /// Throws an [UnknownMessageException] if the message is not recognized.
  static WebSocketMessage fromJsonString(
    String jsonString,
    SerializationManager serializationManager,
  ) {
    try {
      Map data = jsonDecode(jsonString) as Map;

      var messageType = data[_messageTypeKeyword];
      var messageData = data[_messageDataKeyword];

      switch (messageType) {
        case PingCommand._messageType:
          return PingCommand();
        case PongCommand._messageType:
          return PongCommand();
        case BadRequestMessage._messageType:
          return BadRequestMessage(messageData);
        case OpenMethodStreamCommand._messageType:
          return OpenMethodStreamCommand(messageData);
        case OpenMethodStreamResponse._messageType:
          return OpenMethodStreamResponse(messageData);
        case CloseMethodStreamCommand._messageType:
          return CloseMethodStreamCommand(messageData);
        case MethodStreamMessage._messageType:
          return MethodStreamMessage(
            messageData,
            serializationManager,
          );
        case MethodStreamSerializableException._messageType:
          return MethodStreamSerializableException(
            messageData,
            serializationManager,
          );
      }

      throw UnknownMessageException(jsonString, error: 'Unknown message type');
    } on UnknownMessageException {
      rethrow;
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

  /// The endpoint called.
  final String endpoint;

  /// The method called.
  final String method;

  /// The response type.
  final OpenMethodStreamResponseType responseType;

  /// Creates a new [OpenMethodStreamResponse].
  OpenMethodStreamResponse(Map data)
      : connectionId = UuidValueJsonExtension.fromJson(
            data[WebSocketMessageDataKey.connectionIdKey]),
        endpoint = data[WebSocketMessageDataKey.endpointKey],
        method = data[WebSocketMessageDataKey.methodKey],
        responseType = OpenMethodStreamResponseType.tryParse(
          data[WebSocketMessageDataKey.responseTypeKey],
        );

  /// Builds a new [OpenMethodStreamResponse] message.
  static String buildMessage({
    required UuidValue connectionId,
    required OpenMethodStreamResponseType responseType,
    required String endpoint,
    required String method,
  }) {
    return WebSocketMessage._buildMessage(
      _messageType,
      {
        WebSocketMessageDataKey.connectionIdKey: connectionId,
        WebSocketMessageDataKey.responseTypeKey: responseType.name,
        WebSocketMessageDataKey.endpointKey: endpoint,
        WebSocketMessageDataKey.methodKey: method,
      },
    );
  }

  @override
  String toString() => buildMessage(
        connectionId: connectionId,
        responseType: responseType,
        endpoint: endpoint,
        method: method,
      );
}

/// A message sent over a websocket connection to open a websocket stream of
/// data to an endpoint method.
///
/// An [OpenMethodStreamResponse] should be sent in response to this message.
class OpenMethodStreamCommand extends WebSocketMessage {
  static const String _messageType =
      WebSocketMessageTypeKey.openMethodStreamCommandTypeKey;

  /// The endpoint to call.
  final String endpoint;

  /// The method to call.
  final String method;

  /// The arguments to pass to the method.
  final String args;

  /// The input streams that should be opened.
  final List<String> inputStreams;

  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  /// The authentication token.
  final String? authentication;

  /// Creates a new [OpenMethodStreamCommand] message.
  OpenMethodStreamCommand(Map data)
      : endpoint = data[WebSocketMessageDataKey.endpointKey],
        method = data[WebSocketMessageDataKey.methodKey],
        args = data[WebSocketMessageDataKey.argsKey],
        connectionId = UuidValueJsonExtension.fromJson(
            data[WebSocketMessageDataKey.connectionIdKey]),
        authentication = data[WebSocketMessageDataKey.authenticationKey],
        inputStreams =
            List<String>.from(data[WebSocketMessageDataKey.inputStreamsKey]);

  /// Creates a new [OpenMethodStreamCommand].
  static String buildMessage({
    required String endpoint,
    required String method,
    required Map<String, dynamic> args,
    required UuidValue connectionId,
    required List<String> inputStreams,
    String? authentication,
  }) {
    return WebSocketMessage._buildMessage(_messageType, {
      WebSocketMessageDataKey.endpointKey: endpoint,
      WebSocketMessageDataKey.methodKey: method,
      WebSocketMessageDataKey.connectionIdKey: connectionId,
      WebSocketMessageDataKey.argsKey:
          SerializationManager.encodeForProtocol(args),
      WebSocketMessageDataKey.inputStreamsKey: inputStreams,
      if (authentication != null)
        WebSocketMessageDataKey.authenticationKey: authentication,
    });
  }

  @override
  String toString() => WebSocketMessage._buildMessage(_messageType, {
        WebSocketMessageDataKey.endpointKey: endpoint,
        WebSocketMessageDataKey.methodKey: method,
        WebSocketMessageDataKey.connectionIdKey:
            SerializationManager.encodeForProtocol(connectionId),
        WebSocketMessageDataKey.argsKey: args,
        WebSocketMessageDataKey.inputStreamsKey: inputStreams,
        if (authentication != null)
          WebSocketMessageDataKey.authenticationKey: authentication,
      }).toString();
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
  static const String _messageType =
      WebSocketMessageTypeKey.closeMethodStreamCommandTypeKey;

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
      : endpoint = data[WebSocketMessageDataKey.endpointKey],
        method = data[WebSocketMessageDataKey.methodKey],
        connectionId = UuidValueJsonExtension.fromJson(
            data[WebSocketMessageDataKey.connectionIdKey]),
        parameter = data[WebSocketMessageDataKey.parameterKey],
        reason =
            CloseReason.tryParse(data[WebSocketMessageDataKey.closeReasonKey]);

  /// Creates a new [CloseMethodStreamCommand] message.
  static String buildMessage({
    required String endpoint,
    required UuidValue connectionId,
    String? parameter,
    required String method,
    required CloseReason reason,
  }) {
    return WebSocketMessage._buildMessage(_messageType, {
      WebSocketMessageDataKey.endpointKey: endpoint,
      WebSocketMessageDataKey.methodKey: method,
      WebSocketMessageDataKey.connectionIdKey: connectionId,
      if (parameter != null) WebSocketMessageDataKey.parameterKey: parameter,
      WebSocketMessageDataKey.closeReasonKey: reason.name,
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
  static const String _messageType = WebSocketMessageTypeKey.pingCommandTypeKey;

  /// Builds a [PingCommand] message.
  static String buildMessage() {
    return WebSocketMessage._buildMessage(_messageType);
  }

  @override
  String toString() => buildMessage();
}

/// A response to a [PingCommand].
class PongCommand extends WebSocketMessage {
  static const String _messageType = WebSocketMessageTypeKey.pongCommandTypeKey;

  /// Builds a [PongCommand] message.
  static String buildMessage() {
    return WebSocketMessage._buildMessage(_messageType);
  }

  @override
  String toString() => buildMessage();
}

/// A serializable exception sent over a method stream.
class MethodStreamSerializableException extends WebSocketMessage {
  static const String _messageType =
      WebSocketMessageTypeKey.methodStreamSerializableExceptionTypeKey;

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
  )   : endpoint = data[WebSocketMessageDataKey.endpointKey],
        method = data[WebSocketMessageDataKey.methodKey],
        connectionId = UuidValueJsonExtension.fromJson(
            data[WebSocketMessageDataKey.connectionIdKey]),
        parameter = data[WebSocketMessageDataKey.parameterKey],
        exception = serializationManager
            .deserializeByClassName(data[WebSocketMessageDataKey.exceptionKey]);

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
    return WebSocketMessage._buildMessage(
      _messageType,
      {
        WebSocketMessageDataKey.endpointKey: endpoint,
        WebSocketMessageDataKey.methodKey: method,
        WebSocketMessageDataKey.connectionIdKey: connectionId,
        if (parameter != null) WebSocketMessageDataKey.parameterKey: parameter,
        WebSocketMessageDataKey.exceptionKey:
            serializationManager.wrapWithClassName(object),
      },
    );
  }

  @override
  String toString() => WebSocketMessage._buildMessage(
        _messageType,
        {
          WebSocketMessageDataKey.endpointKey: endpoint,
          WebSocketMessageDataKey.methodKey: method,
          WebSocketMessageDataKey.connectionIdKey: connectionId,
          if (parameter != null)
            WebSocketMessageDataKey.parameterKey: parameter,
          WebSocketMessageDataKey.exceptionKey: exception,
        },
      ).toString();
}

/// A message sent to a method stream.
class MethodStreamMessage extends WebSocketMessage {
  static const String _messageType =
      WebSocketMessageTypeKey.methodStreamMessageTypeKey;

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
      : endpoint = data[WebSocketMessageDataKey.endpointKey],
        method = data[WebSocketMessageDataKey.methodKey],
        connectionId = UuidValueJsonExtension.fromJson(
            data[WebSocketMessageDataKey.connectionIdKey]),
        parameter = data[WebSocketMessageDataKey.parameterKey],
        object = serializationManager
            .deserializeByClassName(data[WebSocketMessageDataKey.objectKey]);

  /// Builds a [MethodStreamMessage] message.
  static String buildMessage({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    String? parameter,
    required dynamic object,
    required SerializationManager serializationManager,
  }) {
    return WebSocketMessage._buildMessage(_messageType, {
      WebSocketMessageDataKey.endpointKey: endpoint,
      WebSocketMessageDataKey.methodKey: method,
      WebSocketMessageDataKey.connectionIdKey: connectionId,
      if (parameter != null) WebSocketMessageDataKey.parameterKey: parameter,
      WebSocketMessageDataKey.objectKey:
          serializationManager.wrapWithClassName(object),
    });
  }

  @override
  String toString() => WebSocketMessage._buildMessage(
        _messageType,
        {
          WebSocketMessageDataKey.endpointKey: endpoint,
          WebSocketMessageDataKey.methodKey: method,
          WebSocketMessageDataKey.connectionIdKey: connectionId,
          if (parameter != null)
            WebSocketMessageDataKey.parameterKey: parameter,
          WebSocketMessageDataKey.objectKey: object,
        },
      ).toString();
}

/// A message sent when a bad request is received.
class BadRequestMessage extends WebSocketMessage {
  static const String _messageType =
      WebSocketMessageTypeKey.badRequestMessageTypeKey;

  /// The request that was bad.
  final String request;

  /// Creates a new [BadRequestMessage].
  BadRequestMessage(Map data)
      : request = data[WebSocketMessageDataKey.requestKey];

  /// Builds a [BadRequestMessage] message.
  static String buildMessage(String request) {
    return WebSocketMessage._buildMessage(
      _messageType,
      {
        WebSocketMessageDataKey.requestKey: request,
      },
    );
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
