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

/// A fully configured Facebook account to be used for logins.\
abstract class FacebookAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FacebookAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    required this.userIdentifier,
    this.email,
    this.fullName,
    this.firstName,
    this.lastName,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FacebookAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    required String userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  }) = _FacebookAccountImpl;

  factory FacebookAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return FacebookAccount(
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
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
    );
  }

  static final t = FacebookAccountTable();

  static const db = FacebookAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The Facebook-provided user identifier (Facebook User ID).
  String userIdentifier;

  /// The verified email of the user, as received from Facebook.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups and user profile creation.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user hasn't granted email permission.
  String? email;

  /// The user's full name from Facebook.
  ///
  /// Combined first and last name as provided by Facebook.
  String? fullName;

  /// The user's first name from Facebook.
  String? firstName;

  /// The user's last name from Facebook.
  String? lastName;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FacebookAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FacebookAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    String? userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.FacebookAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      'userIdentifier': userIdentifier,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FacebookAccountInclude include({
    _iacs.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<FacebookAccountTable>? select,
  }) {
    return FacebookAccountInclude.internal_(
      authUser: authUser,
      selectedColumns: select?.call(FacebookAccount.t),
    );
  }

  static FacebookAccountIncludeList includeList({
    _is.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    FacebookAccountInclude? include,
    _is.SelectColumnsBuilder<FacebookAccountTable>? select,
  }) {
    return FacebookAccountIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      include: include,
      selectedColumns: select?.call(FacebookAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FacebookAccountImpl extends FacebookAccount {
  _FacebookAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? createdAt,
    required String userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
         userIdentifier: userIdentifier,
         email: email,
         fullName: fullName,
         firstName: firstName,
         lastName: lastName,
       );

  /// Returns a shallow copy of this [FacebookAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FacebookAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    String? userIdentifier,
    Object? email = _Undefined,
    Object? fullName = _Undefined,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
  }) {
    return FacebookAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email is String? ? email : this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
    );
  }
}

class FacebookAccountUpdateTable extends _is.UpdateTable<FacebookAccountTable> {
  FacebookAccountUpdateTable(super.table);

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

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> fullName(String? value) => _is.ColumnValue(
    table.fullName,
    value,
  );

  _is.ColumnValue<String, String> firstName(String? value) => _is.ColumnValue(
    table.firstName,
    value,
  );

  _is.ColumnValue<String, String> lastName(String? value) => _is.ColumnValue(
    table.lastName,
    value,
  );
}

