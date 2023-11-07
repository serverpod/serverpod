/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Cat extends _i1.SerializableEntity {
  Cat._({
    this.id,
    required this.name,
    this.motherId,
    this.mother,
    this.kittens,
  });

  factory Cat({
    int? id,
    required String name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  }) = _CatImpl;

  factory Cat.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Cat(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      motherId:
          serializationManager.deserialize<int?>(jsonSerialization['motherId']),
      mother: serializationManager
          .deserialize<_i2.Cat?>(jsonSerialization['mother']),
      kittens: serializationManager
          .deserialize<List<_i2.Cat>?>(jsonSerialization['kittens']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? motherId;

  _i2.Cat? mother;

  List<_i2.Cat>? kittens;

  Cat copyWith({
    int? id,
    String? name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'motherId': motherId,
      'mother': mother,
      'kittens': kittens,
    };
  }
}

class _Undefined {}

class _CatImpl extends Cat {
  _CatImpl({
    int? id,
    required String name,
    int? motherId,
    _i2.Cat? mother,
    List<_i2.Cat>? kittens,
  }) : super._(
          id: id,
          name: name,
          motherId: motherId,
          mother: mother,
          kittens: kittens,
        );

  @override
  Cat copyWith({
    Object? id = _Undefined,
    String? name,
    Object? motherId = _Undefined,
    Object? mother = _Undefined,
    Object? kittens = _Undefined,
  }) {
    return Cat(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      motherId: motherId is int? ? motherId : this.motherId,
      mother: mother is _i2.Cat? ? mother : this.mother?.copyWith(),
      kittens: kittens is List<_i2.Cat>? ? kittens : this.kittens?.clone(),
    );
  }
}
