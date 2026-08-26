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

/// A fully configured Google account to be used for logins.
abstract class GoogleAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  GoogleAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    required this.email,
    required this.userIdentifier,
  }) : created = created ?? DateTime.now();

  factory GoogleAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    required String email,
    required String userIdentifier,
  }) = _GoogleAccountImpl;

  factory GoogleAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleAccount(
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
      created: jsonSerialization['created'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = GoogleAccountTable();

  static const db = GoogleAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime created;

  /// The verified email of the user, as received from Google.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  String email;

  /// The user identifier given by Google for this account.
  String userIdentifier;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [GoogleAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GoogleAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.GoogleAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      'email': email,
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  /// Builds a complete [GoogleAccountInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static GoogleAccountInclude include({_iacs.AuthUserInclude? authUser}) {
    return GoogleAccountInclude._(authUser: authUser);
  }

  /// Builds a complete [GoogleAccountIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static GoogleAccountIncludeList includeList({
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    GoogleAccountInclude? include,
  }) {
    return GoogleAccountIncludeList._(
      where: where?.call(GoogleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [GoogleAccountJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static GoogleAccountJsonInclude includeJson({
    _iacs.AuthUserJsonInclude? authUser,
    _is.SelectColumnsBuilder<GoogleAccountTable>? select,
  }) {
    return _GoogleAccountJsonInclude._(
      authUser: authUser,
      selectedColumns: select?.call(GoogleAccount.t),
    );
  }

  /// Builds a JSON-compatible [GoogleAccountJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static GoogleAccountJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    GoogleAccountJsonInclude? include,
    _is.SelectColumnsBuilder<GoogleAccountTable>? select,
  }) {
    return _GoogleAccountJsonIncludeList._(
      where: where?.call(GoogleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      include: include,
      selectedColumns: select?.call(GoogleAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleAccountImpl extends GoogleAccount {
  _GoogleAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    required String email,
    required String userIdentifier,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         created: created,
         email: email,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [GoogleAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GoogleAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    String? email,
    String? userIdentifier,
  }) {
    return GoogleAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      created: created ?? this.created,
      email: email ?? this.email,
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class GoogleAccountUpdateTable extends _is.UpdateTable<GoogleAccountTable> {
  GoogleAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> created(DateTime value) =>
      _is.ColumnValue(
        table.created,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class GoogleAccountTable extends _is.Table<_is.UuidValue?> {
  GoogleAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_google_account') {
    updateTable = GoogleAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    created = _is.ColumnDateTime(
      'created',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final GoogleAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime created;

  /// The verified email of the user, as received from Google.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  /// The user identifier given by Google for this account.
  late final _is.ColumnString userIdentifier;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: GoogleAccount.t.authUserId,
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
    created,
    email,
    userIdentifier,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

abstract interface class GoogleAccountJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class GoogleAccountJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class GoogleAccountInclude extends _is.IncludeObject
    implements GoogleAccountJsonInclude, _is.FullModelInclude {
  GoogleAccountInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => GoogleAccount.t;
}

final class GoogleAccountIncludeList extends _is.IncludeList
    implements GoogleAccountJsonIncludeList, _is.FullModelInclude {
  GoogleAccountIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    GoogleAccountInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => GoogleAccount.t;
}

final class _GoogleAccountJsonInclude extends _is.IncludeObject
    implements GoogleAccountJsonInclude {
  _GoogleAccountJsonInclude._({
    _iacs.AuthUserJsonInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _iacs.AuthUserJsonInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => GoogleAccount.t;
}

final class _GoogleAccountJsonIncludeList extends _is.IncludeList
    implements GoogleAccountJsonIncludeList {
  _GoogleAccountJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    GoogleAccountJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => GoogleAccount.t;
}

class GoogleAccountRepository {
  const GoogleAccountRepository._();

  final attachRow = const GoogleAccountAttachRowRepository._();

  /// Returns a list of [GoogleAccount]s matching the given query parameters.
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
  Future<List<GoogleAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    GoogleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GoogleAccount] matching the given query parameters.
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
  Future<GoogleAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    GoogleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GoogleAccount] by its [id] or null if no such row exists.
  Future<GoogleAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    GoogleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GoogleAccount>(
      id,
      transaction: transaction,
      include: include,
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
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    GoogleAccountJsonInclude? include,
    _is.SelectColumnsBuilder<GoogleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(GoogleAccount.t),
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
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    GoogleAccountJsonInclude? include,
    _is.SelectColumnsBuilder<GoogleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(GoogleAccount.t),
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
    GoogleAccountJsonInclude? include,
    _is.SelectColumnsBuilder<GoogleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<GoogleAccount>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(GoogleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GoogleAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [GoogleAccount]s will have their `id` fields set.
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
  Future<List<GoogleAccount>> insert(
    _is.DatabaseSession session,
    List<GoogleAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GoogleAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GoogleAccount] and returns the inserted row.
  ///
  /// The returned [GoogleAccount] will have its `id` field set.
  Future<GoogleAccount> insertRow(
    _is.DatabaseSession session,
    GoogleAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<GoogleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GoogleAccount]s in the list and returns the resulting rows.
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
  /// The returned [GoogleAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GoogleAccount>> upsert(
    _is.DatabaseSession session,
    List<GoogleAccount> rows, {
    required _is.ColumnSelections<GoogleAccountTable> conflictColumns,
    _is.ColumnSelections<GoogleAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<GoogleAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GoogleAccount>(
      rows,
      conflictColumns: conflictColumns(GoogleAccount.t),
      updateColumns: updateColumns?.call(GoogleAccount.t),
      updateWhere: updateWhere?.call(GoogleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GoogleAccount] and returns the resulting row.
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
  /// The returned [GoogleAccount] will have its `id` field set.
  Future<GoogleAccount?> upsertRow(
    _is.DatabaseSession session,
    GoogleAccount row, {
    required _is.ColumnSelections<GoogleAccountTable> conflictColumns,
    _is.ColumnSelections<GoogleAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<GoogleAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GoogleAccount>(
      row,
      conflictColumns: conflictColumns(GoogleAccount.t),
      updateColumns: updateColumns?.call(GoogleAccount.t),
      updateWhere: updateWhere?.call(GoogleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [GoogleAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GoogleAccount>> update(
    _is.DatabaseSession session,
    List<GoogleAccount> rows, {
    _is.ColumnSelections<GoogleAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GoogleAccount>(
      rows,
      columns: columns?.call(GoogleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GoogleAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GoogleAccount> updateRow(
    _is.DatabaseSession session,
    GoogleAccount row, {
    _is.ColumnSelections<GoogleAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<GoogleAccount>(
      row,
      columns: columns?.call(GoogleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GoogleAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<GoogleAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<GoogleAccount>(
      id,
      columnValues: columnValues(GoogleAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GoogleAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GoogleAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GoogleAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<GoogleAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GoogleAccount>(
      columnValues: columnValues(GoogleAccount.t.updateTable),
      where: where(GoogleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GoogleAccount]s in the list and returns the deleted rows.
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
  Future<List<GoogleAccount>> delete(
    _is.DatabaseSession session,
    List<GoogleAccount> rows, {
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GoogleAccount>(
      rows,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GoogleAccount].
  Future<GoogleAccount> deleteRow(
    _is.DatabaseSession session,
    GoogleAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GoogleAccount>(
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
  Future<List<GoogleAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GoogleAccountTable> where,
    _is.OrderByBuilder<GoogleAccountTable>? orderBy,
    _is.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GoogleAccount>(
      where: where(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GoogleAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GoogleAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GoogleAccount>(
      where: where(GoogleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GoogleAccountAttachRowRepository {
  const GoogleAccountAttachRowRepository._();

  /// Creates a relation between the given [GoogleAccount] and [AuthUser]
  /// by setting the [GoogleAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    GoogleAccount googleAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (googleAccount.id == null) {
      throw ArgumentError.notNull('googleAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $googleAccount = googleAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<GoogleAccount>(
      $googleAccount,
      columns: [GoogleAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
