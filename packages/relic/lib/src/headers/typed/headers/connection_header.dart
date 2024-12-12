import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Connection header.
///
/// This class manages connection directives, such as `keep-alive`, `close`, or multiple
/// directives (e.g., `upgrade, keep-alive`). It provides functionality to parse and generate
/// connection header values.
class ConnectionHeader implements TypedHeader {
  /// A list of connection directives (e.g., `keep-alive`, `close`, `upgrade`).
  final List<ConnectionHeaderType> directives;

  /// Constructs a [ConnectionHeader] instance with the specified connection directives.
  const ConnectionHeader({
    required this.directives,
  });

  /// Parses the Connection header value and returns a [ConnectionHeader] instance.
  ///
  /// This method splits the value by commas and trims each directive.
  factory ConnectionHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    var directives = splitValues.map(ConnectionHeaderType.parse).toList();

    return ConnectionHeader(directives: directives);
  }

  /// Checks if the connection is marked as `keep-alive`.
  bool get isKeepAlive => directives.contains(ConnectionHeaderType.keepAlive);

  /// Checks if the connection is marked as `close`.
  bool get isClose => directives.contains(ConnectionHeaderType.close);

  /// Checks if the connection is marked as `upgrade`.
  bool get isUpgrade => directives.contains(ConnectionHeaderType.upgrade);

  /// Checks if the connection is marked as `downgrade`.
  bool get isDowngrade => directives.contains(ConnectionHeaderType.downgrade);

  /// Converts the [ConnectionHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the connection directives.
  @override
  String toHeaderString() {
    return directives.map((directive) => directive.value).join(', ');
  }

  @override
  String toString() {
    return 'ConnectionHeader(directives: $directives)';
  }
}

/// A class representing the type of connection directives for the Connection header.
class ConnectionHeaderType {
  /// The string representation of the connection directive.
  final String value;

  /// Constructs a [ConnectionHeaderType] instance with the specified value.
  const ConnectionHeaderType._(this.value);

  /// Predefined connection directives.
  static const _keepAlive = 'keep-alive';
  static const _close = 'close';
  static const _upgrade = 'upgrade';
  static const _downgrade = 'downgrade';

  static const keepAlive = ConnectionHeaderType._(_keepAlive);
  static const close = ConnectionHeaderType._(_close);
  static const upgrade = ConnectionHeaderType._(_upgrade);
  static const downgrade = ConnectionHeaderType._(_downgrade);

  /// Parses a [value] and returns the corresponding [ConnectionHeaderType] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory ConnectionHeaderType.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }
    switch (trimmed) {
      case _keepAlive:
        return keepAlive;
      case _close:
        return close;
      case _upgrade:
        return upgrade;
      case _downgrade:
        return downgrade;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Returns the string representation of the connection directive.
  String toHeaderString() => value;

  @override
  String toString() => 'ConnectionHeaderType(value: $value)';
}
