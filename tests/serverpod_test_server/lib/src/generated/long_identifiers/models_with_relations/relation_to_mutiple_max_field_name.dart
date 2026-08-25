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
import '../../long_identifiers/multiple_max_field_name.dart' as _ipoh7twa;

abstract class RelationToMultipleMaxFieldName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RelationToMultipleMaxFieldName._({
    this.id,
    required this.name,
    this.multipleMaxFieldNames,
  });

  factory RelationToMultipleMaxFieldName({
    int? id,
    required String name,
    List<_ipoh7twa.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) = _RelationToMultipleMaxFieldNameImpl;

  factory RelationToMultipleMaxFieldName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RelationToMultipleMaxFieldName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      multipleMaxFieldNames: jsonSerialization['multipleMaxFieldNames'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_ipoh7twa.MultipleMaxFieldName>>(
                  jsonSerialization['multipleMaxFieldNames'],
                ),
    );
  }

  static final t = RelationToMultipleMaxFieldNameTable();

  static const db = RelationToMultipleMaxFieldNameRepository._();

  @override
  int? id;

  String name;

  List<_ipoh7twa.MultipleMaxFieldName>? multipleMaxFieldNames;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RelationToMultipleMaxFieldName copyWith({
    int? id,
    String? name,
    List<_ipoh7twa.MultipleMaxFieldName>? multipleMaxFieldNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RelationToMultipleMaxFieldName',
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames': multipleMaxFieldNames?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RelationToMultipleMaxFieldName',
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames': multipleMaxFieldNames?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static RelationToMultipleMaxFieldNameInclude include({
    _ipoh7twa.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames,
    _is.SelectColumnsBuilder<RelationToMultipleMaxFieldNameTable>? select,
  }) {
    return RelationToMultipleMaxFieldNameInclude._(
      multipleMaxFieldNames: multipleMaxFieldNames,
      selectedColumns: select?.call(RelationToMultipleMaxFieldName.t),
    );
  }

  static RelationToMultipleMaxFieldNameIncludeList includeList({
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.SelectColumnsBuilder<RelationToMultipleMaxFieldNameTable>? select,
  }) {
    return RelationToMultipleMaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      include: include,
      selectedColumns: select?.call(RelationToMultipleMaxFieldName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationToMultipleMaxFieldNameImpl
    extends RelationToMultipleMaxFieldName {
  _RelationToMultipleMaxFieldNameImpl({
    int? id,
    required String name,
    List<_ipoh7twa.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) : super._(
         id: id,
         name: name,
         multipleMaxFieldNames: multipleMaxFieldNames,
       );

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RelationToMultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? multipleMaxFieldNames = _Undefined,
  }) {
    return RelationToMultipleMaxFieldName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      multipleMaxFieldNames:
          multipleMaxFieldNames is List<_ipoh7twa.MultipleMaxFieldName>?
          ? multipleMaxFieldNames
          : this.multipleMaxFieldNames?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class RelationToMultipleMaxFieldNameUpdateTable
    extends _is.UpdateTable<RelationToMultipleMaxFieldNameTable> {
  RelationToMultipleMaxFieldNameUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class RelationToMultipleMaxFieldNameTable extends _is.Table<int?> {
  RelationToMultipleMaxFieldNameTable({super.tableRelation})
    : super(tableName: 'relation_to_multiple_max_field_name') {
    updateTable = RelationToMultipleMaxFieldNameUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final RelationToMultipleMaxFieldNameUpdateTable updateTable;

  late final _is.ColumnString name;

  _ipoh7twa.MultipleMaxFieldNameTable? ___multipleMaxFieldNames;

  _is.ManyRelation<_ipoh7twa.MultipleMaxFieldNameTable>? _multipleMaxFieldNames;

  _ipoh7twa.MultipleMaxFieldNameTable get __multipleMaxFieldNames {
    if (___multipleMaxFieldNames != null) return ___multipleMaxFieldNames!;
    ___multipleMaxFieldNames = _is.createRelationTable(
      relationFieldName: '__multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _ipoh7twa
          .MultipleMaxFieldName
          .t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ipoh7twa.MultipleMaxFieldNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___multipleMaxFieldNames!;
  }

  _is.ManyRelation<_ipoh7twa.MultipleMaxFieldNameTable>
  get multipleMaxFieldNames {
    if (_multipleMaxFieldNames != null) return _multipleMaxFieldNames!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _ipoh7twa
          .MultipleMaxFieldName
          .t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ipoh7twa.MultipleMaxFieldNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _multipleMaxFieldNames =
        _is.ManyRelation<_ipoh7twa.MultipleMaxFieldNameTable>(
          tableWithRelations: relationTable,
          table: _ipoh7twa.MultipleMaxFieldNameTable(
            tableRelation: relationTable.tableRelation!.lastRelation,
          ),
        );
    return _multipleMaxFieldNames!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'multipleMaxFieldNames') {
      return __multipleMaxFieldNames;
    }
    return null;
  }
}

class RelationToMultipleMaxFieldNameInclude extends _is.IncludeObject {
  RelationToMultipleMaxFieldNameInclude._({
    _ipoh7twa.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames,
    this.selectedColumns,
  }) {
    _multipleMaxFieldNames = multipleMaxFieldNames;
  }

  _ipoh7twa.MultipleMaxFieldNameIncludeList? _multipleMaxFieldNames;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'multipleMaxFieldNames': _multipleMaxFieldNames,
  };

  @override
  _is.Table<int?> get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameIncludeList extends _is.IncludeList {
  RelationToMultipleMaxFieldNameIncludeList._({
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RelationToMultipleMaxFieldName.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameRepository {
  const RelationToMultipleMaxFieldNameRepository._();

  final attach = const RelationToMultipleMaxFieldNameAttachRepository._();

  final attachRow = const RelationToMultipleMaxFieldNameAttachRowRepository._();

  final detach = const RelationToMultipleMaxFieldNameDetachRepository._();

  final detachRow = const RelationToMultipleMaxFieldNameDetachRowRepository._();

  /// Returns a list of [RelationToMultipleMaxFieldName]s matching the given query parameters.
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
  Future<List<RelationToMultipleMaxFieldName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RelationToMultipleMaxFieldName] matching the given query parameters.
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
  Future<RelationToMultipleMaxFieldName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RelationToMultipleMaxFieldName] by its [id] or null if no such row exists.
  Future<RelationToMultipleMaxFieldName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RelationToMultipleMaxFieldName>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.SelectColumnsBuilder<RelationToMultipleMaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(RelationToMultipleMaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.SelectColumnsBuilder<RelationToMultipleMaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(RelationToMultipleMaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
    _is.SelectColumnsBuilder<RelationToMultipleMaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<RelationToMultipleMaxFieldName>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(RelationToMultipleMaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RelationToMultipleMaxFieldName]s in the list and returns the inserted rows.
  ///
  /// The returned [RelationToMultipleMaxFieldName]s will have their `id` fields set.
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
  Future<List<RelationToMultipleMaxFieldName>> insert(
    _is.DatabaseSession session,
    List<RelationToMultipleMaxFieldName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RelationToMultipleMaxFieldName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RelationToMultipleMaxFieldName] and returns the inserted row.
  ///
  /// The returned [RelationToMultipleMaxFieldName] will have its `id` field set.
  Future<RelationToMultipleMaxFieldName> insertRow(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelationToMultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RelationToMultipleMaxFieldName]s in the list and returns the resulting rows.
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
  /// The returned [RelationToMultipleMaxFieldName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationToMultipleMaxFieldName>> upsert(
    _is.DatabaseSession session,
    List<RelationToMultipleMaxFieldName> rows, {
    required _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>
    conflictColumns,
    _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RelationToMultipleMaxFieldName>(
      rows,
      conflictColumns: conflictColumns(RelationToMultipleMaxFieldName.t),
      updateColumns: updateColumns?.call(RelationToMultipleMaxFieldName.t),
      updateWhere: updateWhere?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RelationToMultipleMaxFieldName] and returns the resulting row.
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
  /// The returned [RelationToMultipleMaxFieldName] will have its `id` field set.
  Future<RelationToMultipleMaxFieldName?> upsertRow(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName row, {
    required _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>
    conflictColumns,
    _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RelationToMultipleMaxFieldName>(
      row,
      conflictColumns: conflictColumns(RelationToMultipleMaxFieldName.t),
      updateColumns: updateColumns?.call(RelationToMultipleMaxFieldName.t),
      updateWhere: updateWhere?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates all [RelationToMultipleMaxFieldName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationToMultipleMaxFieldName>> update(
    _is.DatabaseSession session,
    List<RelationToMultipleMaxFieldName> rows, {
    _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RelationToMultipleMaxFieldName>(
      rows,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RelationToMultipleMaxFieldName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RelationToMultipleMaxFieldName> updateRow(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName row, {
    _is.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelationToMultipleMaxFieldName>(
      row,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RelationToMultipleMaxFieldName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RelationToMultipleMaxFieldName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      RelationToMultipleMaxFieldNameUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RelationToMultipleMaxFieldName>(
      id,
      columnValues: columnValues(RelationToMultipleMaxFieldName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RelationToMultipleMaxFieldName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationToMultipleMaxFieldName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      RelationToMultipleMaxFieldNameUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RelationToMultipleMaxFieldName>(
      columnValues: columnValues(RelationToMultipleMaxFieldName.t.updateTable),
      where: where(RelationToMultipleMaxFieldName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RelationToMultipleMaxFieldName]s in the list and returns the deleted rows.
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
  Future<List<RelationToMultipleMaxFieldName>> delete(
    _is.DatabaseSession session,
    List<RelationToMultipleMaxFieldName> rows, {
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RelationToMultipleMaxFieldName>(
      rows,
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RelationToMultipleMaxFieldName].
  Future<RelationToMultipleMaxFieldName> deleteRow(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelationToMultipleMaxFieldName>(
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
  Future<List<RelationToMultipleMaxFieldName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>
    where,
    _is.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RelationToMultipleMaxFieldName>(
      where: where(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RelationToMultipleMaxFieldName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RelationToMultipleMaxFieldName>(
      where: where(RelationToMultipleMaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRepository {
  const RelationToMultipleMaxFieldNameAttachRepository._();

  /// Creates a relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]s
  /// by setting each [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to refer to this [RelationToMultipleMaxFieldName].
  Future<void> multipleMaxFieldNames(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    List<_ipoh7twa.MultipleMaxFieldName> multipleMaxFieldName, {
    _is.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map(
          (e) => _ipoh7twa.MultipleMaxFieldNameImplicit(
            e,
            $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                relationToMultipleMaxFieldName.id,
          ),
        )
        .toList();
    await session.db.update<_ipoh7twa.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _ipoh7twa
            .MultipleMaxFieldName
            .t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRowRepository {
  const RelationToMultipleMaxFieldNameAttachRowRepository._();

  /// Creates a relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to refer to this [RelationToMultipleMaxFieldName].
  Future<void> multipleMaxFieldNames(
    _is.DatabaseSession session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    _ipoh7twa.MultipleMaxFieldName multipleMaxFieldName, {
    _is.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _ipoh7twa.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          relationToMultipleMaxFieldName.id,
    );
    await session.db.updateRow<_ipoh7twa.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _ipoh7twa
            .MultipleMaxFieldName
            .t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRepository {
  const RelationToMultipleMaxFieldNameDetachRepository._();

  /// Detaches the relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> multipleMaxFieldNames(
    _is.DatabaseSession session,
    List<_ipoh7twa.MultipleMaxFieldName> multipleMaxFieldName, {
    _is.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map(
          (e) => _ipoh7twa.MultipleMaxFieldNameImplicit(
            e,
            $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                null,
          ),
        )
        .toList();
    await session.db.update<_ipoh7twa.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _ipoh7twa
            .MultipleMaxFieldName
            .t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRowRepository {
  const RelationToMultipleMaxFieldNameDetachRowRepository._();

  /// Detaches the relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> multipleMaxFieldNames(
    _is.DatabaseSession session,
    _ipoh7twa.MultipleMaxFieldName multipleMaxFieldName, {
    _is.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _ipoh7twa.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId: null,
    );
    await session.db.updateRow<_ipoh7twa.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _ipoh7twa
            .MultipleMaxFieldName
            .t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      ],
      transaction: transaction,
    );
  }
}
