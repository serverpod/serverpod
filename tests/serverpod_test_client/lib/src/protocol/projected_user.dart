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
import 'projected_address.dart' as _iegbxll6;
import 'projected_json_field.dart' as _irlz4dmd;
import 'projected_order.dart' as _i8r3x6pe;

abstract class ProjectedUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUser._({
    this.id,
    required this.name,
    required this.addressId,
    this.address,
    this.orders,
    this.jsonField,
  });

  factory ProjectedUser({
    int? id,
    required String name,
    required int addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
  }) = _ProjectedUserImpl;

  factory ProjectedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      addressId: jsonSerialization['addressId'] as int,
      address: jsonSerialization['address'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iegbxll6.ProjectedAddress>(
              jsonSerialization['address'],
            ),
      orders: jsonSerialization['orders'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_i8r3x6pe.ProjectedOrder>>(
              jsonSerialization['orders'],
            ),
      jsonField: jsonSerialization['jsonField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_irlz4dmd.ProjectedJsonField>(
              jsonSerialization['jsonField'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int addressId;

  _iegbxll6.ProjectedAddress? address;

  List<_i8r3x6pe.ProjectedOrder>? orders;

  _irlz4dmd.ProjectedJsonField? jsonField;

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUser copyWith({
    int? id,
    String? name,
    int? addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
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
      if (jsonField != null) 'jsonField': jsonField?.toJson(),
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
      if (jsonField != null) 'jsonField': jsonField?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserImpl extends ProjectedUser {
  _ProjectedUserImpl({
    int? id,
    required String name,
    required int addressId,
    _iegbxll6.ProjectedAddress? address,
    List<_i8r3x6pe.ProjectedOrder>? orders,
    _irlz4dmd.ProjectedJsonField? jsonField,
  }) : super._(
         id: id,
         name: name,
         addressId: addressId,
         address: address,
         orders: orders,
         jsonField: jsonField,
       );

  /// Returns a shallow copy of this [ProjectedUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUser copyWith({
    Object? id = _Undefined,
    String? name,
    int? addressId,
    Object? address = _Undefined,
    Object? orders = _Undefined,
    Object? jsonField = _Undefined,
  }) {
    return ProjectedUser(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      addressId: addressId ?? this.addressId,
      address: address is _iegbxll6.ProjectedAddress?
          ? address
          : this.address?.copyWith(),
      orders: orders is List<_i8r3x6pe.ProjectedOrder>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      jsonField: jsonField is _irlz4dmd.ProjectedJsonField?
          ? jsonField
          : this.jsonField?.copyWith(),
    );
  }
}
