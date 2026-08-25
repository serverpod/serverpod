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
import '../../models_with_relations/many_to_many/enrollment.dart' as _im07rq0v;

abstract class Course
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Course._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory Course({
    int? id,
    required String name,
    List<_im07rq0v.Enrollment>? enrollments,
  }) = _CourseImpl;

  factory Course.fromJson(Map<String, dynamic> jsonSerialization) {
    return Course(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_im07rq0v.Enrollment>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  static final t = CourseTable();

  static const db = CourseRepository._();

  @override
  int? id;

  String name;

  List<_im07rq0v.Enrollment>? enrollments;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Course copyWith({
    int? id,
    String? name,
    List<_im07rq0v.Enrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Course',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Course',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static CourseInclude include({
    _im07rq0v.EnrollmentIncludeList? enrollments,
    _isd.SelectColumnsBuilder<CourseTable>? select,
  }) {
    return CourseInclude._(
      enrollments: enrollments,
      selectedColumns: select?.call(Course.t),
    );
  }

  static CourseIncludeList includeList({
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    CourseInclude? include,
    _isd.SelectColumnsBuilder<CourseTable>? select,
  }) {
    return CourseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      include: include,
      selectedColumns: select?.call(Course.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseImpl extends Course {
  _CourseImpl({
    int? id,
    required String name,
    List<_im07rq0v.Enrollment>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Course copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return Course(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_im07rq0v.Enrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CourseUpdateTable extends _isd.UpdateTable<CourseTable> {
  CourseUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );
}

class CourseTable extends _isd.Table<int?> {
  CourseTable({super.tableRelation}) : super(tableName: 'course') {
    updateTable = CourseUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
  }

  late final CourseUpdateTable updateTable;

  late final _isd.ColumnString name;

  _im07rq0v.EnrollmentTable? ___enrollments;

  _isd.ManyRelation<_im07rq0v.EnrollmentTable>? _enrollments;

  _im07rq0v.EnrollmentTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _isd.createRelationTable(
      relationFieldName: '__enrollments',
      field: Course.t.id,
      foreignField: _im07rq0v.Enrollment.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _im07rq0v.EnrollmentTable(tableRelation: foreignTableRelation),
    );
    return ___enrollments!;
  }

  _isd.ManyRelation<_im07rq0v.EnrollmentTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'enrollments',
      field: Course.t.id,
      foreignField: _im07rq0v.Enrollment.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _im07rq0v.EnrollmentTable(tableRelation: foreignTableRelation),
    );
    _enrollments = _isd.ManyRelation<_im07rq0v.EnrollmentTable>(
      tableWithRelations: relationTable,
      table: _im07rq0v.EnrollmentTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _enrollments!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    name,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'enrollments') {
      return __enrollments;
    }
    return null;
  }
}

class CourseInclude extends _isd.IncludeObject {
  CourseInclude._({
    _im07rq0v.EnrollmentIncludeList? enrollments,
    this.selectedColumns,
  }) {
    _enrollments = enrollments;
  }

  _im07rq0v.EnrollmentIncludeList? _enrollments;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'enrollments': _enrollments};

  @override
  _isd.Table<int?> get table => Course.t;
}

class CourseIncludeList extends _isd.IncludeList {
  CourseIncludeList._({
    _isd.WhereExpressionBuilder<CourseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Course.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Course.t;
}

class CourseRepository {
  const CourseRepository._();

  final attach = const CourseAttachRepository._();

  final attachRow = const CourseAttachRowRepository._();

  /// Returns a list of [Course]s matching the given query parameters.
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
  Future<List<Course>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Course] matching the given query parameters.
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
  Future<Course?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Course] by its [id] or null if no such row exists.
  Future<Course?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Course>(
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

  Future<List<Map<String, dynamic>>> findAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.SelectColumnsBuilder<CourseTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Course.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.SelectColumnsBuilder<CourseTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Course.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    CourseInclude? include,
    _isd.SelectColumnsBuilder<CourseTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Course>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Course.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Course]s in the list and returns the inserted rows.
  ///
  /// The returned [Course]s will have their `id` fields set.
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
  Future<List<Course>> insert(
    _isd.DatabaseSession session,
    List<Course> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Course>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Course] and returns the inserted row.
  ///
  /// The returned [Course] will have its `id` field set.
  Future<Course> insertRow(
    _isd.DatabaseSession session,
    Course row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Course>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Course]s in the list and returns the resulting rows.
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
  /// The returned [Course]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Course>> upsert(
    _isd.DatabaseSession session,
    List<Course> rows, {
    required _isd.ColumnSelections<CourseTable> conflictColumns,
    _isd.ColumnSelections<CourseTable>? updateColumns,
    _isd.WhereExpressionBuilder<CourseTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Course>(
      rows,
      conflictColumns: conflictColumns(Course.t),
      updateColumns: updateColumns?.call(Course.t),
      updateWhere: updateWhere?.call(Course.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Course] and returns the resulting row.
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
  /// The returned [Course] will have its `id` field set.
  Future<Course?> upsertRow(
    _isd.DatabaseSession session,
    Course row, {
    required _isd.ColumnSelections<CourseTable> conflictColumns,
    _isd.ColumnSelections<CourseTable>? updateColumns,
    _isd.WhereExpressionBuilder<CourseTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Course>(
      row,
      conflictColumns: conflictColumns(Course.t),
      updateColumns: updateColumns?.call(Course.t),
      updateWhere: updateWhere?.call(Course.t),
      transaction: transaction,
    );
  }

  /// Updates all [Course]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Course>> update(
    _isd.DatabaseSession session,
    List<Course> rows, {
    _isd.ColumnSelections<CourseTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Course>(
      rows,
      columns: columns?.call(Course.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Course]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Course> updateRow(
    _isd.DatabaseSession session,
    Course row, {
    _isd.ColumnSelections<CourseTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Course>(
      row,
      columns: columns?.call(Course.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Course] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Course?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<CourseUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Course>(
      id,
      columnValues: columnValues(Course.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Course]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Course>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<CourseUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<CourseTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Course>(
      columnValues: columnValues(Course.t.updateTable),
      where: where(Course.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Course]s in the list and returns the deleted rows.
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
  Future<List<Course>> delete(
    _isd.DatabaseSession session,
    List<Course> rows, {
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Course>(
      rows,
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Course].
  Future<Course> deleteRow(
    _isd.DatabaseSession session,
    Course row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Course>(
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
  Future<List<Course>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CourseTable> where,
    _isd.OrderByBuilder<CourseTable>? orderBy,
    _isd.OrderByListBuilder<CourseTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Course>(
      where: where(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Course>(
      where: where?.call(Course.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Course] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CourseTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Course>(
      where: where(Course.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseAttachRepository {
  const CourseAttachRepository._();

  /// Creates a relation between this [Course] and the given [Enrollment]s
  /// by setting each [Enrollment]'s foreign key `courseId` to refer to this [Course].
  Future<void> enrollments(
    _isd.DatabaseSession session,
    Course course,
    List<_im07rq0v.Enrollment> enrollment, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment = enrollment
        .map((e) => e.copyWith(courseId: course.id))
        .toList();
    await session.db.update<_im07rq0v.Enrollment>(
      $enrollment,
      columns: [_im07rq0v.Enrollment.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseAttachRowRepository {
  const CourseAttachRowRepository._();

  /// Creates a relation between this [Course] and the given [Enrollment]
  /// by setting the [Enrollment]'s foreign key `courseId` to refer to this [Course].
  Future<void> enrollments(
    _isd.DatabaseSession session,
    Course course,
    _im07rq0v.Enrollment enrollment, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment = enrollment.copyWith(courseId: course.id);
    await session.db.updateRow<_im07rq0v.Enrollment>(
      $enrollment,
      columns: [_im07rq0v.Enrollment.t.courseId],
      transaction: transaction,
    );
  }
}
