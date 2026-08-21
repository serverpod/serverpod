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

abstract class UuidDefaultPersist
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UuidDefaultPersist._({
    this.id,
    this.uuidDefaultPersistRandom,
    this.uuidDefaultPersistRandomV7,
    this.uuidDefaultPersistStr,
  });

  factory UuidDefaultPersist({
    int? id,
    _isc.UuidValue? uuidDefaultPersistRandom,
    _isc.UuidValue? uuidDefaultPersistRandomV7,
    _isc.UuidValue? uuidDefaultPersistStr,
  }) = _UuidDefaultPersistImpl;

  factory UuidDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uuidDefaultPersistRandom:
          jsonSerialization['uuidDefaultPersistRandom'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistRandom'],
            ),
      uuidDefaultPersistRandomV7:
          jsonSerialization['uuidDefaultPersistRandomV7'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistRandomV7'],
            ),
      uuidDefaultPersistStr: jsonSerialization['uuidDefaultPersistStr'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistStr'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue? uuidDefaultPersistRandom;

  _isc.UuidValue? uuidDefaultPersistRandomV7;

  _isc.UuidValue? uuidDefaultPersistStr;

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UuidDefaultPersist copyWith({
    int? id,
    _isc.UuidValue? uuidDefaultPersistRandom,
    _isc.UuidValue? uuidDefaultPersistRandomV7,
    _isc.UuidValue? uuidDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UuidDefaultPersist',
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistRandomV7 != null)
        'uuidDefaultPersistRandomV7': uuidDefaultPersistRandomV7?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UuidDefaultPersist',
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistRandomV7 != null)
        'uuidDefaultPersistRandomV7': uuidDefaultPersistRandomV7?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultPersistImpl extends UuidDefaultPersist {
  _UuidDefaultPersistImpl({
    int? id,
    _isc.UuidValue? uuidDefaultPersistRandom,
    _isc.UuidValue? uuidDefaultPersistRandomV7,
    _isc.UuidValue? uuidDefaultPersistStr,
  }) : super._(
         id: id,
         uuidDefaultPersistRandom: uuidDefaultPersistRandom,
         uuidDefaultPersistRandomV7: uuidDefaultPersistRandomV7,
         uuidDefaultPersistStr: uuidDefaultPersistStr,
       );

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UuidDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uuidDefaultPersistRandom = _Undefined,
    Object? uuidDefaultPersistRandomV7 = _Undefined,
    Object? uuidDefaultPersistStr = _Undefined,
  }) {
    return UuidDefaultPersist(
      id: id is int? ? id : this.id,
      uuidDefaultPersistRandom: uuidDefaultPersistRandom is _isc.UuidValue?
          ? uuidDefaultPersistRandom
          : this.uuidDefaultPersistRandom,
      uuidDefaultPersistRandomV7: uuidDefaultPersistRandomV7 is _isc.UuidValue?
          ? uuidDefaultPersistRandomV7
          : this.uuidDefaultPersistRandomV7,
      uuidDefaultPersistStr: uuidDefaultPersistStr is _isc.UuidValue?
          ? uuidDefaultPersistStr
          : this.uuidDefaultPersistStr,
    );
  }
}
