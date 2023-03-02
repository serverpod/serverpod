/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

class Types extends _i1.TableRow {
  Types({
    int? id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
  }) : super(id);

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

  static final t = TypesTable();

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  Duration? aDuration;

  _i1.UuidValue? aUuid;

  @override
  String get tableName => 'types';
  @override
  List<String> get uniqueColumns => [];
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

  @override
  Map<String, dynamic> allToJson() {
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
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'anInt':
        anInt = value;
        return;
      case 'aBool':
        aBool = value;
        return;
      case 'aDouble':
        aDouble = value;
        return;
      case 'aDateTime':
        aDateTime = value;
        return;
      case 'aString':
        aString = value;
        return;
      case 'aByteData':
        aByteData = value;
        return;
      case 'aDuration':
        aDuration = value;
        return;
      case 'aUuid':
        aUuid = value;
        return;
      default:
        throw UnimplementedError();
    }
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

  static Future<void> upsert(
    _i1.Session session,
    Types row,
    List<String> uniqueColumns, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert(
      row,
      uniqueColumns,
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
}

typedef TypesExpressionBuilder = _i1.Expression Function(TypesTable);

class TypesTable extends _i1.Table {
  TypesTable() : super(tableName: 'types');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final anInt = _i1.ColumnInt('anInt');

  final aBool = _i1.ColumnBool('aBool');

  final aDouble = _i1.ColumnDouble('aDouble');

  final aDateTime = _i1.ColumnDateTime('aDateTime');

  final aString = _i1.ColumnString('aString');

  final aByteData = _i1.ColumnByteData('aByteData');

  final aDuration = _i1.ColumnDuration('aDuration');

  final aUuid = _i1.ColumnUuid('aUuid');

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
TypesTable tTypes = TypesTable();
