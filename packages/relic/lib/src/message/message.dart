import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/relic.dart';

abstract class Message {
  /// The HTTP headers associated with this message.
  final Headers headers;

  /// Extra context for middleware and handlers.
  final Map<String, Object> context;

  /// The streaming body of the message.
  Body body;

  Message({
    required this.body,
    required this.headers,
    this.context = const {},
  });

  /// Returns the MIME type from the Content-Type header, if available.
  MimeType? get mimeType => body.contentType?.mimeType;

  /// Returns the encoding specified in the Content-Type header, or null if not specified.
  Encoding? get encoding => body.contentType?.encoding;

  /// Reads the body as a stream of bytes. Can only be called once.
  Stream<Uint8List> read() => body.read();

  /// Reads the body as a string, decoding it using the specified or detected encoding.
  /// Defaults to utf8 if no encoding is provided or detected.
  Future<String> readAsString([Encoding? encoding]) {
    encoding ??= body.contentType?.encoding ?? utf8;
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
