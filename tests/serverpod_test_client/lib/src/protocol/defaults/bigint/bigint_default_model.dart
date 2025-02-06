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

abstract class BigIntDefaultModel implements _i1.SerializableModel {
  BigIntDefaultModel._({
    this.id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  })  : bigIntDefaultModelStr = bigIntDefaultModelStr ??
            BigInt.parse('1234567890123456789099999999'),
        bigIntDefaultModelStrNull = bigIntDefaultModelStrNull ??
            BigInt.parse('-1234567890123456789099999999');

  factory BigIntDefaultModel({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  }) = _BigIntDefaultModelImpl;

  factory BigIntDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultModel(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultModelStr: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultModelStr']),
      bigIntDefaultModelStrNull:
          jsonSerialization['bigIntDefaultModelStrNull'] == null
              ? null
              : _i1.BigIntJsonExtension.fromJson(
                  jsonSerialization['bigIntDefaultModelStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  BigInt bigIntDefaultModelStr;

  BigInt? bigIntDefaultModelStrNull;

  /// Returns a shallow copy of this [BigIntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefaultModel copyWith({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bigIntDefaultModelStr': bigIntDefaultModelStr.toJson(),
      if (bigIntDefaultModelStrNull != null)
        'bigIntDefaultModelStrNull': bigIntDefaultModelStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultModelImpl extends BigIntDefaultModel {
  _BigIntDefaultModelImpl({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  }) : super._(
          id: id,
          bigIntDefaultModelStr: bigIntDefaultModelStr,
          bigIntDefaultModelStrNull: bigIntDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [BigIntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefaultModel copyWith({
    Object? id = _Undefined,
    BigInt? bigIntDefaultModelStr,
    Object? bigIntDefaultModelStrNull = _Undefined,
  }) {
    return BigIntDefaultModel(
      id: id is int? ? id : this.id,
      bigIntDefaultModelStr:
          bigIntDefaultModelStr ?? this.bigIntDefaultModelStr,
      bigIntDefaultModelStrNull: bigIntDefaultModelStrNull is BigInt?
          ? bigIntDefaultModelStrNull
          : this.bigIntDefaultModelStrNull,
    );
  }
}
