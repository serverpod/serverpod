/// Normalizes a phone number by removing all non-digit characters
/// except the leading '+' for international format.
String normalizePhoneNumber(String phone) {
  final trimmed = phone.trim();
  if (trimmed.isEmpty) return '';

  final buffer = StringBuffer();
  bool hasLeadingPlus = trimmed.startsWith('+');
  if (hasLeadingPlus) {
    buffer.write('+');
  }

  for (int i = hasLeadingPlus ? 1 : 0; i < trimmed.length; i++) {
    final char = trimmed[i];
    if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
      buffer.write(char);
    }
  }

  return buffer.toString();
}
