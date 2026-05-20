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

abstract class ObjectWithGeographyPoint implements _i1.SerializableModel {
  ObjectWithGeographyPoint._({
    this.id,
    required this.location,
    this.locationNullable,
  });

  factory ObjectWithGeographyPoint({
    int? id,
    required _i1.GeographyPoint location,
    _i1.GeographyPoint? locationNullable,
  }) = _ObjectWithGeographyPointImpl;

  factory ObjectWithGeographyPoint.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPoint(
      id: jsonSerialization['id'] as int?,
      location: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['location'],
      ),
      locationNullable: jsonSerialization['locationNullable'] == null
          ? null
          : _i1.GeographyPointJsonExtension.fromJson(
              jsonSerialization['locationNullable'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.GeographyPoint location;

  _i1.GeographyPoint? locationNullable;

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyPoint copyWith({
    int? id,
    _i1.GeographyPoint? location,
    _i1.GeographyPoint? locationNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPoint',
      if (id != null) 'id': id,
      'location': location.toJson(),
      if (locationNullable != null)
        'locationNullable': locationNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPointImpl extends ObjectWithGeographyPoint {
  _ObjectWithGeographyPointImpl({
    int? id,
    required _i1.GeographyPoint location,
    _i1.GeographyPoint? locationNullable,
  }) : super._(
         id: id,
         location: location,
         locationNullable: locationNullable,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyPoint copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? location,
    Object? locationNullable = _Undefined,
  }) {
    return ObjectWithGeographyPoint(
      id: id is int? ? id : this.id,
      location: location ?? this.location,
      locationNullable: locationNullable is _i1.GeographyPoint?
          ? locationNullable
          : this.locationNullable,
    );
  }
}
