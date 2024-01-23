/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;

abstract class TypesMap extends _i1.SerializableEntity {
  TypesMap._({
    this.anIntKey,
    this.aBoolKey,
    this.aDoubleKey,
    this.aDateTimeKey,
    this.aStringKey,
    this.aByteDataKey,
    this.aDurationKey,
    this.aUuidKey,
    this.anEnumKey,
    this.aStringifiedEnumKey,
    this.anObjectKey,
    this.aMapKey,
    this.aListKey,
    this.anIntValue,
    this.aBoolValue,
    this.aDoubleValue,
    this.aDateTimeValue,
    this.aStringValue,
    this.aByteDataValue,
    this.aDurationValue,
    this.aUuidValue,
    this.anEnumValue,
    this.aStringifiedEnumValue,
    this.anObjectValue,
    this.aMapValue,
    this.aListValue,
  });

  factory TypesMap({
    Map<int, String>? anIntKey,
    Map<bool, String>? aBoolKey,
    Map<double, String>? aDoubleKey,
    Map<DateTime, String>? aDateTimeKey,
    Map<String, String>? aStringKey,
    Map<_i2.ByteData, String>? aByteDataKey,
    Map<Duration, String>? aDurationKey,
    Map<_i1.UuidValue, String>? aUuidKey,
    Map<_i3.TestEnum, String>? anEnumKey,
    Map<_i3.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i3.Types, String>? anObjectKey,
    Map<Map<_i3.Types, String>, String>? aMapKey,
    Map<List<_i3.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i3.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i3.Types>? anObjectValue,
    Map<String, Map<String, _i3.Types>>? aMapValue,
    Map<String, List<_i3.Types>>? aListValue,
  }) = _TypesMapImpl;

