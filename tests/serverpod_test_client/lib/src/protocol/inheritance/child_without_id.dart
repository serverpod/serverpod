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

abstract class ChildClassWithoutId extends _i1.ParentClassWithoutId
    implements _i2.SerializableModel {
  ChildClassWithoutId._({
    this.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ChildClassWithoutId({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) = _ChildClassWithoutIdImpl;

  factory ChildClassWithoutId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i2.UuidValue? id;

  String childField;

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildClassWithoutId copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassWithoutIdImpl extends ChildClassWithoutId {
  _ChildClassWithoutIdImpl({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) : super._(
         id: id,
         grandParentField: grandParentField,
         parentField: parentField,
         childField: childField,
       );

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    String? childField,
  }) {
    return ChildClassWithoutId(
      id: id is _i2.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}
