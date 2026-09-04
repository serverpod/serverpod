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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../models_with_relations/many_to_many/course.dart' as _iwlbbfis;
import '../../models_with_relations/many_to_many/student.dart' as _i2rea1ue;

abstract class Enrollment
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Enrollment._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory Enrollment({
    int? id,
    required int studentId,
    _i2rea1ue.Student? student,
    required int courseId,
    _iwlbbfis.Course? course,
  }) = _EnrollmentImpl;

  factory Enrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Enrollment(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i2rea1ue.Student>(
              jsonSerialization['student'],
            ),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_iwlbbfis.Course>(
              jsonSerialization['course'],
            ),
    );
  }

  static final t = EnrollmentTable();

  static const db = EnrollmentRepository._();

  @override
  int? id;

  int studentId;

  _i2rea1ue.Student? student;

  int courseId;

  _iwlbbfis.Course? course;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Enrollment copyWith({
    int? id,
    int? studentId,
    _i2rea1ue.Student? student,
    int? courseId,
    _iwlbbfis.Course? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Enrollment',
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
      '__className__': 'Enrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [EnrollmentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnrollmentInclude include({
    _i2rea1ue.StudentInclude? student,
    _iwlbbfis.CourseInclude? course,
  }) {
    return EnrollmentInclude._(
      student: student,
      course: course,
    );
  }

  /// Builds a complete [EnrollmentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnrollmentIncludeList includeList({
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    EnrollmentInclude? include,
  }) {
    return EnrollmentIncludeList._(
      where: where?.call(Enrollment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EnrollmentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EnrollmentJsonInclude includeJson({
    _i2rea1ue.StudentJsonInclude? student,
    _iwlbbfis.CourseJsonInclude? course,
    _isd.SelectColumnsBuilder<EnrollmentTable>? select,
  }) {
    return _EnrollmentJsonInclude._(
      student: student,
      course: course,
      selectedColumns: select?.call(Enrollment.t),
    );
  }

  /// Builds a JSON-compatible [EnrollmentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EnrollmentJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    EnrollmentJsonInclude? include,
    _isd.SelectColumnsBuilder<EnrollmentTable>? select,
  }) {
    return _EnrollmentJsonIncludeList._(
      where: where?.call(Enrollment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      include: include,
      selectedColumns: select?.call(Enrollment.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentImpl extends Enrollment {
  _EnrollmentImpl({
    int? id,
    required int studentId,
    _i2rea1ue.Student? student,
    required int courseId,
    _iwlbbfis.Course? course,
  }) : super._(
         id: id,
         studentId: studentId,
         student: student,
         courseId: courseId,
         course: course,
       );

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Enrollment copyWith({
    Object? id = _Undefined,
    int? studentId,
    Object? student = _Undefined,
    int? courseId,
    Object? course = _Undefined,
  }) {
    return Enrollment(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _i2rea1ue.Student?
          ? student
          : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _iwlbbfis.Course? ? course : this.course?.copyWith(),
    );
  }
}

class EnrollmentUpdateTable extends _isd.UpdateTable<EnrollmentTable> {
  EnrollmentUpdateTable(super.table);

  _isd.ColumnValue<int, int> studentId(int value) => _isd.ColumnValue(
    table.studentId,
    value,
  );

  _isd.ColumnValue<int, int> courseId(int value) => _isd.ColumnValue(
    table.courseId,
    value,
  );
}

class EnrollmentTable extends _isd.Table<int?> {
  EnrollmentTable({super.tableRelation}) : super(tableName: 'enrollment') {
    updateTable = EnrollmentUpdateTable(this);
    studentId = _isd.ColumnInt(
      'studentId',
      this,
    );
    courseId = _isd.ColumnInt(
      'courseId',
      this,
    );
  }

  late final EnrollmentUpdateTable updateTable;

  late final _isd.ColumnInt studentId;

  _i2rea1ue.StudentTable? _student;

  late final _isd.ColumnInt courseId;

  _iwlbbfis.CourseTable? _course;

  _i2rea1ue.StudentTable get student {
    if (_student != null) return _student!;
    _student = _isd.createRelationTable(
      relationFieldName: 'student',
      field: Enrollment.t.studentId,
      foreignField: _i2rea1ue.Student.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2rea1ue.StudentTable(tableRelation: foreignTableRelation),
    );
    return _student!;
  }

  _iwlbbfis.CourseTable get course {
    if (_course != null) return _course!;
    _course = _isd.createRelationTable(
      relationFieldName: 'course',
      field: Enrollment.t.courseId,
      foreignField: _iwlbbfis.Course.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iwlbbfis.CourseTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    studentId,
    courseId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'student') {
      return student;
    }
    if (relationField == 'course') {
      return course;
    }
    return null;
  }
}

abstract interface class EnrollmentJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class EnrollmentJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class EnrollmentInclude extends _isd.IncludeObject
    implements EnrollmentJsonInclude, _isd.FullModelInclude {
  EnrollmentInclude._({
    _i2rea1ue.StudentInclude? student,
    _iwlbbfis.CourseInclude? course,
  }) {
    _student = student;
    _course = course;
  }

  _i2rea1ue.StudentInclude? _student;

  _iwlbbfis.CourseInclude? _course;

  @override
  Map<String, _isd.Include?> get includes => {
    'student': _student,
    'course': _course,
  };

  @override
  _isd.Table<int?> get table => Enrollment.t;
}

final class EnrollmentIncludeList extends _isd.IncludeList
    implements EnrollmentJsonIncludeList, _isd.FullModelInclude {
  EnrollmentIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnrollmentInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Enrollment.t;
}

final class _EnrollmentJsonInclude extends _isd.IncludeObject
    implements EnrollmentJsonInclude {
  _EnrollmentJsonInclude._({
    _i2rea1ue.StudentJsonInclude? student,
    _iwlbbfis.CourseJsonInclude? course,
    this.selectedColumns,
  }) {
    _student = student;
    _course = course;
  }

  _i2rea1ue.StudentJsonInclude? _student;

  _iwlbbfis.CourseJsonInclude? _course;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {
    'student': _student,
    'course': _course,
  };

  @override
  _isd.Table<int?> get table => Enrollment.t;
}

final class _EnrollmentJsonIncludeList extends _isd.IncludeList
    implements EnrollmentJsonIncludeList {
  _EnrollmentJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnrollmentJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Enrollment.t;
}

class EnrollmentRepository {
  const EnrollmentRepository._();

  final attachRow = const EnrollmentAttachRowRepository._();

  /// Returns a list of [Enrollment]s matching the given query parameters.
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
  Future<List<Enrollment>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    EnrollmentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Enrollment] matching the given query parameters.
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
  Future<Enrollment?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    EnrollmentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Enrollment] by its [id] or null if no such row exists.
  Future<Enrollment?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    EnrollmentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Enrollment>(
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    EnrollmentJsonInclude? include,
    _isd.SelectColumnsBuilder<EnrollmentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Enrollment.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    EnrollmentJsonInclude? include,
    _isd.SelectColumnsBuilder<EnrollmentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Enrollment.t),
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
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    EnrollmentJsonInclude? include,
    _isd.SelectColumnsBuilder<EnrollmentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Enrollment>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Enrollment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Enrollment]s in the list and returns the inserted rows.
  ///
  /// The returned [Enrollment]s will have their `id` fields set.
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
  Future<List<Enrollment>> insert(
    _isd.DatabaseSession session,
    List<Enrollment> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Enrollment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Enrollment] and returns the inserted row.
  ///
  /// The returned [Enrollment] will have its `id` field set.
  Future<Enrollment> insertRow(
    _isd.DatabaseSession session,
    Enrollment row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Enrollment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Enrollment]s in the list and returns the resulting rows.
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
  /// The returned [Enrollment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Enrollment>> upsert(
    _isd.DatabaseSession session,
    List<Enrollment> rows, {
    required _isd.ColumnSelections<EnrollmentTable> conflictColumns,
    _isd.ColumnSelections<EnrollmentTable>? updateColumns,
    _isd.WhereExpressionBuilder<EnrollmentTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Enrollment>(
      rows,
      conflictColumns: conflictColumns(Enrollment.t),
      updateColumns: updateColumns?.call(Enrollment.t),
      updateWhere: updateWhere?.call(Enrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Enrollment] and returns the resulting row.
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
  /// The returned [Enrollment] will have its `id` field set.
  Future<Enrollment?> upsertRow(
    _isd.DatabaseSession session,
    Enrollment row, {
    required _isd.ColumnSelections<EnrollmentTable> conflictColumns,
    _isd.ColumnSelections<EnrollmentTable>? updateColumns,
    _isd.WhereExpressionBuilder<EnrollmentTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Enrollment>(
      row,
      conflictColumns: conflictColumns(Enrollment.t),
      updateColumns: updateColumns?.call(Enrollment.t),
      updateWhere: updateWhere?.call(Enrollment.t),
      transaction: transaction,
    );
  }

  /// Updates all [Enrollment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Enrollment>> update(
    _isd.DatabaseSession session,
    List<Enrollment> rows, {
    _isd.ColumnSelections<EnrollmentTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Enrollment>(
      rows,
      columns: columns?.call(Enrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Enrollment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Enrollment> updateRow(
    _isd.DatabaseSession session,
    Enrollment row, {
    _isd.ColumnSelections<EnrollmentTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Enrollment>(
      row,
      columns: columns?.call(Enrollment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Enrollment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Enrollment?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<EnrollmentUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Enrollment>(
      id,
      columnValues: columnValues(Enrollment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Enrollment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Enrollment>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<EnrollmentUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<EnrollmentTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Enrollment>(
      columnValues: columnValues(Enrollment.t.updateTable),
      where: where(Enrollment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Enrollment]s in the list and returns the deleted rows.
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
  Future<List<Enrollment>> delete(
    _isd.DatabaseSession session,
    List<Enrollment> rows, {
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Enrollment>(
      rows,
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Enrollment].
  Future<Enrollment> deleteRow(
    _isd.DatabaseSession session,
    Enrollment row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Enrollment>(
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
  Future<List<Enrollment>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<EnrollmentTable> where,
    _isd.OrderByBuilder<EnrollmentTable>? orderBy,
    _isd.OrderByListBuilder<EnrollmentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Enrollment>(
      where: where(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Enrollment>(
      where: where?.call(Enrollment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Enrollment] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<EnrollmentTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Enrollment>(
      where: where(Enrollment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EnrollmentAttachRowRepository {
  const EnrollmentAttachRowRepository._();

  /// Creates a relation between the given [Enrollment] and [Student]
  /// by setting the [Enrollment]'s foreign key `studentId` to refer to the [Student].
  Future<void> student(
    _isd.DatabaseSession session,
    Enrollment enrollment,
    _i2rea1ue.Student student, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment = enrollment.copyWith(studentId: student.id);
    await session.db.updateRow<Enrollment>(
      $enrollment,
      columns: [Enrollment.t.studentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Enrollment] and [Course]
  /// by setting the [Enrollment]'s foreign key `courseId` to refer to the [Course].
  Future<void> course(
    _isd.DatabaseSession session,
    Enrollment enrollment,
    _iwlbbfis.Course course, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment = enrollment.copyWith(courseId: course.id);
    await session.db.updateRow<Enrollment>(
      $enrollment,
      columns: [Enrollment.t.courseId],
      transaction: transaction,
    );
  }
}