  factory TypesMap.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TypesMap(
      anIntKey: serializationManager
          .deserialize<Map<int, String>?>(jsonSerialization['anIntKey']),
      aBoolKey: serializationManager
          .deserialize<Map<bool, String>?>(jsonSerialization['aBoolKey']),
      aDoubleKey: serializationManager
          .deserialize<Map<double, String>?>(jsonSerialization['aDoubleKey']),
      aDateTimeKey: serializationManager.deserialize<Map<DateTime, String>?>(
          jsonSerialization['aDateTimeKey']),
      aStringKey: serializationManager
          .deserialize<Map<String, String>?>(jsonSerialization['aStringKey']),
      aByteDataKey:
          serializationManager.deserialize<Map<_i2.ByteData, String>?>(
              jsonSerialization['aByteDataKey']),
      aDurationKey: serializationManager.deserialize<Map<Duration, String>?>(
          jsonSerialization['aDurationKey']),
      aUuidKey: serializationManager.deserialize<Map<_i1.UuidValue, String>?>(
          jsonSerialization['aUuidKey']),
      anEnumKey: serializationManager.deserialize<Map<_i3.TestEnum, String>?>(
          jsonSerialization['anEnumKey']),
      aStringifiedEnumKey: serializationManager
          .deserialize<Map<_i3.TestEnumStringified, String>?>(
              jsonSerialization['aStringifiedEnumKey']),
      anObjectKey: serializationManager.deserialize<Map<_i3.Types, String>?>(
          jsonSerialization['anObjectKey']),
      aMapKey: serializationManager.deserialize<
          Map<Map<_i3.Types, String>, String>?>(jsonSerialization['aMapKey']),
      aListKey: serializationManager.deserialize<Map<List<_i3.Types>, String>?>(
          jsonSerialization['aListKey']),
      anIntValue: serializationManager
          .deserialize<Map<String, int>?>(jsonSerialization['anIntValue']),
      aBoolValue: serializationManager
          .deserialize<Map<String, bool>?>(jsonSerialization['aBoolValue']),
      aDoubleValue: serializationManager
          .deserialize<Map<String, double>?>(jsonSerialization['aDoubleValue']),
      aDateTimeValue: serializationManager.deserialize<Map<String, DateTime>?>(
          jsonSerialization['aDateTimeValue']),
      aStringValue: serializationManager
          .deserialize<Map<String, String>?>(jsonSerialization['aStringValue']),
      aByteDataValue:
          serializationManager.deserialize<Map<String, _i2.ByteData>?>(
              jsonSerialization['aByteDataValue']),
      aDurationValue: serializationManager.deserialize<Map<String, Duration>?>(
          jsonSerialization['aDurationValue']),
      aUuidValue: serializationManager.deserialize<Map<String, _i1.UuidValue>?>(
          jsonSerialization['aUuidValue']),
      anEnumValue: serializationManager.deserialize<Map<String, _i3.TestEnum>?>(
          jsonSerialization['anEnumValue']),
      aStringifiedEnumValue: serializationManager
          .deserialize<Map<String, _i3.TestEnumStringified>?>(
              jsonSerialization['aStringifiedEnumValue']),
      anObjectValue: serializationManager.deserialize<Map<String, _i3.Types>?>(
          jsonSerialization['anObjectValue']),
      aMapValue: serializationManager.deserialize<
          Map<String, Map<String, _i3.Types>>?>(jsonSerialization['aMapValue']),
      aListValue:
          serializationManager.deserialize<Map<String, List<_i3.Types>>?>(
              jsonSerialization['aListValue']),
    );
  }

  Map<int, String>? anIntKey;

  Map<bool, String>? aBoolKey;

  Map<double, String>? aDoubleKey;

  Map<DateTime, String>? aDateTimeKey;

  Map<String, String>? aStringKey;

  Map<_i2.ByteData, String>? aByteDataKey;

  Map<Duration, String>? aDurationKey;

  Map<_i1.UuidValue, String>? aUuidKey;

  Map<_i3.TestEnum, String>? anEnumKey;

  Map<_i3.TestEnumStringified, String>? aStringifiedEnumKey;

  Map<_i3.Types, String>? anObjectKey;

  Map<Map<_i3.Types, String>, String>? aMapKey;

  Map<List<_i3.Types>, String>? aListKey;

  Map<String, int>? anIntValue;

  Map<String, bool>? aBoolValue;

  Map<String, double>? aDoubleValue;

  Map<String, DateTime>? aDateTimeValue;

  Map<String, String>? aStringValue;

  Map<String, _i2.ByteData>? aByteDataValue;

  Map<String, Duration>? aDurationValue;

  Map<String, _i1.UuidValue>? aUuidValue;

  Map<String, _i3.TestEnum>? anEnumValue;

  Map<String, _i3.TestEnumStringified>? aStringifiedEnumValue;

  Map<String, _i3.Types>? anObjectValue;

  Map<String, Map<String, _i3.Types>>? aMapValue;

  Map<String, List<_i3.Types>>? aListValue;

  TypesMap copyWith({
    Map<int, String>? anIntKey,
    Map<bool, String>? aBoolKey,
    Map<double, String>? aDoubleKey,
    Map<DateTime, String>? aDateTimeKey,
    Map<String, String>? aStringKey,
    Map<_i2.ByteData, String>? aByteDataKey,
    Map<Duration, String>? aDurationKey,
    Map<_i1.UuidValue, String>? aUuidKey,
    Map<_i3.TestEnum, String>? anEnumKey,
    Map<_i3.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i3.Types, String>? anObjectKey,
    Map<Map<_i3.Types, String>, String>? aMapKey,
    Map<List<_i3.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i3.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i3.Types>? anObjectValue,
    Map<String, Map<String, _i3.Types>>? aMapValue,
    Map<String, List<_i3.Types>>? aListValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (anIntKey != null) 'anIntKey': anIntKey?.toJson(),
      if (aBoolKey != null) 'aBoolKey': aBoolKey?.toJson(),
      if (aDoubleKey != null) 'aDoubleKey': aDoubleKey?.toJson(),
      if (aDateTimeKey != null)
        'aDateTimeKey': aDateTimeKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aStringKey != null) 'aStringKey': aStringKey?.toJson(),
      if (aByteDataKey != null)
        'aByteDataKey': aByteDataKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aDurationKey != null)
        'aDurationKey': aDurationKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aUuidKey != null)
        'aUuidKey': aUuidKey?.toJson(keyToJson: (k) => k.toJson()),
      if (anEnumKey != null)
        'anEnumKey': anEnumKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aStringifiedEnumKey != null)
        'aStringifiedEnumKey':
            aStringifiedEnumKey?.toJson(keyToJson: (k) => k.toJson()),
      if (anObjectKey != null)
        'anObjectKey': anObjectKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aMapKey != null)
        'aMapKey': aMapKey?.toJson(
            keyToJson: (k) => k.toJson(keyToJson: (k) => k.toJson())),
      if (aListKey != null)
        'aListKey': aListKey?.toJson(
            keyToJson: (k) => k.toJson(valueToJson: (v) => v.toJson())),
      if (anIntValue != null) 'anIntValue': anIntValue?.toJson(),
      if (aBoolValue != null) 'aBoolValue': aBoolValue?.toJson(),
      if (aDoubleValue != null) 'aDoubleValue': aDoubleValue?.toJson(),
      if (aDateTimeValue != null)
        'aDateTimeValue':
            aDateTimeValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringValue != null) 'aStringValue': aStringValue?.toJson(),
      if (aByteDataValue != null)
        'aByteDataValue':
            aByteDataValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aDurationValue != null)
        'aDurationValue':
            aDurationValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aUuidValue != null)
        'aUuidValue': aUuidValue?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnumValue != null)
        'anEnumValue': anEnumValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnumValue != null)
        'aStringifiedEnumValue':
            aStringifiedEnumValue?.toJson(valueToJson: (v) => v.toJson()),
      if (anObjectValue != null)
        'anObjectValue': anObjectValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aMapValue != null)
        'aMapValue': aMapValue?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
      if (aListValue != null)
        'aListValue': aListValue?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }
}

