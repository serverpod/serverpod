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

/// Model with simple partitionBy using default LIST method.
abstract class PartitionedSimple
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PartitionedSimple._({
    this.id,
    required this.source,
    required this.value,
  });

  factory PartitionedSimple({
    int? id,
    required String source,
    required int value,
  }) = _PartitionedSimpleImpl;

  factory PartitionedSimple.fromJson(Map<String, dynamic> jsonSerialization) {
    return PartitionedSimple(
      id: jsonSerialization['id'] as int?,
      source: jsonSerialization['source'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  static final t = PartitionedSimpleTable();

  static const db = PartitionedSimpleRepository._();

  @override
  int? id;

  String source;

  int value;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PartitionedSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedSimple copyWith({
    int? id,
    String? source,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedSimple',
      if (id != null) 'id': id,
      'source': source,
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PartitionedSimple',
      if (id != null) 'id': id,
      'source': source,
      'value': value,
    };
  }

  static PartitionedSimpleInclude include() {
    return PartitionedSimpleInclude._();
  }

  static PartitionedSimpleIncludeList includeList({
    _i1.WhereExpressionBuilder<PartitionedSimpleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedSimpleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedSimpleTable>? orderByList,
    PartitionedSimpleInclude? include,
  }) {
    return PartitionedSimpleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedSimple.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PartitionedSimple.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedSimpleImpl extends PartitionedSimple {
  _PartitionedSimpleImpl({
    int? id,
    required String source,
    required int value,
  }) : super._(
         id: id,
         source: source,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedSimple copyWith({
    Object? id = _Undefined,
    String? source,
    int? value,
  }) {
    return PartitionedSimple(
      id: id is int? ? id : this.id,
      source: source ?? this.source,
      value: value ?? this.value,
    );
  }
}

class PartitionedSimpleUpdateTable
    extends _i1.UpdateTable<PartitionedSimpleTable> {
  PartitionedSimpleUpdateTable(super.table);

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<int, int> value(int value) => _i1.ColumnValue(
    table.value,
    value,
  );
}

class PartitionedSimpleTable extends _i1.Table<int?> {
  PartitionedSimpleTable({super.tableRelation})
    : super(tableName: 'partitioned_simple') {
    updateTable = PartitionedSimpleUpdateTable(this);
    source = _i1.ColumnString(
      'source',
      this,
    );
    value = _i1.ColumnInt(
      'value',
      this,
    );
  }

  late final PartitionedSimpleUpdateTable updateTable;

  late final _i1.ColumnString source;

  late final _i1.ColumnInt value;

  @override
  List<_i1.Column> get columns => [
    id,
    source,
    value,
  ];
}

class PartitionedSimpleInclude extends _i1.IncludeObject {
  PartitionedSimpleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PartitionedSimple.t;
}

class PartitionedSimpleIncludeList extends _i1.IncludeList {
  PartitionedSimpleIncludeList._({
    _i1.WhereExpressionBuilder<PartitionedSimpleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PartitionedSimple.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PartitionedSimple.t;
}

class PartitionedSimpleRepository {
  const PartitionedSimpleRepository._();

  /// Returns a list of [PartitionedSimple]s matching the given query parameters.
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
  Future<List<PartitionedSimple>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedSimpleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedSimpleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedSimpleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PartitionedSimple>(
      where: where?.call(PartitionedSimple.t),
      orderBy: orderBy?.call(PartitionedSimple.t),
      orderByList: orderByList?.call(PartitionedSimple.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PartitionedSimple] matching the given query parameters.
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
  Future<PartitionedSimple?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedSimpleTable>? where,
    int? offset,
    _i1.OrderByBuilder<PartitionedSimpleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedSimpleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PartitionedSimple>(
      where: where?.call(PartitionedSimple.t),
      orderBy: orderBy?.call(PartitionedSimple.t),
      orderByList: orderByList?.call(PartitionedSimple.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PartitionedSimple] by its [id] or null if no such row exists.
  Future<PartitionedSimple?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PartitionedSimple>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PartitionedSimple]s in the list and returns the inserted rows.
  ///
  /// The returned [PartitionedSimple]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PartitionedSimple>> insert(
    _i1.Session session,
    List<PartitionedSimple> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PartitionedSimple>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PartitionedSimple] and returns the inserted row.
  ///
  /// The returned [PartitionedSimple] will have its `id` field set.
  Future<PartitionedSimple> insertRow(
    _i1.Session session,
    PartitionedSimple row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PartitionedSimple>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedSimple]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PartitionedSimple>> update(
    _i1.Session session,
    List<PartitionedSimple> rows, {
    _i1.ColumnSelections<PartitionedSimpleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PartitionedSimple>(
      rows,
      columns: columns?.call(PartitionedSimple.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedSimple]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PartitionedSimple> updateRow(
    _i1.Session session,
    PartitionedSimple row, {
    _i1.ColumnSelections<PartitionedSimpleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PartitionedSimple>(
      row,
      columns: columns?.call(PartitionedSimple.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedSimple] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PartitionedSimple?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PartitionedSimpleUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PartitionedSimple>(
      id,
      columnValues: columnValues(PartitionedSimple.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedSimple]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PartitionedSimple>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PartitionedSimpleUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PartitionedSimpleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedSimpleTable>? orderBy,
    _i1.OrderByListBuilder<PartitionedSimpleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PartitionedSimple>(
      columnValues: columnValues(PartitionedSimple.t.updateTable),
      where: where(PartitionedSimple.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedSimple.t),
      orderByList: orderByList?.call(PartitionedSimple.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PartitionedSimple]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PartitionedSimple>> delete(
    _i1.Session session,
    List<PartitionedSimple> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PartitionedSimple>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PartitionedSimple].
  Future<PartitionedSimple> deleteRow(
    _i1.Session session,
    PartitionedSimple row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PartitionedSimple>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PartitionedSimple>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PartitionedSimpleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PartitionedSimple>(
      where: where(PartitionedSimple.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedSimpleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PartitionedSimple>(
      where: where?.call(PartitionedSimple.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
