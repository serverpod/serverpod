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

/// Database bindings for a sign in with email.
abstract class EmailAuth
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailAuth._({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
  });

  factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuthImpl;

  factory EmailAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      email: jsonSerialization['email'] as String,
      hash: jsonSerialization['hash'] as String,
    );
  }

  static final t = EmailAuthTable();

  static const db = EmailAuthRepository._();

  @override
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The email of the user.
  String email;

  /// The hashed password of the user.
  String hash;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailAuth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.EmailAuth',
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.EmailAuth',
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  static EmailAuthInclude include({
    _is.SelectColumnsBuilder<EmailAuthTable>? select,
  }) {
    return EmailAuthInclude._(selectedColumns: select?.call(EmailAuth.t));
  }

  static EmailAuthIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    EmailAuthInclude? include,
    _is.SelectColumnsBuilder<EmailAuthTable>? select,
  }) {
    return EmailAuthIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      include: include,
      selectedColumns: select?.call(EmailAuth.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAuthImpl extends EmailAuth {
  _EmailAuthImpl({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) : super._(
         id: id,
         userId: userId,
         email: email,
         hash: hash,
       );

  /// Returns a shallow copy of this [EmailAuth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}

class EmailAuthUpdateTable extends _is.UpdateTable<EmailAuthTable> {
  EmailAuthUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> hash(String value) => _is.ColumnValue(
    table.hash,
    value,
  );
}

class EmailAuthTable extends _is.Table<int?> {
  EmailAuthTable({super.tableRelation})
    : super(tableName: 'serverpod_email_auth') {
    updateTable = EmailAuthUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    hash = _is.ColumnString(
      'hash',
      this,
    );
  }

  late final EmailAuthUpdateTable updateTable;

  /// The id of the user, corresponds to the id field in [UserInfo].
  late final _is.ColumnInt userId;

  /// The email of the user.
  late final _is.ColumnString email;

  /// The hashed password of the user.
  late final _is.ColumnString hash;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    email,
    hash,
  ];
}

class EmailAuthInclude extends _is.IncludeObject {
  EmailAuthInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailAuth.t;
}

class EmailAuthIncludeList extends _is.IncludeList {
  EmailAuthIncludeList._({
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailAuth.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailAuth.t;
}

class EmailAuthRepository {
  const EmailAuthRepository._();

  /// Returns a list of [EmailAuth]s matching the given query parameters.
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
  Future<List<EmailAuth>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailAuth] matching the given query parameters.
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
  Future<EmailAuth?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAuth] by its [id] or null if no such row exists.
  Future<EmailAuth?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAuth>(
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
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailAuthTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailAuth.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailAuthTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailAuth.t),
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
    _is.SelectColumnsBuilder<EmailAuthTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailAuth>(
      id,
      transaction: transaction,
      select: select?.call(EmailAuth.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAuth]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAuth]s will have their `id` fields set.
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
  Future<List<EmailAuth>> insert(
    _is.DatabaseSession session,
    List<EmailAuth> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAuth>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAuth] and returns the inserted row.
  ///
  /// The returned [EmailAuth] will have its `id` field set.
  Future<EmailAuth> insertRow(
    _is.DatabaseSession session,
    EmailAuth row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAuth>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAuth]s in the list and returns the resulting rows.
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
  /// The returned [EmailAuth]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAuth>> upsert(
    _is.DatabaseSession session,
    List<EmailAuth> rows, {
    required _is.ColumnSelections<EmailAuthTable> conflictColumns,
    _is.ColumnSelections<EmailAuthTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAuthTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAuth>(
      rows,
      conflictColumns: conflictColumns(EmailAuth.t),
      updateColumns: updateColumns?.call(EmailAuth.t),
      updateWhere: updateWhere?.call(EmailAuth.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAuth] and returns the resulting row.
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
  /// The returned [EmailAuth] will have its `id` field set.
  Future<EmailAuth?> upsertRow(
    _is.DatabaseSession session,
    EmailAuth row, {
    required _is.ColumnSelections<EmailAuthTable> conflictColumns,
    _is.ColumnSelections<EmailAuthTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAuthTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAuth>(
      row,
      conflictColumns: conflictColumns(EmailAuth.t),
      updateColumns: updateColumns?.call(EmailAuth.t),
      updateWhere: updateWhere?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAuth]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAuth>> update(
    _is.DatabaseSession session,
    List<EmailAuth> rows, {
    _is.ColumnSelections<EmailAuthTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAuth>(
      rows,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAuth]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAuth> updateRow(
    _is.DatabaseSession session,
    EmailAuth row, {
    _is.ColumnSelections<EmailAuthTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAuth>(
      row,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAuth] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAuth?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailAuthUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAuth>(
      id,
      columnValues: columnValues(EmailAuth.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAuth]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAuth>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailAuthUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EmailAuthTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAuth>(
      columnValues: columnValues(EmailAuth.t.updateTable),
      where: where(EmailAuth.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAuth]s in the list and returns the deleted rows.
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
  Future<List<EmailAuth>> delete(
    _is.DatabaseSession session,
    List<EmailAuth> rows, {
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAuth>(
      rows,
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAuth].
  Future<EmailAuth> deleteRow(
    _is.DatabaseSession session,
    EmailAuth row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAuth>(
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
  Future<List<EmailAuth>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAuthTable> where,
    _is.OrderByBuilder<EmailAuthTable>? orderBy,
    _is.OrderByListBuilder<EmailAuthTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAuth>(
      where: where(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAuth>(
      where: where?.call(EmailAuth.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAuth] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAuthTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAuth>(
      where: where(EmailAuth.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
