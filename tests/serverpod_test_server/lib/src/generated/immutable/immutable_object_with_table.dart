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

@_i1.immutable
abstract class ImmutableObjectWithTable
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  const ImmutableObjectWithTable._({
    this.id,
    required this.variable,
  });

  const factory ImmutableObjectWithTable({
    int? id,
    required String variable,
  }) = _ImmutableObjectWithTableImpl;

  factory ImmutableObjectWithTable.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithTable(
      id: jsonSerialization['id'] as int?,
      variable: jsonSerialization['variable'] as String,
    );
  }

  static final t = ImmutableObjectWithTableTable();

  static const db = ImmutableObjectWithTableRepository._();

  @override
  final int? id;

  final String variable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithTable copyWith({
    int? id,
    String? variable,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithTable &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.variable,
                  variable,
                ) ||
                other.variable == variable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      variable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'variable': variable,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'variable': variable,
    };
  }

  static ImmutableObjectWithTableInclude include() {
    return ImmutableObjectWithTableInclude._();
  }

  static ImmutableObjectWithTableIncludeList includeList({
    _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    ImmutableObjectWithTableInclude? include,
  }) {
    return ImmutableObjectWithTableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmutableObjectWithTableImpl extends ImmutableObjectWithTable {
  const _ImmutableObjectWithTableImpl({
    int? id,
    required String variable,
  }) : super._(
         id: id,
         variable: variable,
       );

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithTable copyWith({
    Object? id = _Undefined,
    String? variable,
  }) {
    return ImmutableObjectWithTable(
      id: id is int? ? id : this.id,
      variable: variable ?? this.variable,
    );
  }
}

class ImmutableObjectWithTableUpdateTable
    extends _i1.UpdateTable<ImmutableObjectWithTableTable> {
  ImmutableObjectWithTableUpdateTable(super.table);

  _i1.ColumnValue<String, String> variable(String value) => _i1.ColumnValue(
    table.variable,
    value,
  );
}

class ImmutableObjectWithTableTable extends _i1.Table<int?> {
  ImmutableObjectWithTableTable({super.tableRelation})
    : super(tableName: 'immutable_object_with_table') {
    updateTable = ImmutableObjectWithTableUpdateTable(this);
    variable = _i1.ColumnString(
      'variable',
      this,
    );
  }

  late final ImmutableObjectWithTableUpdateTable updateTable;

  late final _i1.ColumnString variable;

  @override
  List<_i1.Column> get columns => [
    id,
    variable,
  ];
}

class ImmutableObjectWithTableInclude extends _i1.IncludeObject {
  ImmutableObjectWithTableInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ImmutableObjectWithTable.t;
}

class ImmutableObjectWithTableIncludeList extends _i1.IncludeList {
  ImmutableObjectWithTableIncludeList._({
    _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ImmutableObjectWithTable.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ImmutableObjectWithTable.t;
}

class ImmutableObjectWithTableRepository {
  const ImmutableObjectWithTableRepository._();

  /// Returns a list of [ImmutableObjectWithTable]s matching the given query parameters.
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
  Future<List<ImmutableObjectWithTable>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ImmutableObjectWithTable] matching the given query parameters.
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
  Future<ImmutableObjectWithTable?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? offset,
    _i1.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ImmutableObjectWithTable] by its [id] or null if no such row exists.
  Future<ImmutableObjectWithTable?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ImmutableObjectWithTable>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ImmutableObjectWithTable]s in the list and returns the inserted rows.
  ///
  /// The returned [ImmutableObjectWithTable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ImmutableObjectWithTable>> insert(
    _i1.Session session,
    List<ImmutableObjectWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ImmutableObjectWithTable>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ImmutableObjectWithTable] and returns the inserted row.
  ///
  /// The returned [ImmutableObjectWithTable] will have its `id` field set.
  Future<ImmutableObjectWithTable> insertRow(
    _i1.Session session,
    ImmutableObjectWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ImmutableObjectWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ImmutableObjectWithTable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ImmutableObjectWithTable>> update(
    _i1.Session session,
    List<ImmutableObjectWithTable> rows, {
    _i1.ColumnSelections<ImmutableObjectWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ImmutableObjectWithTable>(
      rows,
      columns: columns?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImmutableObjectWithTable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ImmutableObjectWithTable> updateRow(
    _i1.Session session,
    ImmutableObjectWithTable row, {
    _i1.ColumnSelections<ImmutableObjectWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ImmutableObjectWithTable>(
      row,
      columns: columns?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImmutableObjectWithTable] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ImmutableObjectWithTable?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ImmutableObjectWithTableUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ImmutableObjectWithTable>(
      id,
      columnValues: columnValues(ImmutableObjectWithTable.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ImmutableObjectWithTable]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ImmutableObjectWithTable>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ImmutableObjectWithTableUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _i1.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ImmutableObjectWithTable>(
      columnValues: columnValues(ImmutableObjectWithTable.t.updateTable),
      where: where(ImmutableObjectWithTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ImmutableObjectWithTable]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ImmutableObjectWithTable>> delete(
    _i1.Session session,
    List<ImmutableObjectWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ImmutableObjectWithTable>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ImmutableObjectWithTable].
  Future<ImmutableObjectWithTable> deleteRow(
    _i1.Session session,
    ImmutableObjectWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ImmutableObjectWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ImmutableObjectWithTable>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ImmutableObjectWithTable>(
      where: where(ImmutableObjectWithTable.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
