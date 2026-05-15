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

abstract class ObjectWithGeographyLineString implements _i1.SerializableModel {
  ObjectWithGeographyLineString._({
    this.id,
    required this.lineString,
    this.lineStringNullable,
  });

  factory ObjectWithGeographyLineString({
    int? id,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
  }) = _ObjectWithGeographyLineStringImpl;

  factory ObjectWithGeographyLineString.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyLineString(
      id: jsonSerialization['id'] as int?,
      lineString: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringNullable: jsonSerialization['lineStringNullable'] == null
          ? null
          : _i1.GeographyLineStringJsonExtension.fromJson(
              jsonSerialization['lineStringNullable'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.GeographyLineString lineString;

  _i1.GeographyLineString? lineStringNullable;

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyLineString copyWith({
    int? id,
    _i1.GeographyLineString? lineString,
    _i1.GeographyLineString? lineStringNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyLineString',
      if (id != null) 'id': id,
      'lineString': lineString.toJson(),
      if (lineStringNullable != null)
        'lineStringNullable': lineStringNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyLineStringImpl extends ObjectWithGeographyLineString {
  _ObjectWithGeographyLineStringImpl({
    int? id,
    required _i1.GeographyLineString lineString,
    _i1.GeographyLineString? lineStringNullable,
  }) : super._(
         id: id,
         lineString: lineString,
         lineStringNullable: lineStringNullable,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyLineString copyWith({
    Object? id = _Undefined,
    _i1.GeographyLineString? lineString,
    Object? lineStringNullable = _Undefined,
  }) {
    return ObjectWithGeographyLineString(
      id: id is int? ? id : this.id,
      lineString: lineString ?? this.lineString,
      lineStringNullable: lineStringNullable is _i1.GeographyLineString?
          ? lineStringNullable
          : this.lineStringNullable,
    );
  }
}
