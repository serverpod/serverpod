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

class _Undefined {}

/// Just some simple data.
class ExtraDataClass extends _i1.TableRow {
  ExtraDataClass({
    int? id,
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
  }) : super(id);

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

  static var t = ExtraDataClassTable();

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
  String get tableName => 'extra_data_class';
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

  @override
  Map<String, dynamic> toJsonForDatabase() {
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

  static Future<List<ExtraDataClass>> find(
    _i1.Session session, {
    ExtraDataClassExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ExtraDataClass>(
      where: where != null ? where(ExtraDataClass.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ExtraDataClass?> findSingleRow(
    _i1.Session session, {
    ExtraDataClassExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ExtraDataClass>(
      where: where != null ? where(ExtraDataClass.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ExtraDataClass?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ExtraDataClass>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ExtraDataClassExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ExtraDataClass>(
      where: where(ExtraDataClass.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ExtraDataClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ExtraDataClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ExtraDataClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ExtraDataClassExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ExtraDataClass>(
      where: where != null ? where(ExtraDataClass.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ExtraDataClassExpressionBuilder = _i1.Expression Function(
    ExtraDataClassTable);

class ExtraDataClassTable extends _i1.Table {
  ExtraDataClassTable() : super(tableName: 'extra_data_class');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final duration = _i1.ColumnDuration('duration');

  final object = _i1.ColumnSerializable('object');

  final nullableObject = _i1.ColumnSerializable('nullableObject');

  final list = _i1.ColumnSerializable('list');

  final nullableList = _i1.ColumnSerializable('nullableList');

  final optionalValueList = _i1.ColumnSerializable('optionalValueList');

  final testEnum = _i1.ColumnEnum('testEnum');

  final nullableEnum = _i1.ColumnEnum('nullableEnum');

  final enumList = _i1.ColumnSerializable('enumList');

  final nullableEnumList = _i1.ColumnSerializable('nullableEnumList');

  final enumListList = _i1.ColumnSerializable('enumListList');

  final dataMap = _i1.ColumnSerializable('dataMap');

  final intMap = _i1.ColumnSerializable('intMap');

  final stringMap = _i1.ColumnSerializable('stringMap');

  final dateTimeMap = _i1.ColumnSerializable('dateTimeMap');

  final byteDataMap = _i1.ColumnSerializable('byteDataMap');

  final durationMap = _i1.ColumnSerializable('durationMap');

  final uuidMap = _i1.ColumnSerializable('uuidMap');

  final nullableDataMap = _i1.ColumnSerializable('nullableDataMap');

  final nullableIntMap = _i1.ColumnSerializable('nullableIntMap');

  final nullableStringMap = _i1.ColumnSerializable('nullableStringMap');

  final nullableDateTimeMap = _i1.ColumnSerializable('nullableDateTimeMap');

  final nullableByteDataMap = _i1.ColumnSerializable('nullableByteDataMap');

  final nullableDurationMap = _i1.ColumnSerializable('nullableDurationMap');

  final nullableUuidMap = _i1.ColumnSerializable('nullableUuidMap');

  final intIntMap = _i1.ColumnSerializable('intIntMap');

  @override
  List<_i1.Column> get columns => [
        id,
        duration,
        object,
        nullableObject,
        list,
        nullableList,
        optionalValueList,
        testEnum,
        nullableEnum,
        enumList,
        nullableEnumList,
        enumListList,
        dataMap,
        intMap,
        stringMap,
        dateTimeMap,
        byteDataMap,
        durationMap,
        uuidMap,
        nullableDataMap,
        nullableIntMap,
        nullableStringMap,
        nullableDateTimeMap,
        nullableByteDataMap,
        nullableDurationMap,
        nullableUuidMap,
        intIntMap,
      ];
}

@Deprecated('Use ExtraDataClassTable.t instead.')
ExtraDataClassTable tExtraDataClass = ExtraDataClassTable();
