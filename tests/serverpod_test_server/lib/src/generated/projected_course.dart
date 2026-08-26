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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'projected_enrollment.dart' as _i3lw6w5n;

abstract class ProjectedCourse
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProjectedCourse._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory ProjectedCourse({
    int? id,
    required String name,
    List<_i3lw6w5n.ProjectedEnrollment>? enrollments,
  }) = _ProjectedCourseImpl;

  factory ProjectedCourse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedCourse(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_i3lw6w5n.ProjectedEnrollment>>(
                  jsonSerialization['enrollments'],
                ),
    );
  }

  static final t = ProjectedCourseTable();

  static const db = ProjectedCourseRepository._();

  @override
  int? id;

  String name;

  List<_i3lw6w5n.ProjectedEnrollment>? enrollments;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedCourse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedCourse copyWith({
    int? id,
    String? name,
    List<_i3lw6w5n.ProjectedEnrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedCourse',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedCourse',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  /// Builds a complete [ProjectedCourseInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedCourseInclude include({
    _i3lw6w5n.ProjectedEnrollmentIncludeList? enrollments,
  }) {
    return ProjectedCourseInclude._(enrollments: enrollments);
  }

  /// Builds a complete [ProjectedCourseIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedCourseIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    ProjectedCourseInclude? include,
  }) {
    return ProjectedCourseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ProjectedCourseJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ProjectedCourseJsonInclude includeJson({
    _i3lw6w5n.ProjectedEnrollmentJsonIncludeList? enrollments,
    _is.SelectColumnsBuilder<ProjectedCourseTable>? select,
  }) {
    return _ProjectedCourseJsonInclude._(
      enrollments: enrollments,
      selectedColumns: select?.call(ProjectedCourse.t),
    );
  }

  /// Builds a JSON-compatible [ProjectedCourseJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ProjectedCourseJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    ProjectedCourseJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedCourseTable>? select,
  }) {
    return _ProjectedCourseJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      include: include,
      selectedColumns: select?.call(ProjectedCourse.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedCourseImpl extends ProjectedCourse {
  _ProjectedCourseImpl({
    int? id,
    required String name,
    List<_i3lw6w5n.ProjectedEnrollment>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [ProjectedCourse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedCourse copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return ProjectedCourse(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i3lw6w5n.ProjectedEnrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ProjectedCourseUpdateTable extends _is.UpdateTable<ProjectedCourseTable> {
  ProjectedCourseUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class ProjectedCourseTable extends _is.Table<int?> {
  ProjectedCourseTable({super.tableRelation})
    : super(tableName: 'projected_course') {
    updateTable = ProjectedCourseUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final ProjectedCourseUpdateTable updateTable;

  late final _is.ColumnString name;

  _i3lw6w5n.ProjectedEnrollmentTable? ___enrollments;

  _is.ManyRelation<_i3lw6w5n.ProjectedEnrollmentTable>? _enrollments;

  _i3lw6w5n.ProjectedEnrollmentTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _is.createRelationTable(
      relationFieldName: '__enrollments',
      field: ProjectedCourse.t.id,
      foreignField: _i3lw6w5n.ProjectedEnrollment.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3lw6w5n.ProjectedEnrollmentTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___enrollments!;
  }

  _is.ManyRelation<_i3lw6w5n.ProjectedEnrollmentTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'enrollments',
      field: ProjectedCourse.t.id,
      foreignField: _i3lw6w5n.ProjectedEnrollment.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3lw6w5n.ProjectedEnrollmentTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _enrollments = _is.ManyRelation<_i3lw6w5n.ProjectedEnrollmentTable>(
      tableWithRelations: relationTable,
      table: _i3lw6w5n.ProjectedEnrollmentTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _enrollments!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'enrollments') {
      return __enrollments;
    }
    return null;
  }
}

abstract interface class ProjectedCourseJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ProjectedCourseJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ProjectedCourseInclude extends _is.IncludeObject
    implements ProjectedCourseJsonInclude, _is.FullModelInclude {
  ProjectedCourseInclude._({
    _i3lw6w5n.ProjectedEnrollmentIncludeList? enrollments,
  }) {
    _enrollments = enrollments;
  }

  _i3lw6w5n.ProjectedEnrollmentIncludeList? _enrollments;

  @override
  Map<String, _is.Include?> get includes => {'enrollments': _enrollments};

  @override
  _is.Table<int?> get table => ProjectedCourse.t;
}

final class ProjectedCourseIncludeList extends _is.IncludeList
    implements ProjectedCourseJsonIncludeList, _is.FullModelInclude {
  ProjectedCourseIncludeList._({
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedCourseInclude? super.include,
  }) {
    super.where = where?.call(ProjectedCourse.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedCourse.t;
}

final class _ProjectedCourseJsonInclude extends _is.IncludeObject
    implements ProjectedCourseJsonInclude {
  _ProjectedCourseJsonInclude._({
    _i3lw6w5n.ProjectedEnrollmentJsonIncludeList? enrollments,
    this.selectedColumns,
  }) {
    _enrollments = enrollments;
  }

  _i3lw6w5n.ProjectedEnrollmentJsonIncludeList? _enrollments;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'enrollments': _enrollments};

  @override
  _is.Table<int?> get table => ProjectedCourse.t;
}

final class _ProjectedCourseJsonIncludeList extends _is.IncludeList
    implements ProjectedCourseJsonIncludeList {
  _ProjectedCourseJsonIncludeList._({
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedCourseJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedCourse.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedCourse.t;
}

class ProjectedCourseRepository {
  const ProjectedCourseRepository._();

  final attach = const ProjectedCourseAttachRepository._();

  final attachRow = const ProjectedCourseAttachRowRepository._();

  /// Returns a list of [ProjectedCourse]s matching the given query parameters.
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
  Future<List<ProjectedCourse>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedCourseInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedCourse>(
      where: where?.call(ProjectedCourse.t),
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedCourse] matching the given query parameters.
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
  Future<ProjectedCourse?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedCourseInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedCourse>(
      where: where?.call(ProjectedCourse.t),
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedCourse] by its [id] or null if no such row exists.
  Future<ProjectedCourse?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ProjectedCourseInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedCourse>(
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
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedCourseJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedCourseTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedCourse>(
      where: where?.call(ProjectedCourse.t),
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedCourse.t),
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
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedCourseJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedCourseTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedCourse>(
      where: where?.call(ProjectedCourse.t),
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedCourse.t),
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
    ProjectedCourseJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedCourseTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedCourse>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedCourse.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedCourse]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedCourse]s will have their `id` fields set.
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
  Future<List<ProjectedCourse>> insert(
    _is.DatabaseSession session,
    List<ProjectedCourse> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedCourse>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedCourse] and returns the inserted row.
  ///
  /// The returned [ProjectedCourse] will have its `id` field set.
  Future<ProjectedCourse> insertRow(
    _is.DatabaseSession session,
    ProjectedCourse row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedCourse>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedCourse]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedCourse]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedCourse>> upsert(
    _is.DatabaseSession session,
    List<ProjectedCourse> rows, {
    required _is.ColumnSelections<ProjectedCourseTable> conflictColumns,
    _is.ColumnSelections<ProjectedCourseTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedCourseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedCourse>(
      rows,
      conflictColumns: conflictColumns(ProjectedCourse.t),
      updateColumns: updateColumns?.call(ProjectedCourse.t),
      updateWhere: updateWhere?.call(ProjectedCourse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedCourse] and returns the resulting row.
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
  /// The returned [ProjectedCourse] will have its `id` field set.
  Future<ProjectedCourse?> upsertRow(
    _is.DatabaseSession session,
    ProjectedCourse row, {
    required _is.ColumnSelections<ProjectedCourseTable> conflictColumns,
    _is.ColumnSelections<ProjectedCourseTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedCourseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedCourse>(
      row,
      conflictColumns: conflictColumns(ProjectedCourse.t),
      updateColumns: updateColumns?.call(ProjectedCourse.t),
      updateWhere: updateWhere?.call(ProjectedCourse.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedCourse]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedCourse>> update(
    _is.DatabaseSession session,
    List<ProjectedCourse> rows, {
    _is.ColumnSelections<ProjectedCourseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedCourse>(
      rows,
      columns: columns?.call(ProjectedCourse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedCourse]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedCourse> updateRow(
    _is.DatabaseSession session,
    ProjectedCourse row, {
    _is.ColumnSelections<ProjectedCourseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedCourse>(
      row,
      columns: columns?.call(ProjectedCourse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedCourse] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedCourse?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProjectedCourseUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedCourse>(
      id,
      columnValues: columnValues(ProjectedCourse.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedCourse]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedCourse>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedCourseUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectedCourseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedCourse>(
      columnValues: columnValues(ProjectedCourse.t.updateTable),
      where: where(ProjectedCourse.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedCourse]s in the list and returns the deleted rows.
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
  Future<List<ProjectedCourse>> delete(
    _is.DatabaseSession session,
    List<ProjectedCourse> rows, {
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedCourse>(
      rows,
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedCourse].
  Future<ProjectedCourse> deleteRow(
    _is.DatabaseSession session,
    ProjectedCourse row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedCourse>(
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
  Future<List<ProjectedCourse>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedCourseTable> where,
    _is.OrderByBuilder<ProjectedCourseTable>? orderBy,
    _is.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedCourse>(
      where: where(ProjectedCourse.t),
      orderBy: orderBy?.call(ProjectedCourse.t),
      orderByList: orderByList?.call(ProjectedCourse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedCourse>(
      where: where?.call(ProjectedCourse.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedCourse] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedCourseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedCourse>(
      where: where(ProjectedCourse.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectedCourseAttachRepository {
  const ProjectedCourseAttachRepository._();

  /// Creates a relation between this [ProjectedCourse] and the given [ProjectedEnrollment]s
  /// by setting each [ProjectedEnrollment]'s foreign key `courseId` to refer to this [ProjectedCourse].
  Future<void> enrollments(
    _is.DatabaseSession session,
    ProjectedCourse projectedCourse,
    List<_i3lw6w5n.ProjectedEnrollment> projectedEnrollment, {
    _is.Transaction? transaction,
  }) async {
    if (projectedEnrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (projectedCourse.id == null) {
      throw ArgumentError.notNull('projectedCourse.id');
    }

    var $projectedEnrollment = projectedEnrollment
        .map((e) => e.copyWith(courseId: projectedCourse.id))
        .toList();
    await session.db.update<_i3lw6w5n.ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [_i3lw6w5n.ProjectedEnrollment.t.courseId],
      transaction: transaction,
    );
  }
}

class ProjectedCourseAttachRowRepository {
  const ProjectedCourseAttachRowRepository._();

  /// Creates a relation between this [ProjectedCourse] and the given [ProjectedEnrollment]
  /// by setting the [ProjectedEnrollment]'s foreign key `courseId` to refer to this [ProjectedCourse].
  Future<void> enrollments(
    _is.DatabaseSession session,
    ProjectedCourse projectedCourse,
    _i3lw6w5n.ProjectedEnrollment projectedEnrollment, {
    _is.Transaction? transaction,
  }) async {
    if (projectedEnrollment.id == null) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (projectedCourse.id == null) {
      throw ArgumentError.notNull('projectedCourse.id');
    }

    var $projectedEnrollment = projectedEnrollment.copyWith(
      courseId: projectedCourse.id,
    );
    await session.db.updateRow<_i3lw6w5n.ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [_i3lw6w5n.ProjectedEnrollment.t.courseId],
      transaction: transaction,
    );
  }
}
