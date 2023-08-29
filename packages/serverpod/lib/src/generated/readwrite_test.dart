/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database mapping for a read/write test that is performed by the default
/// health checks.
class ReadWriteTestEntry extends _i1.TableRow {
  ReadWriteTestEntry({
    int? id,
    required this.number,
  }) : super(id);

  factory ReadWriteTestEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ReadWriteTestEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      number:
          serializationManager.deserialize<int>(jsonSerialization['number']),
    );
  }

  static final t = ReadWriteTestEntryTable();

  /// A random number, to verify that the write/read was performed correctly.
  int number;

  @override
  String get tableName => 'serverpod_readwrite_test';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'number': number,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'number': number,
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
      case 'number':
        number = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ReadWriteTestEntry>> find(
    _i1.Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ReadWriteTestEntry?> findSingleRow(
    _i1.Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ReadWriteTestEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ReadWriteTestEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ReadWriteTestEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ReadWriteTestEntryExpressionBuilder = _i1.Expression Function(
    ReadWriteTestEntryTable);

class ReadWriteTestEntryTable extends _i1.Table {
  ReadWriteTestEntryTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_readwrite_test') {
    id = _i1.ColumnInt(
      'id',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    number = _i1.ColumnInt(
      'number',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  late final _i1.ColumnInt id;

  /// A random number, to verify that the write/read was performed correctly.
  late final _i1.ColumnInt number;

  @override
  List<_i1.Column> get columns => [
        id,
        number,
      ];
}

@Deprecated('Use ReadWriteTestEntryTable.t instead.')
ReadWriteTestEntryTable tReadWriteTestEntry = ReadWriteTestEntryTable();

class ReadWriteTestEntryInclude extends _i1.Include {
  ReadWriteTestEntryInclude();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ReadWriteTestEntry.t;
}
