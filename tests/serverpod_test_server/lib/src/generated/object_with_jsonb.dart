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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i2;
import 'package:serverpod/protocol.dart' as _i3;

abstract class ObjectWithJsonb
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithJsonb._({
    this.id,
    required this.indexed0,
    required this.indexed1,
    required this.indexed2,
    required this.indexed3,
  });

  factory ObjectWithJsonb({
    int? id,
    required List<String> indexed0,
    required List<String> indexed1,
    required List<String> indexed2,
    required List<String> indexed3,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      indexed0: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed0'],
      ),
      indexed1: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed1'],
      ),
      indexed2: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed2'],
      ),
      indexed3: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['indexed3'],
      ),
    );
  }

  static final t = ObjectWithJsonbTable();

  static const db = ObjectWithJsonbRepository._();

  @override
  int? id;

  List<String> indexed0;

  List<String> indexed1;

  List<String> indexed2;

  List<String> indexed3;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? indexed0,
    List<String>? indexed1,
    List<String>? indexed2,
    List<String>? indexed3,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'indexed0': indexed0.toJson(),
      'indexed1': indexed1.toJson(),
      'indexed2': indexed2.toJson(),
      'indexed3': indexed3.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'indexed0': indexed0.toJson(),
      'indexed1': indexed1.toJson(),
      'indexed2': indexed2.toJson(),
      'indexed3': indexed3.toJson(),
    };
  }

  static ObjectWithJsonbInclude include() {
    return ObjectWithJsonbInclude._();
  }

  static ObjectWithJsonbIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    ObjectWithJsonbInclude? include,
  }) {
    return ObjectWithJsonbIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbImpl extends ObjectWithJsonb {
  _ObjectWithJsonbImpl({
    int? id,
    required List<String> indexed0,
    required List<String> indexed1,
    required List<String> indexed2,
    required List<String> indexed3,
  }) : super._(
         id: id,
         indexed0: indexed0,
         indexed1: indexed1,
         indexed2: indexed2,
         indexed3: indexed3,
       );

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? indexed0,
    List<String>? indexed1,
    List<String>? indexed2,
    List<String>? indexed3,
  }) {
    return ObjectWithJsonb(
      id: id is int? ? id : this.id,
      indexed0: indexed0 ?? this.indexed0.map((e0) => e0).toList(),
      indexed1: indexed1 ?? this.indexed1.map((e0) => e0).toList(),
      indexed2: indexed2 ?? this.indexed2.map((e0) => e0).toList(),
      indexed3: indexed3 ?? this.indexed3.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithJsonbUpdateTable extends _i1.UpdateTable<ObjectWithJsonbTable> {
  ObjectWithJsonbUpdateTable(super.table);

  _i1.ColumnValue<List<String>, List<String>> indexed0(List<String> value) =>
      _i1.ColumnValue(
        table.indexed0,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> indexed1(List<String> value) =>
      _i1.ColumnValue(
        table.indexed1,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> indexed2(List<String> value) =>
      _i1.ColumnValue(
        table.indexed2,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> indexed3(List<String> value) =>
      _i1.ColumnValue(
        table.indexed3,
        value,
      );
}

class ObjectWithJsonbTable extends _i1.Table<int?> {
  ObjectWithJsonbTable({super.tableRelation})
    : super(tableName: 'object_with_jsonb') {
    updateTable = ObjectWithJsonbUpdateTable(this);
    indexed0 = _i1.ColumnSerializable<List<String>>(
      'indexed0',
      this,
    );
    indexed1 = _i1.ColumnSerializable<List<String>>(
      'indexed1',
      this,
      serializationDataType: _i3.SerializationDataType.jsonb,
    );
    indexed2 = _i1.ColumnSerializable<List<String>>(
      'indexed2',
      this,
      serializationDataType: _i3.SerializationDataType.jsonb,
    );
    indexed3 = _i1.ColumnSerializable<List<String>>(
      'indexed3',
      this,
      serializationDataType: _i3.SerializationDataType.jsonb,
    );
  }

  late final ObjectWithJsonbUpdateTable updateTable;

  late final _i1.ColumnSerializable<List<String>> indexed0;

  late final _i1.ColumnSerializable<List<String>> indexed1;

  late final _i1.ColumnSerializable<List<String>> indexed2;

  late final _i1.ColumnSerializable<List<String>> indexed3;

  @override
  List<_i1.Column> get columns => [
    id,
    indexed0,
    indexed1,
    indexed2,
    indexed3,
  ];
}

class ObjectWithJsonbInclude extends _i1.IncludeObject {
  ObjectWithJsonbInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonb.t;
}

class ObjectWithJsonbIncludeList extends _i1.IncludeList {
  ObjectWithJsonbIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithJsonb.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonb.t;
}

class ObjectWithJsonbRepository {
  const ObjectWithJsonbRepository._();

  /// Returns a list of [ObjectWithJsonb]s matching the given query parameters.
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
  Future<List<ObjectWithJsonb>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithJsonb] matching the given query parameters.
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
  Future<ObjectWithJsonb?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithJsonb] by its [id] or null if no such row exists.
  Future<ObjectWithJsonb?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithJsonb>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithJsonb]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithJsonb]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ObjectWithJsonb>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithJsonb>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithJsonb] and returns the inserted row.
  ///
  /// The returned [ObjectWithJsonb] will have its `id` field set.
  Future<ObjectWithJsonb> insertRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithJsonb>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithJsonb>> update(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.ColumnSelections<ObjectWithJsonbTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithJsonb>(
      rows,
      columns: columns?.call(ObjectWithJsonb.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonb]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithJsonb> updateRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.ColumnSelections<ObjectWithJsonbTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithJsonb>(
      row,
      columns: columns?.call(ObjectWithJsonb.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonb] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithJsonb?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithJsonb>(
      id,
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithJsonb>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithJsonb>(
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      where: where(ObjectWithJsonb.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithJsonb]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithJsonb>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithJsonb>(
      rows,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithJsonb].
  Future<ObjectWithJsonb> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithJsonb>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ObjectWithJsonb>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithJsonb] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
