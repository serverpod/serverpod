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
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart' as _i2;

abstract class ObjectWithJsonbClassLevel implements _i1.SerializableModel {
  ObjectWithJsonbClassLevel._({
    this.id,
    required this.implicitJsonb,
    required this.explicitJsonb,
    required this.json,
  });

  factory ObjectWithJsonbClassLevel({
    int? id,
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) = _ObjectWithJsonbClassLevelImpl;

  factory ObjectWithJsonbClassLevel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithJsonbClassLevel(
      id: jsonSerialization['id'] as int?,
      implicitJsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['implicitJsonb'],
      ),
      explicitJsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['explicitJsonb'],
      ),
      json: _i2.Protocol().deserialize<List<String>>(jsonSerialization['json']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<String> implicitJsonb;

  List<String> explicitJsonb;

  List<String> json;

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonbClassLevel copyWith({
    int? id,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonbClassLevel',
      if (id != null) 'id': id,
      'implicitJsonb': implicitJsonb.toJson(),
      'explicitJsonb': explicitJsonb.toJson(),
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
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) : super._(
         id: id,
         implicitJsonb: implicitJsonb,
         explicitJsonb: explicitJsonb,
         json: json,
       );

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonbClassLevel copyWith({
    Object? id = _Undefined,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  }) {
    return ObjectWithJsonbClassLevel(
      id: id is int? ? id : this.id,
      implicitJsonb:
          implicitJsonb ?? this.implicitJsonb.map((e0) => e0).toList(),
      explicitJsonb:
          explicitJsonb ?? this.explicitJsonb.map((e0) => e0).toList(),
      json: json ?? this.json.map((e0) => e0).toList(),
    );
  }
}
