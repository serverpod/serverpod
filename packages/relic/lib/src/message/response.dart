import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/typed/headers/transfer_encoding_header.dart';

import '../body/body.dart';
import '../headers/headers.dart';
import 'message.dart';
import '../util/util.dart';

/// The response returned by a [Handler].
class Response extends Message {
  /// The HTTP status code of the response.
  final int statusCode;

  /// Constructs a 200 OK response.
  ///
  /// This indicates that the request has succeeded.
  ///
  /// {@template relic_response_body_and_encoding_param}
  /// [body] is the response body. It may be either a [String], a [List<int>], a
  /// [Stream<List<int>>], or `null` to indicate no body.
  ///
  /// If the body is a [String], [encoding] is used to encode it to a
  /// [Stream<List<int>>]. It defaults to UTF-8. If it's a [String], a
  /// [List<int>], or `null`, the Content-Length header is set automatically
  /// unless a Transfer-Encoding header is set. Otherwise, it's a
  /// [Stream<List<int>>] and no Transfer-Encoding header is set, the adapter
  /// will set the Transfer-Encoding header to "chunked" and apply the chunked
  /// encoding to the body.
  ///
  /// If [encoding] is passed, the "encoding" field of the Content-Type header
  /// in [headers] will be set appropriately. If there is no existing
  /// Content-Type header, it will be set to "application/octet-stream".
  /// [headers] must contain values that are either `String` or `List<String>`.
  /// An empty list will cause the header to be omitted.
  /// {@endtemplate}
  Response.ok({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          200,
          body: body ?? Body.empty(),
          headers: headers ?? Headers.response(),
          encoding: encoding,
          context: context,
        );

  /// Constructs a 301 Moved Permanently response.
  ///
  /// This indicates that the requested resource has moved permanently to a new
  /// URI. [location] is that URI; it can be either a [String] or a [Uri]. It's
  /// automatically set as the Location header in [headers].
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.movedPermanently(
    Uri location, {
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this._redirect(
          301,
          location,
          body,
          headers,
          encoding,
          context: context,
        );

  /// Constructs a 302 Found response.
  ///
  /// This indicates that the requested resource has moved temporarily to a new
  /// URI. [location] is that URI; it can be either a [String] or a [Uri]. It's
  /// automatically set as the Location header in [headers].
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.found(
    Uri location, {
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this._redirect(
          302,
          location,
          body,
          headers,
          encoding,
          context: context,
        );

  /// Constructs a 303 See Other response.
  ///
  /// This indicates that the response to the request should be retrieved using
  /// a GET request to a new URI. [location] is that URI; it can be either a
  /// [String] or a [Uri]. It's automatically set as the Location header in
  /// [headers].
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.seeOther(
    Uri location, {
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this._redirect(303, location, body, headers, encoding, context: context);

  /// Constructs a helper constructor for redirect responses.
  Response._redirect(
    int statusCode,
    Uri location,
    Body? body,
    Headers? headers,
    Encoding? encoding, {
    Map<String, Object>? context,
  }) : this(
          statusCode,
          body: body ?? Body.empty(),
          encoding: encoding,
          headers: headers?.copyWith(location: location) ??
              Headers.response(location: location),
          context: context,
        );

  /// Constructs a 304 Not Modified response.
  ///
  /// This is used to respond to a conditional GET request that provided
  /// information used to determine whether the requested resource has changed
  /// since the last request. It indicates that the resource has not changed and
  /// the old value should be used.
  ///
  /// [headers] must contain values that are either `String` or `List<String>`.
  /// An empty list will cause the header to be omitted.
  ///
  /// If [headers] contains a value for `content-length` it will be removed.
  Response.notModified({
    Headers? headers,
    Map<String, Object>? context,
  }) : this(
          304,
          body: Body.empty(),
          context: context,
          headers: (headers ?? Headers.response()),
        );

  /// Constructs a 400 Bad Request response.
  ///
  /// This indicates that the server has received a malformed request.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.badRequest({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          400,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Bad Request'),
          context: context,
          encoding: encoding,
        );

  /// Constructs a 401 Unauthorized response.
  ///
  /// This indicates indicates that the client request has not been completed
  /// because it lacks valid authentication credentials.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.unauthorized({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          401,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Unauthorized'),
          context: context,
          encoding: encoding,
        );

  /// Constructs a 403 Forbidden response.
  ///
  /// This indicates that the server is refusing to fulfill the request.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.forbidden({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          403,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Forbidden'),
          context: context,
          encoding: encoding,
        );

  /// Constructs a 404 Not Found response.
  ///
  /// This indicates that the server didn't find any resource matching the
  /// requested URI.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.notFound({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          404,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Not Found'),
          context: context,
          encoding: encoding,
        );

  /// Constructs a 500 Internal Server Error response.
  ///
  /// This indicates that the server had an internal error that prevented it
  /// from fulfilling the request.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.internalServerError({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          500,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Internal Server Error'),
          context: context,
          encoding: encoding,
        );

  /// Constructs a 501 Not Implemented response.
  ///
  /// This indicates that the server does not support the functionality required
  /// to fulfill the request.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response.notImplemented({
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : this(
          501,
          headers: headers ?? Headers.response(),
          body: body ?? Body.fromString('Not Implemented'),
          context: context,
          encoding: encoding,
        );

  /// Constructs an HTTP response with the given [statusCode].
  ///
  /// [statusCode] must be greater than or equal to 100.
  ///
  /// {@macro relic_response_body_and_encoding_param}
  Response(
    this.statusCode, {
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : super(
          body: body ?? Body.empty(),
          headers: headers ?? Headers.response(),
          context: context ?? {},
        ) {
    if (statusCode < 100) {
      throw ArgumentError('Invalid status code: $statusCode.');
    }
  }

  /// Creates a new [Response] by copying existing values and applying specified
  /// changes.
  ///
  /// New key-value pairs in [context] and [headers] will be added to the copied
  /// [Response].
  ///
  /// If [context] or [headers] includes a key that already exists, the
  /// key-value pair will replace the corresponding entry in the copied
  /// [Response]. If [context] or [headers] contains a `null` value the
  /// corresponding `key` will be removed if it exists, otherwise the `null`
  /// value will be ignored.
  /// For [headers] a value which is an empty list will also cause the
  /// corresponding key to be removed.
  ///
  /// All other context and header values from the [Response] will be included
  /// in the copied [Response] unchanged.
  ///
  /// [body] is the response body. It may be either a [String], a [List<int>], a
  /// [Stream<List<int>>], or `<int>[]` (empty list) to indicate no body.
  @override
  Response copyWith({
    Headers? headers,
    Map<String, Object?>? context,
    Body? body,
  }) {
    final newContext = updateMap(this.context, context);

    return Response(
      statusCode,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      context: newContext,
    );
  }

  /// Writes the response to an [HttpResponse].
  ///
  /// This method sets the status code, headers, and body on the [httpResponse]
  /// and returns a [Future] that completes when the body has been written.
  Future<void> writeHttpResponse(
    HttpResponse httpResponse,
  ) async {
    if (context.containsKey('relic_server.buffer_output')) {
      httpResponse.bufferOutput = context['relic_server.buffer_output'] as bool;
    }

    httpResponse.statusCode = statusCode;

    headers.applyHeaders(
      httpResponse,
      body,
    );

    var mBody = _handleTransferEncoding(
      httpResponse,
      headers.transferEncoding,
      statusCode,
      body,
    );

    return httpResponse
        .addStream(mBody.read())
        .then((_) => httpResponse.close());
  }
}

Body _handleTransferEncoding(
  HttpResponse httpResponse,
  TransferEncodingHeader? transferEncoding,
  int statusCode,
  Body body,
) {
  if (transferEncoding?.isChunked == true) {
    // If the response is already chunked, decode it to avoid double chunking.
    body = Body.fromDataStream(
      chunkedCoding.decoder.bind(body.read()).cast<Uint8List>(),
    );
    httpResponse.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
    return body;
  } else if (_shouldEnableChunkedEncoding(statusCode, body)) {
    // If content length is unknown and chunking is needed, set chunked encoding.
    httpResponse.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
  }
  return body;
}

bool _shouldEnableChunkedEncoding(int statusCode, Body body) {
  return statusCode >= 200 &&
      statusCode != 204 &&
      statusCode != 304 &&
      body.contentLength == null &&
      body.contentType?.mimeType.toString() != 'multipart/byteranges';
}
