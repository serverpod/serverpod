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

abstract class TypesMap implements _i1.TableRow, _i1.ProtocolSerialization {
  TypesMap._({
    this.id,
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
    int? id,
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
      id: jsonSerialization['id'] as int?,
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

  static final t = TypesMapTable();

  static const db = TypesMapRepository._();

  @override
  int? id;

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

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [TypesMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TypesMap copyWith({
    int? id,
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
      if (id != null) 'id': id,
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
      if (id != null) 'id': id,
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

  static TypesMapInclude include() {
    return TypesMapInclude._();
  }

  static TypesMapIncludeList includeList({
    _i1.WhereExpressionBuilder<TypesMapTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesMapTable>? orderByList,
    TypesMapInclude? include,
  }) {
    return TypesMapIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TypesMap.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TypesMap.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TypesMapImpl extends TypesMap {
  _TypesMapImpl({
    int? id,
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
          id: id,
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
    Object? id = _Undefined,
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
      id: id is int? ? id : this.id,
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

class TypesMapTable extends _i1.Table {
  TypesMapTable({super.tableRelation}) : super(tableName: 'types_map') {
    anIntKey = _i1.ColumnSerializable(
      'anIntKey',
      this,
    );
    aBoolKey = _i1.ColumnSerializable(
      'aBoolKey',
      this,
    );
    aDoubleKey = _i1.ColumnSerializable(
      'aDoubleKey',
      this,
    );
    aDateTimeKey = _i1.ColumnSerializable(
      'aDateTimeKey',
      this,
    );
    aStringKey = _i1.ColumnSerializable(
      'aStringKey',
      this,
    );
    aByteDataKey = _i1.ColumnSerializable(
      'aByteDataKey',
      this,
    );
    aDurationKey = _i1.ColumnSerializable(
      'aDurationKey',
      this,
    );
    aUuidKey = _i1.ColumnSerializable(
      'aUuidKey',
      this,
    );
    anEnumKey = _i1.ColumnSerializable(
      'anEnumKey',
      this,
    );
    aStringifiedEnumKey = _i1.ColumnSerializable(
      'aStringifiedEnumKey',
      this,
    );
    anObjectKey = _i1.ColumnSerializable(
      'anObjectKey',
      this,
    );
    aMapKey = _i1.ColumnSerializable(
      'aMapKey',
      this,
    );
    aListKey = _i1.ColumnSerializable(
      'aListKey',
      this,
    );
    anIntValue = _i1.ColumnSerializable(
      'anIntValue',
      this,
    );
    aBoolValue = _i1.ColumnSerializable(
      'aBoolValue',
      this,
    );
    aDoubleValue = _i1.ColumnSerializable(
      'aDoubleValue',
      this,
    );
    aDateTimeValue = _i1.ColumnSerializable(
      'aDateTimeValue',
      this,
    );
    aStringValue = _i1.ColumnSerializable(
      'aStringValue',
      this,
    );
    aByteDataValue = _i1.ColumnSerializable(
      'aByteDataValue',
      this,
    );
    aDurationValue = _i1.ColumnSerializable(
      'aDurationValue',
      this,
    );
    aUuidValue = _i1.ColumnSerializable(
      'aUuidValue',
      this,
    );
    anEnumValue = _i1.ColumnSerializable(
      'anEnumValue',
      this,
    );
    aStringifiedEnumValue = _i1.ColumnSerializable(
      'aStringifiedEnumValue',
      this,
    );
    anObjectValue = _i1.ColumnSerializable(
      'anObjectValue',
      this,
    );
    aMapValue = _i1.ColumnSerializable(
      'aMapValue',
      this,
    );
    aListValue = _i1.ColumnSerializable(
      'aListValue',
      this,
    );
  }

  late final _i1.ColumnSerializable anIntKey;

  late final _i1.ColumnSerializable aBoolKey;

  late final _i1.ColumnSerializable aDoubleKey;

  late final _i1.ColumnSerializable aDateTimeKey;

  late final _i1.ColumnSerializable aStringKey;

  late final _i1.ColumnSerializable aByteDataKey;

  late final _i1.ColumnSerializable aDurationKey;

  late final _i1.ColumnSerializable aUuidKey;

  late final _i1.ColumnSerializable anEnumKey;

  late final _i1.ColumnSerializable aStringifiedEnumKey;

  late final _i1.ColumnSerializable anObjectKey;

  late final _i1.ColumnSerializable aMapKey;

  late final _i1.ColumnSerializable aListKey;

  late final _i1.ColumnSerializable anIntValue;

  late final _i1.ColumnSerializable aBoolValue;

  late final _i1.ColumnSerializable aDoubleValue;

  late final _i1.ColumnSerializable aDateTimeValue;

  late final _i1.ColumnSerializable aStringValue;

  late final _i1.ColumnSerializable aByteDataValue;

  late final _i1.ColumnSerializable aDurationValue;

  late final _i1.ColumnSerializable aUuidValue;

  late final _i1.ColumnSerializable anEnumValue;

  late final _i1.ColumnSerializable aStringifiedEnumValue;

  late final _i1.ColumnSerializable anObjectValue;

  late final _i1.ColumnSerializable aMapValue;

  late final _i1.ColumnSerializable aListValue;

  @override
  List<_i1.Column> get columns => [
        id,
        anIntKey,
        aBoolKey,
        aDoubleKey,
        aDateTimeKey,
        aStringKey,
        aByteDataKey,
        aDurationKey,
        aUuidKey,
        anEnumKey,
        aStringifiedEnumKey,
        anObjectKey,
        aMapKey,
        aListKey,
        anIntValue,
        aBoolValue,
        aDoubleValue,
        aDateTimeValue,
        aStringValue,
        aByteDataValue,
        aDurationValue,
        aUuidValue,
        anEnumValue,
        aStringifiedEnumValue,
        anObjectValue,
        aMapValue,
        aListValue,
      ];
}

class TypesMapInclude extends _i1.IncludeObject {
  TypesMapInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => TypesMap.t;
}

class TypesMapIncludeList extends _i1.IncludeList {
  TypesMapIncludeList._({
    _i1.WhereExpressionBuilder<TypesMapTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TypesMap.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => TypesMap.t;
}

class TypesMapRepository {
  const TypesMapRepository._();

  /// Returns a list of [TypesMap]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TypesMap>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesMapTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesMapTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TypesMap>(
      where: where?.call(TypesMap.t),
      orderBy: orderBy?.call(TypesMap.t),
      orderByList: orderByList?.call(TypesMap.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TypesMap] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TypesMap?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesMapTable>? where,
    int? offset,
    _i1.OrderByBuilder<TypesMapTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesMapTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TypesMap>(
      where: where?.call(TypesMap.t),
      orderBy: orderBy?.call(TypesMap.t),
      orderByList: orderByList?.call(TypesMap.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TypesMap] by its [id] or null if no such row exists.
  Future<TypesMap?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TypesMap>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TypesMap]s in the list and returns the inserted rows.
  ///
  /// The returned [TypesMap]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TypesMap>> insert(
    _i1.Session session,
    List<TypesMap> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TypesMap>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TypesMap] and returns the inserted row.
  ///
  /// The returned [TypesMap] will have its `id` field set.
  Future<TypesMap> insertRow(
    _i1.Session session,
    TypesMap row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TypesMap>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TypesMap]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TypesMap>> update(
    _i1.Session session,
    List<TypesMap> rows, {
    _i1.ColumnSelections<TypesMapTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TypesMap>(
      rows,
      columns: columns?.call(TypesMap.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TypesMap]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TypesMap> updateRow(
    _i1.Session session,
    TypesMap row, {
    _i1.ColumnSelections<TypesMapTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TypesMap>(
      row,
      columns: columns?.call(TypesMap.t),
      transaction: transaction,
    );
  }

  /// Deletes all [TypesMap]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TypesMap>> delete(
    _i1.Session session,
    List<TypesMap> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TypesMap>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TypesMap].
  Future<TypesMap> deleteRow(
    _i1.Session session,
    TypesMap row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TypesMap>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TypesMap>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TypesMapTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TypesMap>(
      where: where(TypesMap.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesMapTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TypesMap>(
      where: where?.call(TypesMap.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
