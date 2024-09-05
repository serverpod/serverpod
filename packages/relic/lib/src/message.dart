// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';

import 'body.dart';
import 'headers.dart';

abstract class Message {
  /// The HTTP headers associated with this message.
  final Headers headers;

  /// Extra context for middleware and handlers.
  final Map<String, Object> context;

  /// The streaming body of the message.
  final Body body;

  Message(
    this.body,
    this.headers, {
    this.context = const {},
  });

  /// Caches the parsed content-length value.
  int? _contentLengthCache;

  /// Returns the content-length from the headers if available, caches it.
  int? get contentLength {
    if (_contentLengthCache != null) return _contentLengthCache;
    var contentLength = headers.contentLength;
    if (contentLength == null) return null;
    _contentLengthCache = int.parse(contentLength);
    return _contentLengthCache;
  }

  /// Caches the parsed Content-Type header.
  MediaType? _contentTypeCache;

  /// Returns the MIME type from the Content-Type header, if available.
  String? get mimeType {
    var contentType = _contentType;
    if (contentType == null) return null;
    return contentType.mimeType;
  }

  /// Returns the encoding specified in the Content-Type header, or null if not specified.
  Encoding? get encoding {
    var contentType = _contentType;
    if (contentType == null) return null;
    if (!contentType.parameters.containsKey('charset')) return null;
    return Encoding.getByName(contentType.parameters['charset']);
  }

  /// Caches and returns the parsed Content-Type header.
  MediaType? get _contentType {
    if (_contentTypeCache != null) return _contentTypeCache;
    final contentTypeValue = headers.contentType;
    if (contentTypeValue == null) return null;
    return _contentTypeCache = MediaType.parse(contentTypeValue);
  }

  /// Reads the body as a stream of bytes. Can only be called once.
  Stream<List<int>> read() => body.read();

  /// Reads the body as a string, decoding it using the specified or detected encoding.
  Future<String> readAsString([Encoding? encoding]) {
    encoding ??= body.contentType.encoding ?? utf8;
    return encoding.decodeStream(read());
  }

  /// Determines if the body is empty by checking the content length.
  bool get isEmpty => body.contentLength == 0;

  /// Creates a new message by copying existing values and applying specified changes.
  Message copyWith({
    Headers headers,
    Map<String, Object> context,
    Body? body,
  });
}
