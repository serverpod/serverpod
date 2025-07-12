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
import '../../changed_id_type/one_to_many/order.dart' as _i2;

abstract class CustomerInt implements _i1.SerializableModel {
  CustomerInt._({
    this.id,
    required this.name,
    this.orders,
  });

  factory CustomerInt({
    int? id,
    required String name,
    List<_i2.OrderUuid>? orders,
  }) = _CustomerIntImpl;

  factory CustomerInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: (jsonSerialization['orders'] as List?)
          ?.map((e) => _i2.OrderUuid.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.OrderUuid>? orders;

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CustomerInt copyWith({
    int? id,
    String? name,
    List<_i2.OrderUuid>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerIntImpl extends CustomerInt {
  _CustomerIntImpl({
    int? id,
    required String name,
    List<_i2.OrderUuid>? orders,
  }) : super._(
          id: id,
          name: name,
          orders: orders,
        );

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CustomerInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return CustomerInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.OrderUuid>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
