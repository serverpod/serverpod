/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'dart:typed_data' as _i3;
import 'package:collection/collection.dart' as _i4;

abstract class ObjectWithMaps extends _i1.SerializableEntity {
  const ObjectWithMaps._();

  const factory ObjectWithMaps({
    required Map<String, _i2.SimpleData> dataMap,
    required Map<String, int> intMap,
    required Map<String, String> stringMap,
    required Map<String, DateTime> dateTimeMap,
    required Map<String, _i3.ByteData> byteDataMap,
    required Map<String, Duration> durationMap,
    required Map<String, _i1.UuidValue> uuidMap,
    required Map<String, _i2.SimpleData?> nullableDataMap,
    required Map<String, int?> nullableIntMap,
    required Map<String, String?> nullableStringMap,
    required Map<String, DateTime?> nullableDateTimeMap,
    required Map<String, _i3.ByteData?> nullableByteDataMap,
    required Map<String, Duration?> nullableDurationMap,
    required Map<String, _i1.UuidValue?> nullableUuidMap,
    required Map<int, int> intIntMap,
  }) = _ObjectWithMaps;

  factory ObjectWithMaps.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithMaps(
      dataMap: serializationManager.deserialize<Map<String, _i2.SimpleData>>(
          jsonSerialization['dataMap']),
      intMap: serializationManager
          .deserialize<Map<String, int>>(jsonSerialization['intMap']),
      stringMap: serializationManager
          .deserialize<Map<String, String>>(jsonSerialization['stringMap']),
      dateTimeMap: serializationManager
          .deserialize<Map<String, DateTime>>(jsonSerialization['dateTimeMap']),
      byteDataMap: serializationManager.deserialize<Map<String, _i3.ByteData>>(
          jsonSerialization['byteDataMap']),
      durationMap: serializationManager
          .deserialize<Map<String, Duration>>(jsonSerialization['durationMap']),
      uuidMap: serializationManager.deserialize<Map<String, _i1.UuidValue>>(
          jsonSerialization['uuidMap']),
      nullableDataMap:
          serializationManager.deserialize<Map<String, _i2.SimpleData?>>(
              jsonSerialization['nullableDataMap']),
      nullableIntMap: serializationManager
          .deserialize<Map<String, int?>>(jsonSerialization['nullableIntMap']),
      nullableStringMap: serializationManager.deserialize<Map<String, String?>>(
          jsonSerialization['nullableStringMap']),
      nullableDateTimeMap:
          serializationManager.deserialize<Map<String, DateTime?>>(
              jsonSerialization['nullableDateTimeMap']),
      nullableByteDataMap:
          serializationManager.deserialize<Map<String, _i3.ByteData?>>(
              jsonSerialization['nullableByteDataMap']),
      nullableDurationMap:
          serializationManager.deserialize<Map<String, Duration?>>(
              jsonSerialization['nullableDurationMap']),
      nullableUuidMap:
          serializationManager.deserialize<Map<String, _i1.UuidValue?>>(
              jsonSerialization['nullableUuidMap']),
      intIntMap: serializationManager
          .deserialize<Map<int, int>>(jsonSerialization['intIntMap']),
    );
  }

  ObjectWithMaps copyWith({
    Map<String, _i2.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  });
  Map<String, _i2.SimpleData> get dataMap;
  Map<String, int> get intMap;
  Map<String, String> get stringMap;
  Map<String, DateTime> get dateTimeMap;
  Map<String, _i3.ByteData> get byteDataMap;
  Map<String, Duration> get durationMap;
  Map<String, _i1.UuidValue> get uuidMap;
  Map<String, _i2.SimpleData?> get nullableDataMap;
  Map<String, int?> get nullableIntMap;
  Map<String, String?> get nullableStringMap;
  Map<String, DateTime?> get nullableDateTimeMap;
  Map<String, _i3.ByteData?> get nullableByteDataMap;
  Map<String, Duration?> get nullableDurationMap;
  Map<String, _i1.UuidValue?> get nullableUuidMap;
  Map<int, int> get intIntMap;
}

class _ObjectWithMaps extends ObjectWithMaps {
  const _ObjectWithMaps({
    required this.dataMap,
    required this.intMap,
    required this.stringMap,
    required this.dateTimeMap,
    required this.byteDataMap,
    required this.durationMap,
    required this.uuidMap,
    required this.nullableDataMap,
    required this.nullableIntMap,
    required this.nullableStringMap,
    required this.nullableDateTimeMap,
    required this.nullableByteDataMap,
    required this.nullableDurationMap,
    required this.nullableUuidMap,
    required this.intIntMap,
  }) : super._();

