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
import 'simple_data.dart' as _i0zisc0t;

abstract class ObjectFieldPersist
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _i0zisc0t.SimpleData? data,
  }) = _ObjectFieldPersistImpl;

  factory ObjectFieldPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectFieldPersist(
      id: jsonSerialization['id'] as int?,
      normal: jsonSerialization['normal'] as String,
      api: jsonSerialization['api'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i0zisc0t.SimpleData>(
              jsonSerialization['data'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String normal;

  String? api;

  _i0zisc0t.SimpleData? data;

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectFieldPersist copyWith({
    int? id,
    String? normal,
    String? api,
    _i0zisc0t.SimpleData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectFieldPersist',
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectFieldPersist',
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectFieldPersistImpl extends ObjectFieldPersist {
  _ObjectFieldPersistImpl({
    int? id,
    required String normal,
    String? api,
    _i0zisc0t.SimpleData? data,
  }) : super._(
         id: id,
         normal: normal,
         api: api,
         data: data,
       );

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      data: data is _i0zisc0t.SimpleData? ? data : this.data?.copyWith(),
    );
  }
}
