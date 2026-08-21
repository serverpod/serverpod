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
import '../../../models_with_relations/self_relation/one_to_many/cat.dart'
    as _iayhscrz;

abstract class Cat
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  }) = _CatImpl;

  factory Cat.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cat(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      motherId: jsonSerialization['motherId'] as int?,
      mother: jsonSerialization['mother'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iayhscrz.Cat>(
              jsonSerialization['mother'],
            ),
      kittens: jsonSerialization['kittens'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_iayhscrz.Cat>>(
              jsonSerialization['kittens'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? motherId;

  _iayhscrz.Cat? mother;

  List<_iayhscrz.Cat>? kittens;

  /// Returns a shallow copy of this [Cat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Cat copyWith({
    int? id,
    String? name,
    int? motherId,
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Cat',
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJson(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Cat',
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJsonForProtocol(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatImpl extends Cat {
  _CatImpl({
    int? id,
    required String name,
    int? motherId,
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  }) : super._(
         id: id,
         name: name,
         motherId: motherId,
         mother: mother,
         kittens: kittens,
       );

  /// Returns a shallow copy of this [Cat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      mother: mother is _iayhscrz.Cat? ? mother : this.mother?.copyWith(),
      kittens: kittens is List<_iayhscrz.Cat>?
          ? kittens
          : this.kittens?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
