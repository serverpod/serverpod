import 'dart:async';
import 'dart:typed_data';

import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';

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

final _request = Request(RequestMethod.get, localhostUri);

final localhostUri = Uri.parse('http://localhost/');

final isOhNoStateError =
    isA<StateError>().having((p0) => p0.message, 'message', 'oh no');
