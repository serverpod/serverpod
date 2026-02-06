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

abstract class ModifiedColumnName
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ModifiedColumnName._({
    this.id,
    required this.originalColumn,
    required this.modifiedColumn,
  });

  factory ModifiedColumnName({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) = _ModifiedColumnNameImpl;

  factory ModifiedColumnName.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModifiedColumnName(
      id: jsonSerialization['id'] as int?,
      originalColumn: jsonSerialization['originalColumn'] as String,
      modifiedColumn: jsonSerialization['modifiedColumn'] as String,
    );
  }

  static final t = ModifiedColumnNameTable();

  static const db = ModifiedColumnNameRepository._();

  @override
  int? id;

  String originalColumn;

  String modifiedColumn;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModifiedColumnName copyWith({
    int? id,
    String? originalColumn,
    String? modifiedColumn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModifiedColumnName',
      if (id != null) 'id': id,
      'originalColumn': originalColumn,
      'modifiedColumn': modifiedColumn,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModifiedColumnName',
      if (id != null) 'id': id,
      'originalColumn': originalColumn,
      'modifiedColumn': modifiedColumn,
    };
  }

  static ModifiedColumnNameInclude include() {
    return ModifiedColumnNameInclude._();
  }

  static ModifiedColumnNameIncludeList includeList({
    _i1.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    ModifiedColumnNameInclude? include,
  }) {
    return ModifiedColumnNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ModifiedColumnName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModifiedColumnNameImpl extends ModifiedColumnName {
  _ModifiedColumnNameImpl({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) : super._(
         id: id,
         originalColumn: originalColumn,
         modifiedColumn: modifiedColumn,
       );

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModifiedColumnName copyWith({
    Object? id = _Undefined,
    String? originalColumn,
    String? modifiedColumn,
  }) {
    return ModifiedColumnName(
      id: id is int? ? id : this.id,
      originalColumn: originalColumn ?? this.originalColumn,
      modifiedColumn: modifiedColumn ?? this.modifiedColumn,
    );
  }
}

class ModifiedColumnNameUpdateTable
    extends _i1.UpdateTable<ModifiedColumnNameTable> {
  ModifiedColumnNameUpdateTable(super.table);

  _i1.ColumnValue<String, String> originalColumn(String value) =>
      _i1.ColumnValue(
        table.originalColumn,
        value,
      );

  _i1.ColumnValue<String, String> modifiedColumn(String value) =>
      _i1.ColumnValue(
        table.modifiedColumn,
        value,
      );
}

class ModifiedColumnNameTable extends _i1.Table<int?> {
  ModifiedColumnNameTable({super.tableRelation})
    : super(tableName: 'modified_column_name') {
    updateTable = ModifiedColumnNameUpdateTable(this);
    originalColumn = _i1.ColumnString(
      'originalColumn',
      this,
    );
    modifiedColumn = _i1.ColumnString(
      'modified_column',
      this,
      fieldName: 'modifiedColumn',
    );
  }

  late final ModifiedColumnNameUpdateTable updateTable;

  late final _i1.ColumnString originalColumn;

  late final _i1.ColumnString modifiedColumn;

  @override
  List<_i1.Column> get columns => [
    id,
    originalColumn,
    modifiedColumn,
  ];
}

class ModifiedColumnNameInclude extends _i1.IncludeObject {
  ModifiedColumnNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ModifiedColumnName.t;
}

class ModifiedColumnNameIncludeList extends _i1.IncludeList {
  ModifiedColumnNameIncludeList._({
    _i1.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ModifiedColumnName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ModifiedColumnName.t;
}

class ModifiedColumnNameRepository {
  const ModifiedColumnNameRepository._();

  /// Returns a list of [ModifiedColumnName]s matching the given query parameters.
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
  Future<List<ModifiedColumnName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ModifiedColumnName] matching the given query parameters.
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
  Future<ModifiedColumnName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ModifiedColumnName] by its [id] or null if no such row exists.
  Future<ModifiedColumnName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ModifiedColumnName>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ModifiedColumnName]s in the list and returns the inserted rows.
  ///
  /// The returned [ModifiedColumnName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ModifiedColumnName>> insert(
    _i1.Session session,
    List<ModifiedColumnName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ModifiedColumnName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ModifiedColumnName] and returns the inserted row.
  ///
  /// The returned [ModifiedColumnName] will have its `id` field set.
  Future<ModifiedColumnName> insertRow(
    _i1.Session session,
    ModifiedColumnName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ModifiedColumnName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ModifiedColumnName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ModifiedColumnName>> update(
    _i1.Session session,
    List<ModifiedColumnName> rows, {
    _i1.ColumnSelections<ModifiedColumnNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ModifiedColumnName>(
      rows,
      columns: columns?.call(ModifiedColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModifiedColumnName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ModifiedColumnName> updateRow(
    _i1.Session session,
    ModifiedColumnName row, {
    _i1.ColumnSelections<ModifiedColumnNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ModifiedColumnName>(
      row,
      columns: columns?.call(ModifiedColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModifiedColumnName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ModifiedColumnName?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ModifiedColumnNameUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ModifiedColumnName>(
      id,
      columnValues: columnValues(ModifiedColumnName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ModifiedColumnName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ModifiedColumnName>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ModifiedColumnNameUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _i1.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ModifiedColumnName>(
      columnValues: columnValues(ModifiedColumnName.t.updateTable),
      where: where(ModifiedColumnName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ModifiedColumnName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ModifiedColumnName>> delete(
    _i1.Session session,
    List<ModifiedColumnName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ModifiedColumnName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ModifiedColumnName].
  Future<ModifiedColumnName> deleteRow(
    _i1.Session session,
    ModifiedColumnName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ModifiedColumnName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ModifiedColumnName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ModifiedColumnName>(
      where: where(ModifiedColumnName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ModifiedColumnName] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ModifiedColumnName>(
      where: where(ModifiedColumnName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
