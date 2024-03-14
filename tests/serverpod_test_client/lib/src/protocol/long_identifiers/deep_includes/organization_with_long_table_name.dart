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

abstract class OrganizationWithLongTableName extends _i1.SerializableEntity {
  OrganizationWithLongTableName._({
    this.id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  });

  factory OrganizationWithLongTableName({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
  }) = _OrganizationWithLongTableNameImpl;

  factory OrganizationWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return OrganizationWithLongTableName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      people:
          serializationManager.deserialize<List<_i2.PersonWithLongTableName>?>(
              jsonSerialization['people']),
      cityId:
          serializationManager.deserialize<int?>(jsonSerialization['cityId']),
      city: serializationManager
          .deserialize<_i2.CityWithLongTableName?>(jsonSerialization['city']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.PersonWithLongTableName>? people;

  int? cityId;

  _i2.CityWithLongTableName? city;

  OrganizationWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJson(),
    };
  }
}

class _Undefined {}

class _OrganizationWithLongTableNameImpl extends OrganizationWithLongTableName {
  _OrganizationWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

  @override
  OrganizationWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
    Object? cityId = _Undefined,
    Object? city = _Undefined,
  }) {
    return OrganizationWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_i2.PersonWithLongTableName>?
          ? people
          : this.people?.clone(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i2.CityWithLongTableName? ? city : this.city?.copyWith(),
    );
  }
}
