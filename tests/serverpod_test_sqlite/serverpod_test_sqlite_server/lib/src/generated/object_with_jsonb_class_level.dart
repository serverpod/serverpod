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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i2;

abstract class ObjectWithJsonbClassLevel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithJsonbClassLevel._({
    this.id,
    required this.implicitJsonb,
    required this.explicitJsonb,
    required this.json,
  });

  factory ObjectWithJsonbClassLevel({
    int? id,
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) = _ObjectWithJsonbClassLevelImpl;

  factory ObjectWithJsonbClassLevel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithJsonbClassLevel(
      id: jsonSerialization['id'] as int?,
      implicitJsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['implicitJsonb'],
      ),
      explicitJsonb: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['explicitJsonb'],
      ),
      json: _i2.Protocol().deserialize<List<String>>(jsonSerialization['json']),
    );
  }

  static final t = ObjectWithJsonbClassLevelTable();

  static const db = ObjectWithJsonbClassLevelRepository._();

  @override
  int? id;

  List<String> implicitJsonb;

  List<String> explicitJsonb;

  List<String> json;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonbClassLevel copyWith({
    int? id,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonbClassLevel',
      if (id != null) 'id': id,
      'implicitJsonb': implicitJsonb.toJson(),
      'explicitJsonb': explicitJsonb.toJson(),
      'json': json.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithJsonbClassLevel',
      if (id != null) 'id': id,
      'implicitJsonb': implicitJsonb.toJson(),
      'explicitJsonb': explicitJsonb.toJson(),
      'json': json.toJson(),
    };
  }

  static ObjectWithJsonbClassLevelInclude include() {
    return ObjectWithJsonbClassLevelInclude._();
  }

  static ObjectWithJsonbClassLevelIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    ObjectWithJsonbClassLevelInclude? include,
  }) {
    return ObjectWithJsonbClassLevelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbClassLevelImpl extends ObjectWithJsonbClassLevel {
  _ObjectWithJsonbClassLevelImpl({
    int? id,
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) : super._(
         id: id,
         implicitJsonb: implicitJsonb,
         explicitJsonb: explicitJsonb,
         json: json,
       );

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithJsonbClassLevel copyWith({
    Object? id = _Undefined,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  }) {
    return ObjectWithJsonbClassLevel(
      id: id is int? ? id : this.id,
      implicitJsonb:
          implicitJsonb ?? this.implicitJsonb.map((e0) => e0).toList(),
      explicitJsonb:
          explicitJsonb ?? this.explicitJsonb.map((e0) => e0).toList(),
      json: json ?? this.json.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithJsonbClassLevelUpdateTable
    extends _i1.UpdateTable<ObjectWithJsonbClassLevelTable> {
  ObjectWithJsonbClassLevelUpdateTable(super.table);

  _i1.ColumnValue<List<String>, List<String>> implicitJsonb(
    List<String> value,
  ) => _i1.ColumnValue(
    table.implicitJsonb,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> explicitJsonb(
    List<String> value,
  ) => _i1.ColumnValue(
    table.explicitJsonb,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> json(List<String> value) =>
      _i1.ColumnValue(
        table.json,
        value,
      );
}

class ObjectWithJsonbClassLevelTable extends _i1.Table<int?> {
  ObjectWithJsonbClassLevelTable({super.tableRelation})
    : super(tableName: 'object_with_jsonb_class_level') {
    updateTable = ObjectWithJsonbClassLevelUpdateTable(this);
    implicitJsonb = _i1.ColumnStructured<List<String>>(
      'implicitJsonb',
      this,
    );
    explicitJsonb = _i1.ColumnStructured<List<String>>(
      'explicitJsonb',
      this,
    );
    json = _i1.ColumnSerializable<List<String>>(
      'json',
      this,
    );
  }

  late final ObjectWithJsonbClassLevelUpdateTable updateTable;

  late final _i1.ColumnStructured<List<String>> implicitJsonb;

  late final _i1.ColumnStructured<List<String>> explicitJsonb;

  late final _i1.ColumnSerializable<List<String>> json;

  @override
  List<_i1.Column> get columns => [
    id,
    implicitJsonb,
    explicitJsonb,
    json,
  ];
}

class ObjectWithJsonbClassLevelInclude extends _i1.IncludeObject {
  ObjectWithJsonbClassLevelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

class ObjectWithJsonbClassLevelIncludeList extends _i1.IncludeList {
  ObjectWithJsonbClassLevelIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithJsonbClassLevel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

class ObjectWithJsonbClassLevelRepository {
  const ObjectWithJsonbClassLevelRepository._();

  /// Returns a list of [ObjectWithJsonbClassLevel]s matching the given query parameters.
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
  Future<List<ObjectWithJsonbClassLevel>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithJsonbClassLevel] matching the given query parameters.
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
  Future<ObjectWithJsonbClassLevel?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithJsonbClassLevel] by its [id] or null if no such row exists.
  Future<ObjectWithJsonbClassLevel?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithJsonbClassLevel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithJsonbClassLevel]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithJsonbClassLevel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ObjectWithJsonbClassLevel>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithJsonbClassLevel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithJsonbClassLevel] and returns the inserted row.
  ///
  /// The returned [ObjectWithJsonbClassLevel] will have its `id` field set.
  Future<ObjectWithJsonbClassLevel> insertRow(
    _i1.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithJsonbClassLevel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonbClassLevel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithJsonbClassLevel>> update(
    _i1.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _i1.ColumnSelections<ObjectWithJsonbClassLevelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithJsonbClassLevel>(
      rows,
      columns: columns?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonbClassLevel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithJsonbClassLevel> updateRow(
    _i1.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _i1.ColumnSelections<ObjectWithJsonbClassLevelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithJsonbClassLevel>(
      row,
      columns: columns?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonbClassLevel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithJsonbClassLevel?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbClassLevelUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithJsonbClassLevel>(
      id,
      columnValues: columnValues(ObjectWithJsonbClassLevel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonbClassLevel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithJsonbClassLevel>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbClassLevelUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithJsonbClassLevel>(
      columnValues: columnValues(ObjectWithJsonbClassLevel.t.updateTable),
      where: where(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithJsonbClassLevel]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithJsonbClassLevel>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithJsonbClassLevel>(
      rows,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithJsonbClassLevel].
  Future<ObjectWithJsonbClassLevel> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithJsonbClassLevel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ObjectWithJsonbClassLevel>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    _i1.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithJsonbClassLevel>(
      where: where(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithJsonbClassLevel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithJsonbClassLevel>(
      where: where(ObjectWithJsonbClassLevel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

abstract class ObjectWithJsonbClassLevelReactiveFutureCall
    extends _i1.ReactiveFutureCall<ObjectWithJsonbClassLevel> {
  @override
  String get tableName => 'object_with_jsonb_class_level';

  _i1.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> get where;
  @override
  _i1.Expression? get condition => where(ObjectWithJsonbClassLevel.t);
}