class _Undefined {}

class _TypesMapImpl extends TypesMap {
  _TypesMapImpl({
    Map<int, String>? anIntKey,
    Map<bool, String>? aBoolKey,
    Map<double, String>? aDoubleKey,
    Map<DateTime, String>? aDateTimeKey,
    Map<String, String>? aStringKey,
    Map<_i2.ByteData, String>? aByteDataKey,
    Map<Duration, String>? aDurationKey,
    Map<_i1.UuidValue, String>? aUuidKey,
    Map<_i3.TestEnum, String>? anEnumKey,
    Map<_i3.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i3.Types, String>? anObjectKey,
    Map<Map<_i3.Types, String>, String>? aMapKey,
    Map<List<_i3.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i3.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i3.Types>? anObjectValue,
    Map<String, Map<String, _i3.Types>>? aMapValue,
    Map<String, List<_i3.Types>>? aListValue,
  }) : super._(
          anIntKey: anIntKey,
          aBoolKey: aBoolKey,
          aDoubleKey: aDoubleKey,
          aDateTimeKey: aDateTimeKey,
          aStringKey: aStringKey,
          aByteDataKey: aByteDataKey,
          aDurationKey: aDurationKey,
          aUuidKey: aUuidKey,
          anEnumKey: anEnumKey,
          aStringifiedEnumKey: aStringifiedEnumKey,
          anObjectKey: anObjectKey,
          aMapKey: aMapKey,
          aListKey: aListKey,
          anIntValue: anIntValue,
          aBoolValue: aBoolValue,
          aDoubleValue: aDoubleValue,
          aDateTimeValue: aDateTimeValue,
          aStringValue: aStringValue,
          aByteDataValue: aByteDataValue,
          aDurationValue: aDurationValue,
          aUuidValue: aUuidValue,
          anEnumValue: anEnumValue,
          aStringifiedEnumValue: aStringifiedEnumValue,
          anObjectValue: anObjectValue,
          aMapValue: aMapValue,
          aListValue: aListValue,
        );

