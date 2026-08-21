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
import 'projected_address.dart' as _i2;
import 'projected_order.dart' as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class ProjectedUser
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedUser._({
    this.id,
    required this.name,
    required this.addressId,
    this.address,
    this.orders,
  });

  factory ProjectedUser({
    int? id,
    required String name,
    required int addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
  }) = _ProjectedUserImpl;

  factory ProjectedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      addressId: jsonSerialization['addressId'] as int,
      address: jsonSerialization['address'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ProjectedAddress>(
              jsonSerialization['address'],
            ),
      orders: jsonSerialization['orders'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.ProjectedOrder>>(
              jsonSerialization['orders'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int addressId;

  _i2.ProjectedAddress? address;

  List<_i3.ProjectedOrder>? orders;

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUser copyWith({
    int? id,
    String? name,
    int? addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUser',
      if (id != null) 'id': id,
      'name': name,
      'addressId': addressId,
      if (address != null) 'address': address?.toJson(),
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUser',
      if (id != null) 'id': id,
      'name': name,
      'addressId': addressId,
      if (address != null) 'address': address?.toJsonForProtocol(),
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserImpl extends ProjectedUser {
  _ProjectedUserImpl({
    int? id,
    required String name,
    required int addressId,
    _i2.ProjectedAddress? address,
    List<_i3.ProjectedOrder>? orders,
  }) : super._(
         id: id,
         name: name,
         addressId: addressId,
         address: address,
         orders: orders,
       );

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUser copyWith({
    Object? id = _Undefined,
    String? name,
    int? addressId,
    Object? address = _Undefined,
    Object? orders = _Undefined,
  }) {
    return ProjectedUser(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      addressId: addressId ?? this.addressId,
      address: address is _i2.ProjectedAddress?
          ? address
          : this.address?.copyWith(),
      orders: orders is List<_i3.ProjectedOrder>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
