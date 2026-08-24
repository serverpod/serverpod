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

abstract class UuidDefault
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UuidDefault._({
    this.id,
    _isc.UuidValue? uuidDefaultRandom,
    _isc.UuidValue? uuidDefaultRandomV7,
    _isc.UuidValue? uuidDefaultRandomNull,
    _isc.UuidValue? uuidDefaultStr,
    _isc.UuidValue? uuidDefaultStrNull,
  }) : uuidDefaultRandom = uuidDefaultRandom ?? const _isc.Uuid().v4obj(),
       uuidDefaultRandomV7 = uuidDefaultRandomV7 ?? const _isc.Uuid().v7obj(),
       uuidDefaultRandomNull =
           uuidDefaultRandomNull ?? const _isc.Uuid().v4obj(),
       uuidDefaultStr =
           uuidDefaultStr ??
           _isc.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
       uuidDefaultStrNull =
           uuidDefaultStrNull ??
           _isc.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefault({
    int? id,
    _isc.UuidValue? uuidDefaultRandom,
    _isc.UuidValue? uuidDefaultRandomV7,
    _isc.UuidValue? uuidDefaultRandomNull,
    _isc.UuidValue? uuidDefaultStr,
    _isc.UuidValue? uuidDefaultStrNull,
  }) = _UuidDefaultImpl;

  factory UuidDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefault(
      id: jsonSerialization['id'] as int?,
      uuidDefaultRandom: jsonSerialization['uuidDefaultRandom'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandom'],
            ),
      uuidDefaultRandomV7: jsonSerialization['uuidDefaultRandomV7'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomV7'],
            ),
      uuidDefaultRandomNull: jsonSerialization['uuidDefaultRandomNull'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomNull'],
            ),
      uuidDefaultStr: jsonSerialization['uuidDefaultStr'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStr'],
            ),
      uuidDefaultStrNull: jsonSerialization['uuidDefaultStrNull'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStrNull'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue uuidDefaultRandom;

  _isc.UuidValue uuidDefaultRandomV7;

  _isc.UuidValue? uuidDefaultRandomNull;

  _isc.UuidValue uuidDefaultStr;

  _isc.UuidValue? uuidDefaultStrNull;

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UuidDefault copyWith({
    int? id,
    _isc.UuidValue? uuidDefaultRandom,
    _isc.UuidValue? uuidDefaultRandomV7,
    _isc.UuidValue? uuidDefaultRandomNull,
    _isc.UuidValue? uuidDefaultStr,
    _isc.UuidValue? uuidDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UuidDefault',
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UuidDefault',
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultImpl extends UuidDefault {
  _UuidDefaultImpl({
    int? id,
    _isc.UuidValue? uuidDefaultRandom,
    _isc.UuidValue? uuidDefaultRandomV7,
    _isc.UuidValue? uuidDefaultRandomNull,
    _isc.UuidValue? uuidDefaultStr,
    _isc.UuidValue? uuidDefaultStrNull,
  }) : super._(
         id: id,
         uuidDefaultRandom: uuidDefaultRandom,
         uuidDefaultRandomV7: uuidDefaultRandomV7,
         uuidDefaultRandomNull: uuidDefaultRandomNull,
         uuidDefaultStr: uuidDefaultStr,
         uuidDefaultStrNull: uuidDefaultStrNull,
       );

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UuidDefault copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? uuidDefaultRandom,
    _isc.UuidValue? uuidDefaultRandomV7,
    Object? uuidDefaultRandomNull = _Undefined,
    _isc.UuidValue? uuidDefaultStr,
    Object? uuidDefaultStrNull = _Undefined,
  }) {
    return UuidDefault(
      id: id is int? ? id : this.id,
      uuidDefaultRandom: uuidDefaultRandom ?? this.uuidDefaultRandom,
      uuidDefaultRandomV7: uuidDefaultRandomV7 ?? this.uuidDefaultRandomV7,
      uuidDefaultRandomNull: uuidDefaultRandomNull is _isc.UuidValue?
          ? uuidDefaultRandomNull
          : this.uuidDefaultRandomNull,
      uuidDefaultStr: uuidDefaultStr ?? this.uuidDefaultStr,
      uuidDefaultStrNull: uuidDefaultStrNull is _isc.UuidValue?
          ? uuidDefaultStrNull
          : this.uuidDefaultStrNull,
    );
  }
}
