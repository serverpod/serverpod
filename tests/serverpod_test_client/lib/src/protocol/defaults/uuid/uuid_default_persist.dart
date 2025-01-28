/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UuidDefaultPersist implements _i1.SerializableModel {
  UuidDefaultPersist._({
    this.id,
    this.uuidDefaultPersistRandom,
    this.uuidDefaultPersistStr,
  });

  factory UuidDefaultPersist({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) = _UuidDefaultPersistImpl;

  factory UuidDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uuidDefaultPersistRandom:
          jsonSerialization['uuidDefaultPersistRandom'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultPersistRandom']),
      uuidDefaultPersistStr: jsonSerialization['uuidDefaultPersistStr'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistStr']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue? uuidDefaultPersistRandom;

  _i1.UuidValue? uuidDefaultPersistStr;

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultPersist copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultPersistImpl extends UuidDefaultPersist {
  _UuidDefaultPersistImpl({
    int? id,
    _i1.UuidValue? uuidDefaultPersistRandom,
    _i1.UuidValue? uuidDefaultPersistStr,
  }) : super._(
          id: id,
          uuidDefaultPersistRandom: uuidDefaultPersistRandom,
          uuidDefaultPersistStr: uuidDefaultPersistStr,
        );

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uuidDefaultPersistRandom = _Undefined,
    Object? uuidDefaultPersistStr = _Undefined,
  }) {
    return UuidDefaultPersist(
      id: id is int? ? id : this.id,
      uuidDefaultPersistRandom: uuidDefaultPersistRandom is _i1.UuidValue?
          ? uuidDefaultPersistRandom
          : this.uuidDefaultPersistRandom,
      uuidDefaultPersistStr: uuidDefaultPersistStr is _i1.UuidValue?
          ? uuidDefaultPersistStr
          : this.uuidDefaultPersistStr,
    );
  }
}
