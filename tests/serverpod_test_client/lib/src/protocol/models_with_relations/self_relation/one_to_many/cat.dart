/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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

  factory Cat.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cat(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      motherId: jsonSerialization['motherId'] as int?,
      mother: jsonSerialization.containsKey('mother')
          ? jsonSerialization['mother'] != null
              ? _i2.Cat.fromJson(
                  jsonSerialization['mother'] as Map<String, dynamic>)
              : null
          : null,
      kittens: (jsonSerialization['kittens'] as List<dynamic>?)
          ?.map((e) => _i2.Cat.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJson(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJson()),
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
