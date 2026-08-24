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
import 'projected_address_street.dart' as _iitz0x8d;
import 'projected_order_description.dart' as _id3wrdef;

abstract class ProjectedUserAddressAndOrders
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserAddressAndOrders._({
    this.id,
    required this.name,
    this.orders,
    this.address,
  });

  factory ProjectedUserAddressAndOrders({
    _isc.UuidValue? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
    _iitz0x8d.ProjectedAddressStreet? address,
  }) = _ProjectedUserAddressAndOrdersImpl;

  factory ProjectedUserAddressAndOrders.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserAddressAndOrders(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_id3wrdef.ProjectedOrderDescription>>(
                  jsonSerialization['orders'],
                ),
      address: jsonSerialization['address'] == null
          ? null
          : _iitz0x8d.ProjectedAddressStreet.fromJson(
              jsonSerialization['address'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  List<_id3wrdef.ProjectedOrderDescription>? orders;

  _iitz0x8d.ProjectedAddressStreet? address;

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserAddressAndOrders copyWith({
    _isc.UuidValue? id,
    String? name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
    _iitz0x8d.ProjectedAddressStreet? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserAddressAndOrders',
      if (id != null) 'id': id?.toJson(),
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
      if (id != null) 'id': id?.toJson(),
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
      if (address != null)
        'address':
            // ignore: unnecessary_type_check
            address is _isc.ProtocolSerialization
            ? (address as _isc.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              address?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserAddressAndOrdersImpl extends ProjectedUserAddressAndOrders {
  _ProjectedUserAddressAndOrdersImpl({
    _isc.UuidValue? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
    _iitz0x8d.ProjectedAddressStreet? address,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserAddressAndOrders copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
    Object? address = _Undefined,
  }) {
    return ProjectedUserAddressAndOrders(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_id3wrdef.ProjectedOrderDescription>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      address: address is _iitz0x8d.ProjectedAddressStreet?
          ? address
          : this.address?.copyWith(),
    );
  }
}
