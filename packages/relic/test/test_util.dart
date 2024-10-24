import 'dart:async';
import 'dart:typed_data';

import 'package:relic/relic.dart';
import 'package:relic/src/method/method.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

// "hello,"
final helloBytes = Uint8List.fromList([104, 101, 108, 108, 111, 44]);

// " world"
final worldBytes = Uint8List.fromList([32, 119, 111, 114, 108, 100]);

final Matcher throwsHijackException = throwsA(isA<HijackException>());

/// A simple, synchronous handler for [Request].
///
/// By default, replies with a status code 200, empty headers, and
/// `Hello from ${request.url.path}`.
Response syncHandler(Request request, {int? statusCode, Headers? headers}) {
  return Response(
    statusCode ?? 200,
    headers: headers ?? Headers.response(),
    body: Body.fromString('Hello from ${request.requestedUri.path}'),
  );
}

/// Calls [syncHandler] and wraps the response in a [Future].
Future<Response> asyncHandler(Request request) =>
    Future(() => syncHandler(request));

/// Makes a simple GET request to [handler] and returns the result.
Future<Response> makeSimpleRequest(Handler handler) =>
    Future.sync(() => handler(_request));

final _request = Request(Method.get, localhostUri);

final localhostUri = Uri.parse('http://localhost/');

final isOhNoStateError =
    isA<StateError>().having((p0) => p0.message, 'message', 'oh no');

/// Sends a mock HTTP GET request to the [server] and returns the parsed headers.
///
/// - [server]: The [RelicServer] to send the request to.
/// - [headers]: A [Map] of headers to include in the request.
/// - [strictHeaders]: Enforces strict header parsing if set to `true` (default: `false`).
///
/// Returns a [Future] that completes with the [Headers] from the request or throws an error.

Future<Headers> getServerRequestHeaders({
  required RelicServer server,
  required Map<String, String> headers,
  bool strictHeaders = false,
}) async {
  final Completer<Headers> completer = Completer();

  server.mount(
    (Request request) {
      completer.complete(request.headers);
      return Response.ok();
    },
    strictHeaders: strictHeaders,
    exceptionHandler: (error, stackTrace) async {
      completer.completeError(error);
      return Response.internalServerError();
    },
  );

  http.get(server.url, headers: headers);
  return completer.future.timeout(const Duration(seconds: 1));
}
