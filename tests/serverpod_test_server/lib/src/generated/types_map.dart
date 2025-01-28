/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'test_enum.dart' as _i3;
import 'test_enum_stringified.dart' as _i4;
import 'types.dart' as _i5;

abstract class TypesMap
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    Map<_i4.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i5.Types, String>? anObjectKey,
    Map<Map<_i5.Types, String>, String>? aMapKey,
    Map<List<_i5.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i4.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i5.Types>? anObjectValue,
    Map<String, Map<String, _i5.Types>>? aMapValue,
    Map<String, List<_i5.Types>>? aListValue,
  }) = _TypesMapImpl;

  factory TypesMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesMap(
      anIntKey: (jsonSerialization['anIntKey'] as List?)
          ?.fold<Map<int, String>>(
              {}, (t, e) => {...t, e['k'] as int: e['v'] as String}),
      aBoolKey: (jsonSerialization['aBoolKey'] as List?)
          ?.fold<Map<bool, String>>(
              {}, (t, e) => {...t, e['k'] as bool: e['v'] as String}),
      aDoubleKey: (jsonSerialization['aDoubleKey'] as List?)
          ?.fold<Map<double, String>>({},
              (t, e) => {...t, (e['k'] as num).toDouble(): e['v'] as String}),
      aDateTimeKey: (jsonSerialization['aDateTimeKey'] as List?)
          ?.fold<Map<DateTime, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i1.DateTimeJsonExtension.fromJson(e['k']): e['v'] as String
                  }),
      aStringKey:
          (jsonSerialization['aStringKey'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as String,
              )),
      aByteDataKey: (jsonSerialization['aByteDataKey'] as List?)
          ?.fold<Map<_i2.ByteData, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i1.ByteDataJsonExtension.fromJson(e['k']): e['v'] as String
                  }),
      aDurationKey: (jsonSerialization['aDurationKey'] as List?)
          ?.fold<Map<Duration, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i1.DurationJsonExtension.fromJson(e['k']): e['v'] as String
                  }),
      aUuidKey: (jsonSerialization['aUuidKey'] as List?)
          ?.fold<Map<_i1.UuidValue, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i1.UuidValueJsonExtension.fromJson(e['k']):
                        e['v'] as String
                  }),
      anEnumKey: (jsonSerialization['anEnumKey'] as List?)
          ?.fold<Map<_i3.TestEnum, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i3.TestEnum.fromJson((e['k'] as int)): e['v'] as String
                  }),
      aStringifiedEnumKey: (jsonSerialization['aStringifiedEnumKey'] as List?)
          ?.fold<Map<_i4.TestEnumStringified, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i4.TestEnumStringified.fromJson((e['k'] as String)):
                        e['v'] as String
                  }),
      anObjectKey: (jsonSerialization['anObjectKey'] as List?)
          ?.fold<Map<_i5.Types, String>>(
              {},
              (t, e) => {
                    ...t,
                    _i5.Types.fromJson((e['k'] as Map<String, dynamic>)):
                        e['v'] as String
                  }),
      aMapKey: (jsonSerialization['aMapKey'] as List?)?.fold<
              Map<Map<_i5.Types, String>, String>>(
          {},
          (t, e) => {
                ...t,
                (e['k'] as List).fold<Map<_i5.Types, String>>(
                    {},
                    (t, e) => {
                          ...t,
                          _i5.Types.fromJson((e['k'] as Map<String, dynamic>)):
                              e['v'] as String
                        }): e['v'] as String
              }),
      aListKey: (jsonSerialization['aListKey'] as List?)?.fold<
              Map<List<_i5.Types>, String>>(
          {},
          (t, e) => {
                ...t,
                (e['k'] as List)
                    .map((e) => _i5.Types.fromJson((e as Map<String, dynamic>)))
                    .toList(): e['v'] as String
              }),
      anIntValue:
          (jsonSerialization['anIntValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      aBoolValue:
          (jsonSerialization['aBoolValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as bool,
              )),
      aDoubleValue:
          (jsonSerialization['aDoubleValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                (v as num).toDouble(),
              )),
      aDateTimeValue:
          (jsonSerialization['aDateTimeValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i1.DateTimeJsonExtension.fromJson(v),
              )),
      aStringValue:
          (jsonSerialization['aStringValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as String,
              )),
      aByteDataValue:
          (jsonSerialization['aByteDataValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i1.ByteDataJsonExtension.fromJson(v),
              )),
      aDurationValue:
          (jsonSerialization['aDurationValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i1.DurationJsonExtension.fromJson(v),
              )),
      aUuidValue:
          (jsonSerialization['aUuidValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i1.UuidValueJsonExtension.fromJson(v),
              )),
      anEnumValue:
          (jsonSerialization['anEnumValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i3.TestEnum.fromJson((v as int)),
              )),
      aStringifiedEnumValue:
          (jsonSerialization['aStringifiedEnumValue'] as Map?)
              ?.map((k, v) => MapEntry(
                    k as String,
                    _i4.TestEnumStringified.fromJson((v as String)),
                  )),
      anObjectValue:
          (jsonSerialization['anObjectValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                _i5.Types.fromJson((v as Map<String, dynamic>)),
              )),
      aMapValue:
          (jsonSerialization['aMapValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                (v as Map).map((k, v) => MapEntry(
                      k as String,
                      _i5.Types.fromJson((v as Map<String, dynamic>)),
                    )),
              )),
      aListValue:
          (jsonSerialization['aListValue'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                (v as List)
                    .map((e) => _i5.Types.fromJson((e as Map<String, dynamic>)))
                    .toList(),
              )),
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

  Map<_i4.TestEnumStringified, String>? aStringifiedEnumKey;

  Map<_i5.Types, String>? anObjectKey;

  Map<Map<_i5.Types, String>, String>? aMapKey;

  Map<List<_i5.Types>, String>? aListKey;

  Map<String, int>? anIntValue;

  Map<String, bool>? aBoolValue;

  Map<String, double>? aDoubleValue;

  Map<String, DateTime>? aDateTimeValue;

  Map<String, String>? aStringValue;

  Map<String, _i2.ByteData>? aByteDataValue;

  Map<String, Duration>? aDurationValue;

  Map<String, _i1.UuidValue>? aUuidValue;

  Map<String, _i3.TestEnum>? anEnumValue;

  Map<String, _i4.TestEnumStringified>? aStringifiedEnumValue;

  Map<String, _i5.Types>? anObjectValue;

  Map<String, Map<String, _i5.Types>>? aMapValue;

  Map<String, List<_i5.Types>>? aListValue;

  /// Returns a shallow copy of this [TypesMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
    Map<_i4.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i5.Types, String>? anObjectKey,
    Map<Map<_i5.Types, String>, String>? aMapKey,
    Map<List<_i5.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i4.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i5.Types>? anObjectValue,
    Map<String, Map<String, _i5.Types>>? aMapValue,
    Map<String, List<_i5.Types>>? aListValue,
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

  @override
  Map<String, dynamic> toJsonForProtocol() {
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
        'anObjectKey':
            anObjectKey?.toJson(keyToJson: (k) => k.toJsonForProtocol()),
      if (aMapKey != null)
        'aMapKey': aMapKey?.toJson(
            keyToJson: (k) =>
                k.toJson(keyToJson: (k) => k.toJsonForProtocol())),
      if (aListKey != null)
        'aListKey': aListKey?.toJson(
            keyToJson: (k) =>
                k.toJson(valueToJson: (v) => v.toJsonForProtocol())),
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
        'anObjectValue':
            anObjectValue?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (aMapValue != null)
        'aMapValue': aMapValue?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
      if (aListValue != null)
        'aListValue': aListValue?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    Map<_i4.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_i5.Types, String>? anObjectKey,
    Map<Map<_i5.Types, String>, String>? aMapKey,
    Map<List<_i5.Types>, String>? aListKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _i2.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _i1.UuidValue>? aUuidValue,
    Map<String, _i3.TestEnum>? anEnumValue,
    Map<String, _i4.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _i5.Types>? anObjectValue,
    Map<String, Map<String, _i5.Types>>? aMapValue,
    Map<String, List<_i5.Types>>? aListValue,
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

  /// Returns a shallow copy of this [TypesMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      anIntKey: anIntKey is Map<int, String>?
          ? anIntKey
          : this.anIntKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aBoolKey: aBoolKey is Map<bool, String>?
          ? aBoolKey
          : this.aBoolKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aDoubleKey: aDoubleKey is Map<double, String>?
          ? aDoubleKey
          : this.aDoubleKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aDateTimeKey: aDateTimeKey is Map<DateTime, String>?
          ? aDateTimeKey
          : this.aDateTimeKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aStringKey: aStringKey is Map<String, String>?
          ? aStringKey
          : this.aStringKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aByteDataKey: aByteDataKey is Map<_i2.ByteData, String>?
          ? aByteDataKey
          : this.aByteDataKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0.clone(),
                    value0,
                  )),
      aDurationKey: aDurationKey is Map<Duration, String>?
          ? aDurationKey
          : this.aDurationKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aUuidKey: aUuidKey is Map<_i1.UuidValue, String>?
          ? aUuidKey
          : this.aUuidKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      anEnumKey: anEnumKey is Map<_i3.TestEnum, String>?
          ? anEnumKey
          : this.anEnumKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aStringifiedEnumKey:
          aStringifiedEnumKey is Map<_i4.TestEnumStringified, String>?
              ? aStringifiedEnumKey
              : this.aStringifiedEnumKey?.map((
                    key0,
                    value0,
                  ) =>
                      MapEntry(
                        key0,
                        value0,
                      )),
      anObjectKey: anObjectKey is Map<_i5.Types, String>?
          ? anObjectKey
          : this.anObjectKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0.copyWith(),
                    value0,
                  )),
      aMapKey: aMapKey is Map<Map<_i5.Types, String>, String>?
          ? aMapKey
          : this.aMapKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0.map((
                      key1,
                      value1,
                    ) =>
                        MapEntry(
                          key1.copyWith(),
                          value1,
                        )),
                    value0,
                  )),
      aListKey: aListKey is Map<List<_i5.Types>, String>?
          ? aListKey
          : this.aListKey?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0.map((e1) => e1.copyWith()).toList(),
                    value0,
                  )),
      anIntValue: anIntValue is Map<String, int>?
          ? anIntValue
          : this.anIntValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aBoolValue: aBoolValue is Map<String, bool>?
          ? aBoolValue
          : this.aBoolValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aDoubleValue: aDoubleValue is Map<String, double>?
          ? aDoubleValue
          : this.aDoubleValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aDateTimeValue: aDateTimeValue is Map<String, DateTime>?
          ? aDateTimeValue
          : this.aDateTimeValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aStringValue: aStringValue is Map<String, String>?
          ? aStringValue
          : this.aStringValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aByteDataValue: aByteDataValue is Map<String, _i2.ByteData>?
          ? aByteDataValue
          : this.aByteDataValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.clone(),
                  )),
      aDurationValue: aDurationValue is Map<String, Duration>?
          ? aDurationValue
          : this.aDurationValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aUuidValue: aUuidValue is Map<String, _i1.UuidValue>?
          ? aUuidValue
          : this.aUuidValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      anEnumValue: anEnumValue is Map<String, _i3.TestEnum>?
          ? anEnumValue
          : this.anEnumValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aStringifiedEnumValue:
          aStringifiedEnumValue is Map<String, _i4.TestEnumStringified>?
              ? aStringifiedEnumValue
              : this.aStringifiedEnumValue?.map((
                    key0,
                    value0,
                  ) =>
                      MapEntry(
                        key0,
                        value0,
                      )),
      anObjectValue: anObjectValue is Map<String, _i5.Types>?
          ? anObjectValue
          : this.anObjectValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.copyWith(),
                  )),
      aMapValue: aMapValue is Map<String, Map<String, _i5.Types>>?
          ? aMapValue
          : this.aMapValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.map((
                      key1,
                      value1,
                    ) =>
                        MapEntry(
                          key1,
                          value1.copyWith(),
                        )),
                  )),
      aListValue: aListValue is Map<String, List<_i5.Types>>?
          ? aListValue
          : this.aListValue?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.map((e1) => e1.copyWith()).toList(),
                  )),
    );
  }
}
