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

abstract class ObjectWithDynamic implements _i1.SerializableModel {
  ObjectWithDynamic._({
    this.id,
    required this.payload,
    required this.jsonbPayload,
    required this.payloadList,
    required this.payloadMap,
    required this.payloadSet,
    required this.payloadMapWithDynamicKeys,
  });

  factory ObjectWithDynamic({
    int? id,
    required dynamic payload,
    required dynamic jsonbPayload,
    required List<dynamic> payloadList,
    required Map<String, dynamic> payloadMap,
    required Set<dynamic> payloadSet,
    required Map<dynamic, dynamic> payloadMapWithDynamicKeys,
  }) = _ObjectWithDynamicImpl;

  factory ObjectWithDynamic.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDynamic(
      id: jsonSerialization['id'] as int?,
      payload: _i2.Protocol().decodeDynamicFieldValue(
        jsonSerialization['payload'],
      ),
      jsonbPayload: _i2.Protocol().decodeDynamicFieldValue(
        jsonSerialization['jsonbPayload'],
      ),
      payloadList: _i2.Protocol().deserialize<List<dynamic>>(
        jsonSerialization['payloadList'],
      ),
      payloadMap: _i2.Protocol().deserialize<Map<String, dynamic>>(
        jsonSerialization['payloadMap'],
      ),
      payloadSet: _i2.Protocol().deserialize<Set<dynamic>>(
        jsonSerialization['payloadSet'],
      ),
      payloadMapWithDynamicKeys: _i2.Protocol()
          .deserialize<Map<dynamic, dynamic>>(
            jsonSerialization['payloadMapWithDynamicKeys'],
          ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  dynamic payload;

  dynamic jsonbPayload;

  List<dynamic> payloadList;

  Map<String, dynamic> payloadMap;

  Set<dynamic> payloadSet;

  Map<dynamic, dynamic> payloadMapWithDynamicKeys;

  /// Returns a shallow copy of this [ObjectWithDynamic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDynamic copyWith({
    int? id,
    dynamic payload,
    dynamic jsonbPayload,
    List<dynamic>? payloadList,
    Map<String, dynamic>? payloadMap,
    Set<dynamic>? payloadSet,
    Map<dynamic, dynamic>? payloadMapWithDynamicKeys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDynamic',
      if (id != null) 'id': id,
      'payload': _i2.Protocol().encodeWithType(payload),
      'jsonbPayload': _i2.Protocol().encodeWithType(jsonbPayload),
      'payloadList': payloadList.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadMap': payloadMap.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadSet': payloadSet.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadMapWithDynamicKeys': payloadMapWithDynamicKeys.toJson(
        keyToJson: (k) => _i2.Protocol().encodeWithType(k),
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDynamicImpl extends ObjectWithDynamic {
  _ObjectWithDynamicImpl({
    int? id,
    required dynamic payload,
    required dynamic jsonbPayload,
    required List<dynamic> payloadList,
    required Map<String, dynamic> payloadMap,
    required Set<dynamic> payloadSet,
    required Map<dynamic, dynamic> payloadMapWithDynamicKeys,
  }) : super._(
         id: id,
         payload: payload,
         jsonbPayload: jsonbPayload,
         payloadList: payloadList,
         payloadMap: payloadMap,
         payloadSet: payloadSet,
         payloadMapWithDynamicKeys: payloadMapWithDynamicKeys,
       );

  /// Returns a shallow copy of this [ObjectWithDynamic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDynamic copyWith({
    Object? id = _Undefined,
    Object? payload = _Undefined,
    Object? jsonbPayload = _Undefined,
    List<dynamic>? payloadList,
    Map<String, dynamic>? payloadMap,
    Set<dynamic>? payloadSet,
    Map<dynamic, dynamic>? payloadMapWithDynamicKeys,
  }) {
    return ObjectWithDynamic(
      id: id is int? ? id : this.id,
      payload: payload is! _Undefined ? payload : this.payload,
      jsonbPayload: jsonbPayload is! _Undefined
          ? jsonbPayload
          : this.jsonbPayload,
      payloadList: payloadList ?? this.payloadList.map((e0) => e0).toList(),
      payloadMap:
          payloadMap ??
          this.payloadMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      payloadSet: payloadSet ?? this.payloadSet.map((e0) => e0).toSet(),
      payloadMapWithDynamicKeys:
          payloadMapWithDynamicKeys ??
          this.payloadMapWithDynamicKeys.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
