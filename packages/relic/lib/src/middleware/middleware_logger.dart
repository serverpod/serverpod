import 'dart:async';

import 'package:relic/src/logger/logger.dart';
import 'package:relic/src/method/request_method.dart';

import '../hijack/exception/hijack_exception.dart';
import 'middleware.dart';

/// Middleware which prints the time of the request, the elapsed time for the
/// inner handlers, the response's status code and the request URI.
///
/// If [logger] is passed, it's called for each request. The `msg` parameter is
/// a formatted string that includes the request time, duration, request method,
/// and requested path. When an exception is thrown, it also includes the
/// exception's string and stack trace; otherwise, it includes the status code.
/// The `isError` parameter indicates whether the message is caused by an error.
///
/// If [logger] is not passed, the message is just passed to [print].
Middleware logRequests({
  Logger? logger,
}) =>
    (innerHandler) {
      final localLogger = logger ?? logMessage;

      return (request) {
        var startTime = DateTime.now();
        var watch = Stopwatch()..start();

        return Future.sync(
          () => innerHandler(request),
        ).then(
          (response) {
            var msg = _message(
              startTime,
              response.statusCode,
              request.requestedUri,
              request.method.value,
              watch.elapsed,
            );

            localLogger(msg);

            return response;
          },
          onError: (Object error, StackTrace stackTrace) {
            if (error is HijackException) throw error;

            var msg = _errorMessage(
              startTime,
              request.requestedUri,
              request.method,
              watch.elapsed,
              error,
            );

            localLogger(
              msg,
              type: LoggerType.error,
              stackTrace: stackTrace,
            );

            // ignore: only_throw_errors
            throw error;
          },
        );
      };
    };

String _formatQuery(String query) {
  return query == '' ? '' : '?$query';
}

String _message(
  DateTime requestTime,
  int statusCode,
  Uri requestedUri,
  String method,
  Duration elapsedTime,
) {
  return '${requestTime.toIso8601String()} '
      '${elapsedTime.toString().padLeft(15)} '
      '${method.padRight(7)} [$statusCode] ' // 7 - longest standard HTTP method
      '${requestedUri.path}${_formatQuery(requestedUri.query)}';
}

String _errorMessage(
  DateTime requestTime,
  Uri requestedUri,
  RequestMethod method,
  Duration elapsedTime,
  Object error,
) {
  return '$requestTime\t'
      '$elapsedTime\t'
      '${method.value}\t'
      '${requestedUri.path}'
      '${_formatQuery(requestedUri.query)}\n$error';
}
