/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

/// Defines an element of an index.
abstract class IndexElementDefinition extends _i1.SerializableEntity {
  const IndexElementDefinition._();

  const factory IndexElementDefinition({
    required _i2.IndexElementDefinitionType type,
    required String definition,
  }) = _IndexElementDefinition;

  factory IndexElementDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return IndexElementDefinition(
      type: serializationManager.deserialize<_i2.IndexElementDefinitionType>(
          jsonSerialization['type']),
      definition: serializationManager
          .deserialize<String>(jsonSerialization['definition']),
    );
  }

  IndexElementDefinition copyWith({
    _i2.IndexElementDefinitionType? type,
    String? definition,
  });

  /// The type of this index element.
  _i2.IndexElementDefinitionType get type;

  /// Depending on the [type], this is either a column name or an expression.
  String get definition;
}

/// Defines an element of an index.
class _IndexElementDefinition extends IndexElementDefinition {
  const _IndexElementDefinition({
    required this.type,
    required this.definition,
  }) : super._();

  /// The type of this index element.
  @override
  final _i2.IndexElementDefinitionType type;

  /// Depending on the [type], this is either a column name or an expression.
  @override
  final String definition;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'definition': definition,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is IndexElementDefinition &&
            (identical(
                  other.type,
                  type,
                ) ||
                other.type == type) &&
            (identical(
                  other.definition,
                  definition,
                ) ||
                other.definition == definition));
  }

  @override
  int get hashCode => Object.hash(
        type,
        definition,
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
