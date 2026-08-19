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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../../long_identifiers/deep_includes/city_with_long_table_name.dart'
    as _ii8bs4lb;
import '../../long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i5nficvp;

abstract class OrganizationWithLongTableName
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  }) = _OrganizationWithLongTableNameImpl;

  factory OrganizationWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrganizationWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: jsonSerialization['people'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_i5nficvp.PersonWithLongTableName>>(
                  jsonSerialization['people'],
                ),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ii8bs4lb.CityWithLongTableName>(
              jsonSerialization['city'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i5nficvp.PersonWithLongTableName>? people;

  int? cityId;

  _ii8bs4lb.CityWithLongTableName? city;

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrganizationWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrganizationWithLongTableName',
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrganizationWithLongTableName',
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationWithLongTableNameImpl extends OrganizationWithLongTableName {
  _OrganizationWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  }) : super._(
         id: id,
         name: name,
         people: people,
         cityId: cityId,
         city: city,
       );

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      people: people is List<_i5nficvp.PersonWithLongTableName>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _ii8bs4lb.CityWithLongTableName?
          ? city
          : this.city?.copyWith(),
    );
  }
}
