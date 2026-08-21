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
import 'projected_order_description.dart' as _i2;
import 'projected_address_street.dart' as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class ProjectedUserAddressAndOrders
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedUserAddressAndOrders._({
    this.id,
    required this.name,
    this.orders,
    this.address,
  });

  factory ProjectedUserAddressAndOrders({
    int? id,
    required String name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  }) = _ProjectedUserAddressAndOrdersImpl;

  factory ProjectedUserAddressAndOrders.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserAddressAndOrders(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i2.ProjectedOrderDescription>>(
              jsonSerialization['orders'],
            ),
      address: jsonSerialization['address'] == null
          ? null
          : _i3.ProjectedAddressStreet.fromJson(jsonSerialization['address']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.ProjectedOrderDescription>? orders;

  _i3.ProjectedAddressStreet? address;

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUserAddressAndOrders copyWith({
    int? id,
    String? name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserAddressAndOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserAddressAndOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _i1.ProtocolSerialization
              ? (v as _i1.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
      if (address != null)
        'address':
            // ignore: unnecessary_type_check
            address is _i1.ProtocolSerialization
            ? (address as _i1.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              address?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserAddressAndOrdersImpl extends ProjectedUserAddressAndOrders {
  _ProjectedUserAddressAndOrdersImpl({
    int? id,
    required String name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUserAddressAndOrders copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
    Object? address = _Undefined,
  }) {
    return ProjectedUserAddressAndOrders(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.ProjectedOrderDescription>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      address: address is _i3.ProjectedAddressStreet?
          ? address
          : this.address?.copyWith(),
    );
  }
}
