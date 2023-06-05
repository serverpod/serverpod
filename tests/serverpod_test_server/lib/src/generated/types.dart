/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

typedef TypesExpressionBuilder = _i1.Expression Function(TypesTable);

abstract class Types extends _i1.TableRow {
  const Types._();

  const factory Types({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
  }) = _Types;

  factory Types.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Types(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      anInt: serializationManager.deserialize<int?>(jsonSerialization['anInt']),
      aBool:
          serializationManager.deserialize<bool?>(jsonSerialization['aBool']),
      aDouble: serializationManager
          .deserialize<double?>(jsonSerialization['aDouble']),
      aDateTime: serializationManager
          .deserialize<DateTime?>(jsonSerialization['aDateTime']),
      aString: serializationManager
          .deserialize<String?>(jsonSerialization['aString']),
      aByteData: serializationManager
          .deserialize<_i2.ByteData?>(jsonSerialization['aByteData']),
      aDuration: serializationManager
          .deserialize<Duration?>(jsonSerialization['aDuration']),
      aUuid: serializationManager
          .deserialize<_i1.UuidValue?>(jsonSerialization['aUuid']),
    );
  }

  static const t = TypesTable();

  Types copyWith({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
  });
  @override
  String get tableName => 'types';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime,
      'aString': aString,
      'aByteData': aByteData,
      'aDuration': aDuration,
      'aUuid': aUuid,
    };
  }

  static Future<List<Types>> find(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Types>(
      where: where != null ? where(Types.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Types?> findSingleRow(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Types>(
      where: where != null ? where(Types.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Types?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Types>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required TypesExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where != null ? where(Types.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  int? get anInt;
  bool? get aBool;
  double? get aDouble;
  DateTime? get aDateTime;
  String? get aString;
  _i2.ByteData? get aByteData;
  Duration? get aDuration;
  _i1.UuidValue? get aUuid;
}

class _Undefined {}

class _Types extends Types {
  const _Types({
    int? id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
  }) : super._();

  @override
  final int? anInt;

  @override
  final bool? aBool;

  @override
  final double? aDouble;

  @override
  final DateTime? aDateTime;

  @override
  final String? aString;

  @override
  final _i2.ByteData? aByteData;

  @override
  final Duration? aDuration;

  @override
  final _i1.UuidValue? aUuid;

  @override
  String get tableName => 'types';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime,
      'aString': aString,
      'aByteData': aByteData,
      'aDuration': aDuration,
      'aUuid': aUuid,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is Types &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.anInt,
                  anInt,
                ) ||
                other.anInt == anInt) &&
            (identical(
                  other.aBool,
                  aBool,
                ) ||
                other.aBool == aBool) &&
            (identical(
                  other.aDouble,
                  aDouble,
                ) ||
                other.aDouble == aDouble) &&
            (identical(
                  other.aDateTime,
                  aDateTime,
                ) ||
                other.aDateTime == aDateTime) &&
            (identical(
                  other.aString,
                  aString,
                ) ||
                other.aString == aString) &&
            (identical(
                  other.aByteData,
                  aByteData,
                ) ||
                other.aByteData == aByteData) &&
            (identical(
                  other.aDuration,
                  aDuration,
                ) ||
                other.aDuration == aDuration) &&
            (identical(
                  other.aUuid,
                  aUuid,
                ) ||
                other.aUuid == aUuid));
  }

  @override
  int get hashCode => Object.hash(
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
        aDuration,
        aUuid,
      );

  @override
  Types copyWith({
    Object? id = _Undefined,
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
  }) {
    return Types(
      id: id == _Undefined ? this.id : (id as int?),
      anInt: anInt == _Undefined ? this.anInt : (anInt as int?),
      aBool: aBool == _Undefined ? this.aBool : (aBool as bool?),
      aDouble: aDouble == _Undefined ? this.aDouble : (aDouble as double?),
      aDateTime:
          aDateTime == _Undefined ? this.aDateTime : (aDateTime as DateTime?),
      aString: aString == _Undefined ? this.aString : (aString as String?),
      aByteData: aByteData == _Undefined
          ? this.aByteData
          : (aByteData as _i2.ByteData?),
      aDuration:
          aDuration == _Undefined ? this.aDuration : (aDuration as Duration?),
      aUuid: aUuid == _Undefined ? this.aUuid : (aUuid as _i1.UuidValue?),
    );
  }
}

class TypesTable extends _i1.Table {
  const TypesTable() : super(tableName: 'types');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  final anInt = const _i1.ColumnInt('anInt');

  final aBool = const _i1.ColumnBool('aBool');

  final aDouble = const _i1.ColumnDouble('aDouble');

  final aDateTime = const _i1.ColumnDateTime('aDateTime');

  final aString = const _i1.ColumnString('aString');

  final aByteData = const _i1.ColumnByteData('aByteData');

  final aDuration = const _i1.ColumnDuration('aDuration');

  final aUuid = const _i1.ColumnUuid('aUuid');

  @override
  List<_i1.Column> get columns => [
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
        aDuration,
        aUuid,
      ];
}

@Deprecated('Use TypesTable.t instead.')
TypesTable tTypes = const TypesTable();
