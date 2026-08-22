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

abstract class ObjectWithSparseVector
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithSparseVector._({
    this.id,
    required this.sparseVector,
    this.sparseVectorNullable,
    required this.sparseVectorIndexedHnsw,
    required this.sparseVectorIndexedHnswWithParams,
  });

  factory ObjectWithSparseVector({
    int? id,
    required _isc.SparseVector sparseVector,
    _isc.SparseVector? sparseVectorNullable,
    required _isc.SparseVector sparseVectorIndexedHnsw,
    required _isc.SparseVector sparseVectorIndexedHnswWithParams,
  }) = _ObjectWithSparseVectorImpl;

  factory ObjectWithSparseVector.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSparseVector(
      id: jsonSerialization['id'] as int?,
      sparseVector: _isc.SparseVectorJsonExtension.fromJson(
        jsonSerialization['sparseVector'],
      ),
      sparseVectorNullable: jsonSerialization['sparseVectorNullable'] == null
          ? null
          : _isc.SparseVectorJsonExtension.fromJson(
              jsonSerialization['sparseVectorNullable'],
            ),
      sparseVectorIndexedHnsw: _isc.SparseVectorJsonExtension.fromJson(
        jsonSerialization['sparseVectorIndexedHnsw'],
      ),
      sparseVectorIndexedHnswWithParams:
          _isc.SparseVectorJsonExtension.fromJson(
            jsonSerialization['sparseVectorIndexedHnswWithParams'],
          ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.SparseVector sparseVector;

  _isc.SparseVector? sparseVectorNullable;

  _isc.SparseVector sparseVectorIndexedHnsw;

  _isc.SparseVector sparseVectorIndexedHnswWithParams;

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithSparseVector copyWith({
    int? id,
    _isc.SparseVector? sparseVector,
    _isc.SparseVector? sparseVectorNullable,
    _isc.SparseVector? sparseVectorIndexedHnsw,
    _isc.SparseVector? sparseVectorIndexedHnswWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSparseVector',
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams': sparseVectorIndexedHnswWithParams
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithSparseVector',
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams': sparseVectorIndexedHnswWithParams
          .toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSparseVectorImpl extends ObjectWithSparseVector {
  _ObjectWithSparseVectorImpl({
    int? id,
    required _isc.SparseVector sparseVector,
    _isc.SparseVector? sparseVectorNullable,
    required _isc.SparseVector sparseVectorIndexedHnsw,
    required _isc.SparseVector sparseVectorIndexedHnswWithParams,
  }) : super._(
         id: id,
         sparseVector: sparseVector,
         sparseVectorNullable: sparseVectorNullable,
         sparseVectorIndexedHnsw: sparseVectorIndexedHnsw,
         sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithSparseVector copyWith({
    Object? id = _Undefined,
    _isc.SparseVector? sparseVector,
    Object? sparseVectorNullable = _Undefined,
    _isc.SparseVector? sparseVectorIndexedHnsw,
    _isc.SparseVector? sparseVectorIndexedHnswWithParams,
  }) {
    return ObjectWithSparseVector(
      id: id is int? ? id : this.id,
      sparseVector: sparseVector ?? this.sparseVector.clone(),
      sparseVectorNullable: sparseVectorNullable is _isc.SparseVector?
          ? sparseVectorNullable
          : this.sparseVectorNullable?.clone(),
      sparseVectorIndexedHnsw:
          sparseVectorIndexedHnsw ?? this.sparseVectorIndexedHnsw.clone(),
      sparseVectorIndexedHnswWithParams:
          sparseVectorIndexedHnswWithParams ??
          this.sparseVectorIndexedHnswWithParams.clone(),
    );
  }
}
