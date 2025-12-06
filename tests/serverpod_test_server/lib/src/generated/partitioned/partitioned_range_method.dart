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

/// Model with partitionBy using RANGE method.
abstract class PartitionedRangeMethod
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PartitionedRangeMethod._({
    this.id,
    required this.createdAt,
    required this.value,
  });

  factory PartitionedRangeMethod({
    int? id,
    required DateTime createdAt,
    required int value,
  }) = _PartitionedRangeMethodImpl;

  factory PartitionedRangeMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedRangeMethod(
      id: jsonSerialization['id'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      value: jsonSerialization['value'] as int,
    );
  }

  static final t = PartitionedRangeMethodTable();

  static const db = PartitionedRangeMethodRepository._();

  @override
  int? id;

  DateTime createdAt;

  int value;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PartitionedRangeMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedRangeMethod copyWith({
    int? id,
    DateTime? createdAt,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedRangeMethod',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PartitionedRangeMethod',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'value': value,
    };
  }

  static PartitionedRangeMethodInclude include() {
    return PartitionedRangeMethodInclude._();
  }

  static PartitionedRangeMethodIncludeList includeList({
    _i1.WhereExpressionBuilder<PartitionedRangeMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedRangeMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedRangeMethodTable>? orderByList,
    PartitionedRangeMethodInclude? include,
  }) {
    return PartitionedRangeMethodIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedRangeMethod.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PartitionedRangeMethod.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedRangeMethodImpl extends PartitionedRangeMethod {
  _PartitionedRangeMethodImpl({
    int? id,
    required DateTime createdAt,
    required int value,
  }) : super._(
         id: id,
         createdAt: createdAt,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedRangeMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedRangeMethod copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    int? value,
  }) {
    return PartitionedRangeMethod(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      value: value ?? this.value,
    );
  }
}

class PartitionedRangeMethodUpdateTable
    extends _i1.UpdateTable<PartitionedRangeMethodTable> {
  PartitionedRangeMethodUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> value(int value) => _i1.ColumnValue(
    table.value,
    value,
  );
}

class PartitionedRangeMethodTable extends _i1.Table<int?> {
  PartitionedRangeMethodTable({super.tableRelation})
    : super(tableName: 'partitioned_range_method') {
    updateTable = PartitionedRangeMethodUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    value = _i1.ColumnInt(
      'value',
      this,
    );
  }

  late final PartitionedRangeMethodUpdateTable updateTable;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt value;

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    value,
  ];
}

class PartitionedRangeMethodInclude extends _i1.IncludeObject {
  PartitionedRangeMethodInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PartitionedRangeMethod.t;
}

class PartitionedRangeMethodIncludeList extends _i1.IncludeList {
  PartitionedRangeMethodIncludeList._({
    _i1.WhereExpressionBuilder<PartitionedRangeMethodTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PartitionedRangeMethod.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PartitionedRangeMethod.t;
}

class PartitionedRangeMethodRepository {
  const PartitionedRangeMethodRepository._();

  /// Returns a list of [PartitionedRangeMethod]s matching the given query parameters.
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
  Future<List<PartitionedRangeMethod>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedRangeMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedRangeMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedRangeMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PartitionedRangeMethod>(
      where: where?.call(PartitionedRangeMethod.t),
      orderBy: orderBy?.call(PartitionedRangeMethod.t),
      orderByList: orderByList?.call(PartitionedRangeMethod.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PartitionedRangeMethod] matching the given query parameters.
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
  Future<PartitionedRangeMethod?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedRangeMethodTable>? where,
    int? offset,
    _i1.OrderByBuilder<PartitionedRangeMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedRangeMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PartitionedRangeMethod>(
      where: where?.call(PartitionedRangeMethod.t),
      orderBy: orderBy?.call(PartitionedRangeMethod.t),
      orderByList: orderByList?.call(PartitionedRangeMethod.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PartitionedRangeMethod] by its [id] or null if no such row exists.
  Future<PartitionedRangeMethod?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PartitionedRangeMethod>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PartitionedRangeMethod]s in the list and returns the inserted rows.
  ///
  /// The returned [PartitionedRangeMethod]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PartitionedRangeMethod>> insert(
    _i1.Session session,
    List<PartitionedRangeMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PartitionedRangeMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PartitionedRangeMethod] and returns the inserted row.
  ///
  /// The returned [PartitionedRangeMethod] will have its `id` field set.
  Future<PartitionedRangeMethod> insertRow(
    _i1.Session session,
    PartitionedRangeMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PartitionedRangeMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedRangeMethod]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PartitionedRangeMethod>> update(
    _i1.Session session,
    List<PartitionedRangeMethod> rows, {
    _i1.ColumnSelections<PartitionedRangeMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PartitionedRangeMethod>(
      rows,
      columns: columns?.call(PartitionedRangeMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedRangeMethod]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PartitionedRangeMethod> updateRow(
    _i1.Session session,
    PartitionedRangeMethod row, {
    _i1.ColumnSelections<PartitionedRangeMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PartitionedRangeMethod>(
      row,
      columns: columns?.call(PartitionedRangeMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedRangeMethod] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PartitionedRangeMethod?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PartitionedRangeMethodUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PartitionedRangeMethod>(
      id,
      columnValues: columnValues(PartitionedRangeMethod.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedRangeMethod]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PartitionedRangeMethod>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PartitionedRangeMethodUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PartitionedRangeMethodTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedRangeMethodTable>? orderBy,
    _i1.OrderByListBuilder<PartitionedRangeMethodTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PartitionedRangeMethod>(
      columnValues: columnValues(PartitionedRangeMethod.t.updateTable),
      where: where(PartitionedRangeMethod.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedRangeMethod.t),
      orderByList: orderByList?.call(PartitionedRangeMethod.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PartitionedRangeMethod]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PartitionedRangeMethod>> delete(
    _i1.Session session,
    List<PartitionedRangeMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PartitionedRangeMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PartitionedRangeMethod].
  Future<PartitionedRangeMethod> deleteRow(
    _i1.Session session,
    PartitionedRangeMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PartitionedRangeMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PartitionedRangeMethod>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PartitionedRangeMethodTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PartitionedRangeMethod>(
      where: where(PartitionedRangeMethod.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedRangeMethodTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PartitionedRangeMethod>(
      where: where?.call(PartitionedRangeMethod.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
