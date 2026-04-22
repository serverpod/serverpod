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

abstract class ObjectWithDecimalPrecision implements _i1.SerializableModel {
  ObjectWithDecimalPrecision._({
    this.id,
    required this.price,
    this.priceNullable,
    required this.quantity,
    required this.unbounded,
    _i1.Decimal? priceWithDefault,
    _i1.Decimal? priceWithDefaultNullable,
    _i1.Decimal? quantityWithDefault,
  }) : priceWithDefault = priceWithDefault ?? _i1.Decimal.parse('9.99'),
       priceWithDefaultNullable =
           priceWithDefaultNullable ?? _i1.Decimal.parse('1.23'),
       quantityWithDefault =
           quantityWithDefault ?? _i1.Decimal.parse('100.0000');

  factory ObjectWithDecimalPrecision({
    int? id,
    required _i1.Decimal price,
    _i1.Decimal? priceNullable,
    required _i1.Decimal quantity,
    required _i1.Decimal unbounded,
    _i1.Decimal? priceWithDefault,
    _i1.Decimal? priceWithDefaultNullable,
    _i1.Decimal? quantityWithDefault,
  }) = _ObjectWithDecimalPrecisionImpl;

  factory ObjectWithDecimalPrecision.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithDecimalPrecision(
      id: jsonSerialization['id'] as int?,
      price: _i1.DecimalJsonExtension.fromJson(jsonSerialization['price']),
      priceNullable: jsonSerialization['priceNullable'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['priceNullable'],
            ),
      quantity: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['quantity'],
      ),
      unbounded: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['unbounded'],
      ),
      priceWithDefault: jsonSerialization['priceWithDefault'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['priceWithDefault'],
            ),
      priceWithDefaultNullable:
          jsonSerialization['priceWithDefaultNullable'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['priceWithDefaultNullable'],
            ),
      quantityWithDefault: jsonSerialization['quantityWithDefault'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['quantityWithDefault'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Decimal price;

  _i1.Decimal? priceNullable;

  _i1.Decimal quantity;

  _i1.Decimal unbounded;

  _i1.Decimal priceWithDefault;

  _i1.Decimal? priceWithDefaultNullable;

  _i1.Decimal quantityWithDefault;

  /// Returns a shallow copy of this [ObjectWithDecimalPrecision]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDecimalPrecision copyWith({
    int? id,
    _i1.Decimal? price,
    _i1.Decimal? priceNullable,
    _i1.Decimal? quantity,
    _i1.Decimal? unbounded,
    _i1.Decimal? priceWithDefault,
    _i1.Decimal? priceWithDefaultNullable,
    _i1.Decimal? quantityWithDefault,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDecimalPrecision',
      if (id != null) 'id': id,
      'price': price.toJson(),
      if (priceNullable != null) 'priceNullable': priceNullable?.toJson(),
      'quantity': quantity.toJson(),
      'unbounded': unbounded.toJson(),
      'priceWithDefault': priceWithDefault.toJson(),
      if (priceWithDefaultNullable != null)
        'priceWithDefaultNullable': priceWithDefaultNullable?.toJson(),
      'quantityWithDefault': quantityWithDefault.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDecimalPrecisionImpl extends ObjectWithDecimalPrecision {
  _ObjectWithDecimalPrecisionImpl({
    int? id,
    required _i1.Decimal price,
    _i1.Decimal? priceNullable,
    required _i1.Decimal quantity,
    required _i1.Decimal unbounded,
    _i1.Decimal? priceWithDefault,
    _i1.Decimal? priceWithDefaultNullable,
    _i1.Decimal? quantityWithDefault,
  }) : super._(
         id: id,
         price: price,
         priceNullable: priceNullable,
         quantity: quantity,
         unbounded: unbounded,
         priceWithDefault: priceWithDefault,
         priceWithDefaultNullable: priceWithDefaultNullable,
         quantityWithDefault: quantityWithDefault,
       );

  /// Returns a shallow copy of this [ObjectWithDecimalPrecision]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDecimalPrecision copyWith({
    Object? id = _Undefined,
    _i1.Decimal? price,
    Object? priceNullable = _Undefined,
    _i1.Decimal? quantity,
    _i1.Decimal? unbounded,
    _i1.Decimal? priceWithDefault,
    Object? priceWithDefaultNullable = _Undefined,
    _i1.Decimal? quantityWithDefault,
  }) {
    return ObjectWithDecimalPrecision(
      id: id is int? ? id : this.id,
      price: price ?? this.price,
      priceNullable: priceNullable is _i1.Decimal?
          ? priceNullable
          : this.priceNullable,
      quantity: quantity ?? this.quantity,
      unbounded: unbounded ?? this.unbounded,
      priceWithDefault: priceWithDefault ?? this.priceWithDefault,
      priceWithDefaultNullable: priceWithDefaultNullable is _i1.Decimal?
          ? priceWithDefaultNullable
          : this.priceWithDefaultNullable,
      quantityWithDefault: quantityWithDefault ?? this.quantityWithDefault,
    );
  }
}
