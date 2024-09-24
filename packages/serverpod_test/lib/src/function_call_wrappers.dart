import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'test_stream_manager.dart';

/// Test tools helper to not leak exceptions from awaitable functions.
/// Used by the generated code.
Future<T> callAwaitableFunctionAndHandleExceptions<T>(
  Future<T> Function() call,
) async {
  try {
    return await call();
  } catch (e) {
    var handledException = getException(e);
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
  TestStreamManager streamManager,
) async {
  late Stream<T> stream;
  try {
    stream = await call();
  } catch (e) {
    streamManager.outputStreamController.addError(getException(e));
    return;
  }

  streamManager.setOutputStream(stream);
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

/// Returns a test exception based on the [authenticationFailureReason].
Exception getTestAuthorizationException(
  AuthenticationFailureReason authenticationFailureReason,
) {
  return switch (authenticationFailureReason) {
    AuthenticationFailureReason.unauthenticated =>
      ServerpodUnauthenticatedException(),
    AuthenticationFailureReason.insufficientAccess =>
      ServerpodInsufficientAccessException(),
  };
}

/// Returns the exception that should be exposed to the test.
dynamic getException(dynamic e) {
  switch (e) {
    case NotAuthorizedException():
      return getTestAuthorizationException(e.authenticationFailedResult.reason);
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
