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

abstract class ObjectWithSelfParent implements _i1.SerializableModel {
  ObjectWithSelfParent._({
    this.id,
    this.other,
  });

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithSelfParent(
      id: jsonSerialization['id'] as int?,
      other: jsonSerialization['other'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? other;

  /// Returns a shallow copy of this [ObjectWithSelfParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (other != null) 'other': other,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSelfParentImpl extends ObjectWithSelfParent {
  _ObjectWithSelfParentImpl({
    int? id,
    int? other,
  }) : super._(
          id: id,
          other: other,
        );

  /// Returns a shallow copy of this [ObjectWithSelfParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id is int? ? id : this.id,
      other: other is int? ? other : this.other,
    );
  }
}
