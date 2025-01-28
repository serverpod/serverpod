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
import 'package:uuid/uuid.dart' as _i2;

abstract class UuidDefaultModel implements _i1.SerializableModel {
  UuidDefaultModel._({
    this.id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  })  : uuidDefaultModelRandom = uuidDefaultModelRandom ?? _i2.Uuid().v4obj(),
        uuidDefaultModelRandomNull =
            uuidDefaultModelRandomNull ?? _i2.Uuid().v4obj(),
        uuidDefaultModelStr = uuidDefaultModelStr ??
            _i1.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        uuidDefaultModelStrNull = uuidDefaultModelStrNull ??
            _i1.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefaultModel({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) = _UuidDefaultModelImpl;

  factory UuidDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultModel(
      id: jsonSerialization['id'] as int?,
      uuidDefaultModelRandom: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelRandom']),
      uuidDefaultModelRandomNull:
          jsonSerialization['uuidDefaultModelRandomNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelRandomNull']),
      uuidDefaultModelStr: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['uuidDefaultModelStr']),
      uuidDefaultModelStrNull:
          jsonSerialization['uuidDefaultModelStrNull'] == null
              ? null
              : _i1.UuidValueJsonExtension.fromJson(
                  jsonSerialization['uuidDefaultModelStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuidDefaultModelRandom;

  _i1.UuidValue? uuidDefaultModelRandomNull;

  _i1.UuidValue uuidDefaultModelStr;

  _i1.UuidValue? uuidDefaultModelStrNull;

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UuidDefaultModel copyWith({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultModelImpl extends UuidDefaultModel {
  _UuidDefaultModelImpl({
    int? id,
    _i1.UuidValue? uuidDefaultModelRandom,
    _i1.UuidValue? uuidDefaultModelRandomNull,
    _i1.UuidValue? uuidDefaultModelStr,
    _i1.UuidValue? uuidDefaultModelStrNull,
  }) : super._(
          id: id,
          uuidDefaultModelRandom: uuidDefaultModelRandom,
          uuidDefaultModelRandomNull: uuidDefaultModelRandomNull,
          uuidDefaultModelStr: uuidDefaultModelStr,
          uuidDefaultModelStrNull: uuidDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UuidDefaultModel copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuidDefaultModelRandom,
    Object? uuidDefaultModelRandomNull = _Undefined,
    _i1.UuidValue? uuidDefaultModelStr,
    Object? uuidDefaultModelStrNull = _Undefined,
  }) {
    return UuidDefaultModel(
      id: id is int? ? id : this.id,
      uuidDefaultModelRandom:
          uuidDefaultModelRandom ?? this.uuidDefaultModelRandom,
      uuidDefaultModelRandomNull: uuidDefaultModelRandomNull is _i1.UuidValue?
          ? uuidDefaultModelRandomNull
          : this.uuidDefaultModelRandomNull,
      uuidDefaultModelStr: uuidDefaultModelStr ?? this.uuidDefaultModelStr,
      uuidDefaultModelStrNull: uuidDefaultModelStrNull is _i1.UuidValue?
          ? uuidDefaultModelStrNull
          : this.uuidDefaultModelStrNull,
    );
  }
}
