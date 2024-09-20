part of '../headers.dart';

/// A class representing the HTTP Vary header.
///
/// This class manages the list of headers that the response may vary on.
/// It provides functionality to parse, manipulate, and generate Vary header values.
class VaryHeader {
  /// A list of headers that the response varies on.
  final List<String> fields;

  /// Constructs a [VaryHeader] instance with the specified list of fields.
  const VaryHeader({
    required this.fields,
  });

  /// Parses the Vary header value and returns a [VaryHeader] instance.
  ///
  /// This method splits the value by commas and trims each field.
  factory VaryHeader.fromHeaderValue(String value) {
    final fields = value.split(',').map((field) => field.trim()).toList();
    return VaryHeader(fields: fields);
  }

  /// Static method that attempts to parse the Vary header and returns `null` if the value is `null`.
  static VaryHeader? tryParse(String? value) {
    if (value == null) return null;
    return VaryHeader.fromHeaderValue(value);
  }

  /// Adds a field to the Vary header.
  VaryHeader addField(String field) {
    final updatedFields = List<String>.from(fields);
    if (!updatedFields.contains(field)) {
      updatedFields.add(field);
    }
    return VaryHeader(fields: updatedFields);
  }

  /// Removes a field from the Vary header.
  VaryHeader removeField(String field) {
    final updatedFields = fields.where((f) => f != field).toList();
    return VaryHeader(fields: updatedFields);
  }

  /// Checks if the Vary header contains a specific field.
  bool containsField(String field) {
    return fields.contains(field);
  }

  /// Converts the [VaryHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the fields with commas.
  @override
  String toString() => fields.join(', ');
}
