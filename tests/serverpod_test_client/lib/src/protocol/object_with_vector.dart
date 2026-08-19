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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ObjectWithVector
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.Vector vector,
    _isc.Vector? vectorNullable,
    required _isc.Vector vectorIndexedHnsw,
    required _isc.Vector vectorIndexedHnswWithParams,
    required _isc.Vector vectorIndexedIvfflat,
    required _isc.Vector vectorIndexedIvfflatWithParams,
  }) = _ObjectWithVectorImpl;

  factory ObjectWithVector.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithVector(
      id: jsonSerialization['id'] as int?,
      vector: _isc.VectorJsonExtension.fromJson(jsonSerialization['vector']),
      vectorNullable: jsonSerialization['vectorNullable'] == null
          ? null
          : _isc.VectorJsonExtension.fromJson(
              jsonSerialization['vectorNullable'],
            ),
      vectorIndexedHnsw: _isc.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedHnsw'],
      ),
      vectorIndexedHnswWithParams: _isc.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedHnswWithParams'],
      ),
      vectorIndexedIvfflat: _isc.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedIvfflat'],
      ),
      vectorIndexedIvfflatWithParams: _isc.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedIvfflatWithParams'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.Vector vector;

  _isc.Vector? vectorNullable;

  _isc.Vector vectorIndexedHnsw;

  _isc.Vector vectorIndexedHnswWithParams;

  _isc.Vector vectorIndexedIvfflat;

  _isc.Vector vectorIndexedIvfflatWithParams;

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithVector copyWith({
    int? id,
    _isc.Vector? vector,
    _isc.Vector? vectorNullable,
    _isc.Vector? vectorIndexedHnsw,
    _isc.Vector? vectorIndexedHnswWithParams,
    _isc.Vector? vectorIndexedIvfflat,
    _isc.Vector? vectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithVector',
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithVector',
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithVectorImpl extends ObjectWithVector {
  _ObjectWithVectorImpl({
    int? id,
    required _isc.Vector vector,
    _isc.Vector? vectorNullable,
    required _isc.Vector vectorIndexedHnsw,
    required _isc.Vector vectorIndexedHnswWithParams,
    required _isc.Vector vectorIndexedIvfflat,
    required _isc.Vector vectorIndexedIvfflatWithParams,
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
  @_isc.useResult
  @override
  ObjectWithVector copyWith({
    Object? id = _Undefined,
    _isc.Vector? vector,
    Object? vectorNullable = _Undefined,
    _isc.Vector? vectorIndexedHnsw,
    _isc.Vector? vectorIndexedHnswWithParams,
    _isc.Vector? vectorIndexedIvfflat,
    _isc.Vector? vectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithVector(
      id: id is int? ? id : this.id,
      vector: vector ?? this.vector.clone(),
      vectorNullable: vectorNullable is _isc.Vector?
          ? vectorNullable
          : this.vectorNullable?.clone(),
      vectorIndexedHnsw: vectorIndexedHnsw ?? this.vectorIndexedHnsw.clone(),
      vectorIndexedHnswWithParams:
          vectorIndexedHnswWithParams ??
          this.vectorIndexedHnswWithParams.clone(),
      vectorIndexedIvfflat:
          vectorIndexedIvfflat ?? this.vectorIndexedIvfflat.clone(),
      vectorIndexedIvfflatWithParams:
          vectorIndexedIvfflatWithParams ??
          this.vectorIndexedIvfflatWithParams.clone(),
    );
  }
}
