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

abstract class Organization implements _i1.SerializableModel {
  Organization._({
    this.id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  });

  factory Organization({
    int? id,
    required String name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: (jsonSerialization['people'] as List?)
          ?.map((e) => _i2.Person.fromJson((e as Map<String, dynamic>)))
          .toList(),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _i2.City.fromJson(
              (jsonSerialization['city'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Person>? people;

  int? cityId;

  _i2.City? city;

  Organization copyWith({
    int? id,
    String? name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

  @override
  Organization copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
    Object? cityId = _Undefined,
    Object? city = _Undefined,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_i2.Person>? ? people : this.people?.clone(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i2.City? ? city : this.city?.copyWith(),
    );
  }
}
