/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Student extends _i1.TableRow {
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

  factory Student.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Student(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      enrollments: serializationManager
          .deserialize<List<_i2.Enrollment>?>(jsonSerialization['enrollments']),
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
      'id': id,
      'name': name,
      'enrollments': enrollments,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'enrollments': enrollments,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Student>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return session.db.find<Student>(
      where: where != null ? where(Student.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Student?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return session.db.findSingleRow<Student>(
      where: where != null ? where(Student.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Student?> findById(
    _i1.Session session,
    int id, {
    StudentInclude? include,
  }) async {
    return session.db.findById<Student>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Student>(
      where: where(Student.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Student>(
      where: where != null ? where(Student.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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
          : this.enrollments?.clone(),
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

@Deprecated('Use StudentTable.t instead.')
StudentTable tStudent = StudentTable();

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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentTable>? orderByList,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return session.dbNext.find<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Student?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentTable>? orderByList,
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Student>(
      where: where?.call(Student.t),
      orderBy: orderBy?.call(Student.t),
      orderByList: orderByList?.call(Student.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Student?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    StudentInclude? include,
  }) async {
    return session.dbNext.findById<Student>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Student>> insert(
    _i1.Session session,
    List<Student> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Student>(
      rows,
      transaction: transaction,
    );
  }

  Future<Student> insertRow(
    _i1.Session session,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Student>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Student>> update(
    _i1.Session session,
    List<Student> rows, {
    _i1.ColumnSelections<StudentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Student>(
      rows,
      columns: columns?.call(Student.t),
      transaction: transaction,
    );
  }

  Future<Student> updateRow(
    _i1.Session session,
    Student row, {
    _i1.ColumnSelections<StudentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Student>(
      row,
      columns: columns?.call(Student.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Student> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Student>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Student row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Student>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Student>(
      where: where(Student.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Student>(
      where: where?.call(Student.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class StudentAttachRepository {
  const StudentAttachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    Student student,
    List<_i2.Enrollment> enrollment,
  ) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(studentId: student.id)).toList();
    await session.dbNext.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.studentId],
    );
  }
}

class StudentAttachRowRepository {
  const StudentAttachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    Student student,
    _i2.Enrollment enrollment,
  ) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (student.id == null) {
      throw ArgumentError.notNull('student.id');
    }

    var $enrollment = enrollment.copyWith(studentId: student.id);
    await session.dbNext.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.studentId],
    );
  }
}
