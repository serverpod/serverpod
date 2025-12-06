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

abstract class ObjectWithPostgis implements _i1.SerializableModel {
  ObjectWithPostgis._({
    this.id,
    required this.point,
    this.pointNullable,
    required this.lineString,
    this.lineStringNullable,
    required this.polygon,
    this.polygonNullable,
    required this.multiPolygon,
    this.multiPolygonNullable,
  });

  factory ObjectWithPostgis({
    int? id,
    required _i1.GeographyPoint point,
    _i1.GeographyPoint? pointNullable,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
    required _i1.GeographyMultiPolygon multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  }) = _ObjectWithPostgisImpl;

  factory ObjectWithPostgis.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithPostgis(
      id: jsonSerialization['id'] as int?,
      point: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['point'],
      ),
      pointNullable: jsonSerialization['pointNullable'] == null
          ? null
          : _i1.GeographyPointJsonExtension.fromJson(
              jsonSerialization['pointNullable'],
            ),
      lineString: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringNullable: jsonSerialization['lineStringNullable'] == null
          ? null
          : _i1.GeographyLineStringJsonExtension.fromJson(
              jsonSerialization['lineStringNullable'],
            ),
      polygon: _i1.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonNullable: jsonSerialization['polygonNullable'] == null
          ? null
          : _i1.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['polygonNullable'],
            ),
      multiPolygon: _i1.GeographyMultiPolygonJsonExtension.fromJson(
        jsonSerialization['multiPolygon'],
      ),
      multiPolygonNullable: jsonSerialization['multiPolygonNullable'] == null
          ? null
          : _i1.GeographyMultiPolygonJsonExtension.fromJson(
              jsonSerialization['multiPolygonNullable'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.GeographyPoint point;

  _i1.GeographyPoint? pointNullable;

  _i1.GeographyLineString lineString;

  _i1.GeographyLineString? lineStringNullable;

  _i1.GeographyPolygon polygon;

  _i1.GeographyPolygon? polygonNullable;

  _i1.GeographyMultiPolygon multiPolygon;

  _i1.GeographyMultiPolygon? multiPolygonNullable;

  /// Returns a shallow copy of this [ObjectWithPostgis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithPostgis copyWith({
    int? id,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointNullable,
    _i1.GeographyLineString? lineString,
    _i1.GeographyLineString? lineStringNullable,
    _i1.GeographyPolygon? polygon,
    _i1.GeographyPolygon? polygonNullable,
    _i1.GeographyMultiPolygon? multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithPostgis',
      if (id != null) 'id': id,
      'point': point.toJson(),
      if (pointNullable != null) 'pointNullable': pointNullable?.toJson(),
      'lineString': lineString.toJson(),
      if (lineStringNullable != null)
        'lineStringNullable': lineStringNullable?.toJson(),
      'polygon': polygon.toJson(),
      if (polygonNullable != null) 'polygonNullable': polygonNullable?.toJson(),
      'multiPolygon': multiPolygon.toJson(),
      if (multiPolygonNullable != null)
        'multiPolygonNullable': multiPolygonNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithPostgisImpl extends ObjectWithPostgis {
  _ObjectWithPostgisImpl({
    int? id,
    required _i1.GeographyPoint point,
    _i1.GeographyPoint? pointNullable,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
    required _i1.GeographyPolygon polygon,
    _i1.GeographyPolygon? polygonNullable,
    required _i1.GeographyMultiPolygon multiPolygon,
    _i1.GeographyMultiPolygon? multiPolygonNullable,
  }) : super._(
         id: id,
         point: point,
         pointNullable: pointNullable,
         lineString: lineString,
         lineStringNullable: lineStringNullable,
         polygon: polygon,
         polygonNullable: polygonNullable,
         multiPolygon: multiPolygon,
         multiPolygonNullable: multiPolygonNullable,
       );

  /// Returns a shallow copy of this [ObjectWithPostgis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithPostgis copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? point,
    Object? pointNullable = _Undefined,
    _i1.GeographyLineString? lineString,
    Object? lineStringNullable = _Undefined,
    _i1.GeographyPolygon? polygon,
    Object? polygonNullable = _Undefined,
    _i1.GeographyMultiPolygon? multiPolygon,
    Object? multiPolygonNullable = _Undefined,
  }) {
    return ObjectWithPostgis(
      id: id is int? ? id : this.id,
      point: point ?? this.point.copyWith(),
      pointNullable: pointNullable is _i1.GeographyPoint?
          ? pointNullable
          : this.pointNullable?.copyWith(),
      lineString: lineString ?? this.lineString.copyWith(),
      lineStringNullable: lineStringNullable is _i1.GeographyLineString?
          ? lineStringNullable
          : this.lineStringNullable?.copyWith(),
      polygon: polygon ?? this.polygon.copyWith(),
      polygonNullable: polygonNullable is _i1.GeographyPolygon?
          ? polygonNullable
          : this.polygonNullable?.copyWith(),
      multiPolygon: multiPolygon ?? this.multiPolygon.copyWith(),
      multiPolygonNullable: multiPolygonNullable is _i1.GeographyMultiPolygon?
          ? multiPolygonNullable
          : this.multiPolygonNullable?.copyWith(),
    );
  }
}
