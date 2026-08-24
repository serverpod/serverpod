/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../../changed_id_type/many_to_many/enrollment.dart' as _ih6xbg05;

abstract class CourseUuid
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CourseUuid._({
    _is.UuidValue? id,
    required this.name,
    this.enrollments,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory CourseUuid({
    _is.UuidValue? id,
    required String name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  }) = _CourseUuidImpl;

  factory CourseUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_ih6xbg05.EnrollmentInt>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  static final t = CourseUuidTable();

  static const db = CourseUuidRepository._();

  @override
  _is.UuidValue? id;

  String name;

  List<_ih6xbg05.EnrollmentInt>? enrollments;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseUuid copyWith({
    _is.UuidValue? id,
    String? name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static CourseUuidInclude include({
    _ih6xbg05.EnrollmentIntIncludeList? enrollments,
    _is.SelectColumnsBuilder<CourseUuidTable>? select,
  }) {
    return CourseUuidInclude.internal_(
      enrollments: enrollments,
      selectedColumns: select?.call(CourseUuid.t),
    );
  }

  static CourseUuidIncludeList includeList({
    _is.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    CourseUuidInclude? include,
    _is.SelectColumnsBuilder<CourseUuidTable>? select,
  }) {
    return CourseUuidIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      include: include,
      selectedColumns: select?.call(CourseUuid.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseUuidImpl extends CourseUuid {
  _CourseUuidImpl({
    _is.UuidValue? id,
    required String name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return CourseUuid(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_ih6xbg05.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CourseUuidUpdateTable extends _is.UpdateTable<CourseUuidTable> {
  CourseUuidUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class CourseUuidTable extends _is.Table<_is.UuidValue?> {
  CourseUuidTable({super.tableRelation}) : super(tableName: 'course_uuid') {
    updateTable = CourseUuidUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final CourseUuidUpdateTable updateTable;

  late final _is.ColumnString name;

  _ih6xbg05.EnrollmentIntTable? ___enrollments;

  _is.ManyRelation<_ih6xbg05.EnrollmentIntTable>? _enrollments;

  _ih6xbg05.EnrollmentIntTable get __enrollments {
    if (___enrollments != null) return ___enrollments!;
    ___enrollments = _is.createRelationTable(
      relationFieldName: '__enrollments',
      field: CourseUuid.t.id,
      foreignField: _ih6xbg05.EnrollmentInt.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ih6xbg05.EnrollmentIntTable(tableRelation: foreignTableRelation),
    );
    return ___enrollments!;
  }

  _is.ManyRelation<_ih6xbg05.EnrollmentIntTable> get enrollments {
    if (_enrollments != null) return _enrollments!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'enrollments',
      field: CourseUuid.t.id,
      foreignField: _ih6xbg05.EnrollmentInt.t.courseId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ih6xbg05.EnrollmentIntTable(tableRelation: foreignTableRelation),
    );
    _enrollments = _is.ManyRelation<_ih6xbg05.EnrollmentIntTable>(
      tableWithRelations: relationTable,
      table: _ih6xbg05.EnrollmentIntTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _enrollments!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'enrollments') {
      return __enrollments;
    }
    return null;
  }
}

class CourseUuidInclude extends _is.IncludeObject {
  CourseUuidInclude.internal_({
    _ih6xbg05.EnrollmentIntIncludeList? enrollments,
    this.selectedColumns,
  }) {
    _enrollments = enrollments;
  }

  _ih6xbg05.EnrollmentIntIncludeList? _enrollments;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'enrollments': _enrollments};

  @override
  _is.Table<_is.UuidValue?> get table => CourseUuid.t;
}

class CourseUuidIncludeList extends _is.IncludeList {
  CourseUuidIncludeList.internal_({
    _is.WhereExpressionBuilder<CourseUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(CourseUuid.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CourseUuid.t;
}

class CourseUuidRepository {
  const CourseUuidRepository._();

  final attach = const CourseUuidAttachRepository._();

  final attachRow = const CourseUuidAttachRowRepository._();

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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    _is.Transaction? transaction,
    CourseUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CourseUuid>(
      where: where?.call(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    _is.Transaction? transaction,
    CourseUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CourseUuid>(
      where: where?.call(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CourseUuid] by its [id] or null if no such row exists.
  Future<CourseUuid?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    CourseUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CourseUuid>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CourseUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> insert(
    _is.DatabaseSession session,
    List<CourseUuid> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CourseUuid>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CourseUuid] and returns the inserted row.
  ///
  /// The returned [CourseUuid] will have its `id` field set.
  Future<CourseUuid> insertRow(
    _is.DatabaseSession session,
    CourseUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CourseUuid]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CourseUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> upsert(
    _is.DatabaseSession session,
    List<CourseUuid> rows, {
    required _is.ColumnSelections<CourseUuidTable> conflictColumns,
    _is.ColumnSelections<CourseUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseUuidTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CourseUuid>(
      rows,
      conflictColumns: conflictColumns(CourseUuid.t),
      updateColumns: updateColumns?.call(CourseUuid.t),
      updateWhere: updateWhere?.call(CourseUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CourseUuid] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CourseUuid] will have its `id` field set.
  Future<CourseUuid?> upsertRow(
    _is.DatabaseSession session,
    CourseUuid row, {
    required _is.ColumnSelections<CourseUuidTable> conflictColumns,
    _is.ColumnSelections<CourseUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseUuidTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CourseUuid>(
      row,
      conflictColumns: conflictColumns(CourseUuid.t),
      updateColumns: updateColumns?.call(CourseUuid.t),
      updateWhere: updateWhere?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  /// Updates all [CourseUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> update(
    _is.DatabaseSession session,
    List<CourseUuid> rows, {
    _is.ColumnSelections<CourseUuidTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CourseUuid>(
      rows,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CourseUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseUuid> updateRow(
    _is.DatabaseSession session,
    CourseUuid row, {
    _is.ColumnSelections<CourseUuidTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseUuid>(
      row,
      columns: columns?.call(CourseUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CourseUuid?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CourseUuidUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CourseUuid>(
      id,
      columnValues: columnValues(CourseUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CourseUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CourseUuidUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CourseUuidTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CourseUuid>(
      columnValues: columnValues(CourseUuid.t.updateTable),
      where: where(CourseUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CourseUuid]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> delete(
    _is.DatabaseSession session,
    List<CourseUuid> rows, {
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CourseUuid>(
      rows,
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CourseUuid].
  Future<CourseUuid> deleteRow(
    _is.DatabaseSession session,
    CourseUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseUuid>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseUuidTable> where,
    _is.OrderByBuilder<CourseUuidTable>? orderBy,
    _is.OrderByListBuilder<CourseUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CourseUuid>(
      where: where(CourseUuid.t),
      orderBy: orderBy?.call(CourseUuid.t),
      orderByList: orderByList?.call(CourseUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseUuidTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CourseUuid>(
      where: where?.call(CourseUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CourseUuid] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseUuidTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CourseUuid>(
      where: where(CourseUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRepository {
  const CourseUuidAttachRepository._();

  /// Creates a relation between this [CourseUuid] and the given [EnrollmentInt]s
  /// by setting each [EnrollmentInt]'s foreign key `courseId` to refer to this [CourseUuid].
  Future<void> enrollments(
    _is.DatabaseSession session,
    CourseUuid courseUuid,
    List<_ih6xbg05.EnrollmentInt> enrollmentInt, {
    _is.Transaction? transaction,
  }) async {
    if (enrollmentInt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (courseUuid.id == null) {
      throw ArgumentError.notNull('courseUuid.id');
    }

    var $enrollmentInt = enrollmentInt
        .map((e) => e.copyWith(courseId: courseUuid.id))
        .toList();
    await session.db.update<_ih6xbg05.EnrollmentInt>(
      $enrollmentInt,
      columns: [_ih6xbg05.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}

class CourseUuidAttachRowRepository {
  const CourseUuidAttachRowRepository._();

  /// Creates a relation between this [CourseUuid] and the given [EnrollmentInt]
  /// by setting the [EnrollmentInt]'s foreign key `courseId` to refer to this [CourseUuid].
  Future<void> enrollments(
    _is.DatabaseSession session,
    CourseUuid courseUuid,
    _ih6xbg05.EnrollmentInt enrollmentInt, {
    _is.Transaction? transaction,
  }) async {
    if (enrollmentInt.id == null) {
      throw ArgumentError.notNull('enrollmentInt.id');
    }
    if (courseUuid.id == null) {
      throw ArgumentError.notNull('courseUuid.id');
    }

    var $enrollmentInt = enrollmentInt.copyWith(courseId: courseUuid.id);
    await session.db.updateRow<_ih6xbg05.EnrollmentInt>(
      $enrollmentInt,
      columns: [_ih6xbg05.EnrollmentInt.t.courseId],
      transaction: transaction,
    );
  }
}
