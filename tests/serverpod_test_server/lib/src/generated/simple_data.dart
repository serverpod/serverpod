/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
abstract class SimpleData extends _i1.TableRow {
  SimpleData._({
    int? id,
    required this.num,
  }) : super(id);

  factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleDataImpl;

  factory SimpleData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      num: serializationManager.deserialize<int>(jsonSerialization['num']),
    );
  }

  static final t = SimpleDataTable();

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int num;

  @override
  _i1.Table get table => t;
  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'num': num,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'num': num,
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
      case 'num':
        num = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<SimpleData>> find(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findSingleRow(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SimpleData>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SimpleDataExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleData>(
      where: where(SimpleData.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static SimpleDataInclude include() {
    return SimpleDataInclude._();
  }
}

class _Undefined {}

class _SimpleDataImpl extends SimpleData {
  _SimpleDataImpl({
    int? id,
    required int num,
  }) : super._(
          id: id,
          num: num,
        );

  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id is int? ? id : this.id,
      num: num ?? this.num,
    );
  }
}

typedef SimpleDataExpressionBuilder = _i1.Expression Function(SimpleDataTable);
typedef SimpleDataWithoutManyRelationsExpressionBuilder = _i1.Expression
    Function(SimpleDataWithoutManyRelationsTable);

class SimpleDataTable extends SimpleDataWithoutManyRelationsTable {
  SimpleDataTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class SimpleDataWithoutManyRelationsTable extends _i1.Table {
  SimpleDataWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'simple_data') {
    num = _i1.ColumnInt(
      'num',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  late final _i1.ColumnInt num;

  @override
  List<_i1.Column> get columns => [
        id,
        num,
      ];
}

@Deprecated('Use SimpleDataTable.t instead.')
SimpleDataTable tSimpleData = SimpleDataTable();

class SimpleDataInclude extends _i1.Include {
  SimpleDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => SimpleData.t;
}
