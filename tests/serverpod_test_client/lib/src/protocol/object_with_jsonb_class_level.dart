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

abstract class ObjectWithJsonbClassLevel implements _i1.SerializableModel {
  ObjectWithJsonbClassLevel._({
    this.id,
    required this.jsonb1,
    required this.jsonb2,
    required this.json,
  });

  factory ObjectWithJsonbClassLevel({
    int? id,
    required List<String> jsonb1,
    required List<String> jsonb2,
    required List<String> json,
  }) = _ObjectWithJsonbClassLevelImpl;

  factory ObjectWithJsonbClassLevel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonbClassLevel(
      id: jsonSerialization['id'] as int?,
      jsonb1: (jsonSerialization['jsonb1'] as List)
          .map((e) => e as String)
          .toList(),
      jsonb2: (jsonSerialization['jsonb2'] as List)
          .map((e) => e as String)
          .toList(),
      json:
          (jsonSerialization['json'] as List).map((e) => e as String).toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<String> jsonb1;

  List<String> jsonb2;

  List<String> json;

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonbClassLevel copyWith({
    int? id,
    List<String>? jsonb1,
    List<String>? jsonb2,
    List<String>? json,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'jsonb1': jsonb1.toJson(),
      'jsonb2': jsonb2.toJson(),
      'json': json.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbClassLevelImpl extends ObjectWithJsonbClassLevel {
  _ObjectWithJsonbClassLevelImpl({
    int? id,
    required List<String> jsonb1,
    required List<String> jsonb2,
    required List<String> json,
  }) : super._(
          id: id,
          jsonb1: jsonb1,
          jsonb2: jsonb2,
          json: json,
        );

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonbClassLevel copyWith({
    Object? id = _Undefined,
    List<String>? jsonb1,
    List<String>? jsonb2,
    List<String>? json,
  }) {
    return ObjectWithJsonbClassLevel(
      id: id is int? ? id : this.id,
      jsonb1: jsonb1 ?? this.jsonb1.map((e0) => e0).toList(),
      jsonb2: jsonb2 ?? this.jsonb2.map((e0) => e0).toList(),
      json: json ?? this.json.map((e0) => e0).toList(),
    );
  }
}
