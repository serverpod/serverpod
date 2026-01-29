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

/// Operator classes used by GIN indexes.
enum GinOperatorClass implements _i1.SerializableModel {
  array,
  jsonb,
  jsonbPath,
  tsvector,
  trigram;

  static GinOperatorClass fromJson(String name) {
    switch (name) {
      case 'array':
        return GinOperatorClass.array;
      case 'jsonb':
        return GinOperatorClass.jsonb;
      case 'jsonbPath':
        return GinOperatorClass.jsonbPath;
      case 'tsvector':
        return GinOperatorClass.tsvector;
      case 'trigram':
        return GinOperatorClass.trigram;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "GinOperatorClass"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
