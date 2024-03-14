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

abstract class CityWithLongTableName extends _i1.SerializableEntity {
  CityWithLongTableName._({
    this.id,
    required this.name,
    this.citizens,
    this.organizations,
  });

  factory CityWithLongTableName({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i2.OrganizationWithLongTableName>? organizations,
  }) = _CityWithLongTableNameImpl;

  factory CityWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CityWithLongTableName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      citizens:
          serializationManager.deserialize<List<_i2.PersonWithLongTableName>?>(
              jsonSerialization['citizens']),
      organizations: serializationManager
          .deserialize<List<_i2.OrganizationWithLongTableName>?>(
              jsonSerialization['organizations']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.PersonWithLongTableName>? citizens;

  List<_i2.OrganizationWithLongTableName>? organizations;

  CityWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i2.OrganizationWithLongTableName>? organizations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (citizens != null)
        'citizens': citizens?.toJson(valueToJson: (v) => v.toJson()),
      if (organizations != null)
        'organizations': organizations?.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _Undefined {}

class _CityWithLongTableNameImpl extends CityWithLongTableName {
  _CityWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i2.OrganizationWithLongTableName>? organizations,
  }) : super._(
          id: id,
          name: name,
          citizens: citizens,
          organizations: organizations,
        );

  @override
  CityWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? citizens = _Undefined,
    Object? organizations = _Undefined,
  }) {
    return CityWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      citizens: citizens is List<_i2.PersonWithLongTableName>?
          ? citizens
          : this.citizens?.clone(),
      organizations: organizations is List<_i2.OrganizationWithLongTableName>?
          ? organizations
          : this.organizations?.clone(),
    );
  }
}
