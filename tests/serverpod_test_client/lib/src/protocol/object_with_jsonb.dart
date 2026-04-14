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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i2;

abstract class ObjectWithJsonb implements _i1.SerializableModel {
  ObjectWithJsonb._({
    this.id,
    required this.indexed0,
    required this.indexed1,
    required this.indexed2,
    required this.indexed3,
  });

  factory ObjectWithJsonb({
    int? id,
    required List<String> indexed0,
    required List<String> indexed1,
    required List<String> indexed2,
    required List<String> indexed3,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      indexed0: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed0'],
      ),
      indexed1: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed1'],
      ),
      indexed2: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed2'],
      ),
      indexed3: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed3'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<String> indexed0;

  List<String> indexed1;

  List<String> indexed2;

  List<String> indexed3;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? indexed0,
    List<String>? indexed1,
    List<String>? indexed2,
    List<String>? indexed3,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'indexed0': indexed0.toJson(),
      'indexed1': indexed1.toJson(),
      'indexed2': indexed2.toJson(),
      'indexed3': indexed3.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbImpl extends ObjectWithJsonb {
  _ObjectWithJsonbImpl({
    int? id,
    required List<String> indexed0,
    required List<String> indexed1,
    required List<String> indexed2,
    required List<String> indexed3,
  }) : super._(
         id: id,
         indexed0: indexed0,
         indexed1: indexed1,
         indexed2: indexed2,
         indexed3: indexed3,
       );

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? indexed0,
    List<String>? indexed1,
    List<String>? indexed2,
    List<String>? indexed3,
  }) {
    return ObjectWithJsonb(
      id: id is int? ? id : this.id,
      indexed0: indexed0 ?? this.indexed0.map((e0) => e0).toList(),
      indexed1: indexed1 ?? this.indexed1.map((e0) => e0).toList(),
      indexed2: indexed2 ?? this.indexed2.map((e0) => e0).toList(),
      indexed3: indexed3 ?? this.indexed3.map((e0) => e0).toList(),
    );
  }
}
