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

/// Model with partitionBy using multiple columns.
abstract class PartitionedMultiColumn
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PartitionedMultiColumn._({
    this.id,
    required this.source,
    required this.category,
    required this.value,
  });

  factory PartitionedMultiColumn({
    int? id,
    required String source,
    required String category,
    required int value,
  }) = _PartitionedMultiColumnImpl;

  factory PartitionedMultiColumn.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedMultiColumn(
      id: jsonSerialization['id'] as int?,
      source: jsonSerialization['source'] as String,
      category: jsonSerialization['category'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  static final t = PartitionedMultiColumnTable();

  static const db = PartitionedMultiColumnRepository._();

  @override
  int? id;

  String source;

  String category;

  int value;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PartitionedMultiColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedMultiColumn copyWith({
    int? id,
    String? source,
    String? category,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedMultiColumn',
      if (id != null) 'id': id,
      'source': source,
      'category': category,
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PartitionedMultiColumn',
      if (id != null) 'id': id,
      'source': source,
      'category': category,
      'value': value,
    };
  }

  static PartitionedMultiColumnInclude include() {
    return PartitionedMultiColumnInclude._();
  }

  static PartitionedMultiColumnIncludeList includeList({
    _i1.WhereExpressionBuilder<PartitionedMultiColumnTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedMultiColumnTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedMultiColumnTable>? orderByList,
    PartitionedMultiColumnInclude? include,
  }) {
    return PartitionedMultiColumnIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedMultiColumn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PartitionedMultiColumn.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedMultiColumnImpl extends PartitionedMultiColumn {
  _PartitionedMultiColumnImpl({
    int? id,
    required String source,
    required String category,
    required int value,
  }) : super._(
         id: id,
         source: source,
         category: category,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedMultiColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedMultiColumn copyWith({
    Object? id = _Undefined,
    String? source,
    String? category,
    int? value,
  }) {
    return PartitionedMultiColumn(
      id: id is int? ? id : this.id,
      source: source ?? this.source,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }
}

class PartitionedMultiColumnUpdateTable
    extends _i1.UpdateTable<PartitionedMultiColumnTable> {
  PartitionedMultiColumnUpdateTable(super.table);

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<int, int> value(int value) => _i1.ColumnValue(
    table.value,
    value,
  );
}

class PartitionedMultiColumnTable extends _i1.Table<int?> {
  PartitionedMultiColumnTable({super.tableRelation})
    : super(tableName: 'partitioned_multi_column') {
    updateTable = PartitionedMultiColumnUpdateTable(this);
    source = _i1.ColumnString(
      'source',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    value = _i1.ColumnInt(
      'value',
      this,
    );
  }

  late final PartitionedMultiColumnUpdateTable updateTable;

  late final _i1.ColumnString source;

  late final _i1.ColumnString category;

  late final _i1.ColumnInt value;

  @override
  List<_i1.Column> get columns => [
    id,
    source,
    category,
    value,
  ];
}

class PartitionedMultiColumnInclude extends _i1.IncludeObject {
  PartitionedMultiColumnInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PartitionedMultiColumn.t;
}

class PartitionedMultiColumnIncludeList extends _i1.IncludeList {
  PartitionedMultiColumnIncludeList._({
    _i1.WhereExpressionBuilder<PartitionedMultiColumnTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PartitionedMultiColumn.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PartitionedMultiColumn.t;
}

class PartitionedMultiColumnRepository {
  const PartitionedMultiColumnRepository._();

  /// Returns a list of [PartitionedMultiColumn]s matching the given query parameters.
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
  Future<List<PartitionedMultiColumn>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedMultiColumnTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedMultiColumnTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedMultiColumnTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PartitionedMultiColumn>(
      where: where?.call(PartitionedMultiColumn.t),
      orderBy: orderBy?.call(PartitionedMultiColumn.t),
      orderByList: orderByList?.call(PartitionedMultiColumn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PartitionedMultiColumn] matching the given query parameters.
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
  Future<PartitionedMultiColumn?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedMultiColumnTable>? where,
    int? offset,
    _i1.OrderByBuilder<PartitionedMultiColumnTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedMultiColumnTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PartitionedMultiColumn>(
      where: where?.call(PartitionedMultiColumn.t),
      orderBy: orderBy?.call(PartitionedMultiColumn.t),
      orderByList: orderByList?.call(PartitionedMultiColumn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PartitionedMultiColumn] by its [id] or null if no such row exists.
  Future<PartitionedMultiColumn?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PartitionedMultiColumn>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PartitionedMultiColumn]s in the list and returns the inserted rows.
  ///
  /// The returned [PartitionedMultiColumn]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PartitionedMultiColumn>> insert(
    _i1.Session session,
    List<PartitionedMultiColumn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PartitionedMultiColumn>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PartitionedMultiColumn] and returns the inserted row.
  ///
  /// The returned [PartitionedMultiColumn] will have its `id` field set.
  Future<PartitionedMultiColumn> insertRow(
    _i1.Session session,
    PartitionedMultiColumn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PartitionedMultiColumn>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedMultiColumn]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PartitionedMultiColumn>> update(
    _i1.Session session,
    List<PartitionedMultiColumn> rows, {
    _i1.ColumnSelections<PartitionedMultiColumnTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PartitionedMultiColumn>(
      rows,
      columns: columns?.call(PartitionedMultiColumn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedMultiColumn]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PartitionedMultiColumn> updateRow(
    _i1.Session session,
    PartitionedMultiColumn row, {
    _i1.ColumnSelections<PartitionedMultiColumnTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PartitionedMultiColumn>(
      row,
      columns: columns?.call(PartitionedMultiColumn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedMultiColumn] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PartitionedMultiColumn?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PartitionedMultiColumnUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PartitionedMultiColumn>(
      id,
      columnValues: columnValues(PartitionedMultiColumn.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedMultiColumn]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PartitionedMultiColumn>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PartitionedMultiColumnUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PartitionedMultiColumnTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedMultiColumnTable>? orderBy,
    _i1.OrderByListBuilder<PartitionedMultiColumnTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PartitionedMultiColumn>(
      columnValues: columnValues(PartitionedMultiColumn.t.updateTable),
      where: where(PartitionedMultiColumn.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedMultiColumn.t),
      orderByList: orderByList?.call(PartitionedMultiColumn.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PartitionedMultiColumn]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PartitionedMultiColumn>> delete(
    _i1.Session session,
    List<PartitionedMultiColumn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PartitionedMultiColumn>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PartitionedMultiColumn].
  Future<PartitionedMultiColumn> deleteRow(
    _i1.Session session,
    PartitionedMultiColumn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PartitionedMultiColumn>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PartitionedMultiColumn>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PartitionedMultiColumnTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PartitionedMultiColumn>(
      where: where(PartitionedMultiColumn.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedMultiColumnTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PartitionedMultiColumn>(
      where: where?.call(PartitionedMultiColumn.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
