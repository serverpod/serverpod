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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

/// Operator classes used by GIN indexes.
/// See: https://www.postgresql.org/docs/current/gin.html#GIN-BUILTIN-OPCLASSES
enum GinOperatorClass implements _i1.SerializableModel {
  arrayOps,
  jsonbOps,
  jsonbPathOps,
  tsvectorOps
  ;

  static GinOperatorClass fromJson(String name) {
    switch (name) {
      case 'arrayOps':
        return GinOperatorClass.arrayOps;
      case 'jsonbOps':
        return GinOperatorClass.jsonbOps;
      case 'jsonbPathOps':
        return GinOperatorClass.jsonbPathOps;
      case 'tsvectorOps':
        return GinOperatorClass.tsvectorOps;
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
