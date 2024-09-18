import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/src/headers/types/body_type.dart';
import 'package:relic/src/headers/types/mime_type.dart';

/// The body of a request or response.
///
/// This tracks whether the body has been read. It's separate from [Message]
/// because the message may be changed with [Message.copyWith], but each instance
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
    this.contentLength, {
    Encoding? encoding,
    required MimeType mimeType,
  }) : contentType = BodyType(mimeType: mimeType, encoding: encoding);

  factory Body.empty({
    Encoding encoding = utf8,
    MimeType mimeType = MimeType.plainText,
  }) =>
      Body._(
        Stream.empty(),
        0,
        encoding: encoding,
        mimeType: mimeType,
      );

  factory Body.fromString(
    String body, {
    Encoding encoding = utf8,
    MimeType mimeType = MimeType.plainText,
  }) {
    Uint8List encoded = Uint8List.fromList(encoding.encode(body));
    return Body._(
      Stream.value(encoded),
      encoded.length,
      encoding: encoding,
      mimeType: mimeType,
    );
  }

  factory Body.fromDataStream(
    Stream<Uint8List> body, {
    Encoding? encoding = utf8,
    MimeType mimeType = MimeType.plainText,
  }) {
    return Body._(
      body,
      null,
      encoding: encoding,
      mimeType: mimeType,
    );
  }

  factory Body.fromIntStream(
    Stream<List<int>> body, {
    Encoding? encoding = utf8,
    MimeType mimeType = MimeType.plainText,
  }) {
    Stream<Uint8List> byteStream = body.map((list) => Uint8List.fromList(list));
    return Body._(
      byteStream,
      null,
      encoding: encoding,
      mimeType: mimeType,
    );
  }

  factory Body.fromData(
    Uint8List body, {
    Encoding? encoding,
    MimeType mimeType = MimeType.binary,
  }) {
    return Body._(
      Stream.value(body),
      body.length,
      encoding: encoding,
      mimeType: mimeType,
    );
  }

  /// Returns a [Stream] representing the body.
  ///
  /// Can only be called once.
  Stream<Uint8List> read() {
    var stream = _stream;
    if (stream == null) {
      throw StateError(
        "The 'read' method can only be called once on a "
        'Request/Response object.',
      );
    }
    _stream = null;
    return stream;
  }
}
