import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Test tools helper to not leak exceptions from awaitable functions.
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

/// Test tools helper to not leak exceptions from functions that return streams.
/// The [streamController] is used to start executing the endpoint method immediately up to the first `yield`.
/// This removes the need for the caller to start listening to the stream to start the execution.
/// Used by the generated code.
Future<void> callStreamFunctionAndHandleExceptions<T>(
  Future<Stream<T>> Function() call,
  StreamController<T> streamController,
) async {
  late Stream<T> stream;
  try {
    stream = await call();
  } catch (e) {
    streamController.addError(_getException(e));
    return;
  }

  var subscription = stream.listen((data) {
    streamController.add(data);
  }, onError: (e) {
    streamController.addError(_getException(e));
  }, onDone: () {
    streamController.close();
  });

  streamController.onCancel = () {
    subscription.cancel();
  };
}

/// The user was not authenticated.
class UnauthenticatedEndpointCallTestException implements Exception {
  /// Creates a new UnauthenticatedEndpointCallTestException.
  UnauthenticatedEndpointCallTestException();
}

/// The authentication key provided did not have sufficient access.
class InsufficientEndpointAccessTestException implements Exception {
  /// Creates a new InsufficientEndpointAccessTestException.
  InsufficientEndpointAccessTestException();
}

dynamic _getException(dynamic e) {
  switch (e) {
    case NotAuthorizedException():
      return switch (e.authenticationFailedResult.reason) {
        AuthenticationFailureReason.unauthenticated =>
          UnauthenticatedEndpointCallTestException(),
        AuthenticationFailureReason.insufficientAccess =>
          InsufficientEndpointAccessTestException(),
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
