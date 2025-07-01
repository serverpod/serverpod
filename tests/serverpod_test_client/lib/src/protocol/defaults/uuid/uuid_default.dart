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

abstract class UuidDefault implements _i1.SerializableModel {
  UuidDefault._({
    this.id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  })  : uuidDefaultRandom = uuidDefaultRandom ?? _i1.Uuid().v4obj(),
        uuidDefaultRandomV7 = uuidDefaultRandomV7 ?? _i1.Uuid().v7obj(),
        uuidDefaultRandomNull = uuidDefaultRandomNull ?? _i1.Uuid().v4obj(),
        uuidDefaultStr = uuidDefaultStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultStrNull = uuidDefaultStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefault({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  }) = _UuidDefaultImpl;

  factory UuidDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefault(
      id: jsonSerialization['id'] as int?,
      uuidDefaultRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultRandom']),
      uuidDefaultRandomV7: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultRandomV7']),
      uuidDefaultRandomNull: jsonSerialization['uuidDefaultRandomNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomNull']),
      uuidDefaultStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultStr']),
      uuidDefaultStrNull: jsonSerialization['uuidDefaultStrNull'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuidDefaultRandom;

  _i1.UuidValue uuidDefaultRandomV7;

  _i1.UuidValue? uuidDefaultRandomNull;

  _i1.UuidValue uuidDefaultStr;

  _i1.UuidValue? uuidDefaultStrNull;

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefault copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultImpl extends UuidDefault {
  _UuidDefaultImpl({
    int? id,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    _i1.UuidValue? uuidDefaultRandomNull,
    _i1.UuidValue? uuidDefaultStr,
    _i1.UuidValue? uuidDefaultStrNull,
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
  @_i1.useResult
  @override
  UuidDefault copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultRandom,
    _i1.UuidValue? uuidDefaultRandomV7,
    Object? uuidDefaultRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultStr,
    Object? uuidDefaultStrNull = _Undefined,
  }) {
    return UuidDefault(
      id: id is int? ? id : this.id,
      uuidDefaultRandom: uuidDefaultRandom ?? this.uuidDefaultRandom,
      uuidDefaultRandomV7: uuidDefaultRandomV7 ?? this.uuidDefaultRandomV7,
      uuidDefaultRandomNull: uuidDefaultRandomNull is _i1.UuidValue?
          ? uuidDefaultRandomNull
          : this.uuidDefaultRandomNull,
      uuidDefaultStr: uuidDefaultStr ?? this.uuidDefaultStr,
      uuidDefaultStrNull: uuidDefaultStrNull is _i1.UuidValue?
          ? uuidDefaultStrNull
          : this.uuidDefaultStrNull,
    );
  }
}
