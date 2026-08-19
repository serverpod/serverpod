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
import 'package:serverpod/serverpod.dart' as _is;
import '../protocol.dart' as _iv35mfmj;

class ParentClassWithoutId extends _iv35mfmj.GrandparentClassWithId
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ParentClassWithoutId({
    super.id,
    required super.grandParentField,
    required this.parentField,
  });

  factory ParentClassWithoutId.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ParentClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
    );
  }

  String parentField;

  /// Returns a shallow copy of this [ParentClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ParentClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
  }) {
    return ParentClassWithoutId(
      id: id is _is.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}
