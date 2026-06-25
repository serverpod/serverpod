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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithGeographyIndex implements _i1.SerializableModel {
  ObjectWithGeographyIndex._({
    this.id,
    required this.point,
    required this.pointIndexedGist,
    required this.pointIndexedSpgist,
  });

  factory ObjectWithGeographyIndex({
    int? id,
    required _i1.GeographyPoint point,
    required _i1.GeographyPoint pointIndexedGist,
    required _i1.GeographyPoint pointIndexedSpgist,
  }) = _ObjectWithGeographyIndexImpl;

  factory ObjectWithGeographyIndex.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyIndex(
      id: jsonSerialization['id'] as int?,
      point: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['point'],
      ),
      pointIndexedGist: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedGist'],
      ),
      pointIndexedSpgist: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedSpgist'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.GeographyPoint point;

  _i1.GeographyPoint pointIndexedGist;

  _i1.GeographyPoint pointIndexedSpgist;

  /// Returns a shallow copy of this [ObjectWithGeographyIndex]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyIndex copyWith({
    int? id,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointIndexedGist,
    _i1.GeographyPoint? pointIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyIndex',
      if (id != null) 'id': id,
      'point': point.toJson(),
      'pointIndexedGist': pointIndexedGist.toJson(),
      'pointIndexedSpgist': pointIndexedSpgist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyIndexImpl extends ObjectWithGeographyIndex {
  _ObjectWithGeographyIndexImpl({
    int? id,
    required _i1.GeographyPoint point,
    required _i1.GeographyPoint pointIndexedGist,
    required _i1.GeographyPoint pointIndexedSpgist,
  }) : super._(
         id: id,
         point: point,
         pointIndexedGist: pointIndexedGist,
         pointIndexedSpgist: pointIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyIndex]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyIndex copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointIndexedGist,
    _i1.GeographyPoint? pointIndexedSpgist,
  }) {
    return ObjectWithGeographyIndex(
      id: id is int? ? id : this.id,
      point: point ?? this.point,
      pointIndexedGist: pointIndexedGist ?? this.pointIndexedGist,
      pointIndexedSpgist: pointIndexedSpgist ?? this.pointIndexedSpgist,
    );
  }
}
