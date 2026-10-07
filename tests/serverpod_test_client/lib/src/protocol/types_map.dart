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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;
import 'types.dart' as _iwxwszsz;

abstract class TypesMap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TypesMap._({
    this.anIntKey,
    this.aBoolKey,
    this.aDoubleKey,
    this.aDateTimeKey,
    this.aStringKey,
    this.aByteDataKey,
    this.aDurationKey,
    this.aUuidKey,
    this.aUriKey,
    this.aBigIntKey,
    this.anEnumKey,
    this.aStringifiedEnumKey,
    this.anObjectKey,
    this.aMapKey,
    this.aListKey,
    this.aRecordKey,
    this.anIntValue,
    this.aBoolValue,
    this.aDoubleValue,
    this.aDateTimeValue,
    this.aStringValue,
    this.aByteDataValue,
    this.aDurationValue,
    this.aUuidValue,
    this.aUriValue,
    this.aBigIntValue,
    this.anEnumValue,
    this.aStringifiedEnumValue,
    this.anObjectValue,
    this.aMapValue,
    this.aListValue,
    this.aRecordValue,
    this.aNullableRecordValue,
    this.aNullableRecordKey,
  });

  factory TypesMap({
    Map<int, String>? anIntKey,
    Map<bool, String>? aBoolKey,
    Map<double, String>? aDoubleKey,
    Map<DateTime, String>? aDateTimeKey,
    Map<String, String>? aStringKey,
    Map<_idt.ByteData, String>? aByteDataKey,
    Map<Duration, String>? aDurationKey,
    Map<_isc.UuidValue, String>? aUuidKey,
    Map<Uri, String>? aUriKey,
    Map<BigInt, String>? aBigIntKey,
    Map<_ionapfu9.TestEnum, String>? anEnumKey,
    Map<_i7liykk2.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_iwxwszsz.Types, String>? anObjectKey,
    Map<Map<_iwxwszsz.Types, String>, String>? aMapKey,
    Map<List<_iwxwszsz.Types>, String>? aListKey,
    Map<(String,), String>? aRecordKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _idt.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _isc.UuidValue>? aUuidValue,
    Map<String, Uri>? aUriValue,
    Map<String, BigInt>? aBigIntValue,
    Map<String, _ionapfu9.TestEnum>? anEnumValue,
    Map<String, _i7liykk2.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _iwxwszsz.Types>? anObjectValue,
    Map<String, Map<String, _iwxwszsz.Types>>? aMapValue,
    Map<String, List<_iwxwszsz.Types>>? aListValue,
    Map<String, (String,)>? aRecordValue,
    Map<String, (String,)?>? aNullableRecordValue,
    Map<(String,)?, String>? aNullableRecordKey,
  }) = _TypesMapImpl;

  factory TypesMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesMap(
      anIntKey: jsonSerialization['anIntKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<int, String>>(
              jsonSerialization['anIntKey'],
            ),
      aBoolKey: jsonSerialization['aBoolKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<bool, String>>(
              jsonSerialization['aBoolKey'],
            ),
      aDoubleKey: jsonSerialization['aDoubleKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<double, String>>(
              jsonSerialization['aDoubleKey'],
            ),
      aDateTimeKey: jsonSerialization['aDateTimeKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<DateTime, String>>(
              jsonSerialization['aDateTimeKey'],
            ),
      aStringKey: jsonSerialization['aStringKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['aStringKey'],
            ),
      aByteDataKey: jsonSerialization['aByteDataKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<_idt.ByteData, String>>(
              jsonSerialization['aByteDataKey'],
            ),
      aDurationKey: jsonSerialization['aDurationKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<Duration, String>>(
              jsonSerialization['aDurationKey'],
            ),
      aUuidKey: jsonSerialization['aUuidKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<_isc.UuidValue, String>>(
              jsonSerialization['aUuidKey'],
            ),
      aUriKey: jsonSerialization['aUriKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<Uri, String>>(
              jsonSerialization['aUriKey'],
            ),
      aBigIntKey: jsonSerialization['aBigIntKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<BigInt, String>>(
              jsonSerialization['aBigIntKey'],
            ),
      anEnumKey: jsonSerialization['anEnumKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<_ionapfu9.TestEnum, String>>(
              jsonSerialization['anEnumKey'],
            ),
      aStringifiedEnumKey: jsonSerialization['aStringifiedEnumKey'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<_i7liykk2.TestEnumStringified, String>>(
                  jsonSerialization['aStringifiedEnumKey'],
                ),
      anObjectKey: jsonSerialization['anObjectKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<_iwxwszsz.Types, String>>(
              jsonSerialization['anObjectKey'],
            ),
      aMapKey: jsonSerialization['aMapKey'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<Map<_iwxwszsz.Types, String>, String>>(
                  jsonSerialization['aMapKey'],
                ),
      aListKey: jsonSerialization['aListKey'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<List<_iwxwszsz.Types>, String>>(
                  jsonSerialization['aListKey'],
                ),
      aRecordKey: jsonSerialization['aRecordKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<(String,), String>>(
              jsonSerialization['aRecordKey'],
            ),
      anIntValue: jsonSerialization['anIntValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, int>>(
              jsonSerialization['anIntValue'],
            ),
      aBoolValue: jsonSerialization['aBoolValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, bool>>(
              jsonSerialization['aBoolValue'],
            ),
      aDoubleValue: jsonSerialization['aDoubleValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, double>>(
              jsonSerialization['aDoubleValue'],
            ),
      aDateTimeValue: jsonSerialization['aDateTimeValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, DateTime>>(
              jsonSerialization['aDateTimeValue'],
            ),
      aStringValue: jsonSerialization['aStringValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['aStringValue'],
            ),
      aByteDataValue: jsonSerialization['aByteDataValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, _idt.ByteData>>(
              jsonSerialization['aByteDataValue'],
            ),
      aDurationValue: jsonSerialization['aDurationValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, Duration>>(
              jsonSerialization['aDurationValue'],
            ),
      aUuidValue: jsonSerialization['aUuidValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, _isc.UuidValue>>(
              jsonSerialization['aUuidValue'],
            ),
      aUriValue: jsonSerialization['aUriValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, Uri>>(
              jsonSerialization['aUriValue'],
            ),
      aBigIntValue: jsonSerialization['aBigIntValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, BigInt>>(
              jsonSerialization['aBigIntValue'],
            ),
      anEnumValue: jsonSerialization['anEnumValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, _ionapfu9.TestEnum>>(
              jsonSerialization['anEnumValue'],
            ),
      aStringifiedEnumValue: jsonSerialization['aStringifiedEnumValue'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<String, _i7liykk2.TestEnumStringified>>(
                  jsonSerialization['aStringifiedEnumValue'],
                ),
      anObjectValue: jsonSerialization['anObjectValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, _iwxwszsz.Types>>(
              jsonSerialization['anObjectValue'],
            ),
      aMapValue: jsonSerialization['aMapValue'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<String, Map<String, _iwxwszsz.Types>>>(
                  jsonSerialization['aMapValue'],
                ),
      aListValue: jsonSerialization['aListValue'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<String, List<_iwxwszsz.Types>>>(
                  jsonSerialization['aListValue'],
                ),
      aRecordValue: jsonSerialization['aRecordValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, (String,)>>(
              jsonSerialization['aRecordValue'],
            ),
      aNullableRecordValue: jsonSerialization['aNullableRecordValue'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, (String,)?>>(
              jsonSerialization['aNullableRecordValue'],
            ),
      aNullableRecordKey: jsonSerialization['aNullableRecordKey'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<(String,)?, String>>(
              jsonSerialization['aNullableRecordKey'],
            ),
    );
  }

  Map<int, String>? anIntKey;

  Map<bool, String>? aBoolKey;

  Map<double, String>? aDoubleKey;

  Map<DateTime, String>? aDateTimeKey;

  Map<String, String>? aStringKey;

  Map<_idt.ByteData, String>? aByteDataKey;

  Map<Duration, String>? aDurationKey;

  Map<_isc.UuidValue, String>? aUuidKey;

  Map<Uri, String>? aUriKey;

  Map<BigInt, String>? aBigIntKey;

  Map<_ionapfu9.TestEnum, String>? anEnumKey;

  Map<_i7liykk2.TestEnumStringified, String>? aStringifiedEnumKey;

  Map<_iwxwszsz.Types, String>? anObjectKey;

  Map<Map<_iwxwszsz.Types, String>, String>? aMapKey;

  Map<List<_iwxwszsz.Types>, String>? aListKey;

  Map<(String,), String>? aRecordKey;

  Map<String, int>? anIntValue;

  Map<String, bool>? aBoolValue;

  Map<String, double>? aDoubleValue;

  Map<String, DateTime>? aDateTimeValue;

  Map<String, String>? aStringValue;

  Map<String, _idt.ByteData>? aByteDataValue;

  Map<String, Duration>? aDurationValue;

  Map<String, _isc.UuidValue>? aUuidValue;

  Map<String, Uri>? aUriValue;

  Map<String, BigInt>? aBigIntValue;

  Map<String, _ionapfu9.TestEnum>? anEnumValue;

  Map<String, _i7liykk2.TestEnumStringified>? aStringifiedEnumValue;

  Map<String, _iwxwszsz.Types>? anObjectValue;

  Map<String, Map<String, _iwxwszsz.Types>>? aMapValue;

  Map<String, List<_iwxwszsz.Types>>? aListValue;

  Map<String, (String,)>? aRecordValue;

  Map<String, (String,)?>? aNullableRecordValue;

  Map<(String,)?, String>? aNullableRecordKey;

  /// Returns a shallow copy of this [TypesMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TypesMap copyWith({
    Map<int, String>? anIntKey = const _isc.$UndefinedMap<int, String>(),
    Map<bool, String>? aBoolKey = const _isc.$UndefinedMap<bool, String>(),
    Map<double, String>? aDoubleKey =
        const _isc.$UndefinedMap<double, String>(),
    Map<DateTime, String>? aDateTimeKey =
        const _isc.$UndefinedMap<DateTime, String>(),
    Map<String, String>? aStringKey =
        const _isc.$UndefinedMap<String, String>(),
    Map<_idt.ByteData, String>? aByteDataKey =
        const _isc.$UndefinedMap<_idt.ByteData, String>(),
    Map<Duration, String>? aDurationKey =
        const _isc.$UndefinedMap<Duration, String>(),
    Map<_isc.UuidValue, String>? aUuidKey =
        const _isc.$UndefinedMap<_isc.UuidValue, String>(),
    Map<Uri, String>? aUriKey = const _isc.$UndefinedMap<Uri, String>(),
    Map<BigInt, String>? aBigIntKey =
        const _isc.$UndefinedMap<BigInt, String>(),
    Map<_ionapfu9.TestEnum, String>? anEnumKey =
        const _isc.$UndefinedMap<_ionapfu9.TestEnum, String>(),
    Map<_i7liykk2.TestEnumStringified, String>? aStringifiedEnumKey =
        const _isc.$UndefinedMap<_i7liykk2.TestEnumStringified, String>(),
    Map<_iwxwszsz.Types, String>? anObjectKey =
        const _isc.$UndefinedMap<_iwxwszsz.Types, String>(),
    Map<Map<_iwxwszsz.Types, String>, String>? aMapKey =
        const _isc.$UndefinedMap<Map<_iwxwszsz.Types, String>, String>(),
    Map<List<_iwxwszsz.Types>, String>? aListKey =
        const _isc.$UndefinedMap<List<_iwxwszsz.Types>, String>(),
    Map<(String,), String>? aRecordKey =
        const _isc.$UndefinedMap<(String,), String>(),
    Map<String, int>? anIntValue = const _isc.$UndefinedMap<String, int>(),
    Map<String, bool>? aBoolValue = const _isc.$UndefinedMap<String, bool>(),
    Map<String, double>? aDoubleValue =
        const _isc.$UndefinedMap<String, double>(),
    Map<String, DateTime>? aDateTimeValue =
        const _isc.$UndefinedMap<String, DateTime>(),
    Map<String, String>? aStringValue =
        const _isc.$UndefinedMap<String, String>(),
    Map<String, _idt.ByteData>? aByteDataValue =
        const _isc.$UndefinedMap<String, _idt.ByteData>(),
    Map<String, Duration>? aDurationValue =
        const _isc.$UndefinedMap<String, Duration>(),
    Map<String, _isc.UuidValue>? aUuidValue =
        const _isc.$UndefinedMap<String, _isc.UuidValue>(),
    Map<String, Uri>? aUriValue = const _isc.$UndefinedMap<String, Uri>(),
    Map<String, BigInt>? aBigIntValue =
        const _isc.$UndefinedMap<String, BigInt>(),
    Map<String, _ionapfu9.TestEnum>? anEnumValue =
        const _isc.$UndefinedMap<String, _ionapfu9.TestEnum>(),
    Map<String, _i7liykk2.TestEnumStringified>? aStringifiedEnumValue =
        const _isc.$UndefinedMap<String, _i7liykk2.TestEnumStringified>(),
    Map<String, _iwxwszsz.Types>? anObjectValue =
        const _isc.$UndefinedMap<String, _iwxwszsz.Types>(),
    Map<String, Map<String, _iwxwszsz.Types>>? aMapValue =
        const _isc.$UndefinedMap<String, Map<String, _iwxwszsz.Types>>(),
    Map<String, List<_iwxwszsz.Types>>? aListValue =
        const _isc.$UndefinedMap<String, List<_iwxwszsz.Types>>(),
    Map<String, (String,)>? aRecordValue =
        const _isc.$UndefinedMap<String, (String,)>(),
    Map<String, (String,)?>? aNullableRecordValue =
        const _isc.$UndefinedMap<String, (String,)?>(),
    Map<(String,)?, String>? aNullableRecordKey =
        const _isc.$UndefinedMap<(String,)?, String>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TypesMap',
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
      if (aUriKey != null)
        'aUriKey': aUriKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aBigIntKey != null)
        'aBigIntKey': aBigIntKey?.toJson(keyToJson: (k) => k.toJson()),
      if (anEnumKey != null)
        'anEnumKey': anEnumKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aStringifiedEnumKey != null)
        'aStringifiedEnumKey': aStringifiedEnumKey?.toJson(
          keyToJson: (k) => k.toJson(),
        ),
      if (anObjectKey != null)
        'anObjectKey': anObjectKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aMapKey != null)
        'aMapKey': aMapKey?.toJson(
          keyToJson: (k) => k.toJson(keyToJson: (k) => k.toJson()),
        ),
      if (aListKey != null)
        'aListKey': aListKey?.toJson(
          keyToJson: (k) => k.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (aRecordKey != null)
        'aRecordKey': _iza9lbb5.Protocol().mapContainerToJson(aRecordKey!),
      if (anIntValue != null) 'anIntValue': anIntValue?.toJson(),
      if (aBoolValue != null) 'aBoolValue': aBoolValue?.toJson(),
      if (aDoubleValue != null) 'aDoubleValue': aDoubleValue?.toJson(),
      if (aDateTimeValue != null)
        'aDateTimeValue': aDateTimeValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aStringValue != null) 'aStringValue': aStringValue?.toJson(),
      if (aByteDataValue != null)
        'aByteDataValue': aByteDataValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aDurationValue != null)
        'aDurationValue': aDurationValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aUuidValue != null)
        'aUuidValue': aUuidValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aUriValue != null)
        'aUriValue': aUriValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aBigIntValue != null)
        'aBigIntValue': aBigIntValue?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnumValue != null)
        'anEnumValue': anEnumValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnumValue != null)
        'aStringifiedEnumValue': aStringifiedEnumValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (anObjectValue != null)
        'anObjectValue': anObjectValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aMapValue != null)
        'aMapValue': aMapValue?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (aListValue != null)
        'aListValue': aListValue?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (aRecordValue != null)
        'aRecordValue': _iza9lbb5.Protocol().mapContainerToJson(aRecordValue!),
      if (aNullableRecordValue != null)
        'aNullableRecordValue': _iza9lbb5.Protocol().mapContainerToJson(
          aNullableRecordValue!,
        ),
      if (aNullableRecordKey != null)
        'aNullableRecordKey': _iza9lbb5.Protocol().mapContainerToJson(
          aNullableRecordKey!,
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TypesMap',
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
      if (aUriKey != null)
        'aUriKey': aUriKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aBigIntKey != null)
        'aBigIntKey': aBigIntKey?.toJson(keyToJson: (k) => k.toJson()),
      if (anEnumKey != null)
        'anEnumKey': anEnumKey?.toJson(keyToJson: (k) => k.toJson()),
      if (aStringifiedEnumKey != null)
        'aStringifiedEnumKey': aStringifiedEnumKey?.toJson(
          keyToJson: (k) => k.toJson(),
        ),
      if (anObjectKey != null)
        'anObjectKey': anObjectKey?.toJson(
          keyToJson: (k) => k.toJsonForProtocol(),
        ),
      if (aMapKey != null)
        'aMapKey': aMapKey?.toJson(
          keyToJson: (k) => k.toJson(keyToJson: (k) => k.toJsonForProtocol()),
        ),
      if (aListKey != null)
        'aListKey': aListKey?.toJson(
          keyToJson: (k) => k.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (aRecordKey != null)
        'aRecordKey': _iza9lbb5.Protocol().mapContainerToJson(aRecordKey!),
      if (anIntValue != null) 'anIntValue': anIntValue?.toJson(),
      if (aBoolValue != null) 'aBoolValue': aBoolValue?.toJson(),
      if (aDoubleValue != null) 'aDoubleValue': aDoubleValue?.toJson(),
      if (aDateTimeValue != null)
        'aDateTimeValue': aDateTimeValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aStringValue != null) 'aStringValue': aStringValue?.toJson(),
      if (aByteDataValue != null)
        'aByteDataValue': aByteDataValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aDurationValue != null)
        'aDurationValue': aDurationValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (aUuidValue != null)
        'aUuidValue': aUuidValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aUriValue != null)
        'aUriValue': aUriValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aBigIntValue != null)
        'aBigIntValue': aBigIntValue?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnumValue != null)
        'anEnumValue': anEnumValue?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnumValue != null)
        'aStringifiedEnumValue': aStringifiedEnumValue?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (anObjectValue != null)
        'anObjectValue': anObjectValue?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (aMapValue != null)
        'aMapValue': aMapValue?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (aListValue != null)
        'aListValue': aListValue?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (aRecordValue != null)
        'aRecordValue': _iza9lbb5.Protocol().mapContainerToJson(aRecordValue!),
      if (aNullableRecordValue != null)
        'aNullableRecordValue': _iza9lbb5.Protocol().mapContainerToJson(
          aNullableRecordValue!,
        ),
      if (aNullableRecordKey != null)
        'aNullableRecordKey': _iza9lbb5.Protocol().mapContainerToJson(
          aNullableRecordKey!,
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TypesMapImpl extends TypesMap {
  _TypesMapImpl({
    Map<int, String>? anIntKey,
    Map<bool, String>? aBoolKey,
    Map<double, String>? aDoubleKey,
    Map<DateTime, String>? aDateTimeKey,
    Map<String, String>? aStringKey,
    Map<_idt.ByteData, String>? aByteDataKey,
    Map<Duration, String>? aDurationKey,
    Map<_isc.UuidValue, String>? aUuidKey,
    Map<Uri, String>? aUriKey,
    Map<BigInt, String>? aBigIntKey,
    Map<_ionapfu9.TestEnum, String>? anEnumKey,
    Map<_i7liykk2.TestEnumStringified, String>? aStringifiedEnumKey,
    Map<_iwxwszsz.Types, String>? anObjectKey,
    Map<Map<_iwxwszsz.Types, String>, String>? aMapKey,
    Map<List<_iwxwszsz.Types>, String>? aListKey,
    Map<(String,), String>? aRecordKey,
    Map<String, int>? anIntValue,
    Map<String, bool>? aBoolValue,
    Map<String, double>? aDoubleValue,
    Map<String, DateTime>? aDateTimeValue,
    Map<String, String>? aStringValue,
    Map<String, _idt.ByteData>? aByteDataValue,
    Map<String, Duration>? aDurationValue,
    Map<String, _isc.UuidValue>? aUuidValue,
    Map<String, Uri>? aUriValue,
    Map<String, BigInt>? aBigIntValue,
    Map<String, _ionapfu9.TestEnum>? anEnumValue,
    Map<String, _i7liykk2.TestEnumStringified>? aStringifiedEnumValue,
    Map<String, _iwxwszsz.Types>? anObjectValue,
    Map<String, Map<String, _iwxwszsz.Types>>? aMapValue,
    Map<String, List<_iwxwszsz.Types>>? aListValue,
    Map<String, (String,)>? aRecordValue,
    Map<String, (String,)?>? aNullableRecordValue,
    Map<(String,)?, String>? aNullableRecordKey,
  }) : super._(
         anIntKey: anIntKey,
         aBoolKey: aBoolKey,
         aDoubleKey: aDoubleKey,
         aDateTimeKey: aDateTimeKey,
         aStringKey: aStringKey,
         aByteDataKey: aByteDataKey,
         aDurationKey: aDurationKey,
         aUuidKey: aUuidKey,
         aUriKey: aUriKey,
         aBigIntKey: aBigIntKey,
         anEnumKey: anEnumKey,
         aStringifiedEnumKey: aStringifiedEnumKey,
         anObjectKey: anObjectKey,
         aMapKey: aMapKey,
         aListKey: aListKey,
         aRecordKey: aRecordKey,
         anIntValue: anIntValue,
         aBoolValue: aBoolValue,
         aDoubleValue: aDoubleValue,
         aDateTimeValue: aDateTimeValue,
         aStringValue: aStringValue,
         aByteDataValue: aByteDataValue,
         aDurationValue: aDurationValue,
         aUuidValue: aUuidValue,
         aUriValue: aUriValue,
         aBigIntValue: aBigIntValue,
         anEnumValue: anEnumValue,
         aStringifiedEnumValue: aStringifiedEnumValue,
         anObjectValue: anObjectValue,
         aMapValue: aMapValue,
         aListValue: aListValue,
         aRecordValue: aRecordValue,
         aNullableRecordValue: aNullableRecordValue,
         aNullableRecordKey: aNullableRecordKey,
       );

  /// Returns a shallow copy of this [TypesMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TypesMap copyWith({
    Map<int, String>? anIntKey = const _isc.$UndefinedMap<int, String>(),
    Map<bool, String>? aBoolKey = const _isc.$UndefinedMap<bool, String>(),
    Map<double, String>? aDoubleKey =
        const _isc.$UndefinedMap<double, String>(),
    Map<DateTime, String>? aDateTimeKey =
        const _isc.$UndefinedMap<DateTime, String>(),
    Map<String, String>? aStringKey =
        const _isc.$UndefinedMap<String, String>(),
    Map<_idt.ByteData, String>? aByteDataKey =
        const _isc.$UndefinedMap<_idt.ByteData, String>(),
    Map<Duration, String>? aDurationKey =
        const _isc.$UndefinedMap<Duration, String>(),
    Map<_isc.UuidValue, String>? aUuidKey =
        const _isc.$UndefinedMap<_isc.UuidValue, String>(),
    Map<Uri, String>? aUriKey = const _isc.$UndefinedMap<Uri, String>(),
    Map<BigInt, String>? aBigIntKey =
        const _isc.$UndefinedMap<BigInt, String>(),
    Map<_ionapfu9.TestEnum, String>? anEnumKey =
        const _isc.$UndefinedMap<_ionapfu9.TestEnum, String>(),
    Map<_i7liykk2.TestEnumStringified, String>? aStringifiedEnumKey =
        const _isc.$UndefinedMap<_i7liykk2.TestEnumStringified, String>(),
    Map<_iwxwszsz.Types, String>? anObjectKey =
        const _isc.$UndefinedMap<_iwxwszsz.Types, String>(),
    Map<Map<_iwxwszsz.Types, String>, String>? aMapKey =
        const _isc.$UndefinedMap<Map<_iwxwszsz.Types, String>, String>(),
    Map<List<_iwxwszsz.Types>, String>? aListKey =
        const _isc.$UndefinedMap<List<_iwxwszsz.Types>, String>(),
    Map<(String,), String>? aRecordKey =
        const _isc.$UndefinedMap<(String,), String>(),
    Map<String, int>? anIntValue = const _isc.$UndefinedMap<String, int>(),
    Map<String, bool>? aBoolValue = const _isc.$UndefinedMap<String, bool>(),
    Map<String, double>? aDoubleValue =
        const _isc.$UndefinedMap<String, double>(),
    Map<String, DateTime>? aDateTimeValue =
        const _isc.$UndefinedMap<String, DateTime>(),
    Map<String, String>? aStringValue =
        const _isc.$UndefinedMap<String, String>(),
    Map<String, _idt.ByteData>? aByteDataValue =
        const _isc.$UndefinedMap<String, _idt.ByteData>(),
    Map<String, Duration>? aDurationValue =
        const _isc.$UndefinedMap<String, Duration>(),
    Map<String, _isc.UuidValue>? aUuidValue =
        const _isc.$UndefinedMap<String, _isc.UuidValue>(),
    Map<String, Uri>? aUriValue = const _isc.$UndefinedMap<String, Uri>(),
    Map<String, BigInt>? aBigIntValue =
        const _isc.$UndefinedMap<String, BigInt>(),
    Map<String, _ionapfu9.TestEnum>? anEnumValue =
        const _isc.$UndefinedMap<String, _ionapfu9.TestEnum>(),
    Map<String, _i7liykk2.TestEnumStringified>? aStringifiedEnumValue =
        const _isc.$UndefinedMap<String, _i7liykk2.TestEnumStringified>(),
    Map<String, _iwxwszsz.Types>? anObjectValue =
        const _isc.$UndefinedMap<String, _iwxwszsz.Types>(),
    Map<String, Map<String, _iwxwszsz.Types>>? aMapValue =
        const _isc.$UndefinedMap<String, Map<String, _iwxwszsz.Types>>(),
    Map<String, List<_iwxwszsz.Types>>? aListValue =
        const _isc.$UndefinedMap<String, List<_iwxwszsz.Types>>(),
    Map<String, (String,)>? aRecordValue =
        const _isc.$UndefinedMap<String, (String,)>(),
    Map<String, (String,)?>? aNullableRecordValue =
        const _isc.$UndefinedMap<String, (String,)?>(),
    Map<(String,)?, String>? aNullableRecordKey =
        const _isc.$UndefinedMap<(String,)?, String>(),
  }) {
    return TypesMap(
      anIntKey: anIntKey is _isc.UndefinedSentinel
          ? this.anIntKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : anIntKey,
      aBoolKey: aBoolKey is _isc.UndefinedSentinel
          ? this.aBoolKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aBoolKey,
      aDoubleKey: aDoubleKey is _isc.UndefinedSentinel
          ? this.aDoubleKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDoubleKey,
      aDateTimeKey: aDateTimeKey is _isc.UndefinedSentinel
          ? this.aDateTimeKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDateTimeKey,
      aStringKey: aStringKey is _isc.UndefinedSentinel
          ? this.aStringKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aStringKey,
      aByteDataKey: aByteDataKey is _isc.UndefinedSentinel
          ? this.aByteDataKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0.clone(),
                value0,
              ),
            )
          : aByteDataKey,
      aDurationKey: aDurationKey is _isc.UndefinedSentinel
          ? this.aDurationKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDurationKey,
      aUuidKey: aUuidKey is _isc.UndefinedSentinel
          ? this.aUuidKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aUuidKey,
      aUriKey: aUriKey is _isc.UndefinedSentinel
          ? this.aUriKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aUriKey,
      aBigIntKey: aBigIntKey is _isc.UndefinedSentinel
          ? this.aBigIntKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aBigIntKey,
      anEnumKey: anEnumKey is _isc.UndefinedSentinel
          ? this.anEnumKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : anEnumKey,
      aStringifiedEnumKey: aStringifiedEnumKey is _isc.UndefinedSentinel
          ? this.aStringifiedEnumKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aStringifiedEnumKey,
      anObjectKey: anObjectKey is _isc.UndefinedSentinel
          ? this.anObjectKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0.copyWith(),
                value0,
              ),
            )
          : anObjectKey,
      aMapKey: aMapKey is _isc.UndefinedSentinel
          ? this.aMapKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0.map(
                  (
                    key1,
                    value1,
                  ) => MapEntry(
                    key1.copyWith(),
                    value1,
                  ),
                ),
                value0,
              ),
            )
          : aMapKey,
      aListKey: aListKey is _isc.UndefinedSentinel
          ? this.aListKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0.map((e1) => e1.copyWith()).toList(),
                value0,
              ),
            )
          : aListKey,
      aRecordKey: aRecordKey is _isc.UndefinedSentinel
          ? this.aRecordKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                (key0.$1,),
                value0,
              ),
            )
          : aRecordKey,
      anIntValue: anIntValue is _isc.UndefinedSentinel
          ? this.anIntValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : anIntValue,
      aBoolValue: aBoolValue is _isc.UndefinedSentinel
          ? this.aBoolValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aBoolValue,
      aDoubleValue: aDoubleValue is _isc.UndefinedSentinel
          ? this.aDoubleValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDoubleValue,
      aDateTimeValue: aDateTimeValue is _isc.UndefinedSentinel
          ? this.aDateTimeValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDateTimeValue,
      aStringValue: aStringValue is _isc.UndefinedSentinel
          ? this.aStringValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aStringValue,
      aByteDataValue: aByteDataValue is _isc.UndefinedSentinel
          ? this.aByteDataValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.clone(),
              ),
            )
          : aByteDataValue,
      aDurationValue: aDurationValue is _isc.UndefinedSentinel
          ? this.aDurationValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aDurationValue,
      aUuidValue: aUuidValue is _isc.UndefinedSentinel
          ? this.aUuidValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aUuidValue,
      aUriValue: aUriValue is _isc.UndefinedSentinel
          ? this.aUriValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aUriValue,
      aBigIntValue: aBigIntValue is _isc.UndefinedSentinel
          ? this.aBigIntValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aBigIntValue,
      anEnumValue: anEnumValue is _isc.UndefinedSentinel
          ? this.anEnumValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : anEnumValue,
      aStringifiedEnumValue: aStringifiedEnumValue is _isc.UndefinedSentinel
          ? this.aStringifiedEnumValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : aStringifiedEnumValue,
      anObjectValue: anObjectValue is _isc.UndefinedSentinel
          ? this.anObjectValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.copyWith(),
              ),
            )
          : anObjectValue,
      aMapValue: aMapValue is _isc.UndefinedSentinel
          ? this.aMapValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.map(
                  (
                    key1,
                    value1,
                  ) => MapEntry(
                    key1,
                    value1.copyWith(),
                  ),
                ),
              ),
            )
          : aMapValue,
      aListValue: aListValue is _isc.UndefinedSentinel
          ? this.aListValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.map((e1) => e1.copyWith()).toList(),
              ),
            )
          : aListValue,
      aRecordValue: aRecordValue is _isc.UndefinedSentinel
          ? this.aRecordValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                (value0.$1,),
              ),
            )
          : aRecordValue,
      aNullableRecordValue: aNullableRecordValue is _isc.UndefinedSentinel
          ? this.aNullableRecordValue?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0 == null ? null : (value0.$1,),
              ),
            )
          : aNullableRecordValue,
      aNullableRecordKey: aNullableRecordKey is _isc.UndefinedSentinel
          ? this.aNullableRecordKey?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0 == null ? null : (key0.$1,),
                value0,
              ),
            )
          : aNullableRecordKey,
    );
  }
}
