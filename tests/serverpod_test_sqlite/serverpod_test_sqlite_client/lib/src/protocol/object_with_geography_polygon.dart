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

abstract class ObjectWithGeographyPolygon implements _i1.SerializableModel {
  ObjectWithGeographyPolygon._({
    this.id,
    required this.polygon,
    this.polygonNullable,
  });

  factory ObjectWithGeographyPolygon({
    int? id,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
  }) = _ObjectWithGeographyPolygonImpl;

  factory ObjectWithGeographyPolygon.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPolygon(
      id: jsonSerialization['id'] as int?,
      polygon: _i1.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonNullable: jsonSerialization['polygonNullable'] == null
          ? null
          : _i1.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['polygonNullable'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.GeographyPolygon polygon;

  _i1.GeographyPolygon? polygonNullable;

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyPolygon copyWith({
    int? id,
    _i1.GeographyPolygon? polygon,
    _i1.GeographyPolygon? polygonNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPolygonImpl extends ObjectWithGeographyPolygon {
  _ObjectWithGeographyPolygonImpl({
    int? id,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
  }) : super._(
         id: id,
         polygon: polygon,
         polygonNullable: polygonNullable,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyPolygon copyWith({
    Object? id = _Undefined,
    _i1.GeographyPolygon? polygon,
    Object? polygonNullable = _Undefined,
  }) {
    return ObjectWithGeographyPolygon(
      id: id is int? ? id : this.id,
      polygon: polygon ?? this.polygon,
      polygonNullable: polygonNullable is _i1.GeographyPolygon?
          ? polygonNullable
          : this.polygonNullable,
    );
  }
}
