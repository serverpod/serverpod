/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'dart:typed_data' as _i3;
import 'package:collection/collection.dart' as _i4;

class _Undefined {}

/// Just some simple data.
class ExtraDataClass extends _i1.SerializableEntity {
  ExtraDataClass({
    this.id,
    required this.duration,
    required this.object,
    this.nullableObject,
    required this.list,
    this.nullableList,
    required this.optionalValueList,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
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
  });

  factory ExtraDataClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ExtraDataClass(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      duration: serializationManager
          .deserialize<Duration>(jsonSerialization['duration']),
      object: serializationManager
          .deserialize<_i2.ExtraDataSimple>(jsonSerialization['object']),
      nullableObject: serializationManager.deserialize<_i2.ExtraDataSimple?>(
          jsonSerialization['nullableObject']),
      list: serializationManager
          .deserialize<List<_i2.ExtraDataSimple>>(jsonSerialization['list']),
      nullableList:
          serializationManager.deserialize<List<_i2.ExtraDataSimple>?>(
              jsonSerialization['nullableList']),
      optionalValueList:
          serializationManager.deserialize<List<_i2.ExtraDataSimple?>>(
              jsonSerialization['optionalValueList']),
      testEnum: serializationManager
          .deserialize<_i2.TestEnum>(jsonSerialization['testEnum']),
      nullableEnum: serializationManager
          .deserialize<_i2.TestEnum?>(jsonSerialization['nullableEnum']),
      enumList: serializationManager
          .deserialize<List<_i2.TestEnum>>(jsonSerialization['enumList']),
      nullableEnumList: serializationManager.deserialize<List<_i2.TestEnum?>>(
          jsonSerialization['nullableEnumList']),
      enumListList: serializationManager.deserialize<List<List<_i2.TestEnum>>>(
          jsonSerialization['enumListList']),
      dataMap:
          serializationManager.deserialize<Map<String, _i2.ExtraDataSimple>>(
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
          serializationManager.deserialize<Map<String, _i2.ExtraDataSimple?>>(
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  final Duration duration;

  final _i2.ExtraDataSimple object;

  final _i2.ExtraDataSimple? nullableObject;

  final List<_i2.ExtraDataSimple> list;

  final List<_i2.ExtraDataSimple>? nullableList;

  final List<_i2.ExtraDataSimple?> optionalValueList;

  final _i2.TestEnum testEnum;

  final _i2.TestEnum? nullableEnum;

  final List<_i2.TestEnum> enumList;

  final List<_i2.TestEnum?> nullableEnumList;

  final List<List<_i2.TestEnum>> enumListList;

  final Map<String, _i2.ExtraDataSimple> dataMap;

  final Map<String, int> intMap;

  final Map<String, String> stringMap;

  final Map<String, DateTime> dateTimeMap;

  final Map<String, _i3.ByteData> byteDataMap;

  final Map<String, Duration> durationMap;

  final Map<String, _i1.UuidValue> uuidMap;

  final Map<String, _i2.ExtraDataSimple?> nullableDataMap;

  final Map<String, int?> nullableIntMap;

  final Map<String, String?> nullableStringMap;

  final Map<String, DateTime?> nullableDateTimeMap;

  final Map<String, _i3.ByteData?> nullableByteDataMap;

  final Map<String, Duration?> nullableDurationMap;

  final Map<String, _i1.UuidValue?> nullableUuidMap;

  final Map<int, int> intIntMap;

  late Function({
    int? id,
    Duration? duration,
    _i2.ExtraDataSimple? object,
    _i2.ExtraDataSimple? nullableObject,
    List<_i2.ExtraDataSimple>? list,
    List<_i2.ExtraDataSimple>? nullableList,
    List<_i2.ExtraDataSimple?>? optionalValueList,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
    Map<String, _i2.ExtraDataSimple>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.ExtraDataSimple?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'object': object,
      'nullableObject': nullableObject,
      'list': list,
      'nullableList': nullableList,
      'optionalValueList': optionalValueList,
      'testEnum': testEnum,
      'nullableEnum': nullableEnum,
      'enumList': enumList,
      'nullableEnumList': nullableEnumList,
      'enumListList': enumListList,
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
        (other is ExtraDataClass &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration) &&
            (identical(
                  other.object,
                  object,
                ) ||
                other.object == object) &&
            (identical(
                  other.nullableObject,
                  nullableObject,
                ) ||
                other.nullableObject == nullableObject) &&
            (identical(
                  other.testEnum,
                  testEnum,
                ) ||
                other.testEnum == testEnum) &&
            (identical(
                  other.nullableEnum,
                  nullableEnum,
                ) ||
                other.nullableEnum == nullableEnum) &&
            const _i4.DeepCollectionEquality().equals(
              list,
              other.list,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableList,
              other.nullableList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              optionalValueList,
              other.optionalValueList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              enumList,
              other.enumList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              nullableEnumList,
              other.nullableEnumList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              enumListList,
              other.enumListList,
            ) &&
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
  int get hashCode => Object.hashAll([
        id,
        duration,
        object,
        nullableObject,
        testEnum,
        nullableEnum,
        const _i4.DeepCollectionEquality().hash(list),
        const _i4.DeepCollectionEquality().hash(nullableList),
        const _i4.DeepCollectionEquality().hash(optionalValueList),
        const _i4.DeepCollectionEquality().hash(enumList),
        const _i4.DeepCollectionEquality().hash(nullableEnumList),
        const _i4.DeepCollectionEquality().hash(enumListList),
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
      ]);

  ExtraDataClass _copyWith({
    Object? id = _Undefined,
    Duration? duration,
    _i2.ExtraDataSimple? object,
    Object? nullableObject = _Undefined,
    List<_i2.ExtraDataSimple>? list,
    Object? nullableList = _Undefined,
    List<_i2.ExtraDataSimple?>? optionalValueList,
    _i2.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
    Map<String, _i2.ExtraDataSimple>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.ExtraDataSimple?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  }) {
    return ExtraDataClass(
      id: id == _Undefined ? this.id : (id as int?),
      duration: duration ?? this.duration,
      object: object ?? this.object,
      nullableObject: nullableObject == _Undefined
          ? this.nullableObject
          : (nullableObject as _i2.ExtraDataSimple?),
      list: list ?? this.list,
      nullableList: nullableList == _Undefined
          ? this.nullableList
          : (nullableList as List<_i2.ExtraDataSimple>?),
      optionalValueList: optionalValueList ?? this.optionalValueList,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum: nullableEnum == _Undefined
          ? this.nullableEnum
          : (nullableEnum as _i2.TestEnum?),
      enumList: enumList ?? this.enumList,
      nullableEnumList: nullableEnumList ?? this.nullableEnumList,
      enumListList: enumListList ?? this.enumListList,
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
