import 'package:serverpod_client/serverpod_client.dart';

/// Exceptions thrown by the [ClientMethodStreamManager].
abstract class MethodStreamException implements Exception {
  /// The error message to show to the user.
  final String message;

  /// Creates a new [MethodStreamException].
  const MethodStreamException(this.message);

  @override
  String toString() => message;
}

/// Thrown if the WebSocket connection fails.
class WebSocketConnectException extends MethodStreamException {
  /// The error that caused the exception.
  final Object? error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// Creates a new [WebSocketConnectException].
  const WebSocketConnectException(this.error, [this.stackTrace])
    : super('Method stream WebSocket failed to connect with error: $error');
}

/// Thrown if connection attempt timed out.
class ConnectionAttemptTimedOutException extends MethodStreamException {
  /// Creates a new [ConnectionAttemptTimedOutException].
  const ConnectionAttemptTimedOutException()
    : super('Method stream connection attempt timed out');
}

/// Thrown if an error occurs when listening to the WebSocket connection.
class WebSocketListenException extends MethodStreamException {
  /// The error that caused the exception.
  final Object? error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// Creates a new [WebSocketListenException].
  const WebSocketListenException(this.error, [this.stackTrace])
    : super('Method stream WebSocket listen error: $error');
}

/// Thrown if the WebSocket connection is closed.
class WebSocketClosedException extends MethodStreamException {
  /// Creates a new [WebSocketClosedException].
  const WebSocketClosedException()
    : super('Method stream WebSocket connection closed');
}

/// Thrown if opening a method stream fails.
class OpenMethodStreamException extends MethodStreamException {
  /// The response type that caused the exception.
  final OpenMethodStreamResponseType responseType;

  /// Creates a new [OpenMethodStreamException].
  OpenMethodStreamException(this.responseType)
    : super(
        'Failed to open method stream with response type "${responseType.name}"',
      );
}

/// Thrown if the connection is closed with an error.
class ConnectionClosedException extends MethodStreamException {
  /// Creates a new [ConnectionClosedException].
  const ConnectionClosedException()
    : super('Method stream connection closed with an error');
}

/// Thrown if the method stream connection is idle for too long.
class MethodStreamIdleTimeoutException extends MethodStreamException {
  /// Creates a new [MethodStreamIdleTimeoutException].
  const MethodStreamIdleTimeoutException()
    : super('Method stream connection idle timeout');
}
