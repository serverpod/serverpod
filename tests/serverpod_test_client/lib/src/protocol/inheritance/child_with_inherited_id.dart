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
import '../protocol.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import '../inheritance/child_with_inherited_id.dart' as _i3;

abstract class ChildWithInheritedId extends _i1.ParentWithChangedId
    implements _i2.SerializableModel {
  ChildWithInheritedId._({
    _i2.UuidValue? id,
    required this.name,
    this.parent,
    this.parentId,
  }) : id = id ?? _i2.Uuid().v7obj();

  factory ChildWithInheritedId({
    _i2.UuidValue? id,
    required String name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  }) = _ChildWithInheritedIdImpl;

  factory ChildWithInheritedId.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ChildWithInheritedId(
      id: _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      parent: jsonSerialization['parent'] == null
          ? null
          : _i3.ChildWithInheritedId.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i2.UuidValue id;

  String name;

  _i3.ChildWithInheritedId? parent;

  _i2.UuidValue? parentId;

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildWithInheritedId copyWith({
    _i2.UuidValue? id,
    String? name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'name': name,
      if (parent != null) 'parent': parent?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildWithInheritedIdImpl extends ChildWithInheritedId {
  _ChildWithInheritedIdImpl({
    _i2.UuidValue? id,
    required String name,
    _i3.ChildWithInheritedId? parent,
    _i2.UuidValue? parentId,
  }) : super._(
          id: id,
          name: name,
          parent: parent,
          parentId: parentId,
        );

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildWithInheritedId copyWith({
    _i2.UuidValue? id,
    String? name,
    Object? parent = _Undefined,
    Object? parentId = _Undefined,
  }) {
    return ChildWithInheritedId(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent is _i3.ChildWithInheritedId?
          ? parent
          : this.parent?.copyWith(),
      parentId: parentId is _i2.UuidValue? ? parentId : this.parentId,
    );
  }
}
