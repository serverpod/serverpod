/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;

/// A fully configured email account to be used for logins.
abstract class EmailAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  EmailAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    required this.email,
    required this.passwordHash,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EmailAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    required String email,
    required String passwordHash,
  }) = _EmailAccountImpl;

  factory EmailAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
    );
  }

  static final t = EmailAccountTable();

  static const db = EmailAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String email;

  /// The hashed password of the user.
  ///
  /// Stored in PHC format: $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  String passwordHash;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    String? email,
    String? passwordHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountInclude include({
    _iacs.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<EmailAccountTable>? select,
  }) {
    return EmailAccountInclude.internal_(
      authUser: authUser,
      selectedColumns: select?.call(EmailAccount.t),
    );
  }

  static EmailAccountIncludeList includeList({
    _is.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    EmailAccountInclude? include,
    _is.SelectColumnsBuilder<EmailAccountTable>? select,
  }) {
    return EmailAccountIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      include: include,
      selectedColumns: select?.call(EmailAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountImpl extends EmailAccount {
  _EmailAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    required String email,
    required String passwordHash,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
         email: email,
         passwordHash: passwordHash,
       );

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    String? email,
    String? passwordHash,
  }) {
    return EmailAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}

class EmailAccountUpdateTable extends _is.UpdateTable<EmailAccountTable> {
  EmailAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> passwordHash(String value) => _is.ColumnValue(
    table.passwordHash,
    value,
  );
}

class EmailAccountTable extends _is.Table<_is.UuidValue?> {
  EmailAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account') {
    updateTable = EmailAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    passwordHash = _is.ColumnString(
      'passwordHash',
      this,
    );
  }

  late final EmailAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  /// The hashed password of the user.
  ///
  /// Stored in PHC format: $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  late final _is.ColumnString passwordHash;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: EmailAccount.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    createdAt,
    email,
    passwordHash,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class EmailAccountInclude extends _is.IncludeObject {
  EmailAccountInclude.internal_({
    _iacs.AuthUserInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccount.t;
}

class EmailAccountIncludeList extends _is.IncludeList {
  EmailAccountIncludeList.internal_({
    _is.WhereExpressionBuilder<EmailAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmailAccount.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EmailAccount.t;
}

class EmailAccountRepository {
  const EmailAccountRepository._();

  final attachRow = const EmailAccountAttachRowRepository._();

  /// Returns a list of [EmailAccount]s matching the given query parameters.
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
  Future<List<EmailAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailAccount] matching the given query parameters.
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
  Future<EmailAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    _is.Transaction? transaction,
    EmailAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailAccount] by its [id] or null if no such row exists.
  Future<EmailAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    EmailAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccount]s will have their `id` fields set.
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
  Future<List<EmailAccount>> insert(
    _is.DatabaseSession session,
    List<EmailAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailAccount] and returns the inserted row.
  ///
  /// The returned [EmailAccount] will have its `id` field set.
  Future<EmailAccount> insertRow(
    _is.DatabaseSession session,
    EmailAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailAccount]s in the list and returns the resulting rows.
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
  /// The returned [EmailAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccount>> upsert(
    _is.DatabaseSession session,
    List<EmailAccount> rows, {
    required _is.ColumnSelections<EmailAccountTable> conflictColumns,
    _is.ColumnSelections<EmailAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailAccount>(
      rows,
      conflictColumns: conflictColumns(EmailAccount.t),
      updateColumns: updateColumns?.call(EmailAccount.t),
      updateWhere: updateWhere?.call(EmailAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailAccount] and returns the resulting row.
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
  /// The returned [EmailAccount] will have its `id` field set.
  Future<EmailAccount?> upsertRow(
    _is.DatabaseSession session,
    EmailAccount row, {
    required _is.ColumnSelections<EmailAccountTable> conflictColumns,
    _is.ColumnSelections<EmailAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailAccount>(
      row,
      conflictColumns: conflictColumns(EmailAccount.t),
      updateColumns: updateColumns?.call(EmailAccount.t),
      updateWhere: updateWhere?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccount>> update(
    _is.DatabaseSession session,
    List<EmailAccount> rows, {
    _is.ColumnSelections<EmailAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailAccount>(
      rows,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccount> updateRow(
    _is.DatabaseSession session,
    EmailAccount row, {
    _is.ColumnSelections<EmailAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccount>(
      row,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<EmailAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccount>(
      id,
      columnValues: columnValues(EmailAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EmailAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailAccount>(
      columnValues: columnValues(EmailAccount.t.updateTable),
      where: where(EmailAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailAccount]s in the list and returns the deleted rows.
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
  Future<List<EmailAccount>> delete(
    _is.DatabaseSession session,
    List<EmailAccount> rows, {
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailAccount>(
      rows,
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailAccount].
  Future<EmailAccount> deleteRow(
    _is.DatabaseSession session,
    EmailAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccount>(
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
  Future<List<EmailAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountTable> where,
    _is.OrderByBuilder<EmailAccountTable>? orderBy,
    _is.OrderByListBuilder<EmailAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailAccount>(
      where: where(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccount>(
      where: where?.call(EmailAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailAccount>(
      where: where(EmailAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EmailAccountAttachRowRepository {
  const EmailAccountAttachRowRepository._();

  /// Creates a relation between the given [EmailAccount] and [AuthUser]
  /// by setting the [EmailAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    EmailAccount emailAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (emailAccount.id == null) {
      throw ArgumentError.notNull('emailAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $emailAccount = emailAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<EmailAccount>(
      $emailAccount,
      columns: [EmailAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
