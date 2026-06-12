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
import 'simple_data.dart' as _i2;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart' as _i3;

abstract class ObjectWithJsonb implements _i1.SerializableModel {
  ObjectWithJsonb._({
    this.id,
    required this.notJsonb,
    required this.jsonb,
    required this.jsonbMap,
    required this.jsonbObject,
    required this.jsonbIndexed,
    required this.jsonbIndexedGin,
    required this.jsonbIndexedGinJsonbPath,
    required this.jsonbIndexedImplicitGin,
    this.nullableJsonb,
  });

  factory ObjectWithJsonb({
    int? id,
    required List<String> notJsonb,
    required List<String> jsonb,
    required Map<String, String> jsonbMap,
    required _i2.SimpleData jsonbObject,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
    required List<String> jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      notJsonb: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['notJsonb'],
      ),
      jsonb: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonb'],
      ),
      jsonbMap: _i3.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['jsonbMap'],
      ),
      jsonbObject: _i3.Protocol().deserialize<_i2.SimpleData>(
        jsonSerialization['jsonbObject'],
      ),
      jsonbIndexed: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexed'],
      ),
      jsonbIndexedGin: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGin'],
      ),
      jsonbIndexedGinJsonbPath: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGinJsonbPath'],
      ),
      jsonbIndexedImplicitGin: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedImplicitGin'],
      ),
      nullableJsonb: jsonSerialization['nullableJsonb'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['nullableJsonb'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<String> notJsonb;

  List<String> jsonb;

  Map<String, String> jsonbMap;

  _i2.SimpleData jsonbObject;

  List<String> jsonbIndexed;

  List<String> jsonbIndexedGin;

  List<String> jsonbIndexedGinJsonbPath;

  List<String> jsonbIndexedImplicitGin;

  List<String>? nullableJsonb;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i2.SimpleData? jsonbObject,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
    List<String>? jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'notJsonb': notJsonb.toJson(),
      'jsonb': jsonb.toJson(),
      'jsonbMap': jsonbMap.toJson(),
      'jsonbObject': jsonbObject.toJson(),
      'jsonbIndexed': jsonbIndexed.toJson(),
      'jsonbIndexedGin': jsonbIndexedGin.toJson(),
      'jsonbIndexedGinJsonbPath': jsonbIndexedGinJsonbPath.toJson(),
      'jsonbIndexedImplicitGin': jsonbIndexedImplicitGin.toJson(),
      if (nullableJsonb != null) 'nullableJsonb': nullableJsonb?.toJson(),
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
    required Map<String, String> jsonbMap,
    required _i2.SimpleData jsonbObject,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
    required List<String> jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  }) : super._(
         id: id,
         notJsonb: notJsonb,
         jsonb: jsonb,
         jsonbMap: jsonbMap,
         jsonbObject: jsonbObject,
         jsonbIndexed: jsonbIndexed,
         jsonbIndexedGin: jsonbIndexedGin,
         jsonbIndexedGinJsonbPath: jsonbIndexedGinJsonbPath,
         jsonbIndexedImplicitGin: jsonbIndexedImplicitGin,
         nullableJsonb: nullableJsonb,
       );

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i2.SimpleData? jsonbObject,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
    List<String>? jsonbIndexedImplicitGin,
    Object? nullableJsonb = _Undefined,
  }) {
    return ObjectWithJsonb(
      id: id is int? ? id : this.id,
      notJsonb: notJsonb ?? this.notJsonb.map((e0) => e0).toList(),
      jsonb: jsonb ?? this.jsonb.map((e0) => e0).toList(),
      jsonbMap:
          jsonbMap ??
          this.jsonbMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      jsonbObject: jsonbObject ?? this.jsonbObject.copyWith(),
      jsonbIndexed: jsonbIndexed ?? this.jsonbIndexed.map((e0) => e0).toList(),
      jsonbIndexedGin:
          jsonbIndexedGin ?? this.jsonbIndexedGin.map((e0) => e0).toList(),
      jsonbIndexedGinJsonbPath:
          jsonbIndexedGinJsonbPath ??
          this.jsonbIndexedGinJsonbPath.map((e0) => e0).toList(),
      jsonbIndexedImplicitGin:
          jsonbIndexedImplicitGin ??
          this.jsonbIndexedImplicitGin.map((e0) => e0).toList(),
      nullableJsonb: nullableJsonb is List<String>?
          ? nullableJsonb
          : this.nullableJsonb?.map((e0) => e0).toList(),
    );
  }
}
