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
import 'projected_address_country.dart' as _i2;

abstract class ProjectedUserCountryAddress
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedUserCountryAddress._({
    this.id,
    required this.name,
    this.address,
  });

  factory ProjectedUserCountryAddress({
    int? id,
    required String name,
    _i2.ProjectedAddressCountry? address,
  }) = _ProjectedUserCountryAddressImpl;

  factory ProjectedUserCountryAddress.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserCountryAddress(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _i2.ProjectedAddressCountry.fromJson(jsonSerialization['address']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i2.ProjectedAddressCountry? address;

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUserCountryAddress copyWith({
    int? id,
    String? name,
    _i2.ProjectedAddressCountry? address,
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

class _ProjectedUserCountryAddressImpl extends ProjectedUserCountryAddress {
  _ProjectedUserCountryAddressImpl({
    int? id,
    required String name,
    _i2.ProjectedAddressCountry? address,
  }) : super._(
         id: id,
         name: name,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUserCountryAddress copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
  }) {
    return ProjectedUserCountryAddress(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _i2.ProjectedAddressCountry?
          ? address
          : this.address?.copyWith(),
    );
  }
}
