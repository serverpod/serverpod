/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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
    this.aStringifiedEnum,
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
    _i3.TestEnumStringified? aStringifiedEnum,
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
      aStringifiedEnum:
          serializationManager.deserialize<_i3.TestEnumStringified?>(
              jsonSerialization['aStringifiedEnum']),
    );
  }

  static final t = TypesTable();

  static const db = TypesRepository._();

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  Duration? aDuration;

  _i1.UuidValue? aUuid;

  _i3.TestEnum? anEnum;

  _i3.TestEnumStringified? aStringifiedEnum;

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
    _i3.TestEnumStringified? aStringifiedEnum,
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
      'aStringifiedEnum': aStringifiedEnum,
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
      'aStringifiedEnum': aStringifiedEnum,
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
      'aStringifiedEnum': aStringifiedEnum,
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
      case 'aStringifiedEnum':
        aStringifiedEnum = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Types>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Types?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Types?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Types>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TypesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
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

  static TypesIncludeList includeList({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    TypesInclude? include,
  }) {
    return TypesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Types.t),
      include: include,
    );
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
    _i3.TestEnumStringified? aStringifiedEnum,
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
          aStringifiedEnum: aStringifiedEnum,
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
    Object? aStringifiedEnum = _Undefined,
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
      aStringifiedEnum: aStringifiedEnum is _i3.TestEnumStringified?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
    );
  }
}

class TypesTable extends _i1.Table {
  TypesTable({super.tableRelation}) : super(tableName: 'types') {
    anInt = _i1.ColumnInt(
      'anInt',
      this,
    );
    aBool = _i1.ColumnBool(
      'aBool',
      this,
    );
    aDouble = _i1.ColumnDouble(
      'aDouble',
      this,
    );
    aDateTime = _i1.ColumnDateTime(
      'aDateTime',
      this,
    );
    aString = _i1.ColumnString(
      'aString',
      this,
    );
    aByteData = _i1.ColumnByteData(
      'aByteData',
      this,
    );
    aDuration = _i1.ColumnDuration(
      'aDuration',
      this,
    );
    aUuid = _i1.ColumnUuid(
      'aUuid',
      this,
    );
    anEnum = _i1.ColumnEnum(
      'anEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    aStringifiedEnum = _i1.ColumnEnum(
      'aStringifiedEnum',
      this,
      _i1.EnumSerialization.byName,
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

  late final _i1.ColumnEnum<_i3.TestEnumStringified> aStringifiedEnum;

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
        aStringifiedEnum,
      ];
}

@Deprecated('Use TypesTable.t instead.')
TypesTable tTypes = TypesTable();

class TypesInclude extends _i1.IncludeObject {
  TypesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Types.t;
}

class TypesIncludeList extends _i1.IncludeList {
  TypesIncludeList._({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Types.t;
}

class TypesRepository {
  const TypesRepository._();

  Future<List<Types>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<Types?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      offset: offset,
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

  Future<List<Types>> insert(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Types>(
      rows,
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

  Future<List<Types>> update(
    _i1.Session session,
    List<Types> rows, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Types>(
      rows,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  Future<Types> updateRow(
    _i1.Session session,
    Types row, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Types>(
      row,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Types>(
      rows,
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
    required _i1.WhereExpressionBuilder<TypesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
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
