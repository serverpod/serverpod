import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Test tools helper to not leak exceptions.
/// Used for calls to awaitable functions with non-stream input parameters.
/// Used by the generated code.
Future<T> callAwaitableFunctionAndHandleExceptions<T>(
  Future<T> Function() call,
) async {
  try {
    return await call();
  } catch (e) {
    var handledException = _getException(e);
    if (handledException != null) {
      throw handledException;
    }

    // Rethrow user exceptions to preserve stack trace
    rethrow;
  }
}

/// Test tools helper to not leak exceptions.
/// Used for calls to awaitable functions with streams as input parameters.
/// Used by the generated code.
Future<T> callAwaitableFunctionWithStreamInputAndHandleExceptions<T>(
  Future<Stream<T>> Function() call,
) async {
  late Stream<T> stream;
  try {
    stream = await call();
  } catch (e) {
    var handledException = _getException(e);
    if (handledException != null) {
      throw handledException;
    }

    // Rethrow user exceptions to preserve stack trace
    rethrow;
  }

  return stream.first;
}

/// Test tools helper to not leak exceptions.
/// Used for calls to functions that return a stream, regardless of input parameters.
/// Used by the generated code.
Future<void> callStreamFunctionAndHandleExceptions<T>(
  Future<void> Function() call,
  StreamController controllerToCloseUponFailure,
) async {
  try {
    await call();
  } catch (e) {
    controllerToCloseUponFailure.addError(_getException(e));
    await controllerToCloseUponFailure.close();
    return;
  }
}

/// The user was not authenticated.
class ServerpodUnauthenticatedException implements Exception {
  /// Creates a new [ServerpodUnauthenticatedException].
  ServerpodUnauthenticatedException();
}

/// The authentication key provided did not have sufficient access.
class ServerpodInsufficientAccessException implements Exception {
  /// Creates a new [ServerpodInsufficientAccessException].
  ServerpodInsufficientAccessException();
}

/// Thrown if a stream connection is closed with an error.
/// For example, if the user authentication was revoked.
class ConnectionClosedException implements Exception {
  /// Creates a new [ConnectionClosedException].
  const ConnectionClosedException();
}

dynamic _getException(dynamic e) {
  switch (e) {
    case NotAuthorizedException():
      return switch (e.authenticationFailedResult.reason) {
        AuthenticationFailureReason.unauthenticated =>
          ServerpodUnauthenticatedException(),
        AuthenticationFailureReason.insufficientAccess =>
          ServerpodInsufficientAccessException(),
      };
    case MethodNotFoundException():
    case EndpointNotFoundException():
    case InvalidParametersException():
    case InvalidEndpointMethodTypeException():
      return StateError(
        'An unexpected error occured while trying to call the endpoint in the test. '
        'Make sure you have run the `serverpod generate` command.\n ${StackTrace.current}',
      );
    default:
      return null;
  }
}
