/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;

abstract class Types extends _i1.TableRow {
  Types._({
    int? id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.anEnum,
  }) : super(id);

  factory Types({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
  }) = _TypesImpl;

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
      anEnum: serializationManager
          .deserialize<_i3.TestEnum?>(jsonSerialization['anEnum']),
    );
  }

  static final t = TypesTable();

  static final db = TypesRepository._();

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  Duration? aDuration;

  _i1.UuidValue? aUuid;

  _i3.TestEnum? anEnum;

  @override
  _i1.Table get table => t;
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
    _i3.TestEnum? anEnum,
  });
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
      'anEnum': anEnum,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
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
      'anEnum': anEnum,
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
      'anEnum': anEnum,
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
      case 'anEnum':
        anEnum = value;
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

  static TypesInclude include() {
    return TypesInclude._();
  }
}

class _Undefined {}

class _TypesImpl extends Types {
  _TypesImpl({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
  }) : super._(
          id: id,
          anInt: anInt,
          aBool: aBool,
          aDouble: aDouble,
          aDateTime: aDateTime,
          aString: aString,
          aByteData: aByteData,
          aDuration: aDuration,
          aUuid: aUuid,
          anEnum: anEnum,
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
    Object? anEnum = _Undefined,
  }) {
    return Types(
      id: id is int? ? id : this.id,
      anInt: anInt is int? ? anInt : this.anInt,
      aBool: aBool is bool? ? aBool : this.aBool,
      aDouble: aDouble is double? ? aDouble : this.aDouble,
      aDateTime: aDateTime is DateTime? ? aDateTime : this.aDateTime,
      aString: aString is String? ? aString : this.aString,
      aByteData:
          aByteData is _i2.ByteData? ? aByteData : this.aByteData?.clone(),
      aDuration: aDuration is Duration? ? aDuration : this.aDuration,
      aUuid: aUuid is _i1.UuidValue? ? aUuid : this.aUuid,
      anEnum: anEnum is _i3.TestEnum? ? anEnum : this.anEnum,
    );
  }
}

typedef TypesExpressionBuilder = _i1.Expression Function(TypesTable);

class TypesTable extends _i1.Table {
  TypesTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'types') {
    anInt = _i1.ColumnInt(
      'anInt',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aBool = _i1.ColumnBool(
      'aBool',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aDouble = _i1.ColumnDouble(
      'aDouble',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aDateTime = _i1.ColumnDateTime(
      'aDateTime',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aString = _i1.ColumnString(
      'aString',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aByteData = _i1.ColumnByteData(
      'aByteData',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aDuration = _i1.ColumnDuration(
      'aDuration',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    aUuid = _i1.ColumnUuid(
      'aUuid',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    anEnum = _i1.ColumnEnum<_i3.TestEnum>(
      'anEnum',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnInt anInt;

  late final _i1.ColumnBool aBool;

  late final _i1.ColumnDouble aDouble;

  late final _i1.ColumnDateTime aDateTime;

  late final _i1.ColumnString aString;

  late final _i1.ColumnByteData aByteData;

  late final _i1.ColumnDuration aDuration;

  late final _i1.ColumnUuid aUuid;

  late final _i1.ColumnEnum<_i3.TestEnum> anEnum;

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
        anEnum,
      ];
}

@Deprecated('Use TypesTable.t instead.')
TypesTable tTypes = TypesTable();

class TypesInclude extends _i1.Include {
  TypesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => Types.t;
}

class TypesRepository {
  const TypesRepository._();

  Future<List<Types>> find(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<Types>(
      where: where?.call(Types.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<Types?> findRow(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<Types>(
      where: where?.call(Types.t),
      transaction: transaction,
    );
  }

  Future<Types?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<Types>(
      id,
      transaction: transaction,
    );
  }

  Future<Types> insertRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Types>(
      row,
      transaction: transaction,
    );
  }

  Future<Types> updateRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Types>(
      row,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Types>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required TypesExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Types>(
      where: where?.call(Types.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
