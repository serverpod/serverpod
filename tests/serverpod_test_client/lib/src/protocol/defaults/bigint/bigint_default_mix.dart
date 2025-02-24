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

abstract class BigIntDefaultMix implements _i1.SerializableModel {
  BigIntDefaultMix._({
    this.id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  })  : bigIntDefaultAndDefaultModel =
            bigIntDefaultAndDefaultModel ?? BigInt.parse('2'),
        bigIntDefaultAndDefaultPersist = bigIntDefaultAndDefaultPersist ??
            BigInt.parse('-12345678901234567890'),
        bigIntDefaultModelAndDefaultPersist =
            bigIntDefaultModelAndDefaultPersist ??
                BigInt.parse('1234567890123456789099999999');

  factory BigIntDefaultMix({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) = _BigIntDefaultMixImpl;

  factory BigIntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultMix(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultAndDefaultModel: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultAndDefaultModel']),
      bigIntDefaultAndDefaultPersist: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultAndDefaultPersist']),
      bigIntDefaultModelAndDefaultPersist: _i1.BigIntJsonExtension.fromJson(
          jsonSerialization['bigIntDefaultModelAndDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  BigInt bigIntDefaultAndDefaultModel;

  BigInt bigIntDefaultAndDefaultPersist;

  BigInt bigIntDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BigIntDefaultMix copyWith({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bigIntDefaultAndDefaultModel': bigIntDefaultAndDefaultModel.toJson(),
      'bigIntDefaultAndDefaultPersist': bigIntDefaultAndDefaultPersist.toJson(),
      'bigIntDefaultModelAndDefaultPersist':
          bigIntDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultMixImpl extends BigIntDefaultMix {
  _BigIntDefaultMixImpl({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          bigIntDefaultAndDefaultModel: bigIntDefaultAndDefaultModel,
          bigIntDefaultAndDefaultPersist: bigIntDefaultAndDefaultPersist,
          bigIntDefaultModelAndDefaultPersist:
              bigIntDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BigIntDefaultMix copyWith({
    Object? id = _Undefined,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) {
    return BigIntDefaultMix(
      id: id is int? ? id : this.id,
      bigIntDefaultAndDefaultModel:
          bigIntDefaultAndDefaultModel ?? this.bigIntDefaultAndDefaultModel,
      bigIntDefaultAndDefaultPersist:
          bigIntDefaultAndDefaultPersist ?? this.bigIntDefaultAndDefaultPersist,
      bigIntDefaultModelAndDefaultPersist:
          bigIntDefaultModelAndDefaultPersist ??
              this.bigIntDefaultModelAndDefaultPersist,
    );
  }
}
