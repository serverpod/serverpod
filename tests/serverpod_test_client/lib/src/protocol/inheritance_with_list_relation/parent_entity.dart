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
import '../inheritance_with_list_relation/child_entity.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ParentEntity implements _i1.SerializableModel {
  ParentEntity._({
    this.id,
    this.children,
  });

  factory ParentEntity({
    int? id,
    List<_i2.ChildEntity>? children,
  }) = _ParentEntityImpl;

  factory ParentEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentEntity(
      id: jsonSerialization['id'] as int?,
      children: jsonSerialization['children'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ChildEntity>>(
              jsonSerialization['children'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<_i2.ChildEntity>? children;

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ParentEntity copyWith({
    int? id,
    List<_i2.ChildEntity>? children,
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentEntityImpl extends ParentEntity {
  _ParentEntityImpl({
    int? id,
    List<_i2.ChildEntity>? children,
  }) : super._(
         id: id,
         children: children,
       );

  /// Returns a shallow copy of this [ParentEntity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ParentEntity copyWith({
    Object? id = _Undefined,
    Object? children = _Undefined,
  }) {
    return ParentEntity(
      id: id is int? ? id : this.id,
      children: children is List<_i2.ChildEntity>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
