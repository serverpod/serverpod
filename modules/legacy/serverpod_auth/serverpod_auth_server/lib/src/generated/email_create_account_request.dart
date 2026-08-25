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

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class EmailCreateAccountRequest
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailCreateAccountRequest._({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

  factory EmailCreateAccountRequest({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) = _EmailCreateAccountRequestImpl;

  factory EmailCreateAccountRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailCreateAccountRequest(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String,
      hash: jsonSerialization['hash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  static final t = EmailCreateAccountRequestTable();

  static const db = EmailCreateAccountRequestRepository._();

  @override
  int? id;

  /// The name of the user.
  String userName;

  /// The email of the user.
  String email;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailCreateAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.EmailCreateAccountRequest',
      if (id != null) 'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.EmailCreateAccountRequest',
      if (id != null) 'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  static EmailCreateAccountRequestInclude include({
    _is.SelectColumnsBuilder<EmailCreateAccountRequestTable>? select,
  }) {
    return EmailCreateAccountRequestInclude._(
      selectedColumns: select?.call(EmailCreateAccountRequest.t),
    );
  }

  static EmailCreateAccountRequestIncludeList includeList({
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    EmailCreateAccountRequestInclude? include,
    _is.SelectColumnsBuilder<EmailCreateAccountRequestTable>? select,
  }) {
    return EmailCreateAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      include: include,
      selectedColumns: select?.call(EmailCreateAccountRequest.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailCreateAccountRequestImpl extends EmailCreateAccountRequest {
  _EmailCreateAccountRequestImpl({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) : super._(
         id: id,
         userName: userName,
         email: email,
         hash: hash,
         verificationCode: verificationCode,
       );

  /// Returns a shallow copy of this [EmailCreateAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailCreateAccountRequest copyWith({
    Object? id = _Undefined,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  }) {
    return EmailCreateAccountRequest(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}

class EmailCreateAccountRequestUpdateTable
    extends _is.UpdateTable<EmailCreateAccountRequestTable> {
  EmailCreateAccountRequestUpdateTable(super.table);

  _is.ColumnValue<String, String> userName(String value) => _is.ColumnValue(
    table.userName,
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

  _is.ColumnValue<String, String> verificationCode(String value) =>
      _is.ColumnValue(
        table.verificationCode,
        value,
      );
}

class EmailCreateAccountRequestTable extends _is.Table<int?> {
  EmailCreateAccountRequestTable({super.tableRelation})
    : super(tableName: 'serverpod_email_create_request') {
    updateTable = EmailCreateAccountRequestUpdateTable(this);
    userName = _is.ColumnString(
      'userName',
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
    verificationCode = _is.ColumnString(
      'verificationCode',
      this,
    );
  }

  late final EmailCreateAccountRequestUpdateTable updateTable;

  /// The name of the user.
  late final _is.ColumnString userName;

  /// The email of the user.
  late final _is.ColumnString email;

  /// Hash of the user's requested password.
  late final _is.ColumnString hash;

  /// The verification code sent to the user.
  late final _is.ColumnString verificationCode;

  @override
  List<_is.Column> get columns => [
    id,
    userName,
    email,
    hash,
    verificationCode,
  ];
}

class EmailCreateAccountRequestInclude extends _is.IncludeObject {
  EmailCreateAccountRequestInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailCreateAccountRequest.t;
}

class EmailCreateAccountRequestIncludeList extends _is.IncludeList {
  EmailCreateAccountRequestIncludeList._({
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailCreateAccountRequest.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailCreateAccountRequest.t;
}

class EmailCreateAccountRequestRepository {
  const EmailCreateAccountRequestRepository._();

  /// Returns a list of [EmailCreateAccountRequest]s matching the given query parameters.
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
  Future<List<EmailCreateAccountRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailCreateAccountRequest] matching the given query parameters.
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
  Future<EmailCreateAccountRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailCreateAccountRequest] by its [id] or null if no such row exists.
  Future<EmailCreateAccountRequest?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailCreateAccountRequest>(
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
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailCreateAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailCreateAccountRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmailCreateAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmailCreateAccountRequest.t),
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
    _is.SelectColumnsBuilder<EmailCreateAccountRequestTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmailCreateAccountRequest>(
      id,
      transaction: transaction,
      select: select?.call(EmailCreateAccountRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailCreateAccountRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailCreateAccountRequest]s will have their `id` fields set.
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
  Future<List<EmailCreateAccountRequest>> insert(
    _is.DatabaseSession session,
    List<EmailCreateAccountRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailCreateAccountRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailCreateAccountRequest] and returns the inserted row.
  ///
  /// The returned [EmailCreateAccountRequest] will have its `id` field set.
  Future<EmailCreateAccountRequest> insertRow(
    _is.DatabaseSession session,
    EmailCreateAccountRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailCreateAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailCreateAccountRequest]s in the list and returns the resulting rows.
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
  /// The returned [EmailCreateAccountRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailCreateAccountRequest>> upsert(
    _is.DatabaseSession session,
    List<EmailCreateAccountRequest> rows, {
    required _is.ColumnSelections<EmailCreateAccountRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailCreateAccountRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailCreateAccountRequest>(
      rows,
      conflictColumns: conflictColumns(EmailCreateAccountRequest.t),
      updateColumns: updateColumns?.call(EmailCreateAccountRequest.t),
      updateWhere: updateWhere?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailCreateAccountRequest] and returns the resulting row.
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
  /// The returned [EmailCreateAccountRequest] will have its `id` field set.
  Future<EmailCreateAccountRequest?> upsertRow(
    _is.DatabaseSession session,
    EmailCreateAccountRequest row, {
    required _is.ColumnSelections<EmailCreateAccountRequestTable>
    conflictColumns,
    _is.ColumnSelections<EmailCreateAccountRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailCreateAccountRequest>(
      row,
      conflictColumns: conflictColumns(EmailCreateAccountRequest.t),
      updateColumns: updateColumns?.call(EmailCreateAccountRequest.t),
      updateWhere: updateWhere?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailCreateAccountRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailCreateAccountRequest>> update(
    _is.DatabaseSession session,
    List<EmailCreateAccountRequest> rows, {
    _is.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailCreateAccountRequest>(
      rows,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailCreateAccountRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailCreateAccountRequest> updateRow(
    _is.DatabaseSession session,
    EmailCreateAccountRequest row, {
    _is.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailCreateAccountRequest>(
      row,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailCreateAccountRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailCreateAccountRequest?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailCreateAccountRequestUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailCreateAccountRequest>(
      id,
      columnValues: columnValues(EmailCreateAccountRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailCreateAccountRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailCreateAccountRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailCreateAccountRequestUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailCreateAccountRequest>(
      columnValues: columnValues(EmailCreateAccountRequest.t.updateTable),
      where: where(EmailCreateAccountRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailCreateAccountRequest]s in the list and returns the deleted rows.
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
  Future<List<EmailCreateAccountRequest>> delete(
    _is.DatabaseSession session,
    List<EmailCreateAccountRequest> rows, {
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailCreateAccountRequest>(
      rows,
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailCreateAccountRequest].
  Future<EmailCreateAccountRequest> deleteRow(
    _is.DatabaseSession session,
    EmailCreateAccountRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailCreateAccountRequest>(
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
  Future<List<EmailCreateAccountRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    _is.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    _is.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailCreateAccountRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
