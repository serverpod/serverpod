/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class PersonWithLongTableName extends _i1.SerializableEntity {
  PersonWithLongTableName._({
    this.id,
    required this.name,
    this.organizationId,
    this.organization,
  });

  factory PersonWithLongTableName({
    int? id,
    required String name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  }) = _PersonWithLongTableNameImpl;

  factory PersonWithLongTableName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PersonWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      organization: jsonSerialization.containsKey('organization')
          ? _i2.OrganizationWithLongTableName.fromJson(
              jsonSerialization['organization'] as Map<String, dynamic>)
          : null,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? organizationId;

  _i2.OrganizationWithLongTableName? organization;

  PersonWithLongTableName copyWith({
    int? id,
    String? name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null) 'organization': organization?.toJson(),
    };
  }
}

class _Undefined {}

class _PersonWithLongTableNameImpl extends PersonWithLongTableName {
  _PersonWithLongTableNameImpl({
    int? id,
    required String name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  }) : super._(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  @override
  PersonWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return PersonWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      organization: organization is _i2.OrganizationWithLongTableName?
          ? organization
          : this.organization?.copyWith(),
    );
  }
}
