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
import '../../changed_id_type/one_to_many/customer.dart' as _i2;
import '../../changed_id_type/one_to_many/comment.dart' as _i3;

abstract class OrderUuid implements _i1.SerializableModel {
  OrderUuid._({
    _i1.UuidValue? id,
    required this.description,
    required this.customerId,
    this.customer,
    this.comments,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory OrderUuid({
    _i1.UuidValue? id,
    required String description,
    required int customerId,
    _i2.CustomerInt? customer,
    List<_i3.CommentInt>? comments,
  }) = _OrderUuidImpl;

  factory OrderUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderUuid(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      customerId: jsonSerialization['customerId'] as int,
      customer: jsonSerialization['customer'] == null
          ? null
          : _i2.CustomerInt.fromJson(
              (jsonSerialization['customer'] as Map<String, dynamic>)),
      comments: (jsonSerialization['comments'] as List?)
          ?.map((e) => _i3.CommentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue id;

  String description;

  int customerId;

  _i2.CustomerInt? customer;

  List<_i3.CommentInt>? comments;

  /// Returns a shallow copy of this [OrderUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderUuid copyWith({
    _i1.UuidValue? id,
    String? description,
    int? customerId,
    _i2.CustomerInt? customer,
    List<_i3.CommentInt>? comments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJson(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderUuidImpl extends OrderUuid {
  _OrderUuidImpl({
    _i1.UuidValue? id,
    required String description,
    required int customerId,
    _i2.CustomerInt? customer,
    List<_i3.CommentInt>? comments,
  }) : super._(
          id: id,
          description: description,
          customerId: customerId,
          customer: customer,
          comments: comments,
        );

  /// Returns a shallow copy of this [OrderUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderUuid copyWith({
    _i1.UuidValue? id,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? comments = _Undefined,
  }) {
    return OrderUuid(
      id: id ?? this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.CustomerInt? ? customer : this.customer?.copyWith(),
      comments: comments is List<_i3.CommentInt>?
          ? comments
          : this.comments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
