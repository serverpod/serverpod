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
import '../../changed_id_type/many_to_many/enrollment.dart' as _i2;

abstract class StudentUuid
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  StudentUuid._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory StudentUuid({
    int? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) = _StudentUuidImpl;

  factory StudentUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentUuid(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.EnrollmentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = StudentUuidTable();

  static const db = StudentUuidRepository._();

  @override
  int? id;

  String name;

  List<_i2.EnrollmentInt>? enrollments;

  @override
  _i1.Table<int> get table => t;

  StudentUuid copyWith({
    int? id,
    String? name,
    List<_i2.EnrollmentInt>? enrollments,
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

  static StudentUuidInclude include(
      {_i2.EnrollmentIntIncludeList? enrollments}) {
    return StudentUuidInclude._(enrollments: enrollments);
  }

  static StudentUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentUuidTable>? orderByList,
    StudentUuidInclude? include,
  }) {
    return StudentUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StudentUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentUuidImpl extends StudentUuid {
  _StudentUuidImpl({
    int? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  @override
  StudentUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return StudentUuid(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class StudentUuidTable extends _i1.Table<int> {
  StudentUuidTable({super.tableRelation}) : super(tableName: 'student_uuid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.EnrollmentIntTable? ___enrollments;

  _i1.ManyRelation<_i2.EnrollmentIntTable>? _enrollments;

  _i2.EnrollmentIntTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _i1.createRelationTable(
      relationFieldName: '__enrollments',
      field: StudentUuid.t.id,
      foreignField: _i2.EnrollmentInt.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EnrollmentIntTable(tableRelation: foreignTableRelation),
    );
    return ___enrollments!;
  }

  _i1.ManyRelation<_i2.EnrollmentIntTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'enrollments',
      field: StudentUuid.t.id,
      foreignField: _i2.EnrollmentInt.t.studentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EnrollmentIntTable(tableRelation: foreignTableRelation),
    );
    _enrollments = _i1.ManyRelation<_i2.EnrollmentIntTable>(
      tableWithRelations: relationTable,
      table: _i2.EnrollmentIntTable(
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

class StudentUuidInclude extends _i1.IncludeObject {
  StudentUuidInclude._({_i2.EnrollmentIntIncludeList? enrollments}) {
    _enrollments = enrollments;
  }

  _i2.EnrollmentIntIncludeList? _enrollments;

  @override
  Map<String, _i1.Include?> get includes => {'enrollments': _enrollments};

  @override
  _i1.Table<int> get table => StudentUuid.t;
}

class StudentUuidIncludeList extends _i1.IncludeList {
  StudentUuidIncludeList._({
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudentUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => StudentUuid.t;
}

class StudentUuidRepository {
  const StudentUuidRepository._();

  final attach = const StudentUuidAttachRepository._();

  final attachRow = const StudentUuidAttachRowRepository._();

  Future<List<StudentUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentUuidTable>? orderByList,
    _i1.Transaction? transaction,
    StudentUuidInclude? include,
  }) async {
    return session.db.find<int, StudentUuid>(
      where: where?.call(StudentUuid.t),
      orderBy: orderBy?.call(StudentUuid.t),
      orderByList: orderByList?.call(StudentUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<StudentUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentUuidTable>? orderByList,
    _i1.Transaction? transaction,
    StudentUuidInclude? include,
  }) async {
    return session.db.findFirstRow<int, StudentUuid>(
      where: where?.call(StudentUuid.t),
      orderBy: orderBy?.call(StudentUuid.t),
      orderByList: orderByList?.call(StudentUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<StudentUuid?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    StudentUuidInclude? include,
  }) async {
    return session.db.findById<int, StudentUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<StudentUuid>> insert(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<int, StudentUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<StudentUuid> insertRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<int, StudentUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StudentUuid>> update(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.ColumnSelections<StudentUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<int, StudentUuid>(
      rows,
      columns: columns?.call(StudentUuid.t),
      transaction: transaction,
    );
  }

  Future<StudentUuid> updateRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.ColumnSelections<StudentUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<int, StudentUuid>(
      row,
      columns: columns?.call(StudentUuid.t),
      transaction: transaction,
    );
  }

  Future<List<StudentUuid>> delete(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<int, StudentUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<StudentUuid> deleteRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<int, StudentUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StudentUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<int, StudentUuid>(
      where: where(StudentUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<int, StudentUuid>(
      where: where?.call(StudentUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class StudentUuidAttachRepository {
  const StudentUuidAttachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    StudentUuid studentUuid,
    List<_i2.EnrollmentInt> enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (studentUuid.id == null) {
      throw ArgumentError.notNull('studentUuid.id');
    }

    var $enrollmentInt = enrollmentInt
        .map((e) => e.copyWith(studentId: studentUuid.id))
        .toList();
    await session.db.update<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.studentId],
      transaction: transaction,
    );
  }
}

class StudentUuidAttachRowRepository {
  const StudentUuidAttachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    StudentUuid studentUuid,
    _i2.EnrollmentInt enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (studentUuid.id == null) {
      throw ArgumentError.notNull('studentUuid.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(studentId: studentUuid.id);
    await session.db.updateRow<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.studentId],
      transaction: transaction,
    );
  }
}
