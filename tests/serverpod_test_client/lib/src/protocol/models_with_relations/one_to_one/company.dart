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

abstract class Company extends _i1.SerializableEntity {
  Company._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory Company({
    int? id,
    required String name,
    required int townId,
    _i2.Town? town,
  }) = _CompanyImpl;

  factory Company.fromJson(Map<String, dynamic> jsonSerialization) {
    return Company(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization.containsKey('town')
          ? jsonSerialization['town'] != null
              ? _i2.Town.fromJson(
                  jsonSerialization['town'] as Map<String, dynamic>)
              : null
          : null,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int townId;

  _i2.Town? town;

  Company copyWith({
    int? id,
    String? name,
    int? townId,
    _i2.Town? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }
}

class _Undefined {}

class _CompanyImpl extends Company {
  _CompanyImpl({
    int? id,
    required String name,
    required int townId,
    _i2.Town? town,
  }) : super._(
          id: id,
          name: name,
          townId: townId,
          town: town,
        );

  @override
  Company copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return Company(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i2.Town? ? town : this.town?.copyWith(),
    );
  }
}
