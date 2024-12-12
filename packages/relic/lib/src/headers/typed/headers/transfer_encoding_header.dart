import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Transfer-Encoding header.
///
/// This class manages transfer encodings such as `chunked`, `compress`, `deflate`, and `gzip`.
/// It provides functionality to parse and generate transfer encoding header values.
class TransferEncodingHeader implements TypedHeader {
  /// A list of transfer encodings.
  final List<TransferEncoding> encodings;

  /// Constructs a [TransferEncodingHeader] instance with the specified transfer encodings.
  const TransferEncodingHeader({
    required this.encodings,
  });

  /// Parses the Transfer-Encoding header value and returns a [TransferEncodingHeader] instance.
  ///
  /// This method splits the value by commas and trims each encoding.
  factory TransferEncodingHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    var encodings = splitValues.map(TransferEncoding.parse).toList();

    return TransferEncodingHeader(encodings: encodings);
  }

  /// Checks if the Transfer-Encoding contains `chunked`.
  bool get isChunked {
    return encodings.contains(TransferEncoding.chunked);
  }

  /// Converts the [TransferEncodingHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => encodings.map((e) => e.name).join(', ');

  @override
  String toString() {
    return 'TransferEncodingHeader(encodings: $encodings)';
  }
}

/// A class representing valid transfer encodings.
class TransferEncoding {
  /// The string representation of the transfer encoding.
  final String name;

  /// Constructs a [TransferEncoding] instance with the specified name.
  const TransferEncoding._(this.name);

  /// Predefined transfer encodings.
  static const _identity = 'identity';
  static const _chunked = 'chunked';
  static const _compress = 'compress';
  static const _deflate = 'deflate';
  static const _gzip = 'gzip';

  static const identity = TransferEncoding._(_identity);
  static const chunked = TransferEncoding._(_chunked);
  static const compress = TransferEncoding._(_compress);
  static const deflate = TransferEncoding._(_deflate);
  static const gzip = TransferEncoding._(_gzip);

  /// Parses a [name] and returns the corresponding [TransferEncoding] instance.
  /// If the name does not match any predefined encodings, it returns a custom instance.
  factory TransferEncoding.parse(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Name cannot be empty');
    }
    switch (trimmed) {
      case _identity:
        return identity;
      case _chunked:
        return chunked;
      case _compress:
        return compress;
      case _deflate:
        return deflate;
      case _gzip:
        return gzip;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Returns the string representation of the transfer encoding.
  String toHeaderString() => name;

  @override
  String toString() => name;
}
