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

abstract class Comment extends _i1.SerializableEntity {
  Comment._({
    this.id,
    required this.description,
    required this.orderId,
    this.order,
  });

  factory Comment({
    int? id,
    required String description,
    required int orderId,
    _i2.Order? order,
  }) = _CommentImpl;

  factory Comment.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Comment(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      orderId:
          serializationManager.deserialize<int>(jsonSerialization['orderId']),
      order: serializationManager
          .deserialize<_i2.Order?>(jsonSerialization['order']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  int orderId;

  _i2.Order? order;

  Comment copyWith({
    int? id,
    String? description,
    int? orderId,
    _i2.Order? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'orderId': orderId,
      'order': order,
    };
  }
}

class _Undefined {}

class _CommentImpl extends Comment {
  _CommentImpl({
    int? id,
    required String description,
    required int orderId,
    _i2.Order? order,
  }) : super._(
          id: id,
          description: description,
          orderId: orderId,
          order: order,
        );

  @override
  Comment copyWith({
    Object? id = _Undefined,
    String? description,
    int? orderId,
    Object? order = _Undefined,
  }) {
    return Comment(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
    );
  }
}
