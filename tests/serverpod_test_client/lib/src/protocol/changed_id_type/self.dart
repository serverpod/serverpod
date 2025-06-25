/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../changed_id_type/self.dart' as _i2;

abstract class ChangedIdTypeSelf implements _i1.SerializableModel {
  ChangedIdTypeSelf._({
    _i1.UuidValue? id,
    required this.name,
    this.previous,
    this.nextId,
    this.next,
    this.parentId,
    this.parent,
    this.children,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory ChangedIdTypeSelf({
    _i1.UuidValue? id,
    required String name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  }) = _ChangedIdTypeSelfImpl;

  factory ChangedIdTypeSelf.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChangedIdTypeSelf(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['previous'] as Map<String, dynamic>)),
      nextId: jsonSerialization['nextId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['nextId']),
      next: jsonSerialization['next'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['next'] as Map<String, dynamic>)),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      parent: jsonSerialization['parent'] == null
          ? null
          : _i2.ChangedIdTypeSelf.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
      children: (jsonSerialization['children'] as List?)
          ?.map((e) =>
              _i2.ChangedIdTypeSelf.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String name;

  _i2.ChangedIdTypeSelf? previous;

  _i1.UuidValue? nextId;

  _i2.ChangedIdTypeSelf? next;

  _i1.UuidValue? parentId;

  _i2.ChangedIdTypeSelf? parent;

  List<_i2.ChangedIdTypeSelf>? children;

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChangedIdTypeSelf copyWith({
    _i1.UuidValue? id,
    String? name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      if (next != null) 'next': next?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (parent != null) 'parent': parent?.toJson(),
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

class _ChangedIdTypeSelfImpl extends ChangedIdTypeSelf {
  _ChangedIdTypeSelfImpl({
    _i1.UuidValue? id,
    required String name,
    _i2.ChangedIdTypeSelf? previous,
    _i1.UuidValue? nextId,
    _i2.ChangedIdTypeSelf? next,
    _i1.UuidValue? parentId,
    _i2.ChangedIdTypeSelf? parent,
    List<_i2.ChangedIdTypeSelf>? children,
  }) : super._(
          id: id,
          name: name,
          previous: previous,
          nextId: nextId,
          next: next,
          parentId: parentId,
          parent: parent,
          children: children,
        );

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChangedIdTypeSelf copyWith({
    Object? id = _Undefined,
    String? name,
    Object? previous = _Undefined,
    Object? nextId = _Undefined,
    Object? next = _Undefined,
    Object? parentId = _Undefined,
    Object? parent = _Undefined,
    Object? children = _Undefined,
  }) {
    return ChangedIdTypeSelf(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      previous: previous is _i2.ChangedIdTypeSelf?
          ? previous
          : this.previous?.copyWith(),
      nextId: nextId is _i1.UuidValue? ? nextId : this.nextId,
      next: next is _i2.ChangedIdTypeSelf? ? next : this.next?.copyWith(),
      parentId: parentId is _i1.UuidValue? ? parentId : this.parentId,
      parent:
          parent is _i2.ChangedIdTypeSelf? ? parent : this.parent?.copyWith(),
      children: children is List<_i2.ChangedIdTypeSelf>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
