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

abstract class ProjectedAddressStreet
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedAddressStreet._({
    this.id,
    required this.street,
  });

  factory ProjectedAddressStreet({
    int? id,
    required String street,
  }) = _ProjectedAddressStreetImpl;

  factory ProjectedAddressStreet.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedAddressStreet(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String street;

  /// Returns a shallow copy of this [ProjectedAddressStreet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedAddressStreet copyWith({
    int? id,
    String? street,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAddressStreet',
      if (id != null) 'id': id,
      'street': street,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAddressStreet',
      if (id != null) 'id': id,
      'street': street,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAddressStreetImpl extends ProjectedAddressStreet {
  _ProjectedAddressStreetImpl({
    int? id,
    required String street,
  }) : super._(
         id: id,
         street: street,
       );

  /// Returns a shallow copy of this [ProjectedAddressStreet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedAddressStreet copyWith({
    Object? id = _Undefined,
    String? street,
  }) {
    return ProjectedAddressStreet(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
    );
  }
}
