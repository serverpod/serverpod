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
import '../../changed_id_type/many_to_many/enrollment.dart' as _i2;

abstract class StudentUuid
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  StudentUuid._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory StudentUuid({
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) = _StudentUuidImpl;

  factory StudentUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.EnrollmentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = StudentUuidTable();

  static const db = StudentUuidRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  List<_i2.EnrollmentInt>? enrollments;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [StudentUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentUuid copyWith({
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
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static StudentUuidInclude include({
    _i2.EnrollmentIntIncludeList? enrollments,
  }) {
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
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [StudentUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return StudentUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class StudentUuidUpdateTable extends _i1.UpdateTable<StudentUuidTable> {
  StudentUuidUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );
}

class StudentUuidTable extends _i1.Table<_i1.UuidValue?> {
  StudentUuidTable({super.tableRelation}) : super(tableName: 'student_uuid') {
    updateTable = StudentUuidUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final StudentUuidUpdateTable updateTable;

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
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
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
  _i1.Table<_i1.UuidValue?> get table => StudentUuid.t;
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
  _i1.Table<_i1.UuidValue?> get table => StudentUuid.t;
}

class StudentUuidRepository {
  const StudentUuidRepository._();

  final attach = const StudentUuidAttachRepository._();

  final attachRow = const StudentUuidAttachRowRepository._();

  /// Returns a list of [StudentUuid]s matching the given query parameters.
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
    return session.db.find<StudentUuid>(
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

  /// Returns the first matching [StudentUuid] matching the given query parameters.
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
    return session.db.findFirstRow<StudentUuid>(
      where: where?.call(StudentUuid.t),
      orderBy: orderBy?.call(StudentUuid.t),
      orderByList: orderByList?.call(StudentUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [StudentUuid] by its [id] or null if no such row exists.
  Future<StudentUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    StudentUuidInclude? include,
  }) async {
    return session.db.findById<StudentUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [StudentUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [StudentUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StudentUuid>> insert(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StudentUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StudentUuid] and returns the inserted row.
  ///
  /// The returned [StudentUuid] will have its `id` field set.
  Future<StudentUuid> insertRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudentUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StudentUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StudentUuid>> update(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.ColumnSelections<StudentUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StudentUuid>(
      rows,
      columns: columns?.call(StudentUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudentUuid> updateRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.ColumnSelections<StudentUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudentUuid>(
      row,
      columns: columns?.call(StudentUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StudentUuid?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<StudentUuidUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<StudentUuid>(
      id,
      columnValues: columnValues(StudentUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StudentUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<StudentUuid>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<StudentUuidUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<StudentUuidTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentUuidTable>? orderBy,
    _i1.OrderByListBuilder<StudentUuidTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<StudentUuid>(
      columnValues: columnValues(StudentUuid.t.updateTable),
      where: where(StudentUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentUuid.t),
      orderByList: orderByList?.call(StudentUuid.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [StudentUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StudentUuid>> delete(
    _i1.Session session,
    List<StudentUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StudentUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StudentUuid].
  Future<StudentUuid> deleteRow(
    _i1.Session session,
    StudentUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudentUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StudentUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StudentUuid>(
      where: where(StudentUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StudentUuid>(
      where: where?.call(StudentUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class StudentUuidAttachRepository {
  const StudentUuidAttachRepository._();

  /// Creates a relation between this [StudentUuid] and the given [EnrollmentInt]s
  /// by setting each [EnrollmentInt]'s foreign key `studentId` to refer to this [StudentUuid].
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
    await session.db.update<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.studentId],
      transaction: transaction,
    );
  }
}

class StudentUuidAttachRowRepository {
  const StudentUuidAttachRowRepository._();

  /// Creates a relation between this [StudentUuid] and the given [EnrollmentInt]
  /// by setting the [EnrollmentInt]'s foreign key `studentId` to refer to this [StudentUuid].
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
    await session.db.updateRow<_i2.EnrollmentInt>(
      $enrollmentInt,
      columns: [_i2.EnrollmentInt.t.studentId],
      transaction: transaction,
    );
  }
}
