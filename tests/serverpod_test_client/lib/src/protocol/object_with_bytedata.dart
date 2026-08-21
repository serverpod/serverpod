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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ObjectWithByteData
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithByteData._({
    this.id,
    required this.byteData,
  });

  factory ObjectWithByteData({
    int? id,
    required _idt.ByteData byteData,
  }) = _ObjectWithByteDataImpl;

  factory ObjectWithByteData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithByteData(
      id: jsonSerialization['id'] as int?,
      byteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _idt.ByteData byteData;

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithByteData copyWith({
    int? id,
    _idt.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithByteData',
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithByteData',
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithByteDataImpl extends ObjectWithByteData {
  _ObjectWithByteDataImpl({
    int? id,
    required _idt.ByteData byteData,
  }) : super._(
         id: id,
         byteData: byteData,
       );

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithByteData copyWith({
    Object? id = _Undefined,
    _idt.ByteData? byteData,
  }) {
    return ObjectWithByteData(
      id: id is int? ? id : this.id,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}