  @override
  TypesMap copyWith({
    Object? anIntKey = _Undefined,
    Object? aBoolKey = _Undefined,
    Object? aDoubleKey = _Undefined,
    Object? aDateTimeKey = _Undefined,
    Object? aStringKey = _Undefined,
    Object? aByteDataKey = _Undefined,
    Object? aDurationKey = _Undefined,
    Object? aUuidKey = _Undefined,
    Object? anEnumKey = _Undefined,
    Object? aStringifiedEnumKey = _Undefined,
    Object? anObjectKey = _Undefined,
    Object? aMapKey = _Undefined,
    Object? aListKey = _Undefined,
    Object? anIntValue = _Undefined,
    Object? aBoolValue = _Undefined,
    Object? aDoubleValue = _Undefined,
    Object? aDateTimeValue = _Undefined,
    Object? aStringValue = _Undefined,
    Object? aByteDataValue = _Undefined,
    Object? aDurationValue = _Undefined,
    Object? aUuidValue = _Undefined,
    Object? anEnumValue = _Undefined,
    Object? aStringifiedEnumValue = _Undefined,
    Object? anObjectValue = _Undefined,
    Object? aMapValue = _Undefined,
    Object? aListValue = _Undefined,
  }) {
    return TypesMap(
      anIntKey:
          anIntKey is Map<int, String>? ? anIntKey : this.anIntKey?.clone(),
      aBoolKey:
          aBoolKey is Map<bool, String>? ? aBoolKey : this.aBoolKey?.clone(),
      aDoubleKey: aDoubleKey is Map<double, String>?
          ? aDoubleKey
          : this.aDoubleKey?.clone(),
      aDateTimeKey: aDateTimeKey is Map<DateTime, String>?
          ? aDateTimeKey
          : this.aDateTimeKey?.clone(),
      aStringKey: aStringKey is Map<String, String>?
          ? aStringKey
          : this.aStringKey?.clone(),
      aByteDataKey: aByteDataKey is Map<_i2.ByteData, String>?
          ? aByteDataKey
          : this.aByteDataKey?.clone(),
      aDurationKey: aDurationKey is Map<Duration, String>?
          ? aDurationKey
          : this.aDurationKey?.clone(),
      aUuidKey: aUuidKey is Map<_i1.UuidValue, String>?
          ? aUuidKey
          : this.aUuidKey?.clone(),
      anEnumKey: anEnumKey is Map<_i3.TestEnum, String>?
          ? anEnumKey
          : this.anEnumKey?.clone(),
      aStringifiedEnumKey:
          aStringifiedEnumKey is Map<_i3.TestEnumStringified, String>?
              ? aStringifiedEnumKey
              : this.aStringifiedEnumKey?.clone(),
      anObjectKey: anObjectKey is Map<_i3.Types, String>?
          ? anObjectKey
          : this.anObjectKey?.clone(),
      aMapKey: aMapKey is Map<Map<_i3.Types, String>, String>?
          ? aMapKey
          : this.aMapKey?.clone(),
      aListKey: aListKey is Map<List<_i3.Types>, String>?
          ? aListKey
          : this.aListKey?.clone(),
      anIntValue: anIntValue is Map<String, int>?
          ? anIntValue
          : this.anIntValue?.clone(),
      aBoolValue: aBoolValue is Map<String, bool>?
          ? aBoolValue
          : this.aBoolValue?.clone(),
      aDoubleValue: aDoubleValue is Map<String, double>?
          ? aDoubleValue
          : this.aDoubleValue?.clone(),
      aDateTimeValue: aDateTimeValue is Map<String, DateTime>?
          ? aDateTimeValue
          : this.aDateTimeValue?.clone(),
      aStringValue: aStringValue is Map<String, String>?
          ? aStringValue
          : this.aStringValue?.clone(),
      aByteDataValue: aByteDataValue is Map<String, _i2.ByteData>?
          ? aByteDataValue
          : this.aByteDataValue?.clone(),
      aDurationValue: aDurationValue is Map<String, Duration>?
          ? aDurationValue
          : this.aDurationValue?.clone(),
      aUuidValue: aUuidValue is Map<String, _i1.UuidValue>?
          ? aUuidValue
          : this.aUuidValue?.clone(),
      anEnumValue: anEnumValue is Map<String, _i3.TestEnum>?
          ? anEnumValue
          : this.anEnumValue?.clone(),
      aStringifiedEnumValue:
          aStringifiedEnumValue is Map<String, _i3.TestEnumStringified>?
              ? aStringifiedEnumValue
              : this.aStringifiedEnumValue?.clone(),
      anObjectValue: anObjectValue is Map<String, _i3.Types>?
          ? anObjectValue
          : this.anObjectValue?.clone(),
      aMapValue: aMapValue is Map<String, Map<String, _i3.Types>>?
          ? aMapValue
          : this.aMapValue?.clone(),
      aListValue: aListValue is Map<String, List<_i3.Types>>?
          ? aListValue
          : this.aListValue?.clone(),
    );
  }
}
