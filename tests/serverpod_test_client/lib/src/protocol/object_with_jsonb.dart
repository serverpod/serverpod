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
    required this.notJsonb,
    required this.jsonb,
    required this.jsonbIndexed,
    required this.jsonbIndexedGin,
    required this.jsonbIndexedGinJsonbPath,
  });

  factory ObjectWithJsonb({
    int? id,
    required List<String> notJsonb,
    required List<String> jsonb,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      notJsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['notJsonb'],
      ),
      jsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonb'],
      ),
      jsonbIndexed: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexed'],
      ),
      jsonbIndexedGin: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGin'],
      ),
      jsonbIndexedGinJsonbPath: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGinJsonbPath'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<String> notJsonb;

  List<String> jsonb;

  List<String> jsonbIndexed;

  List<String> jsonbIndexedGin;

  List<String> jsonbIndexedGinJsonbPath;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? notJsonb,
    List<String>? jsonb,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'notJsonb': notJsonb.toJson(),
      'jsonb': jsonb.toJson(),
      'jsonbIndexed': jsonbIndexed.toJson(),
      'jsonbIndexedGin': jsonbIndexedGin.toJson(),
      'jsonbIndexedGinJsonbPath': jsonbIndexedGinJsonbPath.toJson(),
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
    required List<String> notJsonb,
    required List<String> jsonb,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
  }) : super._(
         id: id,
         notJsonb: notJsonb,
         jsonb: jsonb,
         jsonbIndexed: jsonbIndexed,
         jsonbIndexedGin: jsonbIndexedGin,
         jsonbIndexedGinJsonbPath: jsonbIndexedGinJsonbPath,
       );

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? notJsonb,
    List<String>? jsonb,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
  }) {
    return ObjectWithJsonb(
      id: id is int? ? id : this.id,
      notJsonb: notJsonb ?? this.notJsonb.map((e0) => e0).toList(),
      jsonb: jsonb ?? this.jsonb.map((e0) => e0).toList(),
      jsonbIndexed: jsonbIndexed ?? this.jsonbIndexed.map((e0) => e0).toList(),
      jsonbIndexedGin:
          jsonbIndexedGin ?? this.jsonbIndexedGin.map((e0) => e0).toList(),
      jsonbIndexedGinJsonbPath:
          jsonbIndexedGinJsonbPath ??
          this.jsonbIndexedGinJsonbPath.map((e0) => e0).toList(),
    );
  }
}
