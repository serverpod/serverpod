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

abstract class ObjectWithHalfVector implements _i1.SerializableModel {
  ObjectWithHalfVector._({
    this.id,
    required this.halfVector,
    this.halfVectorNullable,
    required this.halfVectorIndexedHnsw,
    required this.halfVectorIndexedHnswWithParams,
    required this.halfVectorIndexedIvfflat,
    required this.halfVectorIndexedIvfflatWithParams,
  });

  factory ObjectWithHalfVector({
    int? id,
    required _i1.HalfVector halfVector,
    _i1.HalfVector? halfVectorNullable,
    required _i1.HalfVector halfVectorIndexedHnsw,
    required _i1.HalfVector halfVectorIndexedHnswWithParams,
    required _i1.HalfVector halfVectorIndexedIvfflat,
    required _i1.HalfVector halfVectorIndexedIvfflatWithParams,
  }) = _ObjectWithHalfVectorImpl;

  factory ObjectWithHalfVector.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithHalfVector(
      id: jsonSerialization['id'] as int?,
      halfVector:
          _i1.HalfVectorJsonExtension.fromJson(jsonSerialization['halfVector']),
      halfVectorNullable: jsonSerialization['halfVectorNullable'] == null
          ? null
          : _i1.HalfVectorJsonExtension.fromJson(
              jsonSerialization['halfVectorNullable']),
      halfVectorIndexedHnsw: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedHnsw']),
      halfVectorIndexedHnswWithParams: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedHnswWithParams']),
      halfVectorIndexedIvfflat: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedIvfflat']),
      halfVectorIndexedIvfflatWithParams: _i1.HalfVectorJsonExtension.fromJson(
          jsonSerialization['halfVectorIndexedIvfflatWithParams']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.HalfVector halfVector;

  _i1.HalfVector? halfVectorNullable;

  _i1.HalfVector halfVectorIndexedHnsw;

  _i1.HalfVector halfVectorIndexedHnswWithParams;

  _i1.HalfVector halfVectorIndexedIvfflat;

  _i1.HalfVector halfVectorIndexedIvfflatWithParams;

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithHalfVector copyWith({
    int? id,
    _i1.HalfVector? halfVector,
    _i1.HalfVector? halfVectorNullable,
    _i1.HalfVector? halfVectorIndexedHnsw,
    _i1.HalfVector? halfVectorIndexedHnswWithParams,
    _i1.HalfVector? halfVectorIndexedIvfflat,
    _i1.HalfVector? halfVectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'halfVector': halfVector.toJson(),
      if (halfVectorNullable != null)
        'halfVectorNullable': halfVectorNullable?.toJson(),
      'halfVectorIndexedHnsw': halfVectorIndexedHnsw.toJson(),
      'halfVectorIndexedHnswWithParams':
          halfVectorIndexedHnswWithParams.toJson(),
      'halfVectorIndexedIvfflat': halfVectorIndexedIvfflat.toJson(),
      'halfVectorIndexedIvfflatWithParams':
          halfVectorIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithHalfVectorImpl extends ObjectWithHalfVector {
  _ObjectWithHalfVectorImpl({
    int? id,
    required _i1.HalfVector halfVector,
    _i1.HalfVector? halfVectorNullable,
    required _i1.HalfVector halfVectorIndexedHnsw,
    required _i1.HalfVector halfVectorIndexedHnswWithParams,
    required _i1.HalfVector halfVectorIndexedIvfflat,
    required _i1.HalfVector halfVectorIndexedIvfflatWithParams,
  }) : super._(
          id: id,
          halfVector: halfVector,
          halfVectorNullable: halfVectorNullable,
          halfVectorIndexedHnsw: halfVectorIndexedHnsw,
          halfVectorIndexedHnswWithParams: halfVectorIndexedHnswWithParams,
          halfVectorIndexedIvfflat: halfVectorIndexedIvfflat,
          halfVectorIndexedIvfflatWithParams:
              halfVectorIndexedIvfflatWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithHalfVector copyWith({
    Object? id = _Undefined,
    _i1.HalfVector? halfVector,
    Object? halfVectorNullable = _Undefined,
    _i1.HalfVector? halfVectorIndexedHnsw,
    _i1.HalfVector? halfVectorIndexedHnswWithParams,
    _i1.HalfVector? halfVectorIndexedIvfflat,
    _i1.HalfVector? halfVectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithHalfVector(
      id: id is int? ? id : this.id,
      halfVector: halfVector ?? this.halfVector.clone(),
      halfVectorNullable: halfVectorNullable is _i1.HalfVector?
          ? halfVectorNullable
          : this.halfVectorNullable?.clone(),
      halfVectorIndexedHnsw:
          halfVectorIndexedHnsw ?? this.halfVectorIndexedHnsw.clone(),
      halfVectorIndexedHnswWithParams: halfVectorIndexedHnswWithParams ??
          this.halfVectorIndexedHnswWithParams.clone(),
      halfVectorIndexedIvfflat:
          halfVectorIndexedIvfflat ?? this.halfVectorIndexedIvfflat.clone(),
      halfVectorIndexedIvfflatWithParams: halfVectorIndexedIvfflatWithParams ??
          this.halfVectorIndexedIvfflatWithParams.clone(),
    );
  }
}
