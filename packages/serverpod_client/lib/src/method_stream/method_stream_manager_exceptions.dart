import 'package:serverpod_client/serverpod_client.dart';

/// Exceptions thrown by the [ClientMethodStreamManager].
abstract class MethodStreamExceptions implements Exception {
  /// Creates a new [MethodStreamExceptions].
  const MethodStreamExceptions();
}

/// Thrown if the WebSocket connection fails.
class WebSocketConnectException extends MethodStreamExceptions {
  /// The error that caused the exception.
  final Object? error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// Creates a new [WebSocketConnectException].
  const WebSocketConnectException(this.error, [this.stackTrace]);
}

/// Thrown if connection attempt timed out.
class ConnectionAttemptTimedOutException extends MethodStreamExceptions {}

/// Thrown if an error occurs when listening to the WebSocket connection.
class WebSocketListenException extends MethodStreamExceptions {
  /// The error that caused the exception.
  final Object? error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// Creates a new [WebSocketListenException].
  const WebSocketListenException(this.error, [this.stackTrace]);
}

/// Thrown if the WebSocket connection is closed.
class WebSocketClosedException extends MethodStreamExceptions {
  /// Creates a new [WebSocketClosedException].
  const WebSocketClosedException();
}

/// Thrown if opening a method stream fails.
class OpenMethodStreamException extends MethodStreamExceptions {
  /// The response type that caused the exception.
  final OpenMethodStreamResponseType responseType;

  /// Creates a new [OpenMethodStreamException].
  const OpenMethodStreamException(this.responseType);
}
