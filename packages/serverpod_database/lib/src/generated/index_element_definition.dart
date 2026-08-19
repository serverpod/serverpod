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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

/// Defines an element of an index.
abstract class IndexElementDefinition
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  IndexElementDefinition._({
    required this.type,
    required this.definition,
  });

  factory IndexElementDefinition({
    required _isd.IndexElementDefinitionType type,
    required String definition,
  }) = _IndexElementDefinitionImpl;

  factory IndexElementDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IndexElementDefinition(
      type: _isd.IndexElementDefinitionType.fromJson(
        (jsonSerialization['type'] as int),
      ),
      definition: jsonSerialization['definition'] as String,
    );
  }

  /// The type of this index element.
  _isd.IndexElementDefinitionType type;

  /// Depending on the [type], this is either a column name or an expression.
  String definition;

  /// Returns a shallow copy of this [IndexElementDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  IndexElementDefinition copyWith({
    _isd.IndexElementDefinitionType? type,
    String? definition,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.IndexElementDefinition',
      'type': type.toJson(),
      'definition': definition,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.IndexElementDefinition',
      'type': type.toJson(),
      'definition': definition,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _IndexElementDefinitionImpl extends IndexElementDefinition {
  _IndexElementDefinitionImpl({
    required _isd.IndexElementDefinitionType type,
    required String definition,
  }) : super._(
         type: type,
         definition: definition,
       );

  /// Returns a shallow copy of this [IndexElementDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  IndexElementDefinition copyWith({
    _isd.IndexElementDefinitionType? type,
    String? definition,
  }) {
    return IndexElementDefinition(
      type: type ?? this.type,
      definition: definition ?? this.definition,
    );
  }
}
