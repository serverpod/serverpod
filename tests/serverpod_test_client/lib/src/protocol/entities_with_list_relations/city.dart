/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class City extends _i1.SerializableEntity {
  City._({
    this.id,
    required this.name,
    this.citizens,
  });

  factory City({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
  }) = _CityImpl;

  factory City.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return City(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      citizens: serializationManager
          .deserialize<List<_i2.Person>?>(jsonSerialization['citizens']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Person>? citizens;

  City copyWith({
    int? id,
    String? name,
    List<_i2.Person>? citizens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'citizens': citizens,
    };
  }
}

class _Undefined {}

class _CityImpl extends City {
  _CityImpl({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
  }) : super._(
          id: id,
          name: name,
          citizens: citizens,
        );

  @override
  City copyWith({
    Object? id = _Undefined,
    String? name,
    Object? citizens = _Undefined,
  }) {
    return City(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      citizens:
          citizens is List<_i2.Person>? ? citizens : this.citizens?.clone(),
    );
  }
}
