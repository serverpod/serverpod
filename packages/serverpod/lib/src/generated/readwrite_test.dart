/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database mapping for a read/write test that is performed by the default
/// health checks.
abstract class ReadWriteTestEntry extends _i1.TableRow {
  ReadWriteTestEntry._({
    int? id,
    required this.number,
  }) : super(id);

  factory ReadWriteTestEntry({
    int? id,
    required int number,
  }) = _ReadWriteTestEntryImpl;

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

  static const db = ReadWriteTestEntryRepository._();

  /// A random number, to verify that the write/read was performed correctly.
  int number;

  @override
  _i1.Table get table => t;

  ReadWriteTestEntry copyWith({
    int? id,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ReadWriteTestEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<ReadWriteTestEntry?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ReadWriteTestEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ReadWriteTestEntry>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReadWriteTestEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
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

  static ReadWriteTestEntryInclude include() {
    return ReadWriteTestEntryInclude._();
  }

  static ReadWriteTestEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    ReadWriteTestEntryInclude? include,
  }) {
    return ReadWriteTestEntryIncludeList._(
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

class _ReadWriteTestEntryImpl extends ReadWriteTestEntry {
  _ReadWriteTestEntryImpl({
    int? id,
    required int number,
  }) : super._(
          id: id,
          number: number,
        );

  @override
  ReadWriteTestEntry copyWith({
    Object? id = _Undefined,
    int? number,
  }) {
    return ReadWriteTestEntry(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
    );
  }
}

class ReadWriteTestEntryTable extends _i1.Table {
  ReadWriteTestEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_readwrite_test') {
    number = _i1.ColumnInt(
      'number',
      this,
    );
  }

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

class ReadWriteTestEntryInclude extends _i1.IncludeObject {
  ReadWriteTestEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ReadWriteTestEntry.t;
}

class ReadWriteTestEntryIncludeList extends _i1.IncludeList {
  ReadWriteTestEntryIncludeList._({
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReadWriteTestEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ReadWriteTestEntry.t;
}

class ReadWriteTestEntryRepository {
  const ReadWriteTestEntryRepository._();

  Future<List<ReadWriteTestEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ReadWriteTestEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ReadWriteTestEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ReadWriteTestEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ReadWriteTestEntry>> insert(
    _i1.Session session,
    List<ReadWriteTestEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ReadWriteTestEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<ReadWriteTestEntry> insertRow(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ReadWriteTestEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ReadWriteTestEntry>> update(
    _i1.Session session,
    List<ReadWriteTestEntry> rows, {
    _i1.ColumnSelections<ReadWriteTestEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ReadWriteTestEntry>(
      rows,
      columns: columns?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  Future<ReadWriteTestEntry> updateRow(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.ColumnSelections<ReadWriteTestEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ReadWriteTestEntry>(
      row,
      columns: columns?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ReadWriteTestEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ReadWriteTestEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ReadWriteTestEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReadWriteTestEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
