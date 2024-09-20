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
import '../../protocol.dart' as _i2;

abstract class Student extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  Student._({
    int? id,
    required this.name,
    this.enrollments,
  }) : super(id);

  factory Student({
    int? id,
    required String name,
    List<_i2.Enrollment>? enrollments,
  }) = _StudentImpl;

  factory Student.fromJson(Map<String, dynamic> jsonSerialization) {
    return Student(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.Enrollment.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = StudentTable();

  static const db = StudentRepository._();

  String name;

  List<_i2.Enrollment>? enrollments;

  @override
  _i1.Table get table => t;

  Student copyWith({
    int? id,
    String? name,
    List<_i2.Enrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments':
            enrollments?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static StudentInclude include({_i2.EnrollmentIncludeList? enrollments}) {
    return StudentInclude._(enrollments: enrollments);
  }

  static StudentIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentTable>? orderByList,
    StudentInclude? include,
  }) {
    return StudentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Student.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Student.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentImpl extends Student {
  _StudentImpl({
    int? id,
    required String name,
    List<_i2.Enrollment>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  @override
  Student copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return Student(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.Enrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class StudentTable extends _i1.Table {
  StudentTable({super.tableRelation}) : super(tableName: 'student') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.EnrollmentTable? ___enrollments;

  _i1.ManyRelation<_i2.EnrollmentTable>? _enrollments;

  _i2.EnrollmentTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _i1.createRelationTable(
      relationFieldName: '__enrollments',
      field: Student.t.id,
      foreignField: _i2.Enrollment.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EnrollmentTable(tableRelation: foreignTableRelation),
    );
    return ___enrollments!;
  }

  _i1.ManyRelation<_i2.EnrollmentTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'enrollments',
      field: Student.t.id,
      foreignField: _i2.Enrollment.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EnrollmentTable(tableRelation: foreignTableRelation),
    );
    _enrollments = _i1.ManyRelation<_i2.EnrollmentTable>(
      tableWithRelations: relationTable,
      table: _i2.EnrollmentTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
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

class StudentInclude extends _i1.IncludeObject {
  StudentInclude._({_i2.EnrollmentIncludeList? enrollments}) {
    _enrollments = enrollments;
  }

  _i2.EnrollmentIncludeList? _enrollments;

  @override
  Map<String, _i1.Include?> get includes => {'enrollments': _enrollments};

  @override
  _i1.Table get table => Student.t;
}

class StudentIncludeList extends _i1.IncludeList {
  StudentIncludeList._({
    _i1.WhereExpressionBuilder<StudentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Student.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Student.t;
}

class StudentRepository {
  const StudentRepository._();

  final attach = const StudentAttachRepository._();

  final attachRow = const StudentAttachRowRepository._();

  Future<List<Student>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentTable>? orderByList,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return databaseAccessor.db.find<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Student?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentTable>? orderByList,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return databaseAccessor.db.findFirstRow<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Student?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return databaseAccessor.db.findById<Student>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<List<Student>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<Student> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<Student>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Student> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<Student>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Student>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<Student> rows, {
    _i1.ColumnSelections<StudentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<Student>(
      rows,
      columns: columns?.call(Student.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Student> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    Student row, {
    _i1.ColumnSelections<StudentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<Student>(
      row,
      columns: columns?.call(Student.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Student>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<Student> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<Student>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Student> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<Student>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Student>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<StudentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<Student>(
      where: where(Student.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<Student>(
      where: where?.call(Student.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class StudentAttachRepository {
  const StudentAttachRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    Student student,
    List<_i2.Enrollment> enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(studentId: student.id)).toList();
    await databaseAccessor.db.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.studentId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class StudentAttachRowRepository {
  const StudentAttachRowRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    Student student,
    _i2.Enrollment enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment = enrollment.copyWith(studentId: student.id);
    await databaseAccessor.db.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.studentId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
