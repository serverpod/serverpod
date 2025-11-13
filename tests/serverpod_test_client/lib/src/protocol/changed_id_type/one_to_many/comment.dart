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

abstract class CommentInt implements _i1.SerializableModel {
  CommentInt._({
    this.id,
    required this.description,
    required this.orderId,
    this.order,
  });

  factory CommentInt({
    int? id,
    required String description,
    required _i1.UuidValue orderId,
    _i2.OrderUuid? order,
  }) = _CommentIntImpl;

  factory CommentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommentInt(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      order: jsonSerialization['order'] == null
          ? null
          : _i2.OrderUuid.fromJson(
              (jsonSerialization['order'] as Map<String, dynamic>),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  _i1.UuidValue orderId;

  _i2.OrderUuid? order;

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CommentInt copyWith({
    int? id,
    String? description,
    _i1.UuidValue? orderId,
    _i2.OrderUuid? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId.toJson(),
      if (order != null) 'order': order?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommentIntImpl extends CommentInt {
  _CommentIntImpl({
    int? id,
    required String description,
    required _i1.UuidValue orderId,
    _i2.OrderUuid? order,
  }) : super._(
         id: id,
         description: description,
         orderId: orderId,
         order: order,
       );

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CommentInt copyWith({
    Object? id = _Undefined,
    String? description,
    _i1.UuidValue? orderId,
    Object? order = _Undefined,
  }) {
    return CommentInt(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _i2.OrderUuid? ? order : this.order?.copyWith(),
    );
  }
}
