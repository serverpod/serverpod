/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
class SimpleData extends _i1.TableRow {
  SimpleData({
    int? id,
    required this.num,
  }) : super(id);

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
  String get tableName => 'simple_data';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }

  @override
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
}

typedef SimpleDataExpressionBuilder = _i1.Expression Function(SimpleDataTable);

class SimpleDataTable extends _i1.Table {
  SimpleDataTable() : super(tableName: 'simple_data');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  final num = _i1.ColumnInt('num');

  @override
  List<_i1.Column> get columns => [
        id,
        num,
      ];
}

@Deprecated('Use SimpleDataTable.t instead.')
SimpleDataTable tSimpleData = SimpleDataTable();
