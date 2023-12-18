/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithSelfParent extends _i1.SerializableModel {
  ObjectWithSelfParent._({
    this.id,
    this.other,
  });

  factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParentImpl;

  factory ObjectWithSelfParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithSelfParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int?>(jsonSerialization['other']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? other;

  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
    };
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
