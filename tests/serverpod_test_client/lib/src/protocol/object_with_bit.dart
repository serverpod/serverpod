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

abstract class ObjectWithBit
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithBit._({
    this.id,
    required this.bit,
    this.bitNullable,
    required this.bitIndexedHnsw,
    required this.bitIndexedHnswWithParams,
    required this.bitIndexedIvfflat,
    required this.bitIndexedIvfflatWithParams,
  });

  factory ObjectWithBit({
    int? id,
    required _isc.Bit bit,
    _isc.Bit? bitNullable,
    required _isc.Bit bitIndexedHnsw,
    required _isc.Bit bitIndexedHnswWithParams,
    required _isc.Bit bitIndexedIvfflat,
    required _isc.Bit bitIndexedIvfflatWithParams,
  }) = _ObjectWithBitImpl;

  factory ObjectWithBit.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithBit(
      id: jsonSerialization['id'] as int?,
      bit: _isc.BitJsonExtension.fromJson(jsonSerialization['bit']),
      bitNullable: jsonSerialization['bitNullable'] == null
          ? null
          : _isc.BitJsonExtension.fromJson(jsonSerialization['bitNullable']),
      bitIndexedHnsw: _isc.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedHnsw'],
      ),
      bitIndexedHnswWithParams: _isc.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedHnswWithParams'],
      ),
      bitIndexedIvfflat: _isc.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedIvfflat'],
      ),
      bitIndexedIvfflatWithParams: _isc.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedIvfflatWithParams'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.Bit bit;

  _isc.Bit? bitNullable;

  _isc.Bit bitIndexedHnsw;

  _isc.Bit bitIndexedHnswWithParams;

  _isc.Bit bitIndexedIvfflat;

  _isc.Bit bitIndexedIvfflatWithParams;

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithBit copyWith({
    int? id,
    _isc.Bit? bit,
    _isc.Bit? bitNullable,
    _isc.Bit? bitIndexedHnsw,
    _isc.Bit? bitIndexedHnswWithParams,
    _isc.Bit? bitIndexedIvfflat,
    _isc.Bit? bitIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithBit',
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithBit',
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithBitImpl extends ObjectWithBit {
  _ObjectWithBitImpl({
    int? id,
    required _isc.Bit bit,
    _isc.Bit? bitNullable,
    required _isc.Bit bitIndexedHnsw,
    required _isc.Bit bitIndexedHnswWithParams,
    required _isc.Bit bitIndexedIvfflat,
    required _isc.Bit bitIndexedIvfflatWithParams,
  }) : super._(
         id: id,
         bit: bit,
         bitNullable: bitNullable,
         bitIndexedHnsw: bitIndexedHnsw,
         bitIndexedHnswWithParams: bitIndexedHnswWithParams,
         bitIndexedIvfflat: bitIndexedIvfflat,
         bitIndexedIvfflatWithParams: bitIndexedIvfflatWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithBit copyWith({
    Object? id = _Undefined,
    _isc.Bit? bit,
    Object? bitNullable = _Undefined,
    _isc.Bit? bitIndexedHnsw,
    _isc.Bit? bitIndexedHnswWithParams,
    _isc.Bit? bitIndexedIvfflat,
    _isc.Bit? bitIndexedIvfflatWithParams,
  }) {
    return ObjectWithBit(
      id: id is int? ? id : this.id,
      bit: bit ?? this.bit.clone(),
      bitNullable: bitNullable is _isc.Bit?
          ? bitNullable
          : this.bitNullable?.clone(),
      bitIndexedHnsw: bitIndexedHnsw ?? this.bitIndexedHnsw.clone(),
      bitIndexedHnswWithParams:
          bitIndexedHnswWithParams ?? this.bitIndexedHnswWithParams.clone(),
      bitIndexedIvfflat: bitIndexedIvfflat ?? this.bitIndexedIvfflat.clone(),
      bitIndexedIvfflatWithParams:
          bitIndexedIvfflatWithParams ??
          this.bitIndexedIvfflatWithParams.clone(),
    );
  }
}
