// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'body.dart';
import 'headers.dart';
import 'message.dart';
import 'util.dart';

/// The response returned by a [Handler].
class Response extends Message {
  /// The HTTP status code of the response.
  final int statusCode;

  /// Constructs a 200 OK response.
  ///
  /// This indicates that the request has succeeded.
  ///
  /// {@template shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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
  /// {@macro shelf_response_body_and_encoding_param}
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

  /// Constructs an HTTP response with the given [statusCode].
  ///
  /// [statusCode] must be greater than or equal to 100.
  ///
  /// {@macro shelf_response_body_and_encoding_param}
  Response(
    this.statusCode, {
    Body? body,
    Headers? headers,
    Encoding? encoding,
    Map<String, Object>? context,
  }) : super(
          body ?? Body.empty(),
          headers ?? Headers.response(),
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
  Response change({
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

  Future<void> writeHttpResponse(
    HttpResponse httpResponse,
    String? poweredByHeader,
  ) {
    if (context.containsKey('shelf.io.buffer_output')) {
      httpResponse.bufferOutput = context['shelf.io.buffer_output'] as bool;
    }

    httpResponse.statusCode = statusCode;

    // An adapter must not add or modify the `Transfer-Encoding` parameter, but
    // the Dart SDK sets it by default. Set this before we fill in
    // [response.headers] so that the user or Shelf can explicitly override it if
    // necessary.
    httpResponse.headers.chunkedTransferEncoding = false;

    headers.applyHeaders(httpResponse, body);

    // TODO: Support chunked transfer encoding
    // var coding = headers['transfer-encoding'];
    // if (coding != null && !equalsIgnoreAsciiCase(coding, 'identity')) {
    //   // If the response is already in a chunked encoding, de-chunk it because
    //   // otherwise `dart:io` will try to add another layer of chunking.
    //   //
    //   // TODO(nweiz): Do this more cleanly when sdk#27886 is fixed.
    //   var body = Body.fromDataStream(
    //     chunkedCoding.encoder
    //         .bind(read())
    //         .map((list) => Uint8List.fromList(list)),
    //   );

    //   // TODO: Fix
    //   // ignore: unused_local_variable
    //   var response = change(
    //     body: body,
    //   );
    //   httpResponse.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
    // } else if (statusCode >= 200 &&
    //     statusCode != 204 &&
    //     statusCode != 304 &&
    //     contentLength == null &&
    //     mimeType != 'multipart/byteranges') {
    //   // If the response isn't chunked yet and there's no other way to tell its
    //   // length, enable `dart:io`'s chunked encoding.
    //   httpResponse.headers.set(HttpHeaders.transferEncodingHeader, 'chunked');
    // }

    // if (poweredByHeader != null &&
    //     !headers.containsKey(_xPoweredByResponseHeader)) {
    //   httpResponse.headers.set(_xPoweredByResponseHeader, poweredByHeader);
    // }

    // if (!headers.containsKey(HttpHeaders.dateHeader)) {
    //   httpResponse.headers.date = DateTime.now().toUtc();
    // }

    return httpResponse.addStream(read()).then((_) => httpResponse.close());
  }
}
