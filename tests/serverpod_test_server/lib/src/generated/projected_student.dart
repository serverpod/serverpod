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
import 'package:serverpod/serverpod.dart' as _i1;
import 'projected_enrollment.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;
import 'package:meta/meta.dart' as _i4;

abstract class ProjectedStudent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ProjectedStudent._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory ProjectedStudent({
    int? id,
    required String name,
    List<_i2.ProjectedEnrollment>? enrollments,
  }) = _ProjectedStudentImpl;

  factory ProjectedStudent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedStudent(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ProjectedEnrollment>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  static final t = ProjectedStudentTable();

  static const db = ProjectedStudentRepository._();

  @override
  int? id;

  String name;

  List<_i2.ProjectedEnrollment>? enrollments;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedStudent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedStudent copyWith({
    int? id,
    String? name,
    List<_i2.ProjectedEnrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedStudent',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedStudent',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static ProjectedStudentInclude include({
    _i2.ProjectedEnrollmentIncludeList? enrollments,
  }) {
    return ProjectedStudentInclude.internal_(enrollments: enrollments);
  }

  static ProjectedStudentIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    ProjectedStudentInclude? include,
  }) {
    return ProjectedStudentIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedStudentImpl extends ProjectedStudent {
  _ProjectedStudentImpl({
    int? id,
    required String name,
    List<_i2.ProjectedEnrollment>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [ProjectedStudent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedStudent copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return ProjectedStudent(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.ProjectedEnrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ProjectedStudentUpdateTable
    extends _i1.UpdateTable<ProjectedStudentTable> {
  ProjectedStudentUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );
}

class ProjectedStudentTable extends _i1.Table<int?> {
  ProjectedStudentTable({super.tableRelation})
    : super(tableName: 'projected_student') {
    updateTable = ProjectedStudentUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final ProjectedStudentUpdateTable updateTable;

  late final _i1.ColumnString name;

  _i2.ProjectedEnrollmentTable? ___enrollments;

  _i1.ManyRelation<_i2.ProjectedEnrollmentTable>? _enrollments;

  _i2.ProjectedEnrollmentTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _i1.createRelationTable(
      relationFieldName: '__enrollments',
      field: ProjectedStudent.t.id,
      foreignField: _i2.ProjectedEnrollment.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ProjectedEnrollmentTable(tableRelation: foreignTableRelation),
    );
    return ___enrollments!;
  }

  _i1.ManyRelation<_i2.ProjectedEnrollmentTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'enrollments',
      field: ProjectedStudent.t.id,
      foreignField: _i2.ProjectedEnrollment.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ProjectedEnrollmentTable(tableRelation: foreignTableRelation),
    );
    _enrollments = _i1.ManyRelation<_i2.ProjectedEnrollmentTable>(
      tableWithRelations: relationTable,
      table: _i2.ProjectedEnrollmentTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _enrollments!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'enrollments') {
      return __enrollments;
    }
    return null;
  }
}

class ProjectedStudentInclude extends _i1.IncludeObject {
  @_i4.internal
  ProjectedStudentInclude.internal_({
    _i2.ProjectedEnrollmentIncludeList? enrollments,
    List<_i1.Column>? this.selectedColumns,
  }) {
    _enrollments = enrollments;
  }

  _i2.ProjectedEnrollmentIncludeList? _enrollments;

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {'enrollments': _enrollments};

  @override
  _i1.Table<int?> get table => ProjectedStudent.t;
}

class ProjectedStudentIncludeList extends _i1.IncludeList {
  @_i4.internal
  ProjectedStudentIncludeList.internal_({
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedStudent.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProjectedStudent.t;
}

class ProjectedStudentRepository {
  const ProjectedStudentRepository._();

  final attach = const ProjectedStudentAttachRepository._();

  final attachRow = const ProjectedStudentAttachRowRepository._();

  /// Returns a list of [ProjectedStudent]s matching the given query parameters.
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
  Future<List<ProjectedStudent>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _i1.Transaction? transaction,
    ProjectedStudentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedStudent>(
      where: where?.call(ProjectedStudent.t),
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedStudent] matching the given query parameters.
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
  Future<ProjectedStudent?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _i1.Transaction? transaction,
    ProjectedStudentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedStudent>(
      where: where?.call(ProjectedStudent.t),
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedStudent] by its [id] or null if no such row exists.
  Future<ProjectedStudent?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    ProjectedStudentInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedStudent>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedStudent]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedStudent]s will have their `id` fields set.
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
  Future<List<ProjectedStudent>> insert(
    _i1.DatabaseSession session,
    List<ProjectedStudent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedStudent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedStudent] and returns the inserted row.
  ///
  /// The returned [ProjectedStudent] will have its `id` field set.
  Future<ProjectedStudent> insertRow(
    _i1.DatabaseSession session,
    ProjectedStudent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedStudent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedStudent]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedStudent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedStudent>> upsert(
    _i1.DatabaseSession session,
    List<ProjectedStudent> rows, {
    required _i1.ColumnSelections<ProjectedStudentTable> conflictColumns,
    _i1.ColumnSelections<ProjectedStudentTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedStudent>(
      rows,
      conflictColumns: conflictColumns(ProjectedStudent.t),
      updateColumns: updateColumns?.call(ProjectedStudent.t),
      updateWhere: updateWhere?.call(ProjectedStudent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedStudent] and returns the resulting row.
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
  /// The returned [ProjectedStudent] will have its `id` field set.
  Future<ProjectedStudent?> upsertRow(
    _i1.DatabaseSession session,
    ProjectedStudent row, {
    required _i1.ColumnSelections<ProjectedStudentTable> conflictColumns,
    _i1.ColumnSelections<ProjectedStudentTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedStudent>(
      row,
      conflictColumns: conflictColumns(ProjectedStudent.t),
      updateColumns: updateColumns?.call(ProjectedStudent.t),
      updateWhere: updateWhere?.call(ProjectedStudent.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedStudent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedStudent>> update(
    _i1.DatabaseSession session,
    List<ProjectedStudent> rows, {
    _i1.ColumnSelections<ProjectedStudentTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedStudent>(
      rows,
      columns: columns?.call(ProjectedStudent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedStudent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedStudent> updateRow(
    _i1.DatabaseSession session,
    ProjectedStudent row, {
    _i1.ColumnSelections<ProjectedStudentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedStudent>(
      row,
      columns: columns?.call(ProjectedStudent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedStudent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedStudent?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProjectedStudentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedStudent>(
      id,
      columnValues: columnValues(ProjectedStudent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedStudent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedStudent>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProjectedStudentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProjectedStudentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedStudent>(
      columnValues: columnValues(ProjectedStudent.t.updateTable),
      where: where(ProjectedStudent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedStudent]s in the list and returns the deleted rows.
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
  Future<List<ProjectedStudent>> delete(
    _i1.DatabaseSession session,
    List<ProjectedStudent> rows, {
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedStudent>(
      rows,
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedStudent].
  Future<ProjectedStudent> deleteRow(
    _i1.DatabaseSession session,
    ProjectedStudent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedStudent>(
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
  Future<List<ProjectedStudent>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedStudentTable> where,
    _i1.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedStudent>(
      where: where(ProjectedStudent.t),
      orderBy: orderBy?.call(ProjectedStudent.t),
      orderByList: orderByList?.call(ProjectedStudent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedStudent>(
      where: where?.call(ProjectedStudent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedStudent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedStudentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedStudent>(
      where: where(ProjectedStudent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectedStudentAttachRepository {
  const ProjectedStudentAttachRepository._();

  /// Creates a relation between this [ProjectedStudent] and the given [ProjectedEnrollment]s
  /// by setting each [ProjectedEnrollment]'s foreign key `studentId` to refer to this [ProjectedStudent].
  Future<void> enrollments(
    _i1.DatabaseSession session,
    ProjectedStudent projectedStudent,
    List<_i2.ProjectedEnrollment> projectedEnrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedEnrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (projectedStudent.id == null) {
      throw ArgumentError.notNull('projectedStudent.id');
    }

    var $projectedEnrollment = projectedEnrollment
        .map((e) => e.copyWith(studentId: projectedStudent.id))
        .toList();
    await session.db.update<_i2.ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [_i2.ProjectedEnrollment.t.studentId],
      transaction: transaction,
    );
  }
}

class ProjectedStudentAttachRowRepository {
  const ProjectedStudentAttachRowRepository._();

  /// Creates a relation between this [ProjectedStudent] and the given [ProjectedEnrollment]
  /// by setting the [ProjectedEnrollment]'s foreign key `studentId` to refer to this [ProjectedStudent].
  Future<void> enrollments(
    _i1.DatabaseSession session,
    ProjectedStudent projectedStudent,
    _i2.ProjectedEnrollment projectedEnrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (projectedEnrollment.id == null) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (projectedStudent.id == null) {
      throw ArgumentError.notNull('projectedStudent.id');
    }

    var $projectedEnrollment = projectedEnrollment.copyWith(
      studentId: projectedStudent.id,
    );
    await session.db.updateRow<_i2.ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [_i2.ProjectedEnrollment.t.studentId],
      transaction: transaction,
    );
  }
}
