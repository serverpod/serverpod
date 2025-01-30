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

abstract class BigIntDefaultPersist implements _i1.SerializableModel {
  BigIntDefaultPersist._({
    this.id,
    this.bigIntDefaultPersistStr,
  });

  factory BigIntDefaultPersist({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  }) = _BigIntDefaultPersistImpl;

  factory BigIntDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultPersist(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultPersistStr:
          jsonSerialization['bigIntDefaultPersistStr'] == null
              ? null
              : _i1.BigIntJsonExtension.fromJson(
                  jsonSerialization['bigIntDefaultPersistStr']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  BigInt? bigIntDefaultPersistStr;

  /// Returns a shallow copy of this [BigIntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefaultPersist copyWith({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bigIntDefaultPersistStr != null)
        'bigIntDefaultPersistStr': bigIntDefaultPersistStr?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultPersistImpl extends BigIntDefaultPersist {
  _BigIntDefaultPersistImpl({
    int? id,
    BigInt? bigIntDefaultPersistStr,
  }) : super._(
          id: id,
          bigIntDefaultPersistStr: bigIntDefaultPersistStr,
        );

  /// Returns a shallow copy of this [BigIntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? bigIntDefaultPersistStr = _Undefined,
  }) {
    return BigIntDefaultPersist(
      id: id is int? ? id : this.id,
      bigIntDefaultPersistStr: bigIntDefaultPersistStr is BigInt?
          ? bigIntDefaultPersistStr
          : this.bigIntDefaultPersistStr,
    );
  }
}
