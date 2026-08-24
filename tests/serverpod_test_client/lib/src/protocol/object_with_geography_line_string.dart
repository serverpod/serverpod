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

abstract class ObjectWithGeographyLineString
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithGeographyLineString._({
    this.id,
    required this.lineString,
    required this.lineStringIndexedGist,
    required this.lineStringIndexedSpgist,
  });

  factory ObjectWithGeographyLineString({
    int? id,
    required _isc.GeographyLineString lineString,
    required _isc.GeographyLineString lineStringIndexedGist,
    required _isc.GeographyLineString lineStringIndexedSpgist,
  }) = _ObjectWithGeographyLineStringImpl;

  factory ObjectWithGeographyLineString.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyLineString(
      id: jsonSerialization['id'] as int?,
      lineString: _isc.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringIndexedGist: _isc.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedGist'],
      ),
      lineStringIndexedSpgist: _isc.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedSpgist'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.GeographyLineString lineString;

  _isc.GeographyLineString lineStringIndexedGist;

  _isc.GeographyLineString lineStringIndexedSpgist;

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithGeographyLineString copyWith({
    int? id,
    _isc.GeographyLineString? lineString,
    _isc.GeographyLineString? lineStringIndexedGist,
    _isc.GeographyLineString? lineStringIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyLineString',
      if (id != null) 'id': id,
      'lineString': lineString.toJson(),
      'lineStringIndexedGist': lineStringIndexedGist.toJson(),
      'lineStringIndexedSpgist': lineStringIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyLineString',
      if (id != null) 'id': id,
      'lineString': lineString.toJson(),
      'lineStringIndexedGist': lineStringIndexedGist.toJson(),
      'lineStringIndexedSpgist': lineStringIndexedSpgist.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyLineStringImpl extends ObjectWithGeographyLineString {
  _ObjectWithGeographyLineStringImpl({
    int? id,
    required _isc.GeographyLineString lineString,
    required _isc.GeographyLineString lineStringIndexedGist,
    required _isc.GeographyLineString lineStringIndexedSpgist,
  }) : super._(
         id: id,
         lineString: lineString,
         lineStringIndexedGist: lineStringIndexedGist,
         lineStringIndexedSpgist: lineStringIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithGeographyLineString copyWith({
    Object? id = _Undefined,
    _isc.GeographyLineString? lineString,
    _isc.GeographyLineString? lineStringIndexedGist,
    _isc.GeographyLineString? lineStringIndexedSpgist,
  }) {
    return ObjectWithGeographyLineString(
      id: id is int? ? id : this.id,
      lineString: lineString ?? this.lineString,
      lineStringIndexedGist:
          lineStringIndexedGist ?? this.lineStringIndexedGist,
      lineStringIndexedSpgist:
          lineStringIndexedSpgist ?? this.lineStringIndexedSpgist,
    );
  }
}
