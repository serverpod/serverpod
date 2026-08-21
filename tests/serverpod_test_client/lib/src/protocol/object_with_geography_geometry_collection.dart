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

abstract class ObjectWithGeographyGeometryCollection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithGeographyGeometryCollection._({
    this.id,
    required this.geometryCollection,
    required this.geometryCollectionIndexedGist,
    required this.geometryCollectionIndexedSpgist,
  });

  factory ObjectWithGeographyGeometryCollection({
    int? id,
    required _isc.GeographyGeometryCollection geometryCollection,
    required _isc.GeographyGeometryCollection geometryCollectionIndexedGist,
    required _isc.GeographyGeometryCollection geometryCollectionIndexedSpgist,
  }) = _ObjectWithGeographyGeometryCollectionImpl;

  factory ObjectWithGeographyGeometryCollection.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyGeometryCollection(
      id: jsonSerialization['id'] as int?,
      geometryCollection:
          _isc.GeographyGeometryCollectionJsonExtension.fromJson(
            jsonSerialization['geometryCollection'],
          ),
      geometryCollectionIndexedGist:
          _isc.GeographyGeometryCollectionJsonExtension.fromJson(
            jsonSerialization['geometryCollectionIndexedGist'],
          ),
      geometryCollectionIndexedSpgist:
          _isc.GeographyGeometryCollectionJsonExtension.fromJson(
            jsonSerialization['geometryCollectionIndexedSpgist'],
          ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.GeographyGeometryCollection geometryCollection;

  _isc.GeographyGeometryCollection geometryCollectionIndexedGist;

  _isc.GeographyGeometryCollection geometryCollectionIndexedSpgist;

  /// Returns a shallow copy of this [ObjectWithGeographyGeometryCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithGeographyGeometryCollection copyWith({
    int? id,
    _isc.GeographyGeometryCollection? geometryCollection,
    _isc.GeographyGeometryCollection? geometryCollectionIndexedGist,
    _isc.GeographyGeometryCollection? geometryCollectionIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyGeometryCollection',
      if (id != null) 'id': id,
      'geometryCollection': geometryCollection.toJson(),
      'geometryCollectionIndexedGist': geometryCollectionIndexedGist.toJson(),
      'geometryCollectionIndexedSpgist': geometryCollectionIndexedSpgist
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyGeometryCollection',
      if (id != null) 'id': id,
      'geometryCollection': geometryCollection.toJson(),
      'geometryCollectionIndexedGist': geometryCollectionIndexedGist.toJson(),
      'geometryCollectionIndexedSpgist': geometryCollectionIndexedSpgist
          .toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyGeometryCollectionImpl
    extends ObjectWithGeographyGeometryCollection {
  _ObjectWithGeographyGeometryCollectionImpl({
    int? id,
    required _isc.GeographyGeometryCollection geometryCollection,
    required _isc.GeographyGeometryCollection geometryCollectionIndexedGist,
    required _isc.GeographyGeometryCollection geometryCollectionIndexedSpgist,
  }) : super._(
         id: id,
         geometryCollection: geometryCollection,
         geometryCollectionIndexedGist: geometryCollectionIndexedGist,
         geometryCollectionIndexedSpgist: geometryCollectionIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyGeometryCollection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithGeographyGeometryCollection copyWith({
    Object? id = _Undefined,
    _isc.GeographyGeometryCollection? geometryCollection,
    _isc.GeographyGeometryCollection? geometryCollectionIndexedGist,
    _isc.GeographyGeometryCollection? geometryCollectionIndexedSpgist,
  }) {
    return ObjectWithGeographyGeometryCollection(
      id: id is int? ? id : this.id,
      geometryCollection: geometryCollection ?? this.geometryCollection,
      geometryCollectionIndexedGist:
          geometryCollectionIndexedGist ?? this.geometryCollectionIndexedGist,
      geometryCollectionIndexedSpgist:
          geometryCollectionIndexedSpgist ??
          this.geometryCollectionIndexedSpgist,
    );
  }
}
