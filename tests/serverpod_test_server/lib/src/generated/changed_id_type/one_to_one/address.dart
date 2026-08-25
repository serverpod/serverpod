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
import '../../changed_id_type/one_to_one/citizen.dart' as _i7hzilwf;

abstract class AddressUuid
    implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  AddressUuid._({
    _is.UuidValue? id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  }) : id = id ?? const _is.Uuid().v4obj();

  factory AddressUuid({
    _is.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  }) = _AddressUuidImpl;

  factory AddressUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddressUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i7hzilwf.CitizenInt>(
              jsonSerialization['inhabitant'],
            ),
    );
  }

  static final t = AddressUuidTable();

  static const db = AddressUuidRepository._();

  @override
  _is.UuidValue id;

  String street;

  int? inhabitantId;

  _i7hzilwf.CitizenInt? inhabitant;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AddressUuid copyWith({
    _is.UuidValue? id,
    String? street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AddressUuid',
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AddressUuid',
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJsonForProtocol(),
    };
  }

  static AddressUuidInclude include({
    _i7hzilwf.CitizenIntInclude? inhabitant,
    _is.SelectColumnsBuilder<AddressUuidTable>? select,
  }) {
    return AddressUuidInclude._(
      inhabitant: inhabitant,
      selectedColumns: select?.call(AddressUuid.t),
    );
  }

  static AddressUuidIncludeList includeList({
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    AddressUuidInclude? include,
    _is.SelectColumnsBuilder<AddressUuidTable>? select,
  }) {
    return AddressUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      include: include,
      selectedColumns: select?.call(AddressUuid.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressUuidImpl extends AddressUuid {
  _AddressUuidImpl({
    _is.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  }) : super._(
         id: id,
         street: street,
         inhabitantId: inhabitantId,
         inhabitant: inhabitant,
       );

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AddressUuid copyWith({
    _is.UuidValue? id,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return AddressUuid(
      id: id ?? this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant: inhabitant is _i7hzilwf.CitizenInt?
          ? inhabitant
          : this.inhabitant?.copyWith(),
    );
  }
}

class AddressUuidUpdateTable extends _is.UpdateTable<AddressUuidTable> {
  AddressUuidUpdateTable(super.table);

  _is.ColumnValue<String, String> street(String value) => _is.ColumnValue(
    table.street,
    value,
  );

  _is.ColumnValue<int, int> inhabitantId(int? value) => _is.ColumnValue(
    table.inhabitantId,
    value,
  );
}

class AddressUuidTable extends _is.Table<_is.UuidValue> {
  AddressUuidTable({super.tableRelation}) : super(tableName: 'address_uuid') {
    updateTable = AddressUuidUpdateTable(this);
    street = _is.ColumnString(
      'street',
      this,
    );
    inhabitantId = _is.ColumnInt(
      'inhabitantId',
      this,
    );
  }

  late final AddressUuidUpdateTable updateTable;

  late final _is.ColumnString street;

  late final _is.ColumnInt inhabitantId;

  _i7hzilwf.CitizenIntTable? _inhabitant;

  _i7hzilwf.CitizenIntTable get inhabitant {
    if (_inhabitant != null) return _inhabitant!;
    _inhabitant = _is.createRelationTable(
      relationFieldName: 'inhabitant',
      field: AddressUuid.t.inhabitantId,
      foreignField: _i7hzilwf.CitizenInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7hzilwf.CitizenIntTable(tableRelation: foreignTableRelation),
    );
    return _inhabitant!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    street,
    inhabitantId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'inhabitant') {
      return inhabitant;
    }
    return null;
  }
}

class AddressUuidInclude extends _is.IncludeObject {
  AddressUuidInclude._({
    _i7hzilwf.CitizenIntInclude? inhabitant,
    this.selectedColumns,
  }) {
    _inhabitant = inhabitant;
  }

  _i7hzilwf.CitizenIntInclude? _inhabitant;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'inhabitant': _inhabitant};

  @override
  _is.Table<_is.UuidValue> get table => AddressUuid.t;
}

class AddressUuidIncludeList extends _is.IncludeList {
  AddressUuidIncludeList._({
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(AddressUuid.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => AddressUuid.t;
}

class AddressUuidRepository {
  const AddressUuidRepository._();

  final attachRow = const AddressUuidAttachRowRepository._();

  final detachRow = const AddressUuidDetachRowRepository._();

  /// Returns a list of [AddressUuid]s matching the given query parameters.
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
  Future<List<AddressUuid>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    AddressUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AddressUuid] matching the given query parameters.
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
  Future<AddressUuid?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    AddressUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AddressUuid] by its [id] or null if no such row exists.
  Future<AddressUuid?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AddressUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AddressUuid>(
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
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    AddressUuidInclude? include,
    _is.SelectColumnsBuilder<AddressUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(AddressUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    AddressUuidInclude? include,
    _is.SelectColumnsBuilder<AddressUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(AddressUuid.t),
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
    AddressUuidInclude? include,
    _is.SelectColumnsBuilder<AddressUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<AddressUuid>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(AddressUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AddressUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [AddressUuid]s will have their `id` fields set.
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
  Future<List<AddressUuid>> insert(
    _is.DatabaseSession session,
    List<AddressUuid> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AddressUuid>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AddressUuid] and returns the inserted row.
  ///
  /// The returned [AddressUuid] will have its `id` field set.
  Future<AddressUuid> insertRow(
    _is.DatabaseSession session,
    AddressUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AddressUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AddressUuid]s in the list and returns the resulting rows.
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
  /// The returned [AddressUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AddressUuid>> upsert(
    _is.DatabaseSession session,
    List<AddressUuid> rows, {
    required _is.ColumnSelections<AddressUuidTable> conflictColumns,
    _is.ColumnSelections<AddressUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<AddressUuidTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AddressUuid>(
      rows,
      conflictColumns: conflictColumns(AddressUuid.t),
      updateColumns: updateColumns?.call(AddressUuid.t),
      updateWhere: updateWhere?.call(AddressUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AddressUuid] and returns the resulting row.
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
  /// The returned [AddressUuid] will have its `id` field set.
  Future<AddressUuid?> upsertRow(
    _is.DatabaseSession session,
    AddressUuid row, {
    required _is.ColumnSelections<AddressUuidTable> conflictColumns,
    _is.ColumnSelections<AddressUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<AddressUuidTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AddressUuid>(
      row,
      conflictColumns: conflictColumns(AddressUuid.t),
      updateColumns: updateColumns?.call(AddressUuid.t),
      updateWhere: updateWhere?.call(AddressUuid.t),
      transaction: transaction,
    );
  }

  /// Updates all [AddressUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AddressUuid>> update(
    _is.DatabaseSession session,
    List<AddressUuid> rows, {
    _is.ColumnSelections<AddressUuidTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AddressUuid>(
      rows,
      columns: columns?.call(AddressUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AddressUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AddressUuid> updateRow(
    _is.DatabaseSession session,
    AddressUuid row, {
    _is.ColumnSelections<AddressUuidTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AddressUuid>(
      row,
      columns: columns?.call(AddressUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AddressUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AddressUuid?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AddressUuidUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AddressUuid>(
      id,
      columnValues: columnValues(AddressUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AddressUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AddressUuid>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AddressUuidUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AddressUuidTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AddressUuid>(
      columnValues: columnValues(AddressUuid.t.updateTable),
      where: where(AddressUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AddressUuid]s in the list and returns the deleted rows.
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
  Future<List<AddressUuid>> delete(
    _is.DatabaseSession session,
    List<AddressUuid> rows, {
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AddressUuid>(
      rows,
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AddressUuid].
  Future<AddressUuid> deleteRow(
    _is.DatabaseSession session,
    AddressUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AddressUuid>(
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
  Future<List<AddressUuid>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AddressUuidTable> where,
    _is.OrderByBuilder<AddressUuidTable>? orderBy,
    _is.OrderByListBuilder<AddressUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AddressUuid>(
      where: where(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AddressUuid>(
      where: where?.call(AddressUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AddressUuid] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AddressUuidTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AddressUuid>(
      where: where(AddressUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AddressUuidAttachRowRepository {
  const AddressUuidAttachRowRepository._();

  /// Creates a relation between the given [AddressUuid] and [CitizenInt]
  /// by setting the [AddressUuid]'s foreign key `inhabitantId` to refer to the [CitizenInt].
  Future<void> inhabitant(
    _is.DatabaseSession session,
    AddressUuid addressUuid,
    _i7hzilwf.CitizenInt inhabitant, {
    _is.Transaction? transaction,
  }) async {
    if (addressUuid.id == null) {
      throw ArgumentError.notNull('addressUuid.id');
    }
    if (inhabitant.id == null) {
      throw ArgumentError.notNull('inhabitant.id');
    }

    var $addressUuid = addressUuid.copyWith(inhabitantId: inhabitant.id);
    await session.db.updateRow<AddressUuid>(
      $addressUuid,
      columns: [AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }
}

class AddressUuidDetachRowRepository {
  const AddressUuidDetachRowRepository._();

  /// Detaches the relation between this [AddressUuid] and the [CitizenInt] set in `inhabitant`
  /// by setting the [AddressUuid]'s foreign key `inhabitantId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> inhabitant(
    _is.DatabaseSession session,
    AddressUuid addressUuid, {
    _is.Transaction? transaction,
  }) async {
    if (addressUuid.id == null) {
      throw ArgumentError.notNull('addressUuid.id');
    }

    var $addressUuid = addressUuid.copyWith(inhabitantId: null);
    await session.db.updateRow<AddressUuid>(
      $addressUuid,
      columns: [AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }
}
