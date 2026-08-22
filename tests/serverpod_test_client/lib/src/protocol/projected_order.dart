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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ProjectedOrder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedOrder._({
    this.id,
    required this.description,
    required this.price,
  });

  factory ProjectedOrder({
    int? id,
    required String description,
    required int price,
  }) = _ProjectedOrderImpl;

  factory ProjectedOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedOrder(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      price: jsonSerialization['price'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  int price;

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedOrder copyWith({
    int? id,
    String? description,
    int? price,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id,
      'description': description,
      'price': price,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id,
      'description': description,
      'price': price,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderImpl extends ProjectedOrder {
  _ProjectedOrderImpl({
    int? id,
    required String description,
    required int price,
  }) : super._(
         id: id,
         description: description,
         price: price,
       );

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedOrder copyWith({
    Object? id = _Undefined,
    String? description,
    int? price,
  }) {
    return ProjectedOrder(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}
