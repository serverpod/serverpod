/// Extension methods for the [String] class.
extension StringExtension on String? {
  /// Returns true if the string is null.
  bool get isNull => this == null;

  /// Returns true if the string is not null.
  bool get isNotNull => !isNull;

  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns true if the string is not null or empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the substring of the string, or an empty string if the string is
  /// null or empty.
  String subStringOrEmpty(int start, [int? end]) =>
      isNullOrEmpty ? '' : this!.substring(start, end);

  /// Removes the surrounding quotes if the string
  /// starts and ends with ".
  String get removeSurroundingQuotes {
    //TODO: Handle " that are inside an expression.
    if (isNullOrEmpty) {
      return '';
    }
    if (this!.startsWith('"') && this!.endsWith('"')) {
      return this!.subStringOrEmpty(1, this!.length - 1);
    } else {
      return this!;
    }
  }
}
