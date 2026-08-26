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
import 'projected_course.dart' as _iotqocf1;
import 'projected_student.dart' as _iprfievr;

abstract class ProjectedEnrollment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProjectedEnrollment._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory ProjectedEnrollment({
    int? id,
    required int studentId,
    _iprfievr.ProjectedStudent? student,
    required int courseId,
    _iotqocf1.ProjectedCourse? course,
  }) = _ProjectedEnrollmentImpl;

  factory ProjectedEnrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedEnrollment(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iprfievr.ProjectedStudent>(
              jsonSerialization['student'],
            ),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iotqocf1.ProjectedCourse>(
              jsonSerialization['course'],
            ),
    );
  }

  static final t = ProjectedEnrollmentTable();

  static const db = ProjectedEnrollmentRepository._();

  @override
  int? id;

  int studentId;

  _iprfievr.ProjectedStudent? student;

  int courseId;

  _iotqocf1.ProjectedCourse? course;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedEnrollment copyWith({
    int? id,
    int? studentId,
    _iprfievr.ProjectedStudent? student,
    int? courseId,
    _iotqocf1.ProjectedCourse? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [ProjectedEnrollmentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedEnrollmentInclude include({
    _iprfievr.ProjectedStudentInclude? student,
    _iotqocf1.ProjectedCourseInclude? course,
  }) {
    return ProjectedEnrollmentInclude._(
      student: student,
      course: course,
    );
  }

  /// Builds a complete [ProjectedEnrollmentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ProjectedEnrollmentIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    ProjectedEnrollmentInclude? include,
  }) {
    return ProjectedEnrollmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ProjectedEnrollmentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ProjectedEnrollmentJsonInclude includeJson({
    _iprfievr.ProjectedStudentJsonInclude? student,
    _iotqocf1.ProjectedCourseJsonInclude? course,
    _is.SelectColumnsBuilder<ProjectedEnrollmentTable>? select,
  }) {
    return _ProjectedEnrollmentJsonInclude._(
      student: student,
      course: course,
      selectedColumns: select?.call(ProjectedEnrollment.t),
    );
  }

  /// Builds a JSON-compatible [ProjectedEnrollmentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ProjectedEnrollmentJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    ProjectedEnrollmentJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedEnrollmentTable>? select,
  }) {
    return _ProjectedEnrollmentJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      include: include,
      selectedColumns: select?.call(ProjectedEnrollment.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentImpl extends ProjectedEnrollment {
  _ProjectedEnrollmentImpl({
    int? id,
    required int studentId,
    _iprfievr.ProjectedStudent? student,
    required int courseId,
    _iotqocf1.ProjectedCourse? course,
  }) : super._(
         id: id,
         studentId: studentId,
         student: student,
         courseId: courseId,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedEnrollment copyWith({
    Object? id = _Undefined,
    int? studentId,
    Object? student = _Undefined,
    int? courseId,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollment(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _iprfievr.ProjectedStudent?
          ? student
          : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _iotqocf1.ProjectedCourse?
          ? course
          : this.course?.copyWith(),
    );
  }
}

class ProjectedEnrollmentUpdateTable
    extends _is.UpdateTable<ProjectedEnrollmentTable> {
  ProjectedEnrollmentUpdateTable(super.table);

  _is.ColumnValue<int, int> studentId(int value) => _is.ColumnValue(
    table.studentId,
    value,
  );

  _is.ColumnValue<int, int> courseId(int value) => _is.ColumnValue(
    table.courseId,
    value,
  );
}

class ProjectedEnrollmentTable extends _is.Table<int?> {
  ProjectedEnrollmentTable({super.tableRelation})
    : super(tableName: 'projected_enrollment') {
    updateTable = ProjectedEnrollmentUpdateTable(this);
    studentId = _is.ColumnInt(
      'studentId',
      this,
    );
    courseId = _is.ColumnInt(
      'courseId',
      this,
    );
  }

  late final ProjectedEnrollmentUpdateTable updateTable;

  late final _is.ColumnInt studentId;

  _iprfievr.ProjectedStudentTable? _student;

  late final _is.ColumnInt courseId;

  _iotqocf1.ProjectedCourseTable? _course;

  _iprfievr.ProjectedStudentTable get student {
    if (_student != null) return _student!;
    _student = _is.createRelationTable(
      relationFieldName: 'student',
      field: ProjectedEnrollment.t.studentId,
      foreignField: _iprfievr.ProjectedStudent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iprfievr.ProjectedStudentTable(tableRelation: foreignTableRelation),
    );
    return _student!;
  }

  _iotqocf1.ProjectedCourseTable get course {
    if (_course != null) return _course!;
    _course = _is.createRelationTable(
      relationFieldName: 'course',
      field: ProjectedEnrollment.t.courseId,
      foreignField: _iotqocf1.ProjectedCourse.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iotqocf1.ProjectedCourseTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    studentId,
    courseId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'student') {
      return student;
    }
    if (relationField == 'course') {
      return course;
    }
    return null;
  }
}

abstract interface class ProjectedEnrollmentJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ProjectedEnrollmentJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ProjectedEnrollmentInclude extends _is.IncludeObject
    implements ProjectedEnrollmentJsonInclude, _is.FullModelInclude {
  ProjectedEnrollmentInclude._({
    _iprfievr.ProjectedStudentInclude? student,
    _iotqocf1.ProjectedCourseInclude? course,
  }) {
    _student = student;
    _course = course;
  }

  _iprfievr.ProjectedStudentInclude? _student;

  _iotqocf1.ProjectedCourseInclude? _course;

  @override
  Map<String, _is.Include?> get includes => {
    'student': _student,
    'course': _course,
  };

  @override
  _is.Table<int?> get table => ProjectedEnrollment.t;
}

final class ProjectedEnrollmentIncludeList extends _is.IncludeList
    implements ProjectedEnrollmentJsonIncludeList, _is.FullModelInclude {
  ProjectedEnrollmentIncludeList._({
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedEnrollmentInclude? super.include,
  }) {
    super.where = where?.call(ProjectedEnrollment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedEnrollment.t;
}

final class _ProjectedEnrollmentJsonInclude extends _is.IncludeObject
    implements ProjectedEnrollmentJsonInclude {
  _ProjectedEnrollmentJsonInclude._({
    _iprfievr.ProjectedStudentJsonInclude? student,
    _iotqocf1.ProjectedCourseJsonInclude? course,
    this.selectedColumns,
  }) {
    _student = student;
    _course = course;
  }

  _iprfievr.ProjectedStudentJsonInclude? _student;

  _iotqocf1.ProjectedCourseJsonInclude? _course;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'student': _student,
    'course': _course,
  };

  @override
  _is.Table<int?> get table => ProjectedEnrollment.t;
}

final class _ProjectedEnrollmentJsonIncludeList extends _is.IncludeList
    implements ProjectedEnrollmentJsonIncludeList {
  _ProjectedEnrollmentJsonIncludeList._({
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ProjectedEnrollmentJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedEnrollment.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProjectedEnrollment.t;
}

class ProjectedEnrollmentRepository {
  const ProjectedEnrollmentRepository._();

  final attachRow = const ProjectedEnrollmentAttachRowRepository._();

  /// Returns a list of [ProjectedEnrollment]s matching the given query parameters.
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
  Future<List<ProjectedEnrollment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedEnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedEnrollment>(
      where: where?.call(ProjectedEnrollment.t),
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedEnrollment] matching the given query parameters.
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
  Future<ProjectedEnrollment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedEnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedEnrollment>(
      where: where?.call(ProjectedEnrollment.t),
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedEnrollment] by its [id] or null if no such row exists.
  Future<ProjectedEnrollment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ProjectedEnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedEnrollment>(
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
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedEnrollmentJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedEnrollmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedEnrollment>(
      where: where?.call(ProjectedEnrollment.t),
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedEnrollment.t),
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
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    ProjectedEnrollmentJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedEnrollmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedEnrollment>(
      where: where?.call(ProjectedEnrollment.t),
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedEnrollment.t),
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
    ProjectedEnrollmentJsonInclude? include,
    _is.SelectColumnsBuilder<ProjectedEnrollmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedEnrollment>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ProjectedEnrollment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedEnrollment]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedEnrollment]s will have their `id` fields set.
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
  Future<List<ProjectedEnrollment>> insert(
    _is.DatabaseSession session,
    List<ProjectedEnrollment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedEnrollment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedEnrollment] and returns the inserted row.
  ///
  /// The returned [ProjectedEnrollment] will have its `id` field set.
  Future<ProjectedEnrollment> insertRow(
    _is.DatabaseSession session,
    ProjectedEnrollment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedEnrollment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedEnrollment]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedEnrollment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedEnrollment>> upsert(
    _is.DatabaseSession session,
    List<ProjectedEnrollment> rows, {
    required _is.ColumnSelections<ProjectedEnrollmentTable> conflictColumns,
    _is.ColumnSelections<ProjectedEnrollmentTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedEnrollment>(
      rows,
      conflictColumns: conflictColumns(ProjectedEnrollment.t),
      updateColumns: updateColumns?.call(ProjectedEnrollment.t),
      updateWhere: updateWhere?.call(ProjectedEnrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedEnrollment] and returns the resulting row.
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
  /// The returned [ProjectedEnrollment] will have its `id` field set.
  Future<ProjectedEnrollment?> upsertRow(
    _is.DatabaseSession session,
    ProjectedEnrollment row, {
    required _is.ColumnSelections<ProjectedEnrollmentTable> conflictColumns,
    _is.ColumnSelections<ProjectedEnrollmentTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedEnrollment>(
      row,
      conflictColumns: conflictColumns(ProjectedEnrollment.t),
      updateColumns: updateColumns?.call(ProjectedEnrollment.t),
      updateWhere: updateWhere?.call(ProjectedEnrollment.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedEnrollment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedEnrollment>> update(
    _is.DatabaseSession session,
    List<ProjectedEnrollment> rows, {
    _is.ColumnSelections<ProjectedEnrollmentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedEnrollment>(
      rows,
      columns: columns?.call(ProjectedEnrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedEnrollment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedEnrollment> updateRow(
    _is.DatabaseSession session,
    ProjectedEnrollment row, {
    _is.ColumnSelections<ProjectedEnrollmentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedEnrollment>(
      row,
      columns: columns?.call(ProjectedEnrollment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedEnrollment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedEnrollment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProjectedEnrollmentUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedEnrollment>(
      id,
      columnValues: columnValues(ProjectedEnrollment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedEnrollment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedEnrollment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedEnrollmentUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProjectedEnrollmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedEnrollment>(
      columnValues: columnValues(ProjectedEnrollment.t.updateTable),
      where: where(ProjectedEnrollment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedEnrollment]s in the list and returns the deleted rows.
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
  Future<List<ProjectedEnrollment>> delete(
    _is.DatabaseSession session,
    List<ProjectedEnrollment> rows, {
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedEnrollment>(
      rows,
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedEnrollment].
  Future<ProjectedEnrollment> deleteRow(
    _is.DatabaseSession session,
    ProjectedEnrollment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedEnrollment>(
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
  Future<List<ProjectedEnrollment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedEnrollmentTable> where,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedEnrollment>(
      where: where(ProjectedEnrollment.t),
      orderBy: orderBy?.call(ProjectedEnrollment.t),
      orderByList: orderByList?.call(ProjectedEnrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedEnrollment>(
      where: where?.call(ProjectedEnrollment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedEnrollment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedEnrollmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedEnrollment>(
      where: where(ProjectedEnrollment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectedEnrollmentAttachRowRepository {
  const ProjectedEnrollmentAttachRowRepository._();

  /// Creates a relation between the given [ProjectedEnrollment] and [ProjectedStudent]
  /// by setting the [ProjectedEnrollment]'s foreign key `studentId` to refer to the [ProjectedStudent].
  Future<void> student(
    _is.DatabaseSession session,
    ProjectedEnrollment projectedEnrollment,
    _iprfievr.ProjectedStudent student, {
    _is.Transaction? transaction,
  }) async {
    if (projectedEnrollment.id == null) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $projectedEnrollment = projectedEnrollment.copyWith(
      studentId: student.id,
    );
    await session.db.updateRow<ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [ProjectedEnrollment.t.studentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ProjectedEnrollment] and [ProjectedCourse]
  /// by setting the [ProjectedEnrollment]'s foreign key `courseId` to refer to the [ProjectedCourse].
  Future<void> course(
    _is.DatabaseSession session,
    ProjectedEnrollment projectedEnrollment,
    _iotqocf1.ProjectedCourse course, {
    _is.Transaction? transaction,
  }) async {
    if (projectedEnrollment.id == null) {
      throw ArgumentError.notNull('projectedEnrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $projectedEnrollment = projectedEnrollment.copyWith(
      courseId: course.id,
    );
    await session.db.updateRow<ProjectedEnrollment>(
      $projectedEnrollment,
      columns: [ProjectedEnrollment.t.courseId],
      transaction: transaction,
    );
  }
}
