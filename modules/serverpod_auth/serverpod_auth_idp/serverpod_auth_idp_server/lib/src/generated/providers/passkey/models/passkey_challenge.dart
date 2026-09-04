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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

/// A challenge handed out for a subsequent Passkey registration or login.
abstract class PasskeyChallenge
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PasskeyChallenge._({
    this.id,
    DateTime? createdAt,
    required this.challenge,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PasskeyChallenge({
    _is.UuidValue? id,
    DateTime? createdAt,
    required _idt.ByteData challenge,
  }) = _PasskeyChallengeImpl;

  factory PasskeyChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasskeyChallenge(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      challenge: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['challenge'],
      ),
    );
  }

  static final t = PasskeyChallengeTable();

  static const db = PasskeyChallengeRepository._();

  @override
  _is.UuidValue? id;

  /// The time when this challenge was created.
  DateTime createdAt;

  /// The actual challenge for the client
  _idt.ByteData challenge;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PasskeyChallenge]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PasskeyChallenge copyWith({
    _is.UuidValue? id,
    DateTime? createdAt,
    _idt.ByteData? challenge,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.PasskeyChallenge',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'challenge': challenge.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  /// Builds a complete [PasskeyChallengeInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static PasskeyChallengeInclude include() {
    return PasskeyChallengeInclude._();
  }

  /// Builds a complete [PasskeyChallengeIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static PasskeyChallengeIncludeList includeList({
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    PasskeyChallengeInclude? include,
  }) {
    return PasskeyChallengeIncludeList._(
      where: where?.call(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [PasskeyChallengeJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static PasskeyChallengeJsonInclude includeJson({
    _is.SelectColumnsBuilder<PasskeyChallengeTable>? select,
  }) {
    return _PasskeyChallengeJsonInclude._(
      selectedColumns: select?.call(PasskeyChallenge.t),
    );
  }

  /// Builds a JSON-compatible [PasskeyChallengeJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static PasskeyChallengeJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    PasskeyChallengeJsonInclude? include,
    _is.SelectColumnsBuilder<PasskeyChallengeTable>? select,
  }) {
    return _PasskeyChallengeJsonIncludeList._(
      where: where?.call(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      include: include,
      selectedColumns: select?.call(PasskeyChallenge.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasskeyChallengeImpl extends PasskeyChallenge {
  _PasskeyChallengeImpl({
    _is.UuidValue? id,
    DateTime? createdAt,
    required _idt.ByteData challenge,
  }) : super._(
         id: id,
         createdAt: createdAt,
         challenge: challenge,
       );

  /// Returns a shallow copy of this [PasskeyChallenge]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PasskeyChallenge copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    _idt.ByteData? challenge,
  }) {
    return PasskeyChallenge(
      id: id is _is.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      challenge: challenge ?? this.challenge.clone(),
    );
  }
}

class PasskeyChallengeUpdateTable
    extends _is.UpdateTable<PasskeyChallengeTable> {
  PasskeyChallengeUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> challenge(
    _idt.ByteData value,
  ) => _is.ColumnValue(
    table.challenge,
    value,
  );
}

class PasskeyChallengeTable extends _is.Table<_is.UuidValue?> {
  PasskeyChallengeTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_passkey_challenge') {
    updateTable = PasskeyChallengeUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    challenge = _is.ColumnByteData(
      'challenge',
      this,
    );
  }

  late final PasskeyChallengeUpdateTable updateTable;

  /// The time when this challenge was created.
  late final _is.ColumnDateTime createdAt;

  /// The actual challenge for the client
  late final _is.ColumnByteData challenge;

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    challenge,
  ];
}

abstract interface class PasskeyChallengeJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class PasskeyChallengeJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class PasskeyChallengeInclude extends _is.IncludeObject
    implements PasskeyChallengeJsonInclude, _is.FullModelInclude {
  PasskeyChallengeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PasskeyChallenge.t;
}

final class PasskeyChallengeIncludeList extends _is.IncludeList
    implements PasskeyChallengeJsonIncludeList, _is.FullModelInclude {
  PasskeyChallengeIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    PasskeyChallengeInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PasskeyChallenge.t;
}

final class _PasskeyChallengeJsonInclude extends _is.IncludeObject
    implements PasskeyChallengeJsonInclude {
  _PasskeyChallengeJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PasskeyChallenge.t;
}

final class _PasskeyChallengeJsonIncludeList extends _is.IncludeList
    implements PasskeyChallengeJsonIncludeList {
  _PasskeyChallengeJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    PasskeyChallengeJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PasskeyChallenge.t;
}

class PasskeyChallengeRepository {
  const PasskeyChallengeRepository._();

  /// Returns a list of [PasskeyChallenge]s matching the given query parameters.
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
  Future<List<PasskeyChallenge>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PasskeyChallenge] matching the given query parameters.
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
  Future<PasskeyChallenge?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PasskeyChallenge] by its [id] or null if no such row exists.
  Future<PasskeyChallenge?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PasskeyChallenge>(
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
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<PasskeyChallengeTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(PasskeyChallenge.t),
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
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<PasskeyChallengeTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(PasskeyChallenge.t),
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
    _is.SelectColumnsBuilder<PasskeyChallengeTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<PasskeyChallenge>(
      id,
      transaction: transaction,
      select: select?.call(PasskeyChallenge.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PasskeyChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [PasskeyChallenge]s will have their `id` fields set.
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
  Future<List<PasskeyChallenge>> insert(
    _is.DatabaseSession session,
    List<PasskeyChallenge> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PasskeyChallenge>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PasskeyChallenge] and returns the inserted row.
  ///
  /// The returned [PasskeyChallenge] will have its `id` field set.
  Future<PasskeyChallenge> insertRow(
    _is.DatabaseSession session,
    PasskeyChallenge row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PasskeyChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PasskeyChallenge]s in the list and returns the resulting rows.
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
  /// The returned [PasskeyChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PasskeyChallenge>> upsert(
    _is.DatabaseSession session,
    List<PasskeyChallenge> rows, {
    required _is.ColumnSelections<PasskeyChallengeTable> conflictColumns,
    _is.ColumnSelections<PasskeyChallengeTable>? updateColumns,
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PasskeyChallenge>(
      rows,
      conflictColumns: conflictColumns(PasskeyChallenge.t),
      updateColumns: updateColumns?.call(PasskeyChallenge.t),
      updateWhere: updateWhere?.call(PasskeyChallenge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PasskeyChallenge] and returns the resulting row.
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
  /// The returned [PasskeyChallenge] will have its `id` field set.
  Future<PasskeyChallenge?> upsertRow(
    _is.DatabaseSession session,
    PasskeyChallenge row, {
    required _is.ColumnSelections<PasskeyChallengeTable> conflictColumns,
    _is.ColumnSelections<PasskeyChallengeTable>? updateColumns,
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PasskeyChallenge>(
      row,
      conflictColumns: conflictColumns(PasskeyChallenge.t),
      updateColumns: updateColumns?.call(PasskeyChallenge.t),
      updateWhere: updateWhere?.call(PasskeyChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PasskeyChallenge>> update(
    _is.DatabaseSession session,
    List<PasskeyChallenge> rows, {
    _is.ColumnSelections<PasskeyChallengeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PasskeyChallenge>(
      rows,
      columns: columns?.call(PasskeyChallenge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PasskeyChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PasskeyChallenge> updateRow(
    _is.DatabaseSession session,
    PasskeyChallenge row, {
    _is.ColumnSelections<PasskeyChallengeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PasskeyChallenge>(
      row,
      columns: columns?.call(PasskeyChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PasskeyChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PasskeyChallenge?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PasskeyChallengeUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PasskeyChallenge>(
      id,
      columnValues: columnValues(PasskeyChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PasskeyChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PasskeyChallenge>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PasskeyChallengeUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PasskeyChallengeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PasskeyChallenge>(
      columnValues: columnValues(PasskeyChallenge.t.updateTable),
      where: where(PasskeyChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PasskeyChallenge]s in the list and returns the deleted rows.
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
  Future<List<PasskeyChallenge>> delete(
    _is.DatabaseSession session,
    List<PasskeyChallenge> rows, {
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PasskeyChallenge>(
      rows,
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PasskeyChallenge].
  Future<PasskeyChallenge> deleteRow(
    _is.DatabaseSession session,
    PasskeyChallenge row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PasskeyChallenge>(
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
  Future<List<PasskeyChallenge>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PasskeyChallengeTable> where,
    _is.OrderByBuilder<PasskeyChallengeTable>? orderBy,
    _is.OrderByListBuilder<PasskeyChallengeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PasskeyChallenge>(
      where: where(PasskeyChallenge.t),
      orderBy: orderBy?.call(PasskeyChallenge.t),
      orderByList: orderByList?.call(PasskeyChallenge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PasskeyChallengeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PasskeyChallenge>(
      where: where?.call(PasskeyChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PasskeyChallenge] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PasskeyChallengeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PasskeyChallenge>(
      where: where(PasskeyChallenge.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
