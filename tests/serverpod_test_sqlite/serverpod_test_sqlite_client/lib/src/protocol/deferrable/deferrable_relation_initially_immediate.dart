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

abstract class DeferrableRelationInitiallyImmediate
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeferrableRelationInitiallyImmediate._({
    this.id,
    required this.parentId,
  });

  factory DeferrableRelationInitiallyImmediate({
    int? id,
    required int parentId,
  }) = _DeferrableRelationInitiallyImmediateImpl;

  factory DeferrableRelationInitiallyImmediate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeferrableRelationInitiallyImmediate(
      id: jsonSerialization['id'] as int?,
      parentId: jsonSerialization['parentId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int parentId;

  /// Returns a shallow copy of this [DeferrableRelationInitiallyImmediate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeferrableRelationInitiallyImmediate copyWith({
    int? id,
    int? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeferrableRelationInitiallyImmediate',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeferrableRelationInitiallyImmediate',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeferrableRelationInitiallyImmediateImpl
    extends DeferrableRelationInitiallyImmediate {
  _DeferrableRelationInitiallyImmediateImpl({
    int? id,
    required int parentId,
  }) : super._(
         id: id,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [DeferrableRelationInitiallyImmediate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeferrableRelationInitiallyImmediate copyWith({
    Object? id = _Undefined,
    int? parentId,
  }) {
    return DeferrableRelationInitiallyImmediate(
      id: id is int? ? id : this.id,
      parentId: parentId ?? this.parentId,
    );
  }
}
