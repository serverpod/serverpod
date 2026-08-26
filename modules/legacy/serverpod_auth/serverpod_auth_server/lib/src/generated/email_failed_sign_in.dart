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

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
abstract class EmailFailedSignIn
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailFailedSignIn._({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  });

  factory EmailFailedSignIn({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) = _EmailFailedSignInImpl;

  factory EmailFailedSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailFailedSignIn(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      time: _is.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = EmailFailedSignInTable();

  static const db = EmailFailedSignInRepository._();

  @override
  int? id;

  /// Email attempting to sign in with.
  String email;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailFailedSignIn copyWith({
    int? id,
    String? email,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.EmailFailedSignIn',
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.EmailFailedSignIn',
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  /// Builds a complete [EmailFailedSignInInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmailFailedSignInInclude include() {
    return EmailFailedSignInInclude._();
  }

  /// Builds a complete [EmailFailedSignInIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmailFailedSignInIncludeList includeList({
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    EmailFailedSignInInclude? include,
  }) {
    return EmailFailedSignInIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EmailFailedSignInJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EmailFailedSignInJsonInclude includeJson({
    _is.SelectColumnsBuilder<EmailFailedSignInTable>? select,
  }) {
    return _EmailFailedSignInJsonInclude._(
      selectedColumns: select?.call(EmailFailedSignIn.t),
    );
  }

  /// Builds a JSON-compatible [EmailFailedSignInJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EmailFailedSignInJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    EmailFailedSignInJsonInclude? include,
    _is.SelectColumnsBuilder<EmailFailedSignInTable>? select,
  }) {
    return _EmailFailedSignInJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      include: include,
      selectedColumns: select?.call(EmailFailedSignIn.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailFailedSignInImpl extends EmailFailedSignIn {
  _EmailFailedSignInImpl({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) : super._(
         id: id,
         email: email,
         time: time,
         ipAddress: ipAddress,
       );

  /// Returns a shallow copy of this [EmailFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailFailedSignIn copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? time,
    String? ipAddress,
  }) {
    return EmailFailedSignIn(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class EmailFailedSignInUpdateTable
    extends _is.UpdateTable<EmailFailedSignInTable> {
  EmailFailedSignInUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> time(DateTime value) => _is.ColumnValue(
    table.time,
    value,
  );

  _is.ColumnValue<String, String> ipAddress(String value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );
}

class EmailFailedSignInTable extends _is.Table<int?> {
  EmailFailedSignInTable({super.tableRelation})
    : super(tableName: 'serverpod_email_failed_sign_in') {
    updateTable = EmailFailedSignInUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    time = _is.ColumnDateTime(
      'time',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
  }

  late final EmailFailedSignInUpdateTable updateTable;

  /// Email attempting to sign in with.
  late final _is.ColumnString email;

  /// The time of the sign in attempt.
  late final _is.ColumnDateTime time;

  /// The IP address of the sign in attempt.
  late final _is.ColumnString ipAddress;

  @override
  List<_is.Column> get columns => [
    id,
    email,
    time,
    ipAddress,
  ];
}

abstract interface class EmailFailedSignInJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class EmailFailedSignInJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class EmailFailedSignInInclude extends _is.IncludeObject
    implements EmailFailedSignInJsonInclude, _is.FullModelInclude {
  EmailFailedSignInInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailFailedSignIn.t;
}

final class EmailFailedSignInIncludeList extends _is.IncludeList
    implements EmailFailedSignInJsonIncludeList, _is.FullModelInclude {
  EmailFailedSignInIncludeList._({
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmailFailedSignInInclude? super.include,
  }) {
    super.where = where?.call(EmailFailedSignIn.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailFailedSignIn.t;
}

final class _EmailFailedSignInJsonInclude extends _is.IncludeObject
    implements EmailFailedSignInJsonInclude {
  _EmailFailedSignInJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailFailedSignIn.t;
}

final class _EmailFailedSignInJsonIncludeList extends _is.IncludeList
    implements EmailFailedSignInJsonIncludeList {
  _EmailFailedSignInJsonIncludeList._({
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmailFailedSignInJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailFailedSignIn.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailFailedSignIn.t;
}

class EmailFailedSignInRepository {
  const EmailFailedSignInRepository._();

  /// Returns a list of [EmailFailedSignIn]s matching the given query parameters.
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
  Future<List<EmailFailedSignIn>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailFailedSignIn] matching the given query parameters.
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
  Future<EmailFailedSignIn?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailFailedSignIn] by its [id] or null if no such row exists.
  Future<EmailFailedSignIn?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailFailedSignIn>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailFailedSignInTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailFailedSignIn.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailFailedSignInTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailFailedSignIn.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailFailedSignInTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailFailedSignIn>(
      id,
      transaction: transaction,
      select: select?.call(EmailFailedSignIn.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailFailedSignIn]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailFailedSignIn]s will have their `id` fields set.
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
  Future<List<EmailFailedSignIn>> insert(
    _is.DatabaseSession session,
    List<EmailFailedSignIn> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailFailedSignIn>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailFailedSignIn] and returns the inserted row.
  ///
  /// The returned [EmailFailedSignIn] will have its `id` field set.
  Future<EmailFailedSignIn> insertRow(
    _is.DatabaseSession session,
    EmailFailedSignIn row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailFailedSignIn]s in the list and returns the resulting rows.
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
  /// The returned [EmailFailedSignIn]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailFailedSignIn>> upsert(
    _is.DatabaseSession session,
    List<EmailFailedSignIn> rows, {
    required _is.ColumnSelections<EmailFailedSignInTable> conflictColumns,
    _is.ColumnSelections<EmailFailedSignInTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailFailedSignIn>(
      rows,
      conflictColumns: conflictColumns(EmailFailedSignIn.t),
      updateColumns: updateColumns?.call(EmailFailedSignIn.t),
      updateWhere: updateWhere?.call(EmailFailedSignIn.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailFailedSignIn] and returns the resulting row.
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
  /// The returned [EmailFailedSignIn] will have its `id` field set.
  Future<EmailFailedSignIn?> upsertRow(
    _is.DatabaseSession session,
    EmailFailedSignIn row, {
    required _is.ColumnSelections<EmailFailedSignInTable> conflictColumns,
    _is.ColumnSelections<EmailFailedSignInTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailFailedSignIn>(
      row,
      conflictColumns: conflictColumns(EmailFailedSignIn.t),
      updateColumns: updateColumns?.call(EmailFailedSignIn.t),
      updateWhere: updateWhere?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailFailedSignIn]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailFailedSignIn>> update(
    _is.DatabaseSession session,
    List<EmailFailedSignIn> rows, {
    _is.ColumnSelections<EmailFailedSignInTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailFailedSignIn>(
      rows,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailFailedSignIn]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailFailedSignIn> updateRow(
    _is.DatabaseSession session,
    EmailFailedSignIn row, {
    _is.ColumnSelections<EmailFailedSignInTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailFailedSignIn>(
      row,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailFailedSignIn] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailFailedSignIn?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailFailedSignInUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailFailedSignIn>(
      id,
      columnValues: columnValues(EmailFailedSignIn.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailFailedSignIn]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailFailedSignIn>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailFailedSignInUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmailFailedSignInTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailFailedSignIn>(
      columnValues: columnValues(EmailFailedSignIn.t.updateTable),
      where: where(EmailFailedSignIn.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailFailedSignIn]s in the list and returns the deleted rows.
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
  Future<List<EmailFailedSignIn>> delete(
    _is.DatabaseSession session,
    List<EmailFailedSignIn> rows, {
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      rows,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailFailedSignIn].
  Future<EmailFailedSignIn> deleteRow(
    _is.DatabaseSession session,
    EmailFailedSignIn row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailFailedSignIn>(
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
  Future<List<EmailFailedSignIn>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailFailedSignInTable> where,
    _is.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    _is.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailFailedSignIn] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailFailedSignInTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
