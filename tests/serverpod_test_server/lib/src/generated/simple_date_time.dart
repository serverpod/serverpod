/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

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

  static Future<List<SimpleDateTime>> find(
    _i1.Session session, {
    SimpleDateTimeExpressionBuilder? where,
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

  static Future<SimpleDateTime?> findSingleRow(
    _i1.Session session, {
    SimpleDateTimeExpressionBuilder? where,
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

  static Future<SimpleDateTime?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SimpleDateTime>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SimpleDateTimeExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      transaction: transaction,
    );
  }

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

  static Future<int> count(
    _i1.Session session, {
    SimpleDateTimeExpressionBuilder? where,
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

typedef SimpleDateTimeExpressionBuilder = _i1.Expression Function(
    SimpleDateTimeTable);
typedef SimpleDateTimeWithoutManyRelationsExpressionBuilder = _i1.Expression
    Function(SimpleDateTimeWithoutManyRelationsTable);

class SimpleDateTimeTable extends SimpleDateTimeWithoutManyRelationsTable {
  SimpleDateTimeTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class SimpleDateTimeWithoutManyRelationsTable extends _i1.Table {
  SimpleDateTimeWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'simple_date_time') {
    dateTime = _i1.ColumnDateTime(
      'dateTime',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
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

class SimpleDateTimeInclude extends _i1.Include {
  SimpleDateTimeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => SimpleDateTime.t;
}
