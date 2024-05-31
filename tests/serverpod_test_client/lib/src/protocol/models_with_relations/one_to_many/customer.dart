/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Customer implements _i1.SerializableModel {
  Customer._({
    this.id,
    required this.name,
    this.orders,
  });

  factory Customer({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) = _CustomerImpl;

  factory Customer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Customer(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: (jsonSerialization['orders'] as List?)
          ?.map((e) => _i2.Order.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Order>? orders;

  Customer copyWith({
    int? id,
    String? name,
    List<_i2.Order>? orders,
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

class _CustomerImpl extends Customer {
  _CustomerImpl({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) : super._(
          id: id,
          name: name,
          orders: orders,
        );

  @override
  Customer copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return Customer(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.Order>? ? orders : this.orders?.clone(),
    );
  }
}
