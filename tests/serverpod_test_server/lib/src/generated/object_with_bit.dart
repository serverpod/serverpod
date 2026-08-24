/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class ObjectWithBit
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithBit._({
    this.id,
    required this.bit,
    this.bitNullable,
    required this.bitIndexedHnsw,
    required this.bitIndexedHnswWithParams,
    required this.bitIndexedIvfflat,
    required this.bitIndexedIvfflatWithParams,
  });

  factory ObjectWithBit({
    int? id,
    required _is.Bit bit,
    _is.Bit? bitNullable,
    required _is.Bit bitIndexedHnsw,
    required _is.Bit bitIndexedHnswWithParams,
    required _is.Bit bitIndexedIvfflat,
    required _is.Bit bitIndexedIvfflatWithParams,
  }) = _ObjectWithBitImpl;

  factory ObjectWithBit.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithBit(
      id: jsonSerialization['id'] as int?,
      bit: _is.BitJsonExtension.fromJson(jsonSerialization['bit']),
      bitNullable: jsonSerialization['bitNullable'] == null
          ? null
          : _is.BitJsonExtension.fromJson(jsonSerialization['bitNullable']),
      bitIndexedHnsw: _is.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedHnsw'],
      ),
      bitIndexedHnswWithParams: _is.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedHnswWithParams'],
      ),
      bitIndexedIvfflat: _is.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedIvfflat'],
      ),
      bitIndexedIvfflatWithParams: _is.BitJsonExtension.fromJson(
        jsonSerialization['bitIndexedIvfflatWithParams'],
      ),
    );
  }

  static final t = ObjectWithBitTable();

  static const db = ObjectWithBitRepository._();

  @override
  int? id;

  _is.Bit bit;

  _is.Bit? bitNullable;

  _is.Bit bitIndexedHnsw;

  _is.Bit bitIndexedHnswWithParams;

  _is.Bit bitIndexedIvfflat;

  _is.Bit bitIndexedIvfflatWithParams;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithBit copyWith({
    int? id,
    _is.Bit? bit,
    _is.Bit? bitNullable,
    _is.Bit? bitIndexedHnsw,
    _is.Bit? bitIndexedHnswWithParams,
    _is.Bit? bitIndexedIvfflat,
    _is.Bit? bitIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithBit',
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithBit',
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  static ObjectWithBitInclude include({
    _is.SelectColumnsBuilder<ObjectWithBitTable>? select,
  }) {
    return ObjectWithBitInclude.internal_(
      selectedColumns: select?.call(ObjectWithBit.t),
    );
  }

  static ObjectWithBitIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    ObjectWithBitInclude? include,
    _is.SelectColumnsBuilder<ObjectWithBitTable>? select,
  }) {
    return ObjectWithBitIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      include: include,
      selectedColumns: select?.call(ObjectWithBit.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithBitImpl extends ObjectWithBit {
  _ObjectWithBitImpl({
    int? id,
    required _is.Bit bit,
    _is.Bit? bitNullable,
    required _is.Bit bitIndexedHnsw,
    required _is.Bit bitIndexedHnswWithParams,
    required _is.Bit bitIndexedIvfflat,
    required _is.Bit bitIndexedIvfflatWithParams,
  }) : super._(
         id: id,
         bit: bit,
         bitNullable: bitNullable,
         bitIndexedHnsw: bitIndexedHnsw,
         bitIndexedHnswWithParams: bitIndexedHnswWithParams,
         bitIndexedIvfflat: bitIndexedIvfflat,
         bitIndexedIvfflatWithParams: bitIndexedIvfflatWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithBit copyWith({
    Object? id = _Undefined,
    _is.Bit? bit,
    Object? bitNullable = _Undefined,
    _is.Bit? bitIndexedHnsw,
    _is.Bit? bitIndexedHnswWithParams,
    _is.Bit? bitIndexedIvfflat,
    _is.Bit? bitIndexedIvfflatWithParams,
  }) {
    return ObjectWithBit(
      id: id is int? ? id : this.id,
      bit: bit ?? this.bit.clone(),
      bitNullable: bitNullable is _is.Bit?
          ? bitNullable
          : this.bitNullable?.clone(),
      bitIndexedHnsw: bitIndexedHnsw ?? this.bitIndexedHnsw.clone(),
      bitIndexedHnswWithParams:
          bitIndexedHnswWithParams ?? this.bitIndexedHnswWithParams.clone(),
      bitIndexedIvfflat: bitIndexedIvfflat ?? this.bitIndexedIvfflat.clone(),
      bitIndexedIvfflatWithParams:
          bitIndexedIvfflatWithParams ??
          this.bitIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithBitUpdateTable extends _is.UpdateTable<ObjectWithBitTable> {
  ObjectWithBitUpdateTable(super.table);

  _is.ColumnValue<_is.Bit, _is.Bit> bit(_is.Bit value) => _is.ColumnValue(
    table.bit,
    value,
  );

  _is.ColumnValue<_is.Bit, _is.Bit> bitNullable(_is.Bit? value) =>
      _is.ColumnValue(
        table.bitNullable,
        value,
      );

  _is.ColumnValue<_is.Bit, _is.Bit> bitIndexedHnsw(_is.Bit value) =>
      _is.ColumnValue(
        table.bitIndexedHnsw,
        value,
      );

  _is.ColumnValue<_is.Bit, _is.Bit> bitIndexedHnswWithParams(_is.Bit value) =>
      _is.ColumnValue(
        table.bitIndexedHnswWithParams,
        value,
      );

  _is.ColumnValue<_is.Bit, _is.Bit> bitIndexedIvfflat(_is.Bit value) =>
      _is.ColumnValue(
        table.bitIndexedIvfflat,
        value,
      );

  _is.ColumnValue<_is.Bit, _is.Bit> bitIndexedIvfflatWithParams(
    _is.Bit value,
  ) => _is.ColumnValue(
    table.bitIndexedIvfflatWithParams,
    value,
  );
}

class ObjectWithBitTable extends _is.Table<int?> {
  ObjectWithBitTable({super.tableRelation})
    : super(tableName: 'object_with_bit') {
    updateTable = ObjectWithBitUpdateTable(this);
    bit = _is.ColumnBit(
      'bit',
      this,
      dimension: 512,
    );
    bitNullable = _is.ColumnBit(
      'bitNullable',
      this,
      dimension: 512,
    );
    bitIndexedHnsw = _is.ColumnBit(
      'bitIndexedHnsw',
      this,
      dimension: 512,
    );
    bitIndexedHnswWithParams = _is.ColumnBit(
      'bitIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    bitIndexedIvfflat = _is.ColumnBit(
      'bitIndexedIvfflat',
      this,
      dimension: 512,
    );
    bitIndexedIvfflatWithParams = _is.ColumnBit(
      'bitIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final ObjectWithBitUpdateTable updateTable;

  late final _is.ColumnBit bit;

  late final _is.ColumnBit bitNullable;

  late final _is.ColumnBit bitIndexedHnsw;

  late final _is.ColumnBit bitIndexedHnswWithParams;

  late final _is.ColumnBit bitIndexedIvfflat;

  late final _is.ColumnBit bitIndexedIvfflatWithParams;

  @override
  List<_is.Column> get columns => [
    id,
    bit,
    bitNullable,
    bitIndexedHnsw,
    bitIndexedHnswWithParams,
    bitIndexedIvfflat,
    bitIndexedIvfflatWithParams,
  ];
}

class ObjectWithBitInclude extends _is.IncludeObject {
  ObjectWithBitInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithBit.t;
}

class ObjectWithBitIncludeList extends _is.IncludeList {
  ObjectWithBitIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithBitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithBit.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithBit.t;
}

class ObjectWithBitRepository {
  const ObjectWithBitRepository._();

  /// Returns a list of [ObjectWithBit]s matching the given query parameters.
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
  Future<List<ObjectWithBit>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithBit] matching the given query parameters.
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
  Future<ObjectWithBit?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithBit] by its [id] or null if no such row exists.
  Future<ObjectWithBit?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithBit>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithBit]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithBit]s will have their `id` fields set.
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
  Future<List<ObjectWithBit>> insert(
    _is.DatabaseSession session,
    List<ObjectWithBit> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithBit>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithBit] and returns the inserted row.
  ///
  /// The returned [ObjectWithBit] will have its `id` field set.
  Future<ObjectWithBit> insertRow(
    _is.DatabaseSession session,
    ObjectWithBit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithBit>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithBit]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithBit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithBit>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithBit> rows, {
    required _is.ColumnSelections<ObjectWithBitTable> conflictColumns,
    _is.ColumnSelections<ObjectWithBitTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithBitTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithBit>(
      rows,
      conflictColumns: conflictColumns(ObjectWithBit.t),
      updateColumns: updateColumns?.call(ObjectWithBit.t),
      updateWhere: updateWhere?.call(ObjectWithBit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithBit] and returns the resulting row.
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
  /// The returned [ObjectWithBit] will have its `id` field set.
  Future<ObjectWithBit?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithBit row, {
    required _is.ColumnSelections<ObjectWithBitTable> conflictColumns,
    _is.ColumnSelections<ObjectWithBitTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithBitTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithBit>(
      row,
      conflictColumns: conflictColumns(ObjectWithBit.t),
      updateColumns: updateColumns?.call(ObjectWithBit.t),
      updateWhere: updateWhere?.call(ObjectWithBit.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithBit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithBit>> update(
    _is.DatabaseSession session,
    List<ObjectWithBit> rows, {
    _is.ColumnSelections<ObjectWithBitTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithBit>(
      rows,
      columns: columns?.call(ObjectWithBit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithBit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithBit> updateRow(
    _is.DatabaseSession session,
    ObjectWithBit row, {
    _is.ColumnSelections<ObjectWithBitTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithBit>(
      row,
      columns: columns?.call(ObjectWithBit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithBit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithBit?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithBitUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithBit>(
      id,
      columnValues: columnValues(ObjectWithBit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithBit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithBit>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithBitUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ObjectWithBitTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithBit>(
      columnValues: columnValues(ObjectWithBit.t.updateTable),
      where: where(ObjectWithBit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithBit]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithBit>> delete(
    _is.DatabaseSession session,
    List<ObjectWithBit> rows, {
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithBit>(
      rows,
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithBit].
  Future<ObjectWithBit> deleteRow(
    _is.DatabaseSession session,
    ObjectWithBit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithBit>(
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
  Future<List<ObjectWithBit>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithBitTable> where,
    _is.OrderByBuilder<ObjectWithBitTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithBit>(
      where: where(ObjectWithBit.t),
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithBit] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithBitTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithBit>(
      where: where(ObjectWithBit.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
