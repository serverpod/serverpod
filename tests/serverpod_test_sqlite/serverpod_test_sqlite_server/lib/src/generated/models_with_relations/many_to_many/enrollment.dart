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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../../models_with_relations/many_to_many/course.dart' as _iwlbbfis;
import '../../models_with_relations/many_to_many/student.dart' as _i2rea1ue;

abstract class Enrollment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _i08l111i.Protocol().deserialize<_i2rea1ue.Student>(
              jsonSerialization['student'],
            ),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iwlbbfis.Course>(
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
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static EnrollmentInclude include({
    _i2rea1ue.StudentInclude? student,
    _iwlbbfis.CourseInclude? course,
    _is.SelectColumnsBuilder<EnrollmentTable>? select,
  }) {
    return EnrollmentInclude.internal_(
      student: student,
      course: course,
      selectedColumns: select?.call(Enrollment.t),
    );
  }

  static EnrollmentIncludeList includeList({
    _is.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    EnrollmentInclude? include,
    _is.SelectColumnsBuilder<EnrollmentTable>? select,
  }) {
    return EnrollmentIncludeList.internal_(
      where: where,
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
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class EnrollmentUpdateTable extends _is.UpdateTable<EnrollmentTable> {
  EnrollmentUpdateTable(super.table);

  _is.ColumnValue<int, int> studentId(int value) => _is.ColumnValue(
    table.studentId,
    value,
  );

  _is.ColumnValue<int, int> courseId(int value) => _is.ColumnValue(
    table.courseId,
    value,
  );
}

class EnrollmentTable extends _is.Table<int?> {
  EnrollmentTable({super.tableRelation}) : super(tableName: 'enrollment') {
    updateTable = EnrollmentUpdateTable(this);
    studentId = _is.ColumnInt(
      'studentId',
      this,
    );
    courseId = _is.ColumnInt(
      'courseId',
      this,
    );
  }

  late final EnrollmentUpdateTable updateTable;

  late final _is.ColumnInt studentId;

  _i2rea1ue.StudentTable? _student;

  late final _is.ColumnInt courseId;

  _iwlbbfis.CourseTable? _course;

  _i2rea1ue.StudentTable get student {
    if (_student != null) return _student!;
    _student = _is.createRelationTable(
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
    _course = _is.createRelationTable(
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

class EnrollmentInclude extends _is.IncludeObject {
  EnrollmentInclude.internal_({
    _i2rea1ue.StudentInclude? student,
    _iwlbbfis.CourseInclude? course,
    this.selectedColumns,
  }) {
    _student = student;
    _course = course;
  }

  _i2rea1ue.StudentInclude? _student;

  _iwlbbfis.CourseInclude? _course;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'student': _student,
    'course': _course,
  };

  @override
  _is.Table<int?> get table => Enrollment.t;
}

class EnrollmentIncludeList extends _is.IncludeList {
  EnrollmentIncludeList.internal_({
    _is.WhereExpressionBuilder<EnrollmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Enrollment.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Enrollment.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    EnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnrollmentTable>? where,
    int? offset,
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    EnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    EnrollmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Enrollment>(
      id,
      transaction: transaction,
      include: include,
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
    _is.DatabaseSession session,
    List<Enrollment> rows, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Enrollment row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Enrollment> rows, {
    required _is.ColumnSelections<EnrollmentTable> conflictColumns,
    _is.ColumnSelections<EnrollmentTable>? updateColumns,
    _is.WhereExpressionBuilder<EnrollmentTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Enrollment row, {
    required _is.ColumnSelections<EnrollmentTable> conflictColumns,
    _is.ColumnSelections<EnrollmentTable>? updateColumns,
    _is.WhereExpressionBuilder<EnrollmentTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Enrollment> rows, {
    _is.ColumnSelections<EnrollmentTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Enrollment row, {
    _is.ColumnSelections<EnrollmentTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EnrollmentUpdateTable> columnValues,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EnrollmentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EnrollmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Enrollment> rows, {
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Enrollment row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnrollmentTable> where,
    _is.OrderByBuilder<EnrollmentTable>? orderBy,
    _is.OrderByListBuilder<EnrollmentTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Enrollment>(
      where: where?.call(Enrollment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Enrollment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnrollmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
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
    _is.DatabaseSession session,
    Enrollment enrollment,
    _i2rea1ue.Student student, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Enrollment enrollment,
    _iwlbbfis.Course course, {
    _is.Transaction? transaction,
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
