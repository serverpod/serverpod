/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Person extends _i1.SerializableEntity {
  Person._({
    this.id,
    required this.name,
    this.organizationId,
    this.organization,
  });

  factory Person({
    int? id,
    required String name,
    int? organizationId,
    _i2.Organization? organization,
  }) = _PersonImpl;

  factory Person.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Person(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      organizationId: serializationManager
          .deserialize<int?>(jsonSerialization['organizationId']),
      organization: serializationManager
          .deserialize<_i2.Organization?>(jsonSerialization['organization']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? organizationId;

  _i2.Organization? organization;

  Person copyWith({
    int? id,
    String? name,
    int? organizationId,
    _i2.Organization? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null) 'organization': organization,
    };
  }
}

class _Undefined {}

class _PersonImpl extends Person {
  _PersonImpl({
    int? id,
    required String name,
    int? organizationId,
    _i2.Organization? organization,
  }) : super._(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  @override
  Person copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return Person(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      organization: organization is _i2.Organization?
          ? organization
          : this.organization?.copyWith(),
    );
  }
}
