/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/many_to_many/student.dart' as _i2;
import '../../changed_id_type/many_to_many/course.dart' as _i3;

abstract class EnrollmentInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EnrollmentInt._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory EnrollmentInt({
    int? id,
    required _i1.UuidValue studentId,
    _i2.StudentUuid? student,
    required _i1.UuidValue courseId,
    _i3.CourseUuid? course,
  }) = _EnrollmentIntImpl;

  factory EnrollmentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnrollmentInt(
      id: jsonSerialization['id'] as int?,
      studentId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['studentId']),
      student: jsonSerialization['student'] == null
          ? null
          : _i2.StudentUuid.fromJson(
              (jsonSerialization['student'] as Map<String, dynamic>)),
      courseId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['courseId']),
      course: jsonSerialization['course'] == null
          ? null
          : _i3.CourseUuid.fromJson(
              (jsonSerialization['course'] as Map<String, dynamic>)),
    );
  }

  static final t = EnrollmentIntTable();

  static const db = EnrollmentIntRepository._();

  @override
  int? id;

  _i1.UuidValue studentId;

  _i2.StudentUuid? student;

  _i1.UuidValue courseId;

  _i3.CourseUuid? course;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnrollmentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnrollmentInt copyWith({
    int? id,
    _i1.UuidValue? studentId,
    _i2.StudentUuid? student,
    _i1.UuidValue? courseId,
    _i3.CourseUuid? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentId': studentId.toJson(),
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'studentId': studentId.toJson(),
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  static EnrollmentIntInclude include({
    _i2.StudentUuidInclude? student,
    _i3.CourseUuidInclude? course,
  }) {
    return EnrollmentIntInclude._(
      student: student,
      course: course,
    );
  }

  static EnrollmentIntIncludeList includeList({
    _i1.WhereExpressionBuilder<EnrollmentIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnrollmentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentIntTable>? orderByList,
    EnrollmentIntInclude? include,
  }) {
    return EnrollmentIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnrollmentInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnrollmentInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentIntImpl extends EnrollmentInt {
  _EnrollmentIntImpl({
    int? id,
    required _i1.UuidValue studentId,
    _i2.StudentUuid? student,
    required _i1.UuidValue courseId,
    _i3.CourseUuid? course,
  }) : super._(
          id: id,
          studentId: studentId,
          student: student,
          courseId: courseId,
          course: course,
        );

  /// Returns a shallow copy of this [EnrollmentInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnrollmentInt copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? studentId,
    Object? student = _Undefined,
    _i1.UuidValue? courseId,
    Object? course = _Undefined,
  }) {
    return EnrollmentInt(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _i2.StudentUuid? ? student : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _i3.CourseUuid? ? course : this.course?.copyWith(),
    );
  }
}

class EnrollmentIntUpdateTable extends _i1.UpdateTable<EnrollmentIntTable> {
  EnrollmentIntUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> studentId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.studentId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> courseId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.courseId,
        value,
      );
}

class EnrollmentIntTable extends _i1.Table<int?> {
  EnrollmentIntTable({super.tableRelation})
      : super(tableName: 'enrollment_int') {
    updateTable = EnrollmentIntUpdateTable(this);
    studentId = _i1.ColumnUuid(
      'studentId',
      this,
    );
    courseId = _i1.ColumnUuid(
      'courseId',
      this,
    );
  }

  late final EnrollmentIntUpdateTable updateTable;

  late final _i1.ColumnUuid studentId;

  _i2.StudentUuidTable? _student;

  late final _i1.ColumnUuid courseId;

  _i3.CourseUuidTable? _course;

  _i2.StudentUuidTable get student {
    if (_student != null) return _student!;
    _student = _i1.createRelationTable(
      relationFieldName: 'student',
      field: EnrollmentInt.t.studentId,
      foreignField: _i2.StudentUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.StudentUuidTable(tableRelation: foreignTableRelation),
    );
    return _student!;
  }

  _i3.CourseUuidTable get course {
    if (_course != null) return _course!;
    _course = _i1.createRelationTable(
      relationFieldName: 'course',
      field: EnrollmentInt.t.courseId,
      foreignField: _i3.CourseUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CourseUuidTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        studentId,
        courseId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'student') {
      return student;
    }
    if (relationField == 'course') {
      return course;
    }
    return null;
  }
}

class EnrollmentIntInclude extends _i1.IncludeObject {
  EnrollmentIntInclude._({
    _i2.StudentUuidInclude? student,
    _i3.CourseUuidInclude? course,
  }) {
    _student = student;
    _course = course;
  }

  _i2.StudentUuidInclude? _student;

  _i3.CourseUuidInclude? _course;

