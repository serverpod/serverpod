/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../models_with_relations/many_to_many/student.dart' as _i2;
import '../../models_with_relations/many_to_many/course.dart' as _i3;

abstract class Enrollment implements _i1.TableRow, _i1.ProtocolSerialization {
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
    _i2.Student? student,
    required int courseId,
    _i3.Course? course,
  }) = _EnrollmentImpl;

  factory Enrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Enrollment(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _i2.Student.fromJson(
              (jsonSerialization['student'] as Map<String, dynamic>)),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _i3.Course.fromJson(
              (jsonSerialization['course'] as Map<String, dynamic>)),
    );
  }

  static final t = EnrollmentTable();

  static const db = EnrollmentRepository._();

  @override
  int? id;

  int studentId;

  _i2.Student? student;

  int courseId;

  _i3.Course? course;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Enrollment copyWith({
    int? id,
    int? studentId,
    _i2.Student? student,
    int? courseId,
    _i3.Course? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  static EnrollmentInclude include({
    _i2.StudentInclude? student,
    _i3.CourseInclude? course,
  }) {
    return EnrollmentInclude._(
      student: student,
      course: course,
    );
  }

  static EnrollmentIncludeList includeList({
    _i1.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentTable>? orderByList,
    EnrollmentInclude? include,
  }) {
    return EnrollmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Enrollment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Enrollment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentImpl extends Enrollment {
  _EnrollmentImpl({
    int? id,
    required int studentId,
    _i2.Student? student,
    required int courseId,
    _i3.Course? course,
  }) : super._(
          id: id,
          studentId: studentId,
          student: student,
          courseId: courseId,
          course: course,
        );

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      student: student is _i2.Student? ? student : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _i3.Course? ? course : this.course?.copyWith(),
    );
  }
}

class EnrollmentTable extends _i1.Table {
  EnrollmentTable({super.tableRelation}) : super(tableName: 'enrollment') {
    studentId = _i1.ColumnInt(
      'studentId',
      this,
    );
    courseId = _i1.ColumnInt(
      'courseId',
      this,
    );
  }

  late final _i1.ColumnInt studentId;

  _i2.StudentTable? _student;

  late final _i1.ColumnInt courseId;

  _i3.CourseTable? _course;

  _i2.StudentTable get student {
    if (_student != null) return _student!;
    _student = _i1.createRelationTable(
      relationFieldName: 'student',
      field: Enrollment.t.studentId,
      foreignField: _i2.Student.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.StudentTable(tableRelation: foreignTableRelation),
    );
    return _student!;
  }

  _i3.CourseTable get course {
    if (_course != null) return _course!;
    _course = _i1.createRelationTable(
      relationFieldName: 'course',
      field: Enrollment.t.courseId,
      foreignField: _i3.Course.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CourseTable(tableRelation: foreignTableRelation),
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

class EnrollmentInclude extends _i1.IncludeObject {
  EnrollmentInclude._({
    _i2.StudentInclude? student,
    _i3.CourseInclude? course,
  }) {
    _student = student;
    _course = course;
  }

  _i2.StudentInclude? _student;

  _i3.CourseInclude? _course;

  @override
  Map<String, _i1.Include?> get includes => {
        'student': _student,
        'course': _course,
      };

  @override
  _i1.Table get table => Enrollment.t;
}

class EnrollmentIncludeList extends _i1.IncludeList {
  EnrollmentIncludeList._({
    _i1.WhereExpressionBuilder<EnrollmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Enrollment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Enrollment.t;
}

class EnrollmentRepository {
  const EnrollmentRepository._();

  final attachRow = const EnrollmentAttachRowRepository._();

  Future<List<Enrollment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
    EnrollmentInclude? include,
  }) async {
    return session.db.find<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Enrollment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
    EnrollmentInclude? include,
  }) async {
    return session.db.findFirstRow<Enrollment>(
      where: where?.call(Enrollment.t),
      orderBy: orderBy?.call(Enrollment.t),
      orderByList: orderByList?.call(Enrollment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Enrollment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    EnrollmentInclude? include,
  }) async {
    return session.db.findById<Enrollment>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Enrollment>> insert(
    _i1.Session session,
    List<Enrollment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Enrollment>(
      rows,
      transaction: transaction,
    );
  }

  Future<Enrollment> insertRow(
    _i1.Session session,
    Enrollment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Enrollment>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Enrollment>> update(
    _i1.Session session,
    List<Enrollment> rows, {
    _i1.ColumnSelections<EnrollmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Enrollment>(
      rows,
      columns: columns?.call(Enrollment.t),
      transaction: transaction,
    );
  }

  Future<Enrollment> updateRow(
    _i1.Session session,
    Enrollment row, {
    _i1.ColumnSelections<EnrollmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Enrollment>(
      row,
      columns: columns?.call(Enrollment.t),
      transaction: transaction,
    );
  }

  Future<List<Enrollment>> delete(
    _i1.Session session,
    List<Enrollment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Enrollment>(
      rows,
      transaction: transaction,
    );
  }

  Future<Enrollment> deleteRow(
    _i1.Session session,
    Enrollment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Enrollment>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Enrollment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnrollmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Enrollment>(
      where: where(Enrollment.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnrollmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Enrollment>(
      where: where?.call(Enrollment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EnrollmentAttachRowRepository {
  const EnrollmentAttachRowRepository._();

  Future<void> student(
    _i1.Session session,
    Enrollment enrollment,
    _i2.Student student, {
    _i1.Transaction? transaction,
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

  Future<void> course(
    _i1.Session session,
    Enrollment enrollment,
    _i3.Course course, {
    _i1.Transaction? transaction,
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
