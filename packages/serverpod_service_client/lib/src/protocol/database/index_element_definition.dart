/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// Defines an element of an index.
abstract class IndexElementDefinition extends _i1.SerializableEntity {
  IndexElementDefinition._({
    required this.type,
    required this.definition,
  });

  factory IndexElementDefinition({
    required _i2.IndexElementDefinitionType type,
    required String definition,
  }) = _IndexElementDefinitionImpl;

  factory IndexElementDefinition.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return IndexElementDefinition(
      type: _i2.IndexElementDefinitionType.fromJson(
          (jsonSerialization['type'] as int)),
      definition: jsonSerialization['definition'] as String,
    );
  }

  /// The type of this index element.
  _i2.IndexElementDefinitionType type;

  /// Depending on the [type], this is either a column name or an expression.
  String definition;

  IndexElementDefinition copyWith({
    _i2.IndexElementDefinitionType? type,
    String? definition,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'definition': definition,
    };
  }
}

class _IndexElementDefinitionImpl extends IndexElementDefinition {
  _IndexElementDefinitionImpl({
    required _i2.IndexElementDefinitionType type,
    required String definition,
  }) : super._(
          type: type,
          definition: definition,
        );

  @override
  IndexElementDefinition copyWith({
    _i2.IndexElementDefinitionType? type,
    String? definition,
  }) {
    return IndexElementDefinition(
      type: type ?? this.type,
      definition: definition ?? this.definition,
    );
  }
}