  @override
  Map<String, _i1.Include?> get includes => {
        'student': _student,
        'course': _course,
      };

  @override
  _i1.Table<int?> get table => EnrollmentInt.t;
}

class EnrollmentIntIncludeList extends _i1.IncludeList {
  EnrollmentIntIncludeList._({
    _i1.WhereExpressionBuilder<EnrollmentIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnrollmentInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EnrollmentInt.t;
}

class EnrollmentIntRepository {
  const EnrollmentIntRepository._();

  final attachRow = const EnrollmentIntAttachRowRepository._();

  /// Returns a list of [EnrollmentInt]s matching the given query parameters.
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
  Future<List<EnrollmentInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnrollmentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentIntTable>? orderByList,
    _i1.Transaction? transaction,
    EnrollmentIntInclude? include,
  }) async {
    return session.db.find<EnrollmentInt>(
      where: where?.call(EnrollmentInt.t),
      orderBy: orderBy?.call(EnrollmentInt.t),
      orderByList: orderByList?.call(EnrollmentInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EnrollmentInt] matching the given query parameters.
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
  Future<EnrollmentInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnrollmentIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentIntTable>? orderByList,
    _i1.Transaction? transaction,
    EnrollmentIntInclude? include,
  }) async {
    return session.db.findFirstRow<EnrollmentInt>(
      where: where?.call(EnrollmentInt.t),
      orderBy: orderBy?.call(EnrollmentInt.t),
      orderByList: orderByList?.call(EnrollmentInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EnrollmentInt] by its [id] or null if no such row exists.
  Future<EnrollmentInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    EnrollmentIntInclude? include,
  }) async {
    return session.db.findById<EnrollmentInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EnrollmentInt]s in the list and returns the inserted rows.
  ///
  /// The returned [EnrollmentInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EnrollmentInt>> insert(
    _i1.Session session,
    List<EnrollmentInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EnrollmentInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EnrollmentInt] and returns the inserted row.
  ///
  /// The returned [EnrollmentInt] will have its `id` field set.
  Future<EnrollmentInt> insertRow(
    _i1.Session session,
    EnrollmentInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnrollmentInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EnrollmentInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EnrollmentInt>> update(
    _i1.Session session,
    List<EnrollmentInt> rows, {
    _i1.ColumnSelections<EnrollmentIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnrollmentInt>(
      rows,
      columns: columns?.call(EnrollmentInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnrollmentInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnrollmentInt> updateRow(
    _i1.Session session,
    EnrollmentInt row, {
    _i1.ColumnSelections<EnrollmentIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnrollmentInt>(
      row,
      columns: columns?.call(EnrollmentInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnrollmentInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnrollmentInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EnrollmentIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EnrollmentInt>(
      id,
      columnValues: columnValues(EnrollmentInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnrollmentInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EnrollmentInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EnrollmentIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EnrollmentIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnrollmentIntTable>? orderBy,
    _i1.OrderByListBuilder<EnrollmentIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EnrollmentInt>(
      columnValues: columnValues(EnrollmentInt.t.updateTable),
      where: where(EnrollmentInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnrollmentInt.t),
      orderByList: orderByList?.call(EnrollmentInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EnrollmentInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EnrollmentInt>> delete(
    _i1.Session session,
    List<EnrollmentInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnrollmentInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EnrollmentInt].
  Future<EnrollmentInt> deleteRow(
    _i1.Session session,
    EnrollmentInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnrollmentInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EnrollmentInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnrollmentIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnrollmentInt>(
      where: where(EnrollmentInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnrollmentInt>(
      where: where?.call(EnrollmentInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EnrollmentIntAttachRowRepository {
  const EnrollmentIntAttachRowRepository._();

  /// Creates a relation between the given [EnrollmentInt] and [StudentUuid]
  /// by setting the [EnrollmentInt]'s foreign key `studentId` to refer to the [StudentUuid].
  Future<void> student(
    _i1.Session session,
    EnrollmentInt enrollmentInt,
    _i2.StudentUuid student, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(studentId: student.id);
    await session.db.updateRow<EnrollmentInt>(
      $enrollmentInt,
      columns: [EnrollmentInt.t.studentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EnrollmentInt] and [CourseUuid]
  /// by setting the [EnrollmentInt]'s foreign key `courseId` to refer to the [CourseUuid].
  Future<void> course(
    _i1.Session session,
    EnrollmentInt enrollmentInt,
    _i3.CourseUuid course, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(courseId: course.id);
    await session.db.updateRow<EnrollmentInt>(
      $enrollmentInt,
      columns: [EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}
