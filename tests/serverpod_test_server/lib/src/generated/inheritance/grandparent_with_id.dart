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
import 'package:serverpod/serverpod.dart' as _i1;

class GrandparentClassWithId
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GrandparentClassWithId({
    this.id,
    required this.grandParentField,
  });

  factory GrandparentClassWithId.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GrandparentClassWithId(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
    );
  }

  _i1.UuidValue? id;

  String grandParentField;

  /// Returns a shallow copy of this [GrandparentClassWithId]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GrandparentClassWithId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
  }) {
    return GrandparentClassWithId(
      id: id is _i1.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}
