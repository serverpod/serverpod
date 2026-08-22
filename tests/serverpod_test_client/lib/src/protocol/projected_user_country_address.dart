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
import 'projected_address_country.dart' as _ikpl2lpd;

abstract class ProjectedUserCountryAddress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserCountryAddress._({
    this.id,
    required this.name,
    this.address,
  });

  factory ProjectedUserCountryAddress({
    int? id,
    required String name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  }) = _ProjectedUserCountryAddressImpl;

  factory ProjectedUserCountryAddress.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserCountryAddress(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _ikpl2lpd.ProjectedAddressCountry.fromJson(
              jsonSerialization['address'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _ikpl2lpd.ProjectedAddressCountry? address;

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserCountryAddress copyWith({
    int? id,
    String? name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserCountryAddress',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserCountryAddress',
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

class _ProjectedUserCountryAddressImpl extends ProjectedUserCountryAddress {
  _ProjectedUserCountryAddressImpl({
    int? id,
    required String name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  }) : super._(
         id: id,
         name: name,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserCountryAddress copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
  }) {
    return ProjectedUserCountryAddress(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _ikpl2lpd.ProjectedAddressCountry?
          ? address
          : this.address?.copyWith(),
    );
  }
}
