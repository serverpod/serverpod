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
    this.comments,
    required this.customerId,
    this.customer,
  });

  factory Order({
    int? id,
    required String description,
    List<_i2.Comment>? comments,
    required int customerId,
    _i2.Customer? customer,
  }) = _OrderImpl;

  factory Order.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Order(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      comments: serializationManager
          .deserialize<List<_i2.Comment>?>(jsonSerialization['comments']),
      customerId: serializationManager
          .deserialize<int>(jsonSerialization['customerId']),
      customer: serializationManager
          .deserialize<_i2.Customer?>(jsonSerialization['customer']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  List<_i2.Comment>? comments;

  int customerId;

  _i2.Customer? customer;

  Order copyWith({
    int? id,
    String? description,
    List<_i2.Comment>? comments,
    int? customerId,
    _i2.Customer? customer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'comments': comments,
      'customerId': customerId,
      'customer': customer,
    };
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required String description,
    List<_i2.Comment>? comments,
    required int customerId,
    _i2.Customer? customer,
  }) : super._(
          id: id,
          description: description,
          comments: comments,
          customerId: customerId,
          customer: customer,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    Object? comments = _Undefined,
    int? customerId,
    Object? customer = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      comments:
          comments is List<_i2.Comment>? ? comments : this.comments?.clone(),
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
    );
  }
}
