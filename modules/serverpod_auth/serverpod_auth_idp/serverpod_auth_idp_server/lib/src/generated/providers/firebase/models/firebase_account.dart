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

/// A fully configured Firebase account to be used for logins.
abstract class FirebaseAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FirebaseAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    this.email,
    this.phone,
    required this.userIdentifier,
  }) : created = created ?? DateTime.now();

  factory FirebaseAccount({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    required String userIdentifier,
  }) = _FirebaseAccountImpl;

  factory FirebaseAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return FirebaseAccount(
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
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = FirebaseAccountTable();

  static const db = FirebaseAccountRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime created;

  /// The verified email of the user, as received from Firebase.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  String? email;

  /// The phone number of the user, as received from Firebase.
  ///
  /// Only populated when using phone authentication.
  String? phone;

  /// The user identifier given by Firebase for this account.
  String userIdentifier;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FirebaseAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FirebaseAccount copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.FirebaseAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FirebaseAccountInclude include({
    _iacs.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<FirebaseAccountTable>? select,
  }) {
    return FirebaseAccountInclude._(
      authUser: authUser,
      selectedColumns: select?.call(FirebaseAccount.t),
    );
  }

  static FirebaseAccountIncludeList includeList({
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    FirebaseAccountInclude? include,
    _is.SelectColumnsBuilder<FirebaseAccountTable>? select,
  }) {
    return FirebaseAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      include: include,
      selectedColumns: select?.call(FirebaseAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FirebaseAccountImpl extends FirebaseAccount {
  _FirebaseAccountImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    required String userIdentifier,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         created: created,
         email: email,
         phone: phone,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [FirebaseAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FirebaseAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    String? userIdentifier,
  }) {
    return FirebaseAccount(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      created: created ?? this.created,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class FirebaseAccountUpdateTable extends _is.UpdateTable<FirebaseAccountTable> {
  FirebaseAccountUpdateTable(super.table);

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

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> phone(String? value) => _is.ColumnValue(
    table.phone,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class FirebaseAccountTable extends _is.Table<_is.UuidValue?> {
  FirebaseAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_firebase_account') {
    updateTable = FirebaseAccountUpdateTable(this);
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
    phone = _is.ColumnString(
      'phone',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final FirebaseAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime created;

  /// The verified email of the user, as received from Firebase.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  late final _is.ColumnString email;

  /// The phone number of the user, as received from Firebase.
  ///
  /// Only populated when using phone authentication.
  late final _is.ColumnString phone;

  /// The user identifier given by Firebase for this account.
  late final _is.ColumnString userIdentifier;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: FirebaseAccount.t.authUserId,
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
    phone,
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

class FirebaseAccountInclude extends _is.IncludeObject {
  FirebaseAccountInclude._({
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
  _is.Table<_is.UuidValue?> get table => FirebaseAccount.t;
}

class FirebaseAccountIncludeList extends _is.IncludeList {
  FirebaseAccountIncludeList._({
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(FirebaseAccount.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FirebaseAccount.t;
}

class FirebaseAccountRepository {
  const FirebaseAccountRepository._();

  final attachRow = const FirebaseAccountAttachRowRepository._();

  /// Returns a list of [FirebaseAccount]s matching the given query parameters.
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
  Future<List<FirebaseAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FirebaseAccount] matching the given query parameters.
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
  Future<FirebaseAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FirebaseAccount] by its [id] or null if no such row exists.
  Future<FirebaseAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FirebaseAccount>(
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
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.SelectColumnsBuilder<FirebaseAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(FirebaseAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.SelectColumnsBuilder<FirebaseAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(FirebaseAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    FirebaseAccountInclude? include,
    _is.SelectColumnsBuilder<FirebaseAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<FirebaseAccount>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(FirebaseAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FirebaseAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [FirebaseAccount]s will have their `id` fields set.
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
  Future<List<FirebaseAccount>> insert(
    _is.DatabaseSession session,
    List<FirebaseAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FirebaseAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FirebaseAccount] and returns the inserted row.
  ///
  /// The returned [FirebaseAccount] will have its `id` field set.
  Future<FirebaseAccount> insertRow(
    _is.DatabaseSession session,
    FirebaseAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FirebaseAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FirebaseAccount]s in the list and returns the resulting rows.
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
  /// The returned [FirebaseAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FirebaseAccount>> upsert(
    _is.DatabaseSession session,
    List<FirebaseAccount> rows, {
    required _is.ColumnSelections<FirebaseAccountTable> conflictColumns,
    _is.ColumnSelections<FirebaseAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<FirebaseAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FirebaseAccount>(
      rows,
      conflictColumns: conflictColumns(FirebaseAccount.t),
      updateColumns: updateColumns?.call(FirebaseAccount.t),
      updateWhere: updateWhere?.call(FirebaseAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FirebaseAccount] and returns the resulting row.
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
  /// The returned [FirebaseAccount] will have its `id` field set.
  Future<FirebaseAccount?> upsertRow(
    _is.DatabaseSession session,
    FirebaseAccount row, {
    required _is.ColumnSelections<FirebaseAccountTable> conflictColumns,
    _is.ColumnSelections<FirebaseAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<FirebaseAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FirebaseAccount>(
      row,
      conflictColumns: conflictColumns(FirebaseAccount.t),
      updateColumns: updateColumns?.call(FirebaseAccount.t),
      updateWhere: updateWhere?.call(FirebaseAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [FirebaseAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FirebaseAccount>> update(
    _is.DatabaseSession session,
    List<FirebaseAccount> rows, {
    _is.ColumnSelections<FirebaseAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FirebaseAccount>(
      rows,
      columns: columns?.call(FirebaseAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FirebaseAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FirebaseAccount> updateRow(
    _is.DatabaseSession session,
    FirebaseAccount row, {
    _is.ColumnSelections<FirebaseAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FirebaseAccount>(
      row,
      columns: columns?.call(FirebaseAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FirebaseAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FirebaseAccount?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FirebaseAccountUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FirebaseAccount>(
      id,
      columnValues: columnValues(FirebaseAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FirebaseAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FirebaseAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FirebaseAccountUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FirebaseAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FirebaseAccount>(
      columnValues: columnValues(FirebaseAccount.t.updateTable),
      where: where(FirebaseAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FirebaseAccount]s in the list and returns the deleted rows.
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
  Future<List<FirebaseAccount>> delete(
    _is.DatabaseSession session,
    List<FirebaseAccount> rows, {
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FirebaseAccount>(
      rows,
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FirebaseAccount].
  Future<FirebaseAccount> deleteRow(
    _is.DatabaseSession session,
    FirebaseAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FirebaseAccount>(
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
  Future<List<FirebaseAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FirebaseAccountTable> where,
    _is.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _is.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FirebaseAccount>(
      where: where(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FirebaseAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FirebaseAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FirebaseAccount>(
      where: where(FirebaseAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FirebaseAccountAttachRowRepository {
  const FirebaseAccountAttachRowRepository._();

  /// Creates a relation between the given [FirebaseAccount] and [AuthUser]
  /// by setting the [FirebaseAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    FirebaseAccount firebaseAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (firebaseAccount.id == null) {
      throw ArgumentError.notNull('firebaseAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $firebaseAccount = firebaseAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<FirebaseAccount>(
      $firebaseAccount,
      columns: [FirebaseAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
