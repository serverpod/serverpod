/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Used to specify how the definition of an [IndexElementDefinition]
/// should be interpreted.
enum IndexElementDefinitionType implements _i1.SerializableEntity {
  /// Indicates, that the definition of an [IndexElementDefinition]
  /// referees to a column.
  column,

  /// Indicates, that the definition of an [IndexElementDefinition]
  /// is a (complex) expression.
  expression;

  static IndexElementDefinitionType? fromJson(int index) {
    switch (index) {
      case 0:
        return column;
      case 1:
        return expression;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}
