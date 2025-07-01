/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/many_to_many/enrollment.dart' as _i2;

abstract class CourseUuid
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CourseUuid._({
    _i1.UuidValue? id,
    required this.name,
    this.enrollments,
  }) : id = id ?? _i1.Uuid().v7obj();

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
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class CourseUuidTable extends _i1.Table<_i1.UuidValue?> {
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
  _i1.Table<_i1.UuidValue?> get table => CourseUuid.t;
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
  _i1.Table<_i1.UuidValue?> get table => CourseUuid.t;
}

class CourseUuidRepository {
  const CourseUuidRepository._();

  final attach = const CourseUuidAttachRepository._();

  final attachRow = const CourseUuidAttachRowRepository._();

  final detach = const CourseUuidDetachRepository._();

  final detachRow = const CourseUuidDetachRowRepository._();

  /// Returns a list of [CourseUuid]s matching the given query parameters.
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
    return session.db.find<CourseUuid>(
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

  /// Returns the first matching [CourseUuid] matching the given query parameters.
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
    return session.db.findFirstRow<CourseUuid>(
      where: where?.call(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CourseUuid] by its [id] or null if no such row exists.
  Future<CourseUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    CourseUuidInclude? include,
  }) async {
    return session.db.findById<CourseUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CourseUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CourseUuid>> insert(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CourseUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CourseUuid] and returns the inserted row.
  ///
  /// The returned [CourseUuid] will have its `id` field set.
  Future<CourseUuid> insertRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CourseUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CourseUuid>> update(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.ColumnSelections<CourseUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CourseUuid>(
      rows,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseUuid> updateRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.ColumnSelections<CourseUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseUuid>(
      row,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CourseUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CourseUuid>> delete(
    _i1.Session session,
    List<CourseUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CourseUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CourseUuid].
  Future<CourseUuid> deleteRow(
    _i1.Session session,
    CourseUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CourseUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CourseUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CourseUuid>(
      where: where(CourseUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CourseUuid>(
      where: where?.call(CourseUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRepository {
  const CourseUuidAttachRepository._();

  /// Creates a relation between this [CourseUuid] and the given [EnrollmentInt]s
  /// by setting each [EnrollmentInt]'s foreign key `courseId` to refer to this [CourseUuid].
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
    await session.db.update<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRowRepository {
  const CourseUuidAttachRowRepository._();

  /// Creates a relation between this [CourseUuid] and the given [EnrollmentInt]
  /// by setting the [EnrollmentInt]'s foreign key `courseId` to refer to this [CourseUuid].
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
    await session.db.updateRow<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidDetachRepository {
  const CourseUuidDetachRepository._();

  /// Detaches the relation between this [CourseUuid] and the given [EnrollmentInt]
  /// by setting the [EnrollmentInt]'s foreign key `courseId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
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
    await session.db.update<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidDetachRowRepository {
  const CourseUuidDetachRowRepository._();

  /// Detaches the relation between this [CourseUuid] and the given [EnrollmentInt]
  /// by setting the [EnrollmentInt]'s foreign key `courseId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> enrollments(
    _i1.Session session,
    _i2.EnrollmentInt enrollmentInt, {
    _i1.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(courseId: null);
    await session.db.updateRow<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}
