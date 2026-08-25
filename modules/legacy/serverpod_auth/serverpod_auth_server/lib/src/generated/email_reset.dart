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
import 'package:serverpod/serverpod.dart' as _is;

/// Database bindings for an email reset.
abstract class EmailReset
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailReset._({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory EmailReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _EmailResetImpl;

  factory EmailReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailReset(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      verificationCode: jsonSerialization['verificationCode'] as String,
      expiration: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiration'],
      ),
    );
  }

  static final t = EmailResetTable();

  static const db = EmailResetRepository._();

  @override
  int? id;

  /// The id of the user that is resetting his/her password.
  int userId;

  /// The verification code for the password reset.
  String verificationCode;

  /// The expiration time for the password reset.
  DateTime expiration;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailReset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.EmailReset',
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.EmailReset',
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  static EmailResetInclude include({
    _is.SelectColumnsBuilder<EmailResetTable>? select,
  }) {
    return EmailResetInclude._(selectedColumns: select?.call(EmailReset.t));
  }

  static EmailResetIncludeList includeList({
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    EmailResetInclude? include,
    _is.SelectColumnsBuilder<EmailResetTable>? select,
  }) {
    return EmailResetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      include: include,
      selectedColumns: select?.call(EmailReset.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailResetImpl extends EmailReset {
  _EmailResetImpl({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) : super._(
         id: id,
         userId: userId,
         verificationCode: verificationCode,
         expiration: expiration,
       );

  /// Returns a shallow copy of this [EmailReset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return EmailReset(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}

class EmailResetUpdateTable extends _is.UpdateTable<EmailResetTable> {
  EmailResetUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> verificationCode(String value) =>
      _is.ColumnValue(
        table.verificationCode,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiration(DateTime value) =>
      _is.ColumnValue(
        table.expiration,
        value,
      );
}

class EmailResetTable extends _is.Table<int?> {
  EmailResetTable({super.tableRelation})
    : super(tableName: 'serverpod_email_reset') {
    updateTable = EmailResetUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    verificationCode = _is.ColumnString(
      'verificationCode',
      this,
    );
    expiration = _is.ColumnDateTime(
      'expiration',
      this,
    );
  }

  late final EmailResetUpdateTable updateTable;

  /// The id of the user that is resetting his/her password.
  late final _is.ColumnInt userId;

  /// The verification code for the password reset.
  late final _is.ColumnString verificationCode;

  /// The expiration time for the password reset.
  late final _is.ColumnDateTime expiration;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    verificationCode,
    expiration,
  ];
}

class EmailResetInclude extends _is.IncludeObject {
  EmailResetInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailReset.t;
}

class EmailResetIncludeList extends _is.IncludeList {
  EmailResetIncludeList._({
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailReset.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailReset.t;
}

class EmailResetRepository {
  const EmailResetRepository._();

  /// Returns a list of [EmailReset]s matching the given query parameters.
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
  Future<List<EmailReset>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailReset] matching the given query parameters.
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
  Future<EmailReset?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailReset] by its [id] or null if no such row exists.
  Future<EmailReset?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailReset>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailResetTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailReset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailResetTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailReset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailResetTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailReset>(
      id,
      transaction: transaction,
      select: select?.call(EmailReset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailReset]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailReset]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> insert(
    _is.DatabaseSession session,
    List<EmailReset> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailReset>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailReset] and returns the inserted row.
  ///
  /// The returned [EmailReset] will have its `id` field set.
  Future<EmailReset> insertRow(
    _is.DatabaseSession session,
    EmailReset row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailReset>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailReset]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [EmailReset]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> upsert(
    _is.DatabaseSession session,
    List<EmailReset> rows, {
    required _is.ColumnSelections<EmailResetTable> conflictColumns,
    _is.ColumnSelections<EmailResetTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailResetTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailReset>(
      rows,
      conflictColumns: conflictColumns(EmailReset.t),
      updateColumns: updateColumns?.call(EmailReset.t),
      updateWhere: updateWhere?.call(EmailReset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailReset] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [EmailReset] will have its `id` field set.
  Future<EmailReset?> upsertRow(
    _is.DatabaseSession session,
    EmailReset row, {
    required _is.ColumnSelections<EmailResetTable> conflictColumns,
    _is.ColumnSelections<EmailResetTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailResetTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailReset>(
      row,
      conflictColumns: conflictColumns(EmailReset.t),
      updateColumns: updateColumns?.call(EmailReset.t),
      updateWhere: updateWhere?.call(EmailReset.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailReset]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> update(
    _is.DatabaseSession session,
    List<EmailReset> rows, {
    _is.ColumnSelections<EmailResetTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailReset>(
      rows,
      columns: columns?.call(EmailReset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailReset]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailReset> updateRow(
    _is.DatabaseSession session,
    EmailReset row, {
    _is.ColumnSelections<EmailResetTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailReset>(
      row,
      columns: columns?.call(EmailReset.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailReset] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailReset?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailResetUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailReset>(
      id,
      columnValues: columnValues(EmailReset.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailReset]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailResetUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EmailResetTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailReset>(
      columnValues: columnValues(EmailReset.t.updateTable),
      where: where(EmailReset.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailReset]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> delete(
    _is.DatabaseSession session,
    List<EmailReset> rows, {
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailReset>(
      rows,
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailReset].
  Future<EmailReset> deleteRow(
    _is.DatabaseSession session,
    EmailReset row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailReset>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailReset>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailResetTable> where,
    _is.OrderByBuilder<EmailResetTable>? orderBy,
    _is.OrderByListBuilder<EmailResetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailReset>(
      where: where(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailReset>(
      where: where?.call(EmailReset.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailReset] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailResetTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailReset>(
      where: where(EmailReset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
