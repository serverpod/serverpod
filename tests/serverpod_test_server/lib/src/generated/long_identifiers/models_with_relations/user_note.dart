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

abstract class UserNote
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserNote._({
    this.id,
    required this.name,
  }) : _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId = null;

  factory UserNote({
    int? id,
    required String name,
  }) = _UserNoteImpl;

  factory UserNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNoteImplicit._(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          jsonSerialization['_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId']
              as int?,
    );
  }

  static final t = UserNoteTable();

  static const db = UserNoteRepository._();

  @override
  int? id;

  String name;

  final int? _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserNote copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserNote',
      if (id != null) 'id': id,
      'name': name,
      if (_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId !=
          null)
        '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId':
            _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserNote',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  /// Builds a complete [UserNoteInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UserNoteInclude include() {
    return UserNoteInclude._();
  }

  /// Builds a complete [UserNoteIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UserNoteIncludeList includeList({
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    UserNoteInclude? include,
  }) {
    return UserNoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [UserNoteJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static UserNoteJsonInclude includeJson({
    _is.SelectColumnsBuilder<UserNoteTable>? select,
  }) {
    return _UserNoteJsonInclude._(selectedColumns: select?.call(UserNote.t));
  }

  /// Builds a JSON-compatible [UserNoteJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static UserNoteJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    UserNoteJsonInclude? include,
    _is.SelectColumnsBuilder<UserNoteTable>? select,
  }) {
    return _UserNoteJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      include: include,
      selectedColumns: select?.call(UserNote.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteImpl extends UserNote {
  _UserNoteImpl({
    int? id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [UserNote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserNote copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNoteImplicit._(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          this._userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
    );
  }
}

class UserNoteImplicit extends _UserNoteImpl {
  UserNoteImplicit._({
    int? id,
    required String name,
    int? $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
  }) : _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId =
           $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
       super(
         id: id,
         name: name,
       );

  factory UserNoteImplicit(
    UserNote userNote, {
    int? $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
  }) {
    return UserNoteImplicit._(
      id: userNote.id,
      name: userNote.name,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
    );
  }

  @override
  final int? _userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;
}

class UserNoteUpdateTable extends _is.UpdateTable<UserNoteTable> {
  UserNoteUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int>
  $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId(int? value) =>
      _is.ColumnValue(
        table.$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
        value,
      );
}

class UserNoteTable extends _is.Table<int?> {
  UserNoteTable({super.tableRelation}) : super(tableName: 'user_note') {
    updateTable = UserNoteUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId =
        _is.ColumnInt(
          '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
          this,
        );
  }

  late final UserNoteUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt
  $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    name,
  ];
}

abstract interface class UserNoteJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class UserNoteJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class UserNoteInclude extends _is.IncludeObject
    implements UserNoteJsonInclude, _is.FullModelInclude {
  UserNoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserNote.t;
}

final class UserNoteIncludeList extends _is.IncludeList
    implements UserNoteJsonIncludeList, _is.FullModelInclude {
  UserNoteIncludeList._({
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UserNoteInclude? super.include,
  }) {
    super.where = where?.call(UserNote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserNote.t;
}

final class _UserNoteJsonInclude extends _is.IncludeObject
    implements UserNoteJsonInclude {
  _UserNoteJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserNote.t;
}

final class _UserNoteJsonIncludeList extends _is.IncludeList
    implements UserNoteJsonIncludeList {
  _UserNoteJsonIncludeList._({
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UserNoteJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UserNote.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserNote.t;
}

class UserNoteRepository {
  const UserNoteRepository._();

  /// Returns a list of [UserNote]s matching the given query parameters.
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
  Future<List<UserNote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserNote] matching the given query parameters.
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
  Future<UserNote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserNote] by its [id] or null if no such row exists.
  Future<UserNote?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserNote>(
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
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UserNoteTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UserNote.t),
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
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UserNoteTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UserNote>(
      where: where?.call(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UserNote.t),
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
    _is.SelectColumnsBuilder<UserNoteTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UserNote>(
      id,
      transaction: transaction,
      select: select?.call(UserNote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserNote]s in the list and returns the inserted rows.
  ///
  /// The returned [UserNote]s will have their `id` fields set.
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
  Future<List<UserNote>> insert(
    _is.DatabaseSession session,
    List<UserNote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserNote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserNote] and returns the inserted row.
  ///
  /// The returned [UserNote] will have its `id` field set.
  Future<UserNote> insertRow(
    _is.DatabaseSession session,
    UserNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserNote]s in the list and returns the resulting rows.
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
  /// The returned [UserNote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNote>> upsert(
    _is.DatabaseSession session,
    List<UserNote> rows, {
    required _is.ColumnSelections<UserNoteTable> conflictColumns,
    _is.ColumnSelections<UserNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserNote>(
      rows,
      conflictColumns: conflictColumns(UserNote.t),
      updateColumns: updateColumns?.call(UserNote.t),
      updateWhere: updateWhere?.call(UserNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserNote] and returns the resulting row.
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
  /// The returned [UserNote] will have its `id` field set.
  Future<UserNote?> upsertRow(
    _is.DatabaseSession session,
    UserNote row, {
    required _is.ColumnSelections<UserNoteTable> conflictColumns,
    _is.ColumnSelections<UserNoteTable>? updateColumns,
    _is.WhereExpressionBuilder<UserNoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserNote>(
      row,
      conflictColumns: conflictColumns(UserNote.t),
      updateColumns: updateColumns?.call(UserNote.t),
      updateWhere: updateWhere?.call(UserNote.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserNote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNote>> update(
    _is.DatabaseSession session,
    List<UserNote> rows, {
    _is.ColumnSelections<UserNoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserNote>(
      rows,
      columns: columns?.call(UserNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserNote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserNote> updateRow(
    _is.DatabaseSession session,
    UserNote row, {
    _is.ColumnSelections<UserNoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNote>(
      row,
      columns: columns?.call(UserNote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserNote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserNote?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserNoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserNote>(
      id,
      columnValues: columnValues(UserNote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserNote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserNote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserNoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserNoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserNote>(
      columnValues: columnValues(UserNote.t.updateTable),
      where: where(UserNote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserNote]s in the list and returns the deleted rows.
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
  Future<List<UserNote>> delete(
    _is.DatabaseSession session,
    List<UserNote> rows, {
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserNote>(
      rows,
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserNote].
  Future<UserNote> deleteRow(
    _is.DatabaseSession session,
    UserNote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNote>(
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
  Future<List<UserNote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteTable> where,
    _is.OrderByBuilder<UserNoteTable>? orderBy,
    _is.OrderByListBuilder<UserNoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserNote>(
      where: where(UserNote.t),
      orderBy: orderBy?.call(UserNote.t),
      orderByList: orderByList?.call(UserNote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserNoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserNote>(
      where: where?.call(UserNote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserNote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserNoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserNote>(
      where: where(UserNote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
