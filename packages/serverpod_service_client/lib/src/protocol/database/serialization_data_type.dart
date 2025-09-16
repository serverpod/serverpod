/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Serialization types for `ColumnSerializable` columns.
/// The `json` and `jsonb` data types accept almost identical sets of values as input.
/// The major practical difference is one of efficiency.
/// See: https://www.postgresql.org/docs/current/datatype-json.html
enum SerializationDataType implements _i1.SerializableModel {
  /// The `json` data type stores an exact copy of the input text,
  /// which processing functions must reparse on each execution
  json,

  /// The `jsonb` data is stored in a decomposed binary format
  /// that makes it slightly slower to input due to added conversion overhead,
  /// but significantly faster to process, since no reparsing is needed.
  /// `jsonb` also supports indexing, which can be a significant advantage.
  jsonb;

  static SerializationDataType fromJson(String name) {
    switch (name) {
      case 'json':
        return SerializationDataType.json;
      case 'jsonb':
        return SerializationDataType.jsonb;
      default:
        throw ArgumentError(
            'Value "$name" cannot be converted to "SerializationDataType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
