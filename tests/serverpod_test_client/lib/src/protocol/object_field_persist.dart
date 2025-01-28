/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'simple_data.dart' as _i2;

abstract class ObjectFieldPersist implements _i1.SerializableModel {
  ObjectFieldPersist._({
    this.id,
    required this.normal,
    this.api,
    this.data,
  });

  factory ObjectFieldPersist({
    int? id,
    required String normal,
    String? api,
    _i2.SimpleData? data,
  }) = _ObjectFieldPersistImpl;

  factory ObjectFieldPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectFieldPersist(
      id: jsonSerialization['id'] as int?,
      normal: jsonSerialization['normal'] as String,
      api: jsonSerialization['api'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _i2.SimpleData.fromJson(
              (jsonSerialization['data'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String normal;

  String? api;

  _i2.SimpleData? data;

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectFieldPersist copyWith({
    int? id,
    String? normal,
    String? api,
    _i2.SimpleData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectFieldPersistImpl extends ObjectFieldPersist {
  _ObjectFieldPersistImpl({
    int? id,
    required String normal,
    String? api,
    _i2.SimpleData? data,
  }) : super._(
          id: id,
          normal: normal,
          api: api,
          data: data,
        );

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectFieldPersist copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
    Object? data = _Undefined,
  }) {
    return ObjectFieldPersist(
      id: id is int? ? id : this.id,
      normal: normal ?? this.normal,
      api: api is String? ? api : this.api,
      data: data is _i2.SimpleData? ? data : this.data?.copyWith(),
    );
  }
}
