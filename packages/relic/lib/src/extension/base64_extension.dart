/// Helper method to check if a string is valid Base64.
///
/// This method is used internally to validate that the Base64-encoded credentials
/// are correctly formatted before attempting to decode them.
extension Base64Extension on String {
  bool get isValidBase64 {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return length % 4 == 0 && base64Pattern.hasMatch(this);
  }
}
