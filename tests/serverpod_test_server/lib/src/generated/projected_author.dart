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

abstract class ProjectedAuthor
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProjectedAuthor._({
    this.id,
    required this.name,
    this.bio,
    required this.email,
    required this.phone,
  });

  factory ProjectedAuthor({
    int? id,
    required String name,
    String? bio,
    required String email,
    required String phone,
  }) = _ProjectedAuthorImpl;

  factory ProjectedAuthor.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedAuthor(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      bio: jsonSerialization['bio'] as String?,
      email: jsonSerialization['email'] as String,
      phone: jsonSerialization['phone'] as String,
    );
  }

  static final t = ProjectedAuthorTable();

  static const db = ProjectedAuthorRepository._();

  @override
  int? id;

  String name;

  String? bio;

  String email;

  String phone;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedAuthor]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedAuthor copyWith({
    int? id,
    String? name,
    String? bio,
    String? email,
    String? phone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAuthor',
      if (id != null) 'id': id,
      'name': name,
      if (bio != null) 'bio': bio,
      'email': email,
      'phone': phone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAuthor',
      if (id != null) 'id': id,
      'name': name,
      if (bio != null) 'bio': bio,
      'email': email,
      'phone': phone,
    };
  }

  /// Builds a complete [ProjectedAuthorInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedAuthorInclude include() {
    return ProjectedAuthorInclude._();
  }

  /// Builds a complete [ProjectedAuthorIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedAuthorIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    ProjectedAuthorInclude? include,
  }) {
    return ProjectedAuthorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ProjectedAuthorJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ProjectedAuthorJsonInclude includeJson({
    _is.SelectColumnsBuilder<ProjectedAuthorTable>? select,
  }) {
    return _ProjectedAuthorJsonInclude._(
      selectedColumns: select?.call(ProjectedAuthor.t),
    );
  }

  /// Builds a JSON-compatible [ProjectedAuthorJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ProjectedAuthorJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    ProjectedAuthorJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedAuthorTable>? select,
  }) {
    return _ProjectedAuthorJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      include: include,
      selectedColumns: select?.call(ProjectedAuthor.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAuthorImpl extends ProjectedAuthor {
  _ProjectedAuthorImpl({
    int? id,
    required String name,
    String? bio,
    required String email,
    required String phone,
  }) : super._(
         id: id,
         name: name,
         bio: bio,
         email: email,
         phone: phone,
       );

  /// Returns a shallow copy of this [ProjectedAuthor]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedAuthor copyWith({
    Object? id = _Undefined,
    String? name,
    Object? bio = _Undefined,
    String? email,
    String? phone,
  }) {
    return ProjectedAuthor(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      bio: bio is String? ? bio : this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class ProjectedAuthorUpdateTable extends _is.UpdateTable<ProjectedAuthorTable> {
  ProjectedAuthorUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> bio(String? value) => _is.ColumnValue(
    table.bio,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> phone(String value) => _is.ColumnValue(
    table.phone,
    value,
  );
}

class ProjectedAuthorTable extends _is.Table<int?> {
  ProjectedAuthorTable({super.tableRelation})
    : super(tableName: 'projected_author') {
    updateTable = ProjectedAuthorUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    bio = _is.ColumnString(
      'bio',
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
  }

  late final ProjectedAuthorUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString bio;

  late final _is.ColumnString email;

  late final _is.ColumnString phone;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    bio,
    email,
    phone,
  ];
}

abstract interface class ProjectedAuthorJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ProjectedAuthorJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ProjectedAuthorInclude extends _is.IncludeObject
    implements ProjectedAuthorJsonInclude, _is.FullModelInclude {
  ProjectedAuthorInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProjectedAuthor.t;
}

final class ProjectedAuthorIncludeList extends _is.IncludeList
    implements ProjectedAuthorJsonIncludeList, _is.FullModelInclude {
  ProjectedAuthorIncludeList._({
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedAuthorInclude? super.include,
  }) {
    super.where = where?.call(ProjectedAuthor.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedAuthor.t;
}

final class _ProjectedAuthorJsonInclude extends _is.IncludeObject
    implements ProjectedAuthorJsonInclude {
  _ProjectedAuthorJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProjectedAuthor.t;
}

final class _ProjectedAuthorJsonIncludeList extends _is.IncludeList
    implements ProjectedAuthorJsonIncludeList {
  _ProjectedAuthorJsonIncludeList._({
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedAuthorJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedAuthor.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedAuthor.t;
}

class ProjectedAuthorRepository {
  const ProjectedAuthorRepository._();

  /// Returns a list of [ProjectedAuthor]s matching the given query parameters.
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
  Future<List<ProjectedAuthor>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedAuthor>(
      where: where?.call(ProjectedAuthor.t),
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedAuthor] matching the given query parameters.
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
  Future<ProjectedAuthor?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedAuthor>(
      where: where?.call(ProjectedAuthor.t),
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedAuthor] by its [id] or null if no such row exists.
  Future<ProjectedAuthor?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedAuthor>(
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
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ProjectedAuthorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedAuthor>(
      where: where?.call(ProjectedAuthor.t),
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ProjectedAuthor.t),
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
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ProjectedAuthorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedAuthor>(
      where: where?.call(ProjectedAuthor.t),
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ProjectedAuthor.t),
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
    _is.SelectColumnsBuilder<ProjectedAuthorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedAuthor>(
      id,
      transaction: transaction,
      select: select?.call(ProjectedAuthor.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedAuthor]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedAuthor]s will have their `id` fields set.
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
  Future<List<ProjectedAuthor>> insert(
    _is.DatabaseSession session,
    List<ProjectedAuthor> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedAuthor>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedAuthor] and returns the inserted row.
  ///
  /// The returned [ProjectedAuthor] will have its `id` field set.
  Future<ProjectedAuthor> insertRow(
    _is.DatabaseSession session,
    ProjectedAuthor row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedAuthor>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedAuthor]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedAuthor]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAuthor>> upsert(
    _is.DatabaseSession session,
    List<ProjectedAuthor> rows, {
    required _is.ColumnSelections<ProjectedAuthorTable> conflictColumns,
    _is.ColumnSelections<ProjectedAuthorTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedAuthor>(
      rows,
      conflictColumns: conflictColumns(ProjectedAuthor.t),
      updateColumns: updateColumns?.call(ProjectedAuthor.t),
      updateWhere: updateWhere?.call(ProjectedAuthor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedAuthor] and returns the resulting row.
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
  /// The returned [ProjectedAuthor] will have its `id` field set.
  Future<ProjectedAuthor?> upsertRow(
    _is.DatabaseSession session,
    ProjectedAuthor row, {
    required _is.ColumnSelections<ProjectedAuthorTable> conflictColumns,
    _is.ColumnSelections<ProjectedAuthorTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedAuthor>(
      row,
      conflictColumns: conflictColumns(ProjectedAuthor.t),
      updateColumns: updateColumns?.call(ProjectedAuthor.t),
      updateWhere: updateWhere?.call(ProjectedAuthor.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedAuthor]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAuthor>> update(
    _is.DatabaseSession session,
    List<ProjectedAuthor> rows, {
    _is.ColumnSelections<ProjectedAuthorTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedAuthor>(
      rows,
      columns: columns?.call(ProjectedAuthor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedAuthor]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedAuthor> updateRow(
    _is.DatabaseSession session,
    ProjectedAuthor row, {
    _is.ColumnSelections<ProjectedAuthorTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedAuthor>(
      row,
      columns: columns?.call(ProjectedAuthor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedAuthor] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedAuthor?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProjectedAuthorUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedAuthor>(
      id,
      columnValues: columnValues(ProjectedAuthor.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedAuthor]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAuthor>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedAuthorUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectedAuthorTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedAuthor>(
      columnValues: columnValues(ProjectedAuthor.t.updateTable),
      where: where(ProjectedAuthor.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedAuthor]s in the list and returns the deleted rows.
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
  Future<List<ProjectedAuthor>> delete(
    _is.DatabaseSession session,
    List<ProjectedAuthor> rows, {
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedAuthor>(
      rows,
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedAuthor].
  Future<ProjectedAuthor> deleteRow(
    _is.DatabaseSession session,
    ProjectedAuthor row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedAuthor>(
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
  Future<List<ProjectedAuthor>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedAuthorTable> where,
    _is.OrderByBuilder<ProjectedAuthorTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAuthorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedAuthor>(
      where: where(ProjectedAuthor.t),
      orderBy: orderBy?.call(ProjectedAuthor.t),
      orderByList: orderByList?.call(ProjectedAuthor.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedAuthorTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedAuthor>(
      where: where?.call(ProjectedAuthor.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedAuthor] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedAuthorTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedAuthor>(
      where: where(ProjectedAuthor.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
