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

abstract class UniqueDataWithNonPersist
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UniqueDataWithNonPersist._({
    this.id,
    required this.number,
    required this.email,
    this.extra,
  });

  factory UniqueDataWithNonPersist({
    int? id,
    required int number,
    required String email,
    String? extra,
  }) = _UniqueDataWithNonPersistImpl;

  factory UniqueDataWithNonPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UniqueDataWithNonPersist(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
      extra: jsonSerialization['extra'] as String?,
    );
  }

  static final t = UniqueDataWithNonPersistTable();

  static const db = UniqueDataWithNonPersistRepository._();

  @override
  int? id;

  int number;

  String email;

  String? extra;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UniqueDataWithNonPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UniqueDataWithNonPersist copyWith({
    int? id,
    int? number,
    String? email,
    String? extra,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniqueDataWithNonPersist',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
      if (extra != null) 'extra': extra,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UniqueDataWithNonPersist',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
      if (extra != null) 'extra': extra,
    };
  }

  static UniqueDataWithNonPersistInclude include() {
    return UniqueDataWithNonPersistInclude._();
  }

  static UniqueDataWithNonPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataWithNonPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataWithNonPersistTable>? orderByList,
    UniqueDataWithNonPersistInclude? include,
  }) {
    return UniqueDataWithNonPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueDataWithNonPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UniqueDataWithNonPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniqueDataWithNonPersistImpl extends UniqueDataWithNonPersist {
  _UniqueDataWithNonPersistImpl({
    int? id,
    required int number,
    required String email,
    String? extra,
  }) : super._(
         id: id,
         number: number,
         email: email,
         extra: extra,
       );

  /// Returns a shallow copy of this [UniqueDataWithNonPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UniqueDataWithNonPersist copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
    Object? extra = _Undefined,
  }) {
    return UniqueDataWithNonPersist(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
      extra: extra is String? ? extra : this.extra,
    );
  }
}

class UniqueDataWithNonPersistUpdateTable
    extends _i1.UpdateTable<UniqueDataWithNonPersistTable> {
  UniqueDataWithNonPersistUpdateTable(super.table);

  _i1.ColumnValue<int, int> number(int value) => _i1.ColumnValue(
    table.number,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );
}

class UniqueDataWithNonPersistTable extends _i1.Table<int?> {
  UniqueDataWithNonPersistTable({super.tableRelation})
    : super(tableName: 'unique_data_with_non_persist') {
    updateTable = UniqueDataWithNonPersistUpdateTable(this);
    number = _i1.ColumnInt(
      'number',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
  }

  late final UniqueDataWithNonPersistUpdateTable updateTable;

  late final _i1.ColumnInt number;

  late final _i1.ColumnString email;

  @override
  List<_i1.Column> get columns => [
    id,
    number,
    email,
  ];
}

class UniqueDataWithNonPersistInclude extends _i1.IncludeObject {
  UniqueDataWithNonPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UniqueDataWithNonPersist.t;
}

class UniqueDataWithNonPersistIncludeList extends _i1.IncludeList {
  UniqueDataWithNonPersistIncludeList._({
    _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UniqueDataWithNonPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UniqueDataWithNonPersist.t;
}

class UniqueDataWithNonPersistRepository {
  const UniqueDataWithNonPersistRepository._();

  /// Returns a list of [UniqueDataWithNonPersist]s matching the given query parameters.
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
  Future<List<UniqueDataWithNonPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataWithNonPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataWithNonPersistTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UniqueDataWithNonPersist>(
      where: where?.call(UniqueDataWithNonPersist.t),
      orderBy: orderBy?.call(UniqueDataWithNonPersist.t),
      orderByList: orderByList?.call(UniqueDataWithNonPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UniqueDataWithNonPersist] matching the given query parameters.
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
  Future<UniqueDataWithNonPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<UniqueDataWithNonPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataWithNonPersistTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UniqueDataWithNonPersist>(
      where: where?.call(UniqueDataWithNonPersist.t),
      orderBy: orderBy?.call(UniqueDataWithNonPersist.t),
      orderByList: orderByList?.call(UniqueDataWithNonPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UniqueDataWithNonPersist] by its [id] or null if no such row exists.
  Future<UniqueDataWithNonPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UniqueDataWithNonPersist>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UniqueDataWithNonPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [UniqueDataWithNonPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UniqueDataWithNonPersist>> insert(
    _i1.Session session,
    List<UniqueDataWithNonPersist> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UniqueDataWithNonPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UniqueDataWithNonPersist] and returns the inserted row.
  ///
  /// The returned [UniqueDataWithNonPersist] will have its `id` field set.
  Future<UniqueDataWithNonPersist> insertRow(
    _i1.Session session,
    UniqueDataWithNonPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniqueDataWithNonPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UniqueDataWithNonPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UniqueDataWithNonPersist>> update(
    _i1.Session session,
    List<UniqueDataWithNonPersist> rows, {
    _i1.ColumnSelections<UniqueDataWithNonPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UniqueDataWithNonPersist>(
      rows,
      columns: columns?.call(UniqueDataWithNonPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueDataWithNonPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UniqueDataWithNonPersist> updateRow(
    _i1.Session session,
    UniqueDataWithNonPersist row, {
    _i1.ColumnSelections<UniqueDataWithNonPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniqueDataWithNonPersist>(
      row,
      columns: columns?.call(UniqueDataWithNonPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueDataWithNonPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UniqueDataWithNonPersist?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UniqueDataWithNonPersistUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UniqueDataWithNonPersist>(
      id,
      columnValues: columnValues(UniqueDataWithNonPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UniqueDataWithNonPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UniqueDataWithNonPersist>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UniqueDataWithNonPersistUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataWithNonPersistTable>? orderBy,
    _i1.OrderByListBuilder<UniqueDataWithNonPersistTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UniqueDataWithNonPersist>(
      columnValues: columnValues(UniqueDataWithNonPersist.t.updateTable),
      where: where(UniqueDataWithNonPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueDataWithNonPersist.t),
      orderByList: orderByList?.call(UniqueDataWithNonPersist.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UniqueDataWithNonPersist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UniqueDataWithNonPersist>> delete(
    _i1.Session session,
    List<UniqueDataWithNonPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UniqueDataWithNonPersist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UniqueDataWithNonPersist].
  Future<UniqueDataWithNonPersist> deleteRow(
    _i1.Session session,
    UniqueDataWithNonPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniqueDataWithNonPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UniqueDataWithNonPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UniqueDataWithNonPersist>(
      where: where(UniqueDataWithNonPersist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UniqueDataWithNonPersist>(
      where: where?.call(UniqueDataWithNonPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UniqueDataWithNonPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UniqueDataWithNonPersistTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UniqueDataWithNonPersist>(
      where: where(UniqueDataWithNonPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
