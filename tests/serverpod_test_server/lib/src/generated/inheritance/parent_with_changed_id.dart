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

class ParentWithChangedId
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ParentWithChangedId({
    _i1.UuidValue? id,
    this.createdAt,
    this.updatedAt,
  }) : id = id ?? const _i1.Uuid().v7obj();

  factory ParentWithChangedId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentWithChangedId(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  _i1.UuidValue id;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ParentWithChangedId]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ParentWithChangedId copyWith({
    _i1.UuidValue? id,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return ParentWithChangedId(
      id: id ?? this.id,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentWithChangedId',
      'id': id.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}
