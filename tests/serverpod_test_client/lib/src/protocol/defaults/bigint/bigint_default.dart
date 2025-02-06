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

abstract class BigIntDefault implements _i1.SerializableModel {
  BigIntDefault._({
    this.id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  })  : bigintDefaultStr =
            bigintDefaultStr ?? BigInt.parse('-1234567890123456789099999999'),
        bigintDefaultStrNull = bigintDefaultStrNull ??
            BigInt.parse('1234567890123456789099999999');

  factory BigIntDefault({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  }) = _BigIntDefaultImpl;

  factory BigIntDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefault(
      id: jsonSerialization['id'] as int?,
      bigintDefaultStr: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigintDefaultStr']),
      bigintDefaultStrNull: jsonSerialization['bigintDefaultStrNull'] == null
          ? null
          : _i1.BigIntJsonExtension.fromJson(
              jsonSerialization['bigintDefaultStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  BigInt bigintDefaultStr;

  BigInt? bigintDefaultStrNull;

  /// Returns a shallow copy of this [BigIntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefault copyWith({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bigintDefaultStr': bigintDefaultStr.toJson(),
      if (bigintDefaultStrNull != null)
        'bigintDefaultStrNull': bigintDefaultStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultImpl extends BigIntDefault {
  _BigIntDefaultImpl({
    int? id,
    BigInt? bigintDefaultStr,
    BigInt? bigintDefaultStrNull,
  }) : super._(
          id: id,
          bigintDefaultStr: bigintDefaultStr,
          bigintDefaultStrNull: bigintDefaultStrNull,
        );

  /// Returns a shallow copy of this [BigIntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefault copyWith({
    Object? id = _Undefined,
    BigInt? bigintDefaultStr,
    Object? bigintDefaultStrNull = _Undefined,
  }) {
    return BigIntDefault(
      id: id is int? ? id : this.id,
      bigintDefaultStr: bigintDefaultStr ?? this.bigintDefaultStr,
      bigintDefaultStrNull: bigintDefaultStrNull is BigInt?
          ? bigintDefaultStrNull
          : this.bigintDefaultStrNull,
    );
  }
}
