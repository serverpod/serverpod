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
import '../inheritance/child_with_inherited_id.dart' as _id412n1c;
import '../protocol.dart' as _iv35mfmj;

abstract class ChildWithInheritedId extends _iv35mfmj.ParentWithChangedId
    implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  ChildWithInheritedId._({
    _is.UuidValue? id,
    required this.name,
    this.parent,
    this.parentId,
    super.createdAt,
    super.updatedAt,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory ChildWithInheritedId({
    _is.UuidValue? id,
    required String name,
    _id412n1c.ChildWithInheritedId? parent,
    _is.UuidValue? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChildWithInheritedIdImpl;

  factory ChildWithInheritedId.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ChildWithInheritedId(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      parent: jsonSerialization['parent'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_id412n1c.ChildWithInheritedId>(
              jsonSerialization['parent'],
            ),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ChildWithInheritedIdTable();

  static const db = ChildWithInheritedIdRepository._();

  @override
  _is.UuidValue id;

  String name;

  _id412n1c.ChildWithInheritedId? parent;

  _is.UuidValue? parentId;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  ChildWithInheritedId copyWith({
    _is.UuidValue? id,
    String? name,
    _id412n1c.ChildWithInheritedId? parent,
    _is.UuidValue? parentId,
    Object? createdAt,
    Object? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildWithInheritedId',
      'id': id.toJson(),
      'name': name,
      if (parent != null) 'parent': parent?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ChildWithInheritedIdInclude include({
    _id412n1c.ChildWithInheritedIdInclude? parent,
  }) {
    return ChildWithInheritedIdInclude.internal_(parent: parent);
  }

  static ChildWithInheritedIdIncludeList includeList({
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    ChildWithInheritedIdInclude? include,
  }) {
    return ChildWithInheritedIdIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildWithInheritedIdImpl extends ChildWithInheritedId {
  _ChildWithInheritedIdImpl({
    _is.UuidValue? id,
    required String name,
    _id412n1c.ChildWithInheritedId? parent,
    _is.UuidValue? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         parent: parent,
         parentId: parentId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ChildWithInheritedId]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChildWithInheritedId copyWith({
    _is.UuidValue? id,
    String? name,
    Object? parent = _Undefined,
    Object? parentId = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return ChildWithInheritedId(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent is _id412n1c.ChildWithInheritedId?
          ? parent
          : this.parent?.copyWith(),
      parentId: parentId is _is.UuidValue? ? parentId : this.parentId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class ChildWithInheritedIdUpdateTable
    extends _is.UpdateTable<ChildWithInheritedIdTable> {
  ChildWithInheritedIdUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> parentId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.parentId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ChildWithInheritedIdTable extends _is.Table<_is.UuidValue> {
  ChildWithInheritedIdTable({super.tableRelation})
    : super(tableName: 'child_with_inherited_id') {
    updateTable = ChildWithInheritedIdUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    parentId = _is.ColumnUuid(
      'parentId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ChildWithInheritedIdUpdateTable updateTable;

  late final _is.ColumnString name;

  _id412n1c.ChildWithInheritedIdTable? _parent;

  late final _is.ColumnUuid parentId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _id412n1c.ChildWithInheritedIdTable get parent {
    if (_parent != null) return _parent!;
    _parent = _is.createRelationTable(
      relationFieldName: 'parent',
      field: ChildWithInheritedId.t.parentId,
      foreignField: _id412n1c.ChildWithInheritedId.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _id412n1c.ChildWithInheritedIdTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _parent!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    parentId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'parent') {
      return parent;
    }
    return null;
  }
}

class ChildWithInheritedIdInclude extends _is.IncludeObject {
  ChildWithInheritedIdInclude.internal_({
    _id412n1c.ChildWithInheritedIdInclude? parent,
    this.selectedColumns,
  }) {
    _parent = parent;
  }

  _id412n1c.ChildWithInheritedIdInclude? _parent;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'parent': _parent};

  @override
  _is.Table<_is.UuidValue> get table => ChildWithInheritedId.t;
}

class ChildWithInheritedIdIncludeList extends _is.IncludeList {
  ChildWithInheritedIdIncludeList.internal_({
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ChildWithInheritedId.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => ChildWithInheritedId.t;
}

class ChildWithInheritedIdRepository {
  const ChildWithInheritedIdRepository._();

  final attachRow = const ChildWithInheritedIdAttachRowRepository._();

  final detachRow = const ChildWithInheritedIdDetachRowRepository._();

  /// Returns a list of [ChildWithInheritedId]s matching the given query parameters.
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
  Future<List<ChildWithInheritedId>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _is.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChildWithInheritedId] matching the given query parameters.
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
  Future<ChildWithInheritedId?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _is.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChildWithInheritedId] by its [id] or null if no such row exists.
  Future<ChildWithInheritedId?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    ChildWithInheritedIdInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChildWithInheritedId>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChildWithInheritedId]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildWithInheritedId]s will have their `id` fields set.
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
  Future<List<ChildWithInheritedId>> insert(
    _is.DatabaseSession session,
    List<ChildWithInheritedId> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChildWithInheritedId>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChildWithInheritedId] and returns the inserted row.
  ///
  /// The returned [ChildWithInheritedId] will have its `id` field set.
  Future<ChildWithInheritedId> insertRow(
    _is.DatabaseSession session,
    ChildWithInheritedId row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildWithInheritedId>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChildWithInheritedId]s in the list and returns the resulting rows.
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
  /// The returned [ChildWithInheritedId]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildWithInheritedId>> upsert(
    _is.DatabaseSession session,
    List<ChildWithInheritedId> rows, {
    required _is.ColumnSelections<ChildWithInheritedIdTable> conflictColumns,
    _is.ColumnSelections<ChildWithInheritedIdTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChildWithInheritedId>(
      rows,
      conflictColumns: conflictColumns(ChildWithInheritedId.t),
      updateColumns: updateColumns?.call(ChildWithInheritedId.t),
      updateWhere: updateWhere?.call(ChildWithInheritedId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChildWithInheritedId] and returns the resulting row.
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
  /// The returned [ChildWithInheritedId] will have its `id` field set.
  Future<ChildWithInheritedId?> upsertRow(
    _is.DatabaseSession session,
    ChildWithInheritedId row, {
    required _is.ColumnSelections<ChildWithInheritedIdTable> conflictColumns,
    _is.ColumnSelections<ChildWithInheritedIdTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChildWithInheritedId>(
      row,
      conflictColumns: conflictColumns(ChildWithInheritedId.t),
      updateColumns: updateColumns?.call(ChildWithInheritedId.t),
      updateWhere: updateWhere?.call(ChildWithInheritedId.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChildWithInheritedId]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildWithInheritedId>> update(
    _is.DatabaseSession session,
    List<ChildWithInheritedId> rows, {
    _is.ColumnSelections<ChildWithInheritedIdTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChildWithInheritedId>(
      rows,
      columns: columns?.call(ChildWithInheritedId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChildWithInheritedId]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildWithInheritedId> updateRow(
    _is.DatabaseSession session,
    ChildWithInheritedId row, {
    _is.ColumnSelections<ChildWithInheritedIdTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildWithInheritedId>(
      row,
      columns: columns?.call(ChildWithInheritedId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildWithInheritedId] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildWithInheritedId?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ChildWithInheritedIdUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildWithInheritedId>(
      id,
      columnValues: columnValues(ChildWithInheritedId.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildWithInheritedId]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildWithInheritedId>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChildWithInheritedIdUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ChildWithInheritedIdTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChildWithInheritedId>(
      columnValues: columnValues(ChildWithInheritedId.t.updateTable),
      where: where(ChildWithInheritedId.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChildWithInheritedId]s in the list and returns the deleted rows.
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
  Future<List<ChildWithInheritedId>> delete(
    _is.DatabaseSession session,
    List<ChildWithInheritedId> rows, {
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChildWithInheritedId>(
      rows,
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChildWithInheritedId].
  Future<ChildWithInheritedId> deleteRow(
    _is.DatabaseSession session,
    ChildWithInheritedId row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildWithInheritedId>(
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
  Future<List<ChildWithInheritedId>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildWithInheritedIdTable> where,
    _is.OrderByBuilder<ChildWithInheritedIdTable>? orderBy,
    _is.OrderByListBuilder<ChildWithInheritedIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChildWithInheritedId>(
      where: where(ChildWithInheritedId.t),
      orderBy: orderBy?.call(ChildWithInheritedId.t),
      orderByList: orderByList?.call(ChildWithInheritedId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildWithInheritedIdTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChildWithInheritedId>(
      where: where?.call(ChildWithInheritedId.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChildWithInheritedId] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildWithInheritedIdTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChildWithInheritedId>(
      where: where(ChildWithInheritedId.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ChildWithInheritedIdAttachRowRepository {
  const ChildWithInheritedIdAttachRowRepository._();

  /// Creates a relation between the given [ChildWithInheritedId] and [ChildWithInheritedId]
  /// by setting the [ChildWithInheritedId]'s foreign key `parentId` to refer to the [ChildWithInheritedId].
  Future<void> parent(
    _is.DatabaseSession session,
    ChildWithInheritedId childWithInheritedId,
    _id412n1c.ChildWithInheritedId parent, {
    _is.Transaction? transaction,
  }) async {
    if (childWithInheritedId.id == null) {
      throw ArgumentError.notNull('childWithInheritedId.id');
    }
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }

    var $childWithInheritedId = childWithInheritedId.copyWith(
      parentId: parent.id,
    );
    await session.db.updateRow<ChildWithInheritedId>(
      $childWithInheritedId,
      columns: [ChildWithInheritedId.t.parentId],
      transaction: transaction,
    );
  }
}

class ChildWithInheritedIdDetachRowRepository {
  const ChildWithInheritedIdDetachRowRepository._();

  /// Detaches the relation between this [ChildWithInheritedId] and the [ChildWithInheritedId] set in `parent`
  /// by setting the [ChildWithInheritedId]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> parent(
    _is.DatabaseSession session,
    ChildWithInheritedId childWithInheritedId, {
    _is.Transaction? transaction,
  }) async {
    if (childWithInheritedId.id == null) {
      throw ArgumentError.notNull('childWithInheritedId.id');
    }

    var $childWithInheritedId = childWithInheritedId.copyWith(parentId: null);
    await session.db.updateRow<ChildWithInheritedId>(
      $childWithInheritedId,
      columns: [ChildWithInheritedId.t.parentId],
      transaction: transaction,
    );
  }
}
