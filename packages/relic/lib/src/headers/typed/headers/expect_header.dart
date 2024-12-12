import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Expect header.
///
/// This class manages the directive for the Expect header, such as `100-continue`.
/// It provides functionality to parse and generate Expect header values.
class ExpectHeader implements TypedHeader {
  /// The string representation of the expectation directive.
  final String value;

  /// Constructs an [ExpectHeader] instance with the specified value.
  const ExpectHeader._(this.value);

  /// Predefined expectation directives.
  static const _continue100 = '100-continue';

  static const continue100 = ExpectHeader._(_continue100);

  /// Parses a [value] and returns the corresponding [ExpectHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory ExpectHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }
    switch (trimmed) {
      case _continue100:
        return continue100;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Converts the [ExpectHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => value;

  @override
  String toString() {
    return 'ExpectHeader(value: $value)';
  }
}
