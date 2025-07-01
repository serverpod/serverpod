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
    required this.vectorIndexedHnsw,
    required this.vectorIndexedHnswWithParams,
    required this.vectorIndexedIvfflat,
    required this.vectorIndexedIvfflatWithParams,
  });

  factory ObjectWithVector({
    int? id,
    required _i1.Vector vector,
    _i1.Vector? vectorNullable,
    required _i1.Vector vectorIndexedHnsw,
    required _i1.Vector vectorIndexedHnswWithParams,
    required _i1.Vector vectorIndexedIvfflat,
    required _i1.Vector vectorIndexedIvfflatWithParams,
  }) = _ObjectWithVectorImpl;

  factory ObjectWithVector.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithVector(
      id: jsonSerialization['id'] as int?,
      vector: _i1.VectorJsonExtension.fromJson(jsonSerialization['vector']),
      vectorNullable: jsonSerialization['vectorNullable'] == null
          ? null
          : _i1.VectorJsonExtension.fromJson(
              jsonSerialization['vectorNullable']),
      vectorIndexedHnsw: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedHnsw']),
      vectorIndexedHnswWithParams: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedHnswWithParams']),
      vectorIndexedIvfflat: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedIvfflat']),
      vectorIndexedIvfflatWithParams: _i1.VectorJsonExtension.fromJson(
          jsonSerialization['vectorIndexedIvfflatWithParams']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Vector vector;

  _i1.Vector? vectorNullable;

  _i1.Vector vectorIndexedHnsw;

  _i1.Vector vectorIndexedHnswWithParams;

  _i1.Vector vectorIndexedIvfflat;

  _i1.Vector vectorIndexedIvfflatWithParams;

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithVector copyWith({
    int? id,
    _i1.Vector? vector,
    _i1.Vector? vectorNullable,
    _i1.Vector? vectorIndexedHnsw,
    _i1.Vector? vectorIndexedHnswWithParams,
    _i1.Vector? vectorIndexedIvfflat,
    _i1.Vector? vectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
      'vectorIndexedHnsw': vectorIndexedHnsw.toJson(),
      'vectorIndexedHnswWithParams': vectorIndexedHnswWithParams.toJson(),
      'vectorIndexedIvfflat': vectorIndexedIvfflat.toJson(),
      'vectorIndexedIvfflatWithParams': vectorIndexedIvfflatWithParams.toJson(),
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
    required _i1.Vector vectorIndexedHnsw,
    required _i1.Vector vectorIndexedHnswWithParams,
    required _i1.Vector vectorIndexedIvfflat,
    required _i1.Vector vectorIndexedIvfflatWithParams,
  }) : super._(
          id: id,
          vector: vector,
          vectorNullable: vectorNullable,
          vectorIndexedHnsw: vectorIndexedHnsw,
          vectorIndexedHnswWithParams: vectorIndexedHnswWithParams,
          vectorIndexedIvfflat: vectorIndexedIvfflat,
          vectorIndexedIvfflatWithParams: vectorIndexedIvfflatWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithVector copyWith({
    Object? id = _Undefined,
    _i1.Vector? vector,
    Object? vectorNullable = _Undefined,
    _i1.Vector? vectorIndexedHnsw,
    _i1.Vector? vectorIndexedHnswWithParams,
    _i1.Vector? vectorIndexedIvfflat,
    _i1.Vector? vectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithVector(
      id: id is int? ? id : this.id,
      vector: vector ?? this.vector.clone(),
      vectorNullable: vectorNullable is _i1.Vector?
          ? vectorNullable
          : this.vectorNullable?.clone(),
      vectorIndexedHnsw: vectorIndexedHnsw ?? this.vectorIndexedHnsw.clone(),
      vectorIndexedHnswWithParams: vectorIndexedHnswWithParams ??
          this.vectorIndexedHnswWithParams.clone(),
      vectorIndexedIvfflat:
          vectorIndexedIvfflat ?? this.vectorIndexedIvfflat.clone(),
      vectorIndexedIvfflatWithParams: vectorIndexedIvfflatWithParams ??
          this.vectorIndexedIvfflatWithParams.clone(),
    );
  }
}
