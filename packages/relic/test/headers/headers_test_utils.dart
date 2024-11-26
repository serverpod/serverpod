import 'dart:async';

import 'package:relic/relic.dart';
import 'package:http/http.dart' as http;

/// Thrown when the server returns a 400 status code.
class BadRequestException implements Exception {
  final String message;

  BadRequestException(
    this.message,
  );
}

/// Returns the headers from the server request if the server returns a 200
/// status code. Otherwise, throws an exception.
Future<Headers> getServerRequestHeaders({
  required RelicServer server,
  required Map<String, String> headers,
}) async {
  Headers? parsedHeaders;

  server.mountAndStart(
    (Request request) {
      parsedHeaders = request.headers;
      return Response.ok();
    },
  );

  final response = await http.get(server.url, headers: headers);

  var statusCode = response.statusCode;

  if (statusCode == 400) {
    throw BadRequestException(
      response.body,
    );
  }

  if (statusCode != 200) {
    throw StateError(
      'Unexpected response from server: Status:${response.statusCode}: Response: ${response.body}',
    );
  }

  if (parsedHeaders == null) {
    throw StateError(
      'No headers were parsed from the request',
    );
  }

  return parsedHeaders!;
}
