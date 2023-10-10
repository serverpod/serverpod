/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Order extends _i1.SerializableEntity {
  Order._({
    this.id,
    required this.description,
    required this.customerId,
    this.customer,
    this.items,
  });

  factory Order({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  }) = _OrderImpl;

  factory Order.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Order(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      customerId: serializationManager
          .deserialize<int>(jsonSerialization['customerId']),
      customer: serializationManager
          .deserialize<_i2.Customer?>(jsonSerialization['customer']),
      items: serializationManager
          .deserialize<List<_i2.Comment>?>(jsonSerialization['items']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  int customerId;

  _i2.Customer? customer;

  List<_i2.Comment>? items;

  Order copyWith({
    int? id,
    String? description,
    int? customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'customerId': customerId,
      'customer': customer,
      'items': items,
    };
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  }) : super._(
          id: id,
          description: description,
          customerId: customerId,
          customer: customer,
          items: items,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? items = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
      items: items is List<_i2.Comment>? ? items : this.items?.clone(),
    );
  }
}
