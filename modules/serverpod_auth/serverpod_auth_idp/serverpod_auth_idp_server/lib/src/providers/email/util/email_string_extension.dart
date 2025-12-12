/// An extension for normalizing email strings.
extension EmailStringExtension on String {
  /// Returns the email string trimmed and converted to lowercase.
  String get normalizedEmail => trim().toLowerCase();
}
