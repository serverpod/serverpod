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

abstract class ProjectedAddress
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedAddress._({
    this.id,
    required this.street,
    required this.state,
    required this.country,
  });

  factory ProjectedAddress({
    int? id,
    required String street,
    required String state,
    required String country,
  }) = _ProjectedAddressImpl;

  factory ProjectedAddress.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedAddress(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
      state: jsonSerialization['state'] as String,
      country: jsonSerialization['country'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String street;

  String state;

  String country;

  /// Returns a shallow copy of this [ProjectedAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedAddress copyWith({
    int? id,
    String? street,
    String? state,
    String? country,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAddress',
      if (id != null) 'id': id,
      'street': street,
      'state': state,
      'country': country,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAddress',
      if (id != null) 'id': id,
      'street': street,
      'state': state,
      'country': country,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAddressImpl extends ProjectedAddress {
  _ProjectedAddressImpl({
    int? id,
    required String street,
    required String state,
    required String country,
  }) : super._(
         id: id,
         street: street,
         state: state,
         country: country,
       );

  /// Returns a shallow copy of this [ProjectedAddress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedAddress copyWith({
    Object? id = _Undefined,
    String? street,
    String? state,
    String? country,
  }) {
    return ProjectedAddress(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
}
