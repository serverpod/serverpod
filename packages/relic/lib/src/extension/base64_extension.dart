import 'dart:convert';

/// Helper method to check if a string is valid Base64.
///
/// This method is used internally to validate that the Base64-encoded credentials
/// are correctly formatted before attempting to decode them.
extension Base64Extension on String {
  bool get isValidBase64 {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return length % 4 == 0 && base64Pattern.hasMatch(this);
  }

  /// Decodes the Base64 string and returns the decoded string.
  ///
  /// Throws a [FormatException] if the string is not a valid Base64 string.
  String get decodeBase64 {
    return utf8.decode(base64Decode(this));
  }

  /// Encodes the string to a Base64 string.
  String get encodeBase64 {
    return base64Encode(utf8.encode(this));
  }
}
