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
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart'
    as _isg9n5v0;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

abstract class LegacyExternalUserIdentifier
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  LegacyExternalUserIdentifier._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
  });

  factory LegacyExternalUserIdentifier({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String userIdentifier,
  }) = _LegacyExternalUserIdentifierImpl;

  factory LegacyExternalUserIdentifier.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LegacyExternalUserIdentifier(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _isg9n5v0.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = LegacyExternalUserIdentifierTable();

  static const db = LegacyExternalUserIdentifierRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _iacs.AuthUser? authUser;

  /// The user identifier as imported from `serverpod_auth`.
  ///
  /// This could be an external user ID for e.g. "Sign in with Apple", or an
  /// email address (in the Google Sign-In case).
  String userIdentifier;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LegacyExternalUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LegacyExternalUserIdentifier copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacyExternalUserIdentifier',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  /// Builds a complete [LegacyExternalUserIdentifierInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static LegacyExternalUserIdentifierInclude include({
    _iacs.AuthUserInclude? authUser,
  }) {
    return LegacyExternalUserIdentifierInclude._(authUser: authUser);
  }

  /// Builds a complete [LegacyExternalUserIdentifierIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static LegacyExternalUserIdentifierIncludeList includeList({
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    LegacyExternalUserIdentifierInclude? include,
  }) {
    return LegacyExternalUserIdentifierIncludeList._(
      where: where?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [LegacyExternalUserIdentifierJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static LegacyExternalUserIdentifierJsonInclude includeJson({
    _iacs.AuthUserJsonInclude? authUser,
    _is.SelectColumnsBuilder<LegacyExternalUserIdentifierTable>? select,
  }) {
    return _LegacyExternalUserIdentifierJsonInclude._(
      authUser: authUser,
      selectedColumns: select?.call(LegacyExternalUserIdentifier.t),
    );
  }

  /// Builds a JSON-compatible [LegacyExternalUserIdentifierJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static LegacyExternalUserIdentifierJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    LegacyExternalUserIdentifierJsonInclude? include,
    _is.SelectColumnsBuilder<LegacyExternalUserIdentifierTable>? select,
  }) {
    return _LegacyExternalUserIdentifierJsonIncludeList._(
      where: where?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      include: include,
      selectedColumns: select?.call(LegacyExternalUserIdentifier.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyExternalUserIdentifierImpl extends LegacyExternalUserIdentifier {
  _LegacyExternalUserIdentifierImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String userIdentifier,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [LegacyExternalUserIdentifier]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LegacyExternalUserIdentifier copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
  }) {
    return LegacyExternalUserIdentifier(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class LegacyExternalUserIdentifierUpdateTable
    extends _is.UpdateTable<LegacyExternalUserIdentifierTable> {
  LegacyExternalUserIdentifierUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class LegacyExternalUserIdentifierTable extends _is.Table<_is.UuidValue?> {
  LegacyExternalUserIdentifierTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_bridge_external_user_id') {
    updateTable = LegacyExternalUserIdentifierUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final LegacyExternalUserIdentifierUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _iacs.AuthUserTable? _authUser;

  /// The user identifier as imported from `serverpod_auth`.
  ///
  /// This could be an external user ID for e.g. "Sign in with Apple", or an
  /// email address (in the Google Sign-In case).
  late final _is.ColumnString userIdentifier;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: LegacyExternalUserIdentifier.t.authUserId,
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

abstract interface class LegacyExternalUserIdentifierJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class LegacyExternalUserIdentifierJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class LegacyExternalUserIdentifierInclude extends _is.IncludeObject
    implements LegacyExternalUserIdentifierJsonInclude, _is.FullModelInclude {
  LegacyExternalUserIdentifierInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

final class LegacyExternalUserIdentifierIncludeList extends _is.IncludeList
    implements
        LegacyExternalUserIdentifierJsonIncludeList,
        _is.FullModelInclude {
  LegacyExternalUserIdentifierIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    LegacyExternalUserIdentifierInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

final class _LegacyExternalUserIdentifierJsonInclude extends _is.IncludeObject
    implements LegacyExternalUserIdentifierJsonInclude {
  _LegacyExternalUserIdentifierJsonInclude._({
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
  _is.Table<_is.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

final class _LegacyExternalUserIdentifierJsonIncludeList extends _is.IncludeList
    implements LegacyExternalUserIdentifierJsonIncludeList {
  _LegacyExternalUserIdentifierJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    LegacyExternalUserIdentifierJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => LegacyExternalUserIdentifier.t;
}

class LegacyExternalUserIdentifierRepository {
  const LegacyExternalUserIdentifierRepository._();

  final attachRow = const LegacyExternalUserIdentifierAttachRowRepository._();

  /// Returns a list of [LegacyExternalUserIdentifier]s matching the given query parameters.
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
  Future<List<LegacyExternalUserIdentifier>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LegacyExternalUserIdentifier] matching the given query parameters.
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
  Future<LegacyExternalUserIdentifier?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LegacyExternalUserIdentifier] by its [id] or null if no such row exists.
  Future<LegacyExternalUserIdentifier?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    LegacyExternalUserIdentifierInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LegacyExternalUserIdentifier>(
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
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    LegacyExternalUserIdentifierJsonInclude? include,
    _is.SelectColumnsBuilder<LegacyExternalUserIdentifierTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(LegacyExternalUserIdentifier.t),
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
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    LegacyExternalUserIdentifierJsonInclude? include,
    _is.SelectColumnsBuilder<LegacyExternalUserIdentifierTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(LegacyExternalUserIdentifier.t),
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
    LegacyExternalUserIdentifierJsonInclude? include,
    _is.SelectColumnsBuilder<LegacyExternalUserIdentifierTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<LegacyExternalUserIdentifier>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(LegacyExternalUserIdentifier.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LegacyExternalUserIdentifier]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacyExternalUserIdentifier]s will have their `id` fields set.
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
  Future<List<LegacyExternalUserIdentifier>> insert(
    _is.DatabaseSession session,
    List<LegacyExternalUserIdentifier> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LegacyExternalUserIdentifier>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LegacyExternalUserIdentifier] and returns the inserted row.
  ///
  /// The returned [LegacyExternalUserIdentifier] will have its `id` field set.
  Future<LegacyExternalUserIdentifier> insertRow(
    _is.DatabaseSession session,
    LegacyExternalUserIdentifier row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacyExternalUserIdentifier>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LegacyExternalUserIdentifier]s in the list and returns the resulting rows.
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
  /// The returned [LegacyExternalUserIdentifier]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacyExternalUserIdentifier>> upsert(
    _is.DatabaseSession session,
    List<LegacyExternalUserIdentifier> rows, {
    required _is.ColumnSelections<LegacyExternalUserIdentifierTable>
    conflictColumns,
    _is.ColumnSelections<LegacyExternalUserIdentifierTable>? updateColumns,
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LegacyExternalUserIdentifier>(
      rows,
      conflictColumns: conflictColumns(LegacyExternalUserIdentifier.t),
      updateColumns: updateColumns?.call(LegacyExternalUserIdentifier.t),
      updateWhere: updateWhere?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LegacyExternalUserIdentifier] and returns the resulting row.
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
  /// The returned [LegacyExternalUserIdentifier] will have its `id` field set.
  Future<LegacyExternalUserIdentifier?> upsertRow(
    _is.DatabaseSession session,
    LegacyExternalUserIdentifier row, {
    required _is.ColumnSelections<LegacyExternalUserIdentifierTable>
    conflictColumns,
    _is.ColumnSelections<LegacyExternalUserIdentifierTable>? updateColumns,
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LegacyExternalUserIdentifier>(
      row,
      conflictColumns: conflictColumns(LegacyExternalUserIdentifier.t),
      updateColumns: updateColumns?.call(LegacyExternalUserIdentifier.t),
      updateWhere: updateWhere?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Updates all [LegacyExternalUserIdentifier]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacyExternalUserIdentifier>> update(
    _is.DatabaseSession session,
    List<LegacyExternalUserIdentifier> rows, {
    _is.ColumnSelections<LegacyExternalUserIdentifierTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LegacyExternalUserIdentifier>(
      rows,
      columns: columns?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LegacyExternalUserIdentifier]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacyExternalUserIdentifier> updateRow(
    _is.DatabaseSession session,
    LegacyExternalUserIdentifier row, {
    _is.ColumnSelections<LegacyExternalUserIdentifierTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacyExternalUserIdentifier>(
      row,
      columns: columns?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacyExternalUserIdentifier] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegacyExternalUserIdentifier?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LegacyExternalUserIdentifierUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LegacyExternalUserIdentifier>(
      id,
      columnValues: columnValues(LegacyExternalUserIdentifier.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegacyExternalUserIdentifier]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegacyExternalUserIdentifier>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LegacyExternalUserIdentifierUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LegacyExternalUserIdentifier>(
      columnValues: columnValues(LegacyExternalUserIdentifier.t.updateTable),
      where: where(LegacyExternalUserIdentifier.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LegacyExternalUserIdentifier]s in the list and returns the deleted rows.
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
  Future<List<LegacyExternalUserIdentifier>> delete(
    _is.DatabaseSession session,
    List<LegacyExternalUserIdentifier> rows, {
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LegacyExternalUserIdentifier>(
      rows,
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LegacyExternalUserIdentifier].
  Future<LegacyExternalUserIdentifier> deleteRow(
    _is.DatabaseSession session,
    LegacyExternalUserIdentifier row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacyExternalUserIdentifier>(
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
  Future<List<LegacyExternalUserIdentifier>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>
    where,
    _is.OrderByBuilder<LegacyExternalUserIdentifierTable>? orderBy,
    _is.OrderByListBuilder<LegacyExternalUserIdentifierTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LegacyExternalUserIdentifier>(
      where: where(LegacyExternalUserIdentifier.t),
      orderBy: orderBy?.call(LegacyExternalUserIdentifier.t),
      orderByList: orderByList?.call(LegacyExternalUserIdentifier.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LegacyExternalUserIdentifier>(
      where: where?.call(LegacyExternalUserIdentifier.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LegacyExternalUserIdentifier] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegacyExternalUserIdentifierTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LegacyExternalUserIdentifier>(
      where: where(LegacyExternalUserIdentifier.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class LegacyExternalUserIdentifierAttachRowRepository {
  const LegacyExternalUserIdentifierAttachRowRepository._();

  /// Creates a relation between the given [LegacyExternalUserIdentifier] and [AuthUser]
  /// by setting the [LegacyExternalUserIdentifier]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    LegacyExternalUserIdentifier legacyExternalUserIdentifier,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (legacyExternalUserIdentifier.id == null) {
      throw ArgumentError.notNull('legacyExternalUserIdentifier.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $legacyExternalUserIdentifier = legacyExternalUserIdentifier.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<LegacyExternalUserIdentifier>(
      $legacyExternalUserIdentifier,
      columns: [LegacyExternalUserIdentifier.t.authUserId],
      transaction: transaction,
    );
  }
}
