// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/src/headers/types/body_type.dart';

/// The body of a request or response.
///
/// This tracks whether the body has been read. It's separate from [Message]
/// because the message may be changed with [Message.change], but each instance
/// should share a notion of whether the body was read.
class Body {
  /// The contents of the message body.
  ///
  /// This will be `null` after [read] is called.
  Stream<Uint8List>? _stream;

  /// The length of the stream returned by [read], or `null` if that can't be
  /// determined efficiently.
  final int? contentLength;

  final BodyType contentType;

  Body._(
    this._stream,
    this.contentType,
    this.contentLength,
  );

  factory Body.empty({
    Encoding encoding = utf8,
    BodyType contentType = BodyType.plainText,
  }) =>
      Body._(
        Stream.empty(),
        contentType,
        0,
      );

  factory Body.fromString(
    String body, {
    Encoding encoding = utf8,
    BodyType contentType = BodyType.plainText,
  }) {
    Uint8List encoded;
    if (encoding == utf8) {
      encoded = utf8.encode(body);
    } else {
      encoded = Uint8List.fromList(encoding.encode(body));
    }

    return Body._(Stream.value(encoded), contentType, encoded.length);
  }

  factory Body.fromDataStream(
    Stream<Uint8List> body, {
    Encoding? encoding,
    BodyType contentType = BodyType.plainText,
  }) {
    return Body._(body, contentType, null);
  }

  factory Body.fromIntStream(
    Stream<List<int>> body, {
    Encoding? encoding,
    BodyType contentType = BodyType.plainText,
  }) {
    Stream<Uint8List> byteStream = body.map((list) => Uint8List.fromList(list));
    return Body._(byteStream, contentType, null);
  }

  factory Body.fromData(
    Uint8List body, {
    Encoding? encoding,
    BodyType contentType = BodyType.binary,
  }) {
    return Body._(Stream.value(body), contentType, body.length);
  }

  /// Returns a [Stream] representing the body.
  ///
  /// Can only be called once.
  Stream<Uint8List> read() {
    if (_stream == null) {
      throw StateError("The 'read' method can only be called once on a "
          'Request/Response object.');
    }
    var stream = _stream!;
    _stream = null;
    return stream;
  }
}
