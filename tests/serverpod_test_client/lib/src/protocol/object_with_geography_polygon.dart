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

abstract class ObjectWithGeographyPolygon
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithGeographyPolygon._({
    this.id,
    required this.polygon,
    required this.polygonIndexedGist,
    required this.polygonIndexedSpgist,
  });

  factory ObjectWithGeographyPolygon({
    int? id,
    required _isc.GeographyPolygon polygon,
    required _isc.GeographyPolygon polygonIndexedGist,
    required _isc.GeographyPolygon polygonIndexedSpgist,
  }) = _ObjectWithGeographyPolygonImpl;

  factory ObjectWithGeographyPolygon.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPolygon(
      id: jsonSerialization['id'] as int?,
      polygon: _isc.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonIndexedGist: _isc.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygonIndexedGist'],
      ),
      polygonIndexedSpgist: _isc.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygonIndexedSpgist'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.GeographyPolygon polygon;

  _isc.GeographyPolygon polygonIndexedGist;

  _isc.GeographyPolygon polygonIndexedSpgist;

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithGeographyPolygon copyWith({
    int? id,
    _isc.GeographyPolygon? polygon,
    _isc.GeographyPolygon? polygonIndexedGist,
    _isc.GeographyPolygon? polygonIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      'polygonIndexedGist': polygonIndexedGist.toJson(),
      'polygonIndexedSpgist': polygonIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      'polygonIndexedGist': polygonIndexedGist.toJson(),
      'polygonIndexedSpgist': polygonIndexedSpgist.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPolygonImpl extends ObjectWithGeographyPolygon {
  _ObjectWithGeographyPolygonImpl({
    int? id,
    required _isc.GeographyPolygon polygon,
    required _isc.GeographyPolygon polygonIndexedGist,
    required _isc.GeographyPolygon polygonIndexedSpgist,
  }) : super._(
         id: id,
         polygon: polygon,
         polygonIndexedGist: polygonIndexedGist,
         polygonIndexedSpgist: polygonIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithGeographyPolygon copyWith({
    Object? id = _Undefined,
    _isc.GeographyPolygon? polygon,
    _isc.GeographyPolygon? polygonIndexedGist,
    _isc.GeographyPolygon? polygonIndexedSpgist,
  }) {
    return ObjectWithGeographyPolygon(
      id: id is int? ? id : this.id,
      polygon: polygon ?? this.polygon,
      polygonIndexedGist: polygonIndexedGist ?? this.polygonIndexedGist,
      polygonIndexedSpgist: polygonIndexedSpgist ?? this.polygonIndexedSpgist,
    );
  }
}
