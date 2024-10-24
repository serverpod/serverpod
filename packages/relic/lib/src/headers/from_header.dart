part of '../headers.dart';

/// A class representing the HTTP `From` header.
///
/// The `From` header is used to indicate the email address of the user making the request.
/// It usually contains a single email address, but in edge cases, it could contain multiple
/// email addresses separated by commas.
class FromHeader {
  /// A list of email addresses provided in the `From` header.
  ///
  /// Typically, this should only contain one email address, but in rare cases, it could
  /// hold multiple email addresses.
  final List<String> emails;

  /// Private constructor for initializing the [emails] list.
  FromHeader._(this.emails);

  /// Parses a `From` header value and returns a [FromHeader] instance.
  ///
  /// - If the header contains a single email, it is parsed and added to the [emails] list.
  /// - If the header contains multiple emails (comma-separated), they are split, trimmed, and added to the [emails] list.
  factory FromHeader(List<String> value) {
    final emails = value
        .fold(
          <String>[],
          (a, b) => <String>[
            ...a,
            ...b.split(',').map((e) => e.trim()),
          ],
        )
        .map((email) => email.trim())
        .where((email) => email.isNotEmpty)
        .toList();

    return FromHeader._(emails);
  }

  /// Static method that attempts to parse the `From` header and returns `null` if the value is `null` or empty.
  ///
  /// - If the header value is non-null and non-empty, it returns a [FromHeader] instance.
  /// - If the value is `null` or an empty string, it returns `null`.
  static FromHeader? tryParse(List<String>? value) {
    if (value == null) return null;
    return FromHeader(value);
  }

  /// Returns the single email address if the list only contains one email.
  ///
  /// - If the `From` header contains exactly one email, this method returns that email.
  /// - If the `From` header contains multiple emails, this method returns `null`.
  String? get singleEmail => emails.length == 1 ? emails.first : null;

  /// Converts the [FromHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method joins the email addresses with commas (`,`) if there are multiple addresses.
  @override
  String toString() => emails.join(', ');
}
