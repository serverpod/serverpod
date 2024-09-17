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

abstract class Course extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory Course.fromJson(Map<String, dynamic> jsonSerialization) {
    return Course(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.Enrollment.fromJson((e as Map<String, dynamic>)))
          .toList(),
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

  static CourseInclude include({_i2.EnrollmentIncludeList? enrollments}) {
    return CourseInclude._(enrollments: enrollments);
  }

  static CourseIncludeList includeList({
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    CourseInclude? include,
  }) {
    return CourseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Course.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Course.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
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
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return databaseAccessor.db.find<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Course?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return databaseAccessor.db.findFirstRow<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<Course?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
    CourseInclude? include,
  }) async {
    return databaseAccessor.db.findById<Course>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<List<Course>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<Course>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Course> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<Course>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Course>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<Course> rows, {
    _i1.ColumnSelections<CourseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<Course>(
      rows,
      columns: columns?.call(Course.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Course> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    Course row, {
    _i1.ColumnSelections<CourseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<Course>(
      row,
      columns: columns?.call(Course.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Course>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<Course>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<Course> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<Course>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<Course>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<CourseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<Course>(
      where: where(Course.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<Course>(
      where: where?.call(Course.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class CourseAttachRepository {
  const CourseAttachRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    Course course,
    List<_i2.Enrollment> enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(courseId: course.id)).toList();
    await databaseAccessor.db.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class CourseAttachRowRepository {
  const CourseAttachRowRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    Course course,
    _i2.Enrollment enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $enrollment = enrollment.copyWith(courseId: course.id);
    await databaseAccessor.db.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class CourseDetachRepository {
  const CourseDetachRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    List<_i2.Enrollment> enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollment.id');
    }

    var $enrollment =
        enrollment.map((e) => e.copyWith(courseId: null)).toList();
    await databaseAccessor.db.update<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class CourseDetachRowRepository {
  const CourseDetachRowRepository._();

  Future<void> enrollments(
    _i1.DatabaseAccessor databaseAccessor,
    _i2.Enrollment enrollment, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollment.id == null) {
      throw ArgumentError.notNull('enrollment.id');
    }

    var $enrollment = enrollment.copyWith(courseId: null);
    await databaseAccessor.db.updateRow<_i2.Enrollment>(
      $enrollment,
      columns: [_i2.Enrollment.t.courseId],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
