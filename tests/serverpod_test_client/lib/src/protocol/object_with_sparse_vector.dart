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

abstract class ObjectWithSparseVector implements _i1.SerializableModel {
  ObjectWithSparseVector._({
    this.id,
    required this.sparseVector,
    this.sparseVectorNullable,
    required this.sparseVectorIndexedHnsw,
    required this.sparseVectorIndexedHnswWithParams,
  });

  factory ObjectWithSparseVector({
    int? id,
    required _i1.SparseVector sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    required _i1.SparseVector sparseVectorIndexedHnsw,
    required _i1.SparseVector sparseVectorIndexedHnswWithParams,
  }) = _ObjectWithSparseVectorImpl;

  factory ObjectWithSparseVector.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithSparseVector(
      id: jsonSerialization['id'] as int?,
      sparseVector: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVector']),
      sparseVectorNullable: jsonSerialization['sparseVectorNullable'] == null
          ? null
          : _i1.SparseVectorJsonExtension.fromJson(
              jsonSerialization['sparseVectorNullable']),
      sparseVectorIndexedHnsw: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVectorIndexedHnsw']),
      sparseVectorIndexedHnswWithParams: _i1.SparseVectorJsonExtension.fromJson(
          jsonSerialization['sparseVectorIndexedHnswWithParams']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.SparseVector sparseVector;

  _i1.SparseVector? sparseVectorNullable;

  _i1.SparseVector sparseVectorIndexedHnsw;

  _i1.SparseVector sparseVectorIndexedHnswWithParams;

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSparseVector copyWith({
    int? id,
    _i1.SparseVector? sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    _i1.SparseVector? sparseVectorIndexedHnsw,
    _i1.SparseVector? sparseVectorIndexedHnswWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams':
          sparseVectorIndexedHnswWithParams.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSparseVectorImpl extends ObjectWithSparseVector {
  _ObjectWithSparseVectorImpl({
    int? id,
    required _i1.SparseVector sparseVector,
    _i1.SparseVector? sparseVectorNullable,
    required _i1.SparseVector sparseVectorIndexedHnsw,
    required _i1.SparseVector sparseVectorIndexedHnswWithParams,
  }) : super._(
          id: id,
          sparseVector: sparseVector,
          sparseVectorNullable: sparseVectorNullable,
          sparseVectorIndexedHnsw: sparseVectorIndexedHnsw,
          sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSparseVector copyWith({
    Object? id = _Undefined,
    _i1.SparseVector? sparseVector,
    Object? sparseVectorNullable = _Undefined,
    _i1.SparseVector? sparseVectorIndexedHnsw,
    _i1.SparseVector? sparseVectorIndexedHnswWithParams,
  }) {
    return ObjectWithSparseVector(
      id: id is int? ? id : this.id,
      sparseVector: sparseVector ?? this.sparseVector.clone(),
      sparseVectorNullable: sparseVectorNullable is _i1.SparseVector?
          ? sparseVectorNullable
          : this.sparseVectorNullable?.clone(),
      sparseVectorIndexedHnsw:
          sparseVectorIndexedHnsw ?? this.sparseVectorIndexedHnsw.clone(),
      sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams ??
          this.sparseVectorIndexedHnswWithParams.clone(),
    );
  }
}
