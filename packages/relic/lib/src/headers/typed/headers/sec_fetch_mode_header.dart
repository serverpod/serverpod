import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Sec-Fetch-Mode header.
///
/// This header indicates the mode of the request.
class SecFetchModeHeader implements TypedHeader {
  /// The mode value of the request.
  final String mode;

  /// Private constructor for [SecFetchModeHeader].
  const SecFetchModeHeader._(this.mode);

  /// Predefined mode values.
  static const _cors = 'cors';
  static const _noCors = 'no-cors';
  static const _sameOrigin = 'same-origin';
  static const _navigate = 'navigate';
  static const _nestedNavigate = 'nested-navigate';
  static const _webSocket = 'websocket';

  static const cors = SecFetchModeHeader._(_cors);
  static const noCors = SecFetchModeHeader._(_noCors);
  static const sameOrigin = SecFetchModeHeader._(_sameOrigin);
  static const navigate = SecFetchModeHeader._(_navigate);
  static const nestedNavigate = SecFetchModeHeader._(_nestedNavigate);
  static const webSocket = SecFetchModeHeader._(_webSocket);

  /// Parses a [value] and returns the corresponding [SecFetchModeHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory SecFetchModeHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed) {
      case _cors:
        return cors;
      case _noCors:
        return noCors;
      case _sameOrigin:
        return sameOrigin;
      case _navigate:
        return navigate;
      case _nestedNavigate:
        return nestedNavigate;
      case _webSocket:
        return webSocket;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Converts the [SecFetchModeHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => mode;

  @override
  String toString() {
    return 'SecFetchModeHeader(value: $mode)';
  }
}
