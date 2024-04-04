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

abstract class Order extends _i1.SerializableEntity {
  Order._({
    this.id,
    required this.description,
    required this.customerId,
    this.customer,
    this.comments,
  });

  factory Order({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? comments,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      customerId: jsonSerialization['customerId'] as int,
      customer: jsonSerialization.containsKey('customer')
          ? _i2.Customer.fromJson(
              jsonSerialization['customer'] as Map<String, dynamic>)
          : null,
      comments: (jsonSerialization['comments'] as List<dynamic>?)
          ?.map((e) => _i2.Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  int customerId;

  _i2.Customer? customer;

  List<_i2.Comment>? comments;

  Order copyWith({
    int? id,
    String? description,
    int? customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? comments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJson(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJson()),
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
    List<_i2.Comment>? comments,
  }) : super._(
          id: id,
          description: description,
          customerId: customerId,
          customer: customer,
          comments: comments,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? comments = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
      comments:
          comments is List<_i2.Comment>? ? comments : this.comments?.clone(),
    );
  }
}
