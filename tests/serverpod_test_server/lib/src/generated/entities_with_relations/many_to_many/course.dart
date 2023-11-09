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

abstract class Course extends _i1.TableRow {
  Course._({
    int? id,
    required this.name,
    this.enrollments,
  }) : super(id);

  factory Course({
    int? id,
    required String name,
    List<_i2.Enrollment>? enrollments,
  }) = _CourseImpl;

  factory Course.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Course(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      enrollments: serializationManager
          .deserialize<List<_i2.Enrollment>?>(jsonSerialization['enrollments']),
    );
  }

  static final t = CourseTable();

  static const db = CourseRepository._();

  String name;

  List<_i2.Enrollment>? enrollments;

  @override
  _i1.Table get table => t;

  Course copyWith({
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
  static Future<List<Course>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return session.db.find<Course>(
      where: where != null ? where(Course.t) : null,
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
  static Future<Course?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return session.db.findSingleRow<Course>(
      where: where != null ? where(Course.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Course?> findById(
    _i1.Session session,
    int id, {
    CourseInclude? include,
  }) async {
    return session.db.findById<Course>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CourseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Course>(
      where: where(Course.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Course row, {
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
    Course row, {
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
    Course row, {
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
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Course>(
      where: where != null ? where(Course.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CourseInclude include({_i2.EnrollmentIncludeList? enrollments}) {
    return CourseInclude._(enrollments: enrollments);
  }

  static CourseIncludeList includeList({
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    CourseInclude? include,
  }) {
    return CourseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _CourseImpl extends Course {
  _CourseImpl({
    int? id,
    required String name,
    List<_i2.Enrollment>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  @override
  Course copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return Course(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.Enrollment>?
          ? enrollments
          : this.enrollments?.clone(),
    );
  }
}

class CourseTable extends _i1.Table {
  CourseTable({super.tableRelation}) : super(tableName: 'course') {
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
      field: Course.t.id,
      foreignField: _i2.Enrollment.t.courseId,
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
      field: Course.t.id,
      foreignField: _i2.Enrollment.t.courseId,
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

@Deprecated('Use CourseTable.t instead.')
CourseTable tCourse = CourseTable();

class CourseInclude extends _i1.IncludeObject {
  CourseInclude._({_i2.EnrollmentIncludeList? enrollments}) {
    _enrollments = enrollments;
  }

  _i2.EnrollmentIncludeList? _enrollments;

  @override
  Map<String, _i1.Include?> get includes => {'enrollments': _enrollments};

  @override
  _i1.Table get table => Course.t;
}

class CourseIncludeList extends _i1.IncludeList {
  CourseIncludeList._({
    _i1.WhereExpressionBuilder<CourseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Course.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Course.t;
}

class CourseRepository {
  const CourseRepository._();

  final attach = const CourseAttachRepository._();

  final attachRow = const CourseAttachRowRepository._();

  final detach = const CourseDetachRepository._();

  final detachRow = const CourseDetachRowRepository._();

  Future<List<Course>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return session.dbNext.find<Course>(
      where: where?.call(Course.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Course?> findRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return session.dbNext.findRow<Course>(
      where: where?.call(Course.t),
      transaction: transaction,
      include: include,
    );
  }

  Future<Course?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return session.dbNext.findById<Course>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Course>> insert(
    _i1.Session session,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Course>(
      rows,
      transaction: transaction,
    );
  }

  Future<Course> insertRow(
    _i1.Session session,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Course>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Course>> update(
    _i1.Session session,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Course>(
      rows,
      transaction: transaction,
    );
  }

  Future<Course> updateRow(
    _i1.Session session,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Course>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Course>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Course>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CourseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Course>(
      where: where(Course.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Course>(
      where: where?.call(Course.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CourseAttachRepository {
  const CourseAttachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    Course course,
    List<_i2.Enrollment> enrollment,
  ) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(courseId: course.id)).toList();
    await session.dbNext.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
    );
  }
}

class CourseAttachRowRepository {
  const CourseAttachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    Course course,
    _i2.Enrollment enrollment,
  ) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment = enrollment.copyWith(courseId: course.id);
    await session.dbNext.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
    );
  }
}

class CourseDetachRepository {
  const CourseDetachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    List<_i2.Enrollment> enrollment,
  ) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(courseId: null)).toList();
    await session.dbNext.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
    );
  }
}

class CourseDetachRowRepository {
  const CourseDetachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    _i2.Enrollment enrollment,
  ) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }

    var $enrollment = enrollment.copyWith(courseId: null);
    await session.dbNext.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
    );
  }
}
