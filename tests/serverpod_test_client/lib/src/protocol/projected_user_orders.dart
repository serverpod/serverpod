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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'projected_order_description.dart' as _id3wrdef;

abstract class ProjectedUserOrders
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserOrders._({
    this.id,
    required this.name,
    this.orders,
  });

  factory ProjectedUserOrders({
    int? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  }) = _ProjectedUserOrdersImpl;

  factory ProjectedUserOrders.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUserOrders(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_id3wrdef.ProjectedOrderDescription>>(
                  jsonSerialization['orders'],
                ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_id3wrdef.ProjectedOrderDescription>? orders;

  /// Returns a shallow copy of this [ProjectedUserOrders]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserOrders copyWith({
    int? id,
    String? name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _isc.ProtocolSerialization
              ? (v as _isc.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserOrdersImpl extends ProjectedUserOrders {
  _ProjectedUserOrdersImpl({
    int? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
       );

  /// Returns a shallow copy of this [ProjectedUserOrders]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserOrders copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return ProjectedUserOrders(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_id3wrdef.ProjectedOrderDescription>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