class FacebookAccountTable extends _is.Table<_is.UuidValue?> {
  FacebookAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_facebook_account') {
    updateTable = FacebookAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    fullName = _is.ColumnString(
      'fullName',
      this,
    );
    firstName = _is.ColumnString(
      'firstName',
      this,
    );
    lastName = _is.ColumnString(
      'lastName',
      this,
    );
  }

  late final FacebookAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime createdAt;

  /// The Facebook-provided user identifier (Facebook User ID).
  late final _is.ColumnString userIdentifier;

  /// The verified email of the user, as received from Facebook.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups and user profile creation.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user hasn't granted email permission.
  late final _is.ColumnString email;

  /// The user's full name from Facebook.
  ///
  /// Combined first and last name as provided by Facebook.
  late final _is.ColumnString fullName;

  /// The user's first name from Facebook.
  late final _is.ColumnString firstName;

  /// The user's last name from Facebook.
  late final _is.ColumnString lastName;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: FacebookAccount.t.authUserId,
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
    userIdentifier,
    email,
    fullName,
    firstName,
    lastName,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class FacebookAccountInclude extends _is.IncludeObject {
  FacebookAccountInclude.internal_({
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
  _is.Table<_is.UuidValue?> get table => FacebookAccount.t;
}

class FacebookAccountIncludeList extends _is.IncludeList {
  FacebookAccountIncludeList.internal_({
    _is.WhereExpressionBuilder<FacebookAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(FacebookAccount.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FacebookAccount.t;
}

class FacebookAccountRepository {
  const FacebookAccountRepository._();

  final attachRow = const FacebookAccountAttachRowRepository._();

  /// Returns a list of [FacebookAccount]s matching the given query parameters.
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
  Future<List<FacebookAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _is.Transaction? transaction,
    FacebookAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FacebookAccount] matching the given query parameters.
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
  Future<FacebookAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _is.Transaction? transaction,
    FacebookAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FacebookAccount] by its [id] or null if no such row exists.
  Future<FacebookAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    FacebookAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FacebookAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FacebookAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [FacebookAccount]s will have their `id` fields set.
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
  Future<List<FacebookAccount>> insert(
    _is.DatabaseSession session,
    List<FacebookAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FacebookAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FacebookAccount] and returns the inserted row.
  ///
  /// The returned [FacebookAccount] will have its `id` field set.
  Future<FacebookAccount> insertRow(
    _is.DatabaseSession session,
    FacebookAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FacebookAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FacebookAccount]s in the list and returns the resulting rows.
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
  /// The returned [FacebookAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FacebookAccount>> upsert(
    _is.DatabaseSession session,
    List<FacebookAccount> rows, {
    required _is.ColumnSelections<FacebookAccountTable> conflictColumns,
    _is.ColumnSelections<FacebookAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<FacebookAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FacebookAccount>(
      rows,
      conflictColumns: conflictColumns(FacebookAccount.t),
      updateColumns: updateColumns?.call(FacebookAccount.t),
      updateWhere: updateWhere?.call(FacebookAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FacebookAccount] and returns the resulting row.
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
  /// The returned [FacebookAccount] will have its `id` field set.
  Future<FacebookAccount?> upsertRow(
    _is.DatabaseSession session,
    FacebookAccount row, {
    required _is.ColumnSelections<FacebookAccountTable> conflictColumns,
    _is.ColumnSelections<FacebookAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<FacebookAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FacebookAccount>(
      row,
      conflictColumns: conflictColumns(FacebookAccount.t),
      updateColumns: updateColumns?.call(FacebookAccount.t),
      updateWhere: updateWhere?.call(FacebookAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [FacebookAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FacebookAccount>> update(
    _is.DatabaseSession session,
    List<FacebookAccount> rows, {
    _is.ColumnSelections<FacebookAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FacebookAccount>(
      rows,
      columns: columns?.call(FacebookAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FacebookAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FacebookAccount> updateRow(
    _is.DatabaseSession session,
    FacebookAccount row, {
    _is.ColumnSelections<FacebookAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FacebookAccount>(
      row,
      columns: columns?.call(FacebookAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FacebookAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FacebookAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FacebookAccountUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FacebookAccount>(
      id,
      columnValues: columnValues(FacebookAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FacebookAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FacebookAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FacebookAccountUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FacebookAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FacebookAccount>(
      columnValues: columnValues(FacebookAccount.t.updateTable),
      where: where(FacebookAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FacebookAccount]s in the list and returns the deleted rows.
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
  Future<List<FacebookAccount>> delete(
    _is.DatabaseSession session,
    List<FacebookAccount> rows, {
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FacebookAccount>(
      rows,
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FacebookAccount].
  Future<FacebookAccount> deleteRow(
    _is.DatabaseSession session,
    FacebookAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FacebookAccount>(
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
  Future<List<FacebookAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FacebookAccountTable> where,
    _is.OrderByBuilder<FacebookAccountTable>? orderBy,
    _is.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FacebookAccount>(
      where: where(FacebookAccount.t),
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FacebookAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FacebookAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FacebookAccount>(
      where: where(FacebookAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FacebookAccountAttachRowRepository {
  const FacebookAccountAttachRowRepository._();

  /// Creates a relation between the given [FacebookAccount] and [AuthUser]
  /// by setting the [FacebookAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    FacebookAccount facebookAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (facebookAccount.id == null) {
      throw ArgumentError.notNull('facebookAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $facebookAccount = facebookAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<FacebookAccount>(
      $facebookAccount,
      columns: [FacebookAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
