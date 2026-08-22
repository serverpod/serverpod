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
import 'projected_address_street.dart' as _iitz0x8d;

abstract class ProjectedUserStreetAddress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserStreetAddress._({
    this.id,
    required this.name,
    this.address,
  });

  factory ProjectedUserStreetAddress({
    int? id,
    required String name,
    _iitz0x8d.ProjectedAddressStreet? address,
  }) = _ProjectedUserStreetAddressImpl;

  factory ProjectedUserStreetAddress.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserStreetAddress(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
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
  int? id;

  String name;

  _iitz0x8d.ProjectedAddressStreet? address;

  /// Returns a shallow copy of this [ProjectedUserStreetAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserStreetAddress copyWith({
    int? id,
    String? name,
    _iitz0x8d.ProjectedAddressStreet? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserStreetAddress',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserStreetAddress',
      if (id != null) 'id': id,
      'name': name,
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

class _ProjectedUserStreetAddressImpl extends ProjectedUserStreetAddress {
  _ProjectedUserStreetAddressImpl({
    int? id,
    required String name,
    _iitz0x8d.ProjectedAddressStreet? address,
  }) : super._(
         id: id,
         name: name,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserStreetAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserStreetAddress copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
  }) {
    return ProjectedUserStreetAddress(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _iitz0x8d.ProjectedAddressStreet?
          ? address
          : this.address?.copyWith(),
    );
  }
}