  @override
  final Map<String, _i2.SimpleData> dataMap;

  @override
  final Map<String, int> intMap;

  @override
  final Map<String, String> stringMap;

  @override
  final Map<String, DateTime> dateTimeMap;

  @override
  final Map<String, _i3.ByteData> byteDataMap;

  @override
  final Map<String, Duration> durationMap;

  @override
  final Map<String, _i1.UuidValue> uuidMap;

  @override
  final Map<String, _i2.SimpleData?> nullableDataMap;

  @override
  final Map<String, int?> nullableIntMap;

  @override
  final Map<String, String?> nullableStringMap;

  @override
  final Map<String, DateTime?> nullableDateTimeMap;

  @override
  final Map<String, _i3.ByteData?> nullableByteDataMap;

  @override
  final Map<String, Duration?> nullableDurationMap;

  @override
  final Map<String, _i1.UuidValue?> nullableUuidMap;

  @override
  final Map<int, int> intIntMap;

  @override
  Map<String, dynamic> toJson() {
    return {
      'dataMap': dataMap,
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap,
      'byteDataMap': byteDataMap,
      'durationMap': durationMap,
      'uuidMap': uuidMap,
      'nullableDataMap': nullableDataMap,
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap,
      'nullableByteDataMap': nullableByteDataMap,
      'nullableDurationMap': nullableDurationMap,
      'nullableUuidMap': nullableUuidMap,
      'intIntMap': intIntMap,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithMaps &&
            const _i4.DeepCollectionEquality().equals(
              dataMap,
              other.dataMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              intMap,
              other.intMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              stringMap,
              other.stringMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              dateTimeMap,
              other.dateTimeMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              byteDataMap,
              other.byteDataMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              durationMap,
              other.durationMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              uuidMap,
              other.uuidMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableDataMap,
              other.nullableDataMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableIntMap,
              other.nullableIntMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableStringMap,
              other.nullableStringMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableDateTimeMap,
              other.nullableDateTimeMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableByteDataMap,
              other.nullableByteDataMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableDurationMap,
              other.nullableDurationMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableUuidMap,
              other.nullableUuidMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              intIntMap,
              other.intIntMap,
            ));
  }

  @override
  int get hashCode => Object.hash(
        const _i4.DeepCollectionEquality().hash(dataMap),
        const _i4.DeepCollectionEquality().hash(intMap),
        const _i4.DeepCollectionEquality().hash(stringMap),
        const _i4.DeepCollectionEquality().hash(dateTimeMap),
        const _i4.DeepCollectionEquality().hash(byteDataMap),
        const _i4.DeepCollectionEquality().hash(durationMap),
        const _i4.DeepCollectionEquality().hash(uuidMap),
        const _i4.DeepCollectionEquality().hash(nullableDataMap),
        const _i4.DeepCollectionEquality().hash(nullableIntMap),
        const _i4.DeepCollectionEquality().hash(nullableStringMap),
        const _i4.DeepCollectionEquality().hash(nullableDateTimeMap),
        const _i4.DeepCollectionEquality().hash(nullableByteDataMap),
        const _i4.DeepCollectionEquality().hash(nullableDurationMap),
        const _i4.DeepCollectionEquality().hash(nullableUuidMap),
        const _i4.DeepCollectionEquality().hash(intIntMap),
      );

  @override
  ObjectWithMaps copyWith({
    Map<String, _i2.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  }) {
    return ObjectWithMaps(
      dataMap: dataMap ?? this.dataMap,
      intMap: intMap ?? this.intMap,
      stringMap: stringMap ?? this.stringMap,
      dateTimeMap: dateTimeMap ?? this.dateTimeMap,
      byteDataMap: byteDataMap ?? this.byteDataMap,
      durationMap: durationMap ?? this.durationMap,
      uuidMap: uuidMap ?? this.uuidMap,
      nullableDataMap: nullableDataMap ?? this.nullableDataMap,
      nullableIntMap: nullableIntMap ?? this.nullableIntMap,
      nullableStringMap: nullableStringMap ?? this.nullableStringMap,
      nullableDateTimeMap: nullableDateTimeMap ?? this.nullableDateTimeMap,
      nullableByteDataMap: nullableByteDataMap ?? this.nullableByteDataMap,
      nullableDurationMap: nullableDurationMap ?? this.nullableDurationMap,
      nullableUuidMap: nullableUuidMap ?? this.nullableUuidMap,
      intIntMap: intIntMap ?? this.intIntMap,
    );
  }
}
