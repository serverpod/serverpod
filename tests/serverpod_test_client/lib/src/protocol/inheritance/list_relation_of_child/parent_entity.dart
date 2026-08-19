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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../../inheritance/list_relation_of_child/child_entity.dart'
    as _i41rqetj;

abstract class ParentEntity
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ParentEntity._({
    this.id,
    this.children,
  });

  factory ParentEntity({
    int? id,
    List<_i41rqetj.ChildEntity>? children,
  }) = _ParentEntityImpl;

  factory ParentEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentEntity(
      id: jsonSerialization['id'] as int?,
      children: jsonSerialization['children'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_i41rqetj.ChildEntity>>(
              jsonSerialization['children'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<_i41rqetj.ChildEntity>? children;

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ParentEntity copyWith({
    int? id,
    List<_i41rqetj.ChildEntity>? children,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentEntity',
      if (id != null) 'id': id,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentEntity',
      if (id != null) 'id': id,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentEntityImpl extends ParentEntity {
  _ParentEntityImpl({
    int? id,
    List<_i41rqetj.ChildEntity>? children,
  }) : super._(
         id: id,
         children: children,
       );

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ParentEntity copyWith({
    Object? id = _Undefined,
    Object? children = _Undefined,
  }) {
    return ParentEntity(
      id: id is int? ? id : this.id,
      children: children is List<_i41rqetj.ChildEntity>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
