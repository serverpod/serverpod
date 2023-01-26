/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
class DataWithUniqueFields extends _i1.TableRow {
  DataWithUniqueFields({
    int? id,
    required this.num,
    required this.uniqueField,
  }) : super(id);

  factory DataWithUniqueFields.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DataWithUniqueFields(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      num: serializationManager.deserialize<int>(jsonSerialization['num']),
      uniqueField: serializationManager
          .deserialize<int>(jsonSerialization['uniqueField']),
    );
  }

  static final t = DataWithUniqueFieldsTable();

  int num;

  int uniqueField;

  @override
  String get tableName => 'data_with_unique_fields';
  @override
  List<String> get uniqueColumns => ['uniqueField'];
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
      'uniqueField': uniqueField,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'num': num,
      'uniqueField': uniqueField,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'num': num,
      'uniqueField': uniqueField,
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
      case 'uniqueField':
        uniqueField = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<DataWithUniqueFields>> find(
    _i1.Session session, {
    DataWithUniqueFieldsExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DataWithUniqueFields>(
      where: where != null ? where(DataWithUniqueFields.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<DataWithUniqueFields?> findSingleRow(
    _i1.Session session, {
    DataWithUniqueFieldsExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<DataWithUniqueFields>(
      where: where != null ? where(DataWithUniqueFields.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<DataWithUniqueFields?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<DataWithUniqueFields>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required DataWithUniqueFieldsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DataWithUniqueFields>(
      where: where(DataWithUniqueFields.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    DataWithUniqueFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    DataWithUniqueFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    DataWithUniqueFields row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<void> upsert(
    _i1.Session session,
    DataWithUniqueFields row,
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
    DataWithUniqueFieldsExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DataWithUniqueFields>(
      where: where != null ? where(DataWithUniqueFields.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef DataWithUniqueFieldsExpressionBuilder = _i1.Expression Function(
    DataWithUniqueFieldsTable);

class DataWithUniqueFieldsTable extends _i1.Table {
  DataWithUniqueFieldsTable() : super(tableName: 'data_with_unique_fields');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final num = _i1.ColumnInt('num');

  final uniqueField = _i1.ColumnInt('uniqueField');

  @override
  List<_i1.Column> get columns => [
        id,
        num,
        uniqueField,
      ];
}

@Deprecated('Use DataWithUniqueFieldsTable.t instead.')
DataWithUniqueFieldsTable tDataWithUniqueFields = DataWithUniqueFieldsTable();
