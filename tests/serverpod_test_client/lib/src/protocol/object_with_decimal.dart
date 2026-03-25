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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithDecimal implements _i1.SerializableModel {
  ObjectWithDecimal._({
    this.id,
    required this.notNullableDecimal,
    this.nullableDecimal,
    required this.highPrecisionDecimal,
  });

  factory ObjectWithDecimal({
    int? id,
    required _i1.Decimal notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    required _i1.Decimal highPrecisionDecimal,
  }) = _ObjectWithDecimalImpl;

  factory ObjectWithDecimal.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDecimal(
      id: jsonSerialization['id'] as int?,
      notNullableDecimal: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['notNullableDecimal'],
      ),
      nullableDecimal: jsonSerialization['nullableDecimal'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['nullableDecimal'],
            ),
      highPrecisionDecimal: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['highPrecisionDecimal'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Decimal notNullableDecimal;

  _i1.Decimal? nullableDecimal;

  _i1.Decimal highPrecisionDecimal;

  /// Returns a shallow copy of this [ObjectWithDecimal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDecimal copyWith({
    int? id,
    _i1.Decimal? notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    _i1.Decimal? highPrecisionDecimal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDecimal',
      if (id != null) 'id': id,
      'notNullableDecimal': notNullableDecimal.toJson(),
      if (nullableDecimal != null) 'nullableDecimal': nullableDecimal?.toJson(),
      'highPrecisionDecimal': highPrecisionDecimal.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDecimalImpl extends ObjectWithDecimal {
  _ObjectWithDecimalImpl({
    int? id,
    required _i1.Decimal notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    required _i1.Decimal highPrecisionDecimal,
  }) : super._(
         id: id,
         notNullableDecimal: notNullableDecimal,
         nullableDecimal: nullableDecimal,
         highPrecisionDecimal: highPrecisionDecimal,
       );

  /// Returns a shallow copy of this [ObjectWithDecimal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDecimal copyWith({
    Object? id = _Undefined,
    _i1.Decimal? notNullableDecimal,
    Object? nullableDecimal = _Undefined,
    _i1.Decimal? highPrecisionDecimal,
  }) {
    return ObjectWithDecimal(
      id: id is int? ? id : this.id,
      notNullableDecimal: notNullableDecimal ?? this.notNullableDecimal,
      nullableDecimal: nullableDecimal is _i1.Decimal?
          ? nullableDecimal
          : this.nullableDecimal,
      highPrecisionDecimal: highPrecisionDecimal ?? this.highPrecisionDecimal,
    );
  }
}
