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

abstract class ObjectWithVector implements _i1.SerializableModel {
  ObjectWithVector._({
    this.id,
    required this.vector,
    this.vectorNullable,
  });

  factory ObjectWithVector({
    int? id,
    required _i1.Vector vector,
    _i1.Vector? vectorNullable,
  }) = _ObjectWithVectorImpl;

  factory ObjectWithVector.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithVector(
      id: jsonSerialization['id'] as int?,
      vector: _i1.VectorJsonExtension.fromJson(jsonSerialization['vector']),
      vectorNullable: jsonSerialization['vectorNullable'] == null
          ? null
          : _i1.VectorJsonExtension.fromJson(
              jsonSerialization['vectorNullable']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Vector vector;

  _i1.Vector? vectorNullable;

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithVector copyWith({
    int? id,
    _i1.Vector? vector,
    _i1.Vector? vectorNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithVectorImpl extends ObjectWithVector {
  _ObjectWithVectorImpl({
    int? id,
    required _i1.Vector vector,
    _i1.Vector? vectorNullable,
  }) : super._(
          id: id,
          vector: vector,
          vectorNullable: vectorNullable,
        );

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithVector copyWith({
    Object? id = _Undefined,
    _i1.Vector? vector,
    Object? vectorNullable = _Undefined,
  }) {
    return ObjectWithVector(
      id: id is int? ? id : this.id,
      vector: vector ?? this.vector.clone(),
      vectorNullable: vectorNullable is _i1.Vector?
          ? vectorNullable
          : this.vectorNullable?.clone(),
    );
  }
}
