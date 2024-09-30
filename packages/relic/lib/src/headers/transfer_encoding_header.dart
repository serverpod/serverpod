part of '../headers.dart';

/// A class representing the HTTP Transfer-Encoding header.
///
/// This class manages transfer encodings such as `chunked`, `compress`, `deflate`, and `gzip`.
/// It provides functionality to parse and generate transfer encoding header values.
class TransferEncodingHeader {
  /// A list of transfer encodings (e.g., `chunked`, `gzip`).
  final List<String> encodings;

  /// Constructs a [TransferEncodingHeader] instance with the specified transfer encodings.
  const TransferEncodingHeader({
    required this.encodings,
  });

  /// Parses the Transfer-Encoding header value and returns a [TransferEncodingHeader] instance.
  ///
  /// This method splits the value by commas and trims each encoding.
  factory TransferEncodingHeader.fromHeaderValue(dynamic value) {
    final encodings = <String>[];

    if (value is String) {
      encodings.addAll(
        value
            .split(',')
            .where((encoding) => encoding.isNotEmpty)
            .map((encoding) => encoding.trim()),
      );
    } else if (value is List<String>) {
      encodings.addAll(
        value.fold(
          [],
          (a, b) => [
            ...a,
            ...b
                .split(',')
                .where((encoding) => encoding.isNotEmpty)
                .map((encoding) => encoding.trim()),
          ],
        ),
      );
    }

    return TransferEncodingHeader(encodings: encodings);
  }

  /// Static method that attempts to parse the Transfer-Encoding header and returns `null` if the value is `null`.
  static TransferEncodingHeader? tryParse(dynamic value) {
    if (value == null) return null;
    return TransferEncodingHeader.fromHeaderValue(value);
  }

  /// Checks if the Transfer-Encoding contains a specific encoding.
  bool containsEncoding(String encoding) {
    return encodings.contains(encoding);
  }

  /// Converts the [TransferEncodingHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the encodings with commas.
  @override
  String toString() => encodings.join(', ');
}
