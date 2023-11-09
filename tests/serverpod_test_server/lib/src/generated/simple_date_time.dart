/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
abstract class SimpleDateTime extends _i1.TableRow {
  SimpleDateTime._({
    int? id,
    required this.dateTime,
  }) : super(id);

  factory SimpleDateTime({
    int? id,
    required DateTime dateTime,
  }) = _SimpleDateTimeImpl;

  factory SimpleDateTime.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleDateTime(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      dateTime: serializationManager
          .deserialize<DateTime>(jsonSerialization['dateTime']),
    );
  }

  static final t = SimpleDateTimeTable();

  static const db = SimpleDateTimeRepository._();

  /// The only field of [SimpleDateTime]
  DateTime dateTime;

  @override
  _i1.Table get table => t;

  SimpleDateTime copyWith({
    int? id,
    DateTime? dateTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'dateTime': dateTime,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'dateTime': dateTime,
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
      case 'dateTime':
        dateTime = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<SimpleDateTime>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleDateTime>(
      where: where != null ? where(SimpleDateTime.t) : null,
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
  static Future<SimpleDateTime?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SimpleDateTime>(
      where: where != null ? where(SimpleDateTime.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<SimpleDateTime?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SimpleDateTime>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDateTimeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    SimpleDateTime row, {
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
    SimpleDateTime row, {
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
    SimpleDateTime row, {
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
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleDateTime>(
      where: where != null ? where(SimpleDateTime.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static SimpleDateTimeInclude include() {
    return SimpleDateTimeInclude._();
  }

  static SimpleDateTimeIncludeList includeList({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    SimpleDateTimeInclude? include,
  }) {
    return SimpleDateTimeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _SimpleDateTimeImpl extends SimpleDateTime {
  _SimpleDateTimeImpl({
    int? id,
    required DateTime dateTime,
  }) : super._(
          id: id,
          dateTime: dateTime,
        );

  @override
  SimpleDateTime copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
  }) {
    return SimpleDateTime(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class SimpleDateTimeTable extends _i1.Table {
  SimpleDateTimeTable({super.tableRelation})
      : super(tableName: 'simple_date_time') {
    dateTime = _i1.ColumnDateTime(
      'dateTime',
      this,
    );
  }

  /// The only field of [SimpleDateTime]
  late final _i1.ColumnDateTime dateTime;

  @override
  List<_i1.Column> get columns => [
        id,
        dateTime,
      ];
}

@Deprecated('Use SimpleDateTimeTable.t instead.')
SimpleDateTimeTable tSimpleDateTime = SimpleDateTimeTable();

class SimpleDateTimeInclude extends _i1.IncludeObject {
  SimpleDateTimeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeIncludeList extends _i1.IncludeList {
  SimpleDateTimeIncludeList._({
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SimpleDateTime.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => SimpleDateTime.t;
}

class SimpleDateTimeRepository {
  const SimpleDateTimeRepository._();

  Future<List<SimpleDateTime>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<SimpleDateTime?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<SimpleDateTime>(
      id,
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> insert(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  Future<SimpleDateTime> insertRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  Future<List<SimpleDateTime>> update(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<SimpleDateTime>(
      rows,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<SimpleDateTime> updateRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.ColumnSelections<SimpleDateTimeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<SimpleDateTime>(
      row,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<SimpleDateTime> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<SimpleDateTime>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    SimpleDateTime row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SimpleDateTimeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
