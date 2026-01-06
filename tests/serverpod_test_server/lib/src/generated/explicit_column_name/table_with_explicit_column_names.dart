/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class TableWithExplicitColumnName
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TableWithExplicitColumnName._({
    this.id,
    required this.userName,
    String? description,
  }) : description = description ?? 'Just some information';

  factory TableWithExplicitColumnName({
    int? id,
    required String userName,
    String? description,
  }) = _TableWithExplicitColumnNameImpl;

  factory TableWithExplicitColumnName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TableWithExplicitColumnName(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  static final t = TableWithExplicitColumnNameTable();

  static const db = TableWithExplicitColumnNameRepository._();

  @override
  int? id;

  String userName;

  String? description;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TableWithExplicitColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TableWithExplicitColumnName copyWith({
    int? id,
    String? userName,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TableWithExplicitColumnName',
      if (id != null) 'id': id,
      'userName': userName,
      if (description != null) 'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TableWithExplicitColumnName',
      if (id != null) 'id': id,
      'userName': userName,
      if (description != null) 'description': description,
    };
  }

  static TableWithExplicitColumnNameInclude include() {
    return TableWithExplicitColumnNameInclude._();
  }

  static TableWithExplicitColumnNameIncludeList includeList({
    _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TableWithExplicitColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TableWithExplicitColumnNameTable>? orderByList,
    TableWithExplicitColumnNameInclude? include,
  }) {
    return TableWithExplicitColumnNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TableWithExplicitColumnName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TableWithExplicitColumnName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TableWithExplicitColumnNameImpl extends TableWithExplicitColumnName {
  _TableWithExplicitColumnNameImpl({
    int? id,
    required String userName,
    String? description,
  }) : super._(
         id: id,
         userName: userName,
         description: description,
       );

  /// Returns a shallow copy of this [TableWithExplicitColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TableWithExplicitColumnName copyWith({
    Object? id = _Undefined,
    String? userName,
    Object? description = _Undefined,
  }) {
    return TableWithExplicitColumnName(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      description: description is String? ? description : this.description,
    );
  }
}

class TableWithExplicitColumnNameUpdateTable
    extends _i1.UpdateTable<TableWithExplicitColumnNameTable> {
  TableWithExplicitColumnNameUpdateTable(super.table);

  _i1.ColumnValue<String, String> userName(String value) => _i1.ColumnValue(
    table.userName,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );
}

class TableWithExplicitColumnNameTable extends _i1.Table<int?> {
  TableWithExplicitColumnNameTable({super.tableRelation})
    : super(tableName: 'table_with_explicit_column_names') {
    updateTable = TableWithExplicitColumnNameUpdateTable(this);
    userName = _i1.ColumnString(
      'user_name',
      this,
      fieldName: 'userName',
    );
    description = _i1.ColumnString(
      'user_description',
      this,
      hasDefault: true,
      fieldName: 'description',
    );
  }

  late final TableWithExplicitColumnNameUpdateTable updateTable;

  late final _i1.ColumnString userName;

  late final _i1.ColumnString description;

  @override
  List<_i1.Column> get columns => [
    id,
    userName,
    description,
  ];
}

class TableWithExplicitColumnNameInclude extends _i1.IncludeObject {
  TableWithExplicitColumnNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TableWithExplicitColumnName.t;
}

class TableWithExplicitColumnNameIncludeList extends _i1.IncludeList {
  TableWithExplicitColumnNameIncludeList._({
    _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TableWithExplicitColumnName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TableWithExplicitColumnName.t;
}

class TableWithExplicitColumnNameRepository {
  const TableWithExplicitColumnNameRepository._();

  /// Returns a list of [TableWithExplicitColumnName]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TableWithExplicitColumnName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TableWithExplicitColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TableWithExplicitColumnNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TableWithExplicitColumnName>(
      where: where?.call(TableWithExplicitColumnName.t),
      orderBy: orderBy?.call(TableWithExplicitColumnName.t),
      orderByList: orderByList?.call(TableWithExplicitColumnName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TableWithExplicitColumnName] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TableWithExplicitColumnName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<TableWithExplicitColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TableWithExplicitColumnNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TableWithExplicitColumnName>(
      where: where?.call(TableWithExplicitColumnName.t),
      orderBy: orderBy?.call(TableWithExplicitColumnName.t),
      orderByList: orderByList?.call(TableWithExplicitColumnName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TableWithExplicitColumnName] by its [id] or null if no such row exists.
  Future<TableWithExplicitColumnName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TableWithExplicitColumnName>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TableWithExplicitColumnName]s in the list and returns the inserted rows.
  ///
  /// The returned [TableWithExplicitColumnName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TableWithExplicitColumnName>> insert(
    _i1.Session session,
    List<TableWithExplicitColumnName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TableWithExplicitColumnName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TableWithExplicitColumnName] and returns the inserted row.
  ///
  /// The returned [TableWithExplicitColumnName] will have its `id` field set.
  Future<TableWithExplicitColumnName> insertRow(
    _i1.Session session,
    TableWithExplicitColumnName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TableWithExplicitColumnName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TableWithExplicitColumnName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TableWithExplicitColumnName>> update(
    _i1.Session session,
    List<TableWithExplicitColumnName> rows, {
    _i1.ColumnSelections<TableWithExplicitColumnNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TableWithExplicitColumnName>(
      rows,
      columns: columns?.call(TableWithExplicitColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TableWithExplicitColumnName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TableWithExplicitColumnName> updateRow(
    _i1.Session session,
    TableWithExplicitColumnName row, {
    _i1.ColumnSelections<TableWithExplicitColumnNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TableWithExplicitColumnName>(
      row,
      columns: columns?.call(TableWithExplicitColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TableWithExplicitColumnName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TableWithExplicitColumnName?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TableWithExplicitColumnNameUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TableWithExplicitColumnName>(
      id,
      columnValues: columnValues(TableWithExplicitColumnName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TableWithExplicitColumnName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TableWithExplicitColumnName>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TableWithExplicitColumnNameUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TableWithExplicitColumnNameTable>? orderBy,
    _i1.OrderByListBuilder<TableWithExplicitColumnNameTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TableWithExplicitColumnName>(
      columnValues: columnValues(TableWithExplicitColumnName.t.updateTable),
      where: where(TableWithExplicitColumnName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TableWithExplicitColumnName.t),
      orderByList: orderByList?.call(TableWithExplicitColumnName.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TableWithExplicitColumnName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TableWithExplicitColumnName>> delete(
    _i1.Session session,
    List<TableWithExplicitColumnName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TableWithExplicitColumnName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TableWithExplicitColumnName].
  Future<TableWithExplicitColumnName> deleteRow(
    _i1.Session session,
    TableWithExplicitColumnName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TableWithExplicitColumnName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TableWithExplicitColumnName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TableWithExplicitColumnName>(
      where: where(TableWithExplicitColumnName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TableWithExplicitColumnNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TableWithExplicitColumnName>(
      where: where?.call(TableWithExplicitColumnName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
