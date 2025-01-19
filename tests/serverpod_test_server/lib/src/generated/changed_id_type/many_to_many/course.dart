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

abstract class CourseUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  CourseUuid._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory CourseUuid({
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) = _CourseUuidImpl;

  factory CourseUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.EnrollmentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CourseUuidTable();

  static const db = CourseUuidRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  List<_i2.EnrollmentInt>? enrollments;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  CourseUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    List<_i2.EnrollmentInt>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments':
            enrollments?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CourseUuidInclude include(
      {_i2.EnrollmentIntIncludeList? enrollments}) {
    return CourseUuidInclude._(enrollments: enrollments);
  }

  static CourseUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseUuidTable>? orderByList,
    CourseUuidInclude? include,
  }) {
    return CourseUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CourseUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseUuidImpl extends CourseUuid {
  _CourseUuidImpl({
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  @override
  CourseUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return CourseUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CourseUuidTable extends _i1.Table<_i1.UuidValue> {
  CourseUuidTable({super.tableRelation}) : super(tableName: 'course_uuid') {
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
      field: CourseUuid.t.id,
      foreignField: _i2.EnrollmentInt.t.courseId,
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
      field: CourseUuid.t.id,
      foreignField: _i2.EnrollmentInt.t.courseId,
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

class CourseUuidInclude extends _i1.IncludeObject {
  CourseUuidInclude._({_i2.EnrollmentIntIncludeList? enrollments}) {
    _enrollments = enrollments;
  }

  _i2.EnrollmentIntIncludeList? _enrollments;

  @override
  Map<String, _i1.Include?> get includes => {'enrollments': _enrollments};

  @override
  _i1.Table<_i1.UuidValue> get table => CourseUuid.t;
}

class CourseUuidIncludeList extends _i1.IncludeList {
  CourseUuidIncludeList._({
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CourseUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => CourseUuid.t;
}

class CourseUuidRepository {
  const CourseUuidRepository._();

  final attach = const CourseUuidAttachRepository._();

  final attachRow = const CourseUuidAttachRowRepository._();

  final detach = const CourseUuidDetachRepository._();

  final detachRow = const CourseUuidDetachRowRepository._();

  Future<List<CourseUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CourseUuidInclude? include,
  }) async {
    return session.db.find<_i1.UuidValue, CourseUuid>(
      where: where?.call(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CourseUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<CourseUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CourseUuidInclude? include,
  }) async {
    return session.db.findFirstRow<_i1.UuidValue, CourseUuid>(
      where: where?.call(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CourseUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    CourseUuidInclude? include,
  }) async {
    return session.db.findById<_i1.UuidValue, CourseUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<CourseUuid>> insert(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<_i1.UuidValue, CourseUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<CourseUuid> insertRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<_i1.UuidValue, CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CourseUuid>> update(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.ColumnSelections<CourseUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<_i1.UuidValue, CourseUuid>(
      rows,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  Future<CourseUuid> updateRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.ColumnSelections<CourseUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<_i1.UuidValue, CourseUuid>(
      row,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  Future<List<CourseUuid>> delete(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<_i1.UuidValue, CourseUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<CourseUuid> deleteRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<_i1.UuidValue, CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CourseUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CourseUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<_i1.UuidValue, CourseUuid>(
      where: where(CourseUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<_i1.UuidValue, CourseUuid>(
      where: where?.call(CourseUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRepository {
  const CourseUuidAttachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    CourseUuid courseUuid,
    List<_i2.EnrollmentInt> enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (courseUuid.id == null) {
      throw ArgumentError.notNull('courseUuid.id');
    }

    var $enrollmentInt =
        enrollmentInt.map((e) => e.copyWith(courseId: courseUuid.id)).toList();
    await session.db.update<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRowRepository {
  const CourseUuidAttachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    CourseUuid courseUuid,
    _i2.EnrollmentInt enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (courseUuid.id == null) {
      throw ArgumentError.notNull('courseUuid.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(courseId: courseUuid.id);
    await session.db.updateRow<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidDetachRepository {
  const CourseUuidDetachRepository._();

  Future<void> enrollments(
    _i1.Session session,
    List<_i2.EnrollmentInt> enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }

    var $enrollmentInt =
        enrollmentInt.map((e) => e.copyWith(courseId: null)).toList();
    await session.db.update<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidDetachRowRepository {
  const CourseUuidDetachRowRepository._();

  Future<void> enrollments(
    _i1.Session session,
    _i2.EnrollmentInt enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(courseId: null);
    await session.db.updateRow<int, _i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}
