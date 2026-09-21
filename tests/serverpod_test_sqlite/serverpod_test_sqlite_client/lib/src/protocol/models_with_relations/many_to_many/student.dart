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

abstract class Student
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Student._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory Student({
    int? id,
    required String name,
    List<_im07rq0v.Enrollment>? enrollments,
  }) = _StudentImpl;

  factory Student.fromJson(Map<String, dynamic> jsonSerialization) {
    return Student(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_im07rq0v.Enrollment>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  static final t = StudentTable();

  static const db = StudentRepository._();

  @override
  int? id;

  String name;

  List<_im07rq0v.Enrollment>? enrollments;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Student]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Student copyWith({
    int? id,
    String? name,
    List<_im07rq0v.Enrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Student',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Student',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  /// Builds a complete [StudentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StudentInclude include({
    _im07rq0v.EnrollmentIncludeList? enrollments,
  }) {
    return StudentInclude._(enrollments: enrollments);
  }

  /// Builds a complete [StudentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StudentIncludeList includeList({
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    StudentInclude? include,
  }) {
    return StudentIncludeList._(
      where: where?.call(Student.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [StudentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static StudentJsonInclude includeJson({
    _im07rq0v.EnrollmentJsonIncludeList? enrollments,
    _isd.SelectColumnsBuilder<StudentTable>? select,
  }) {
    return _StudentJsonInclude._(
      enrollments: enrollments,
      selectedColumns: select?.call(Student.t),
    );
  }

  /// Builds a JSON-compatible [StudentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static StudentJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    StudentJsonInclude? include,
    _isd.SelectColumnsBuilder<StudentTable>? select,
  }) {
    return _StudentJsonIncludeList._(
      where: where?.call(Student.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      include: include,
      selectedColumns: select?.call(Student.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentImpl extends Student {
  _StudentImpl({
    int? id,
    required String name,
    List<_im07rq0v.Enrollment>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [Student]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Student copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return Student(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_im07rq0v.Enrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class StudentUpdateTable extends _isd.UpdateTable<StudentTable> {
  StudentUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );
}

class StudentTable extends _isd.Table<int?> {
  StudentTable({super.tableRelation}) : super(tableName: 'student') {
    updateTable = StudentUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
  }

  late final StudentUpdateTable updateTable;

  late final _isd.ColumnString name;

  _im07rq0v.EnrollmentTable? ___enrollments;

  _isd.ManyRelation<_im07rq0v.EnrollmentTable>? _enrollments;

  _im07rq0v.EnrollmentTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _isd.createRelationTable(
      relationFieldName: '__enrollments',
      field: Student.t.id,
      foreignField: _im07rq0v.Enrollment.t.studentId,
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
      field: Student.t.id,
      foreignField: _im07rq0v.Enrollment.t.studentId,
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

abstract interface class StudentJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class StudentJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class StudentInclude extends _isd.IncludeObject
    implements StudentJsonInclude, _isd.FullModelInclude {
  StudentInclude._({_im07rq0v.EnrollmentIncludeList? enrollments}) {
    _enrollments = enrollments;
  }

  _im07rq0v.EnrollmentIncludeList? _enrollments;

  @override
  Map<String, _isd.Include?> get includes => {'enrollments': _enrollments};

  @override
  _isd.Table<int?> get table => Student.t;
}

final class StudentIncludeList extends _isd.IncludeList
    implements StudentJsonIncludeList, _isd.FullModelInclude {
  StudentIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StudentInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Student.t;
}

final class _StudentJsonInclude extends _isd.IncludeObject
    implements StudentJsonInclude {
  _StudentJsonInclude._({
    _im07rq0v.EnrollmentJsonIncludeList? enrollments,
    this.selectedColumns,
  }) {
    _enrollments = enrollments;
  }

  _im07rq0v.EnrollmentJsonIncludeList? _enrollments;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'enrollments': _enrollments};

  @override
  _isd.Table<int?> get table => Student.t;
}

final class _StudentJsonIncludeList extends _isd.IncludeList
    implements StudentJsonIncludeList {
  _StudentJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StudentJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Student.t;
}

class StudentRepository {
  const StudentRepository._();

  final attach = const StudentAttachRepository._();

  final attachRow = const StudentAttachRowRepository._();

  /// Returns a list of [Student]s matching the given query parameters.
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
  Future<List<Student>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    StudentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Student] matching the given query parameters.
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
  Future<Student?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    StudentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Student] by its [id] or null if no such row exists.
  Future<Student?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    StudentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Student>(
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
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    StudentJsonInclude? include,
    _isd.SelectColumnsBuilder<StudentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Student.t),
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
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    StudentJsonInclude? include,
    _isd.SelectColumnsBuilder<StudentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Student.t),
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
    StudentJsonInclude? include,
    _isd.SelectColumnsBuilder<StudentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Student>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Student.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Student]s in the list and returns the inserted rows.
  ///
  /// The returned [Student]s will have their `id` fields set.
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
  Future<List<Student>> insert(
    _isd.DatabaseSession session,
    List<Student> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Student>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Student] and returns the inserted row.
  ///
  /// The returned [Student] will have its `id` field set.
  Future<Student> insertRow(
    _isd.DatabaseSession session,
    Student row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Student>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Student]s in the list and returns the resulting rows.
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
  /// The returned [Student]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Student>> upsert(
    _isd.DatabaseSession session,
    List<Student> rows, {
    required _isd.ColumnSelections<StudentTable> conflictColumns,
    _isd.ColumnSelections<StudentTable>? updateColumns,
    _isd.WhereExpressionBuilder<StudentTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Student>(
      rows,
      conflictColumns: conflictColumns(Student.t),
      updateColumns: updateColumns?.call(Student.t),
      updateWhere: updateWhere?.call(Student.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Student] and returns the resulting row.
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
  /// The returned [Student] will have its `id` field set.
  Future<Student?> upsertRow(
    _isd.DatabaseSession session,
    Student row, {
    required _isd.ColumnSelections<StudentTable> conflictColumns,
    _isd.ColumnSelections<StudentTable>? updateColumns,
    _isd.WhereExpressionBuilder<StudentTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Student>(
      row,
      conflictColumns: conflictColumns(Student.t),
      updateColumns: updateColumns?.call(Student.t),
      updateWhere: updateWhere?.call(Student.t),
      transaction: transaction,
    );
  }

  /// Updates all [Student]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Student>> update(
    _isd.DatabaseSession session,
    List<Student> rows, {
    _isd.ColumnSelections<StudentTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Student>(
      rows,
      columns: columns?.call(Student.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Student]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Student> updateRow(
    _isd.DatabaseSession session,
    Student row, {
    _isd.ColumnSelections<StudentTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Student>(
      row,
      columns: columns?.call(Student.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Student] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Student?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<StudentUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Student>(
      id,
      columnValues: columnValues(Student.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Student]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Student>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<StudentUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<StudentTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Student>(
      columnValues: columnValues(Student.t.updateTable),
      where: where(Student.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Student]s in the list and returns the deleted rows.
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
  Future<List<Student>> delete(
    _isd.DatabaseSession session,
    List<Student> rows, {
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Student>(
      rows,
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Student].
  Future<Student> deleteRow(
    _isd.DatabaseSession session,
    Student row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Student>(
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
  Future<List<Student>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<StudentTable> where,
    _isd.OrderByBuilder<StudentTable>? orderBy,
    _isd.OrderByListBuilder<StudentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Student>(
      where: where(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Student>(
      where: where?.call(Student.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Student] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<StudentTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Student>(
      where: where(Student.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class StudentAttachRepository {
  const StudentAttachRepository._();

  /// Creates a relation between this [Student] and the given [Enrollment]s
  /// by setting each [Enrollment]'s foreign key `studentId` to refer to this [Student].
  Future<void> enrollments(
    _isd.DatabaseSession session,
    Student student,
    List<_im07rq0v.Enrollment> enrollment, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment = enrollment
        .map((e) => e.copyWith(studentId: student.id))
        .toList();
    await session.db.update<_im07rq0v.Enrollment>(
      $enrollment,
      columns: [_im07rq0v.Enrollment.t.studentId],
      transaction: transaction,
    );
  }
}

class StudentAttachRowRepository {
  const StudentAttachRowRepository._();

  /// Creates a relation between this [Student] and the given [Enrollment]
  /// by setting the [Enrollment]'s foreign key `studentId` to refer to this [Student].
  Future<void> enrollments(
    _isd.DatabaseSession session,
    Student student,
    _im07rq0v.Enrollment enrollment, {
    _isd.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment = enrollment.copyWith(studentId: student.id);
    await session.db.updateRow<_im07rq0v.Enrollment>(
      $enrollment,
      columns: [_im07rq0v.Enrollment.t.studentId],
      transaction: transaction,
    );
  }
}
