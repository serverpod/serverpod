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

abstract class ObjectWithDecimal
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithDecimal._({
    this.id,
    required this.notNullableDecimal,
    this.nullableDecimal,
    required this.highPrecisionDecimal,
  });

  factory ObjectWithDecimal({
    int? id,
    required _i1.Decimal notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    required _i1.Decimal highPrecisionDecimal,
  }) = _ObjectWithDecimalImpl;

  factory ObjectWithDecimal.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDecimal(
      id: jsonSerialization['id'] as int?,
      notNullableDecimal: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['notNullableDecimal'],
      ),
      nullableDecimal: jsonSerialization['nullableDecimal'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['nullableDecimal'],
            ),
      highPrecisionDecimal: _i1.DecimalJsonExtension.fromJson(
        jsonSerialization['highPrecisionDecimal'],
      ),
    );
  }

  static final t = ObjectWithDecimalTable();

  static const db = ObjectWithDecimalRepository._();

  @override
  int? id;

  _i1.Decimal notNullableDecimal;

  _i1.Decimal? nullableDecimal;

  _i1.Decimal highPrecisionDecimal;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithDecimal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDecimal copyWith({
    int? id,
    _i1.Decimal? notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    _i1.Decimal? highPrecisionDecimal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDecimal',
      if (id != null) 'id': id,
      'notNullableDecimal': notNullableDecimal.toJson(),
      if (nullableDecimal != null) 'nullableDecimal': nullableDecimal?.toJson(),
      'highPrecisionDecimal': highPrecisionDecimal.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithDecimal',
      if (id != null) 'id': id,
      'notNullableDecimal': notNullableDecimal.toJson(),
      if (nullableDecimal != null) 'nullableDecimal': nullableDecimal?.toJson(),
      'highPrecisionDecimal': highPrecisionDecimal.toJson(),
    };
  }

  static ObjectWithDecimalInclude include() {
    return ObjectWithDecimalInclude._();
  }

  static ObjectWithDecimalIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithDecimalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDecimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDecimalTable>? orderByList,
    ObjectWithDecimalInclude? include,
  }) {
    return ObjectWithDecimalIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDecimal.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithDecimal.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDecimalImpl extends ObjectWithDecimal {
  _ObjectWithDecimalImpl({
    int? id,
    required _i1.Decimal notNullableDecimal,
    _i1.Decimal? nullableDecimal,
    required _i1.Decimal highPrecisionDecimal,
  }) : super._(
         id: id,
         notNullableDecimal: notNullableDecimal,
         nullableDecimal: nullableDecimal,
         highPrecisionDecimal: highPrecisionDecimal,
       );

  /// Returns a shallow copy of this [ObjectWithDecimal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDecimal copyWith({
    Object? id = _Undefined,
    _i1.Decimal? notNullableDecimal,
    Object? nullableDecimal = _Undefined,
    _i1.Decimal? highPrecisionDecimal,
  }) {
    return ObjectWithDecimal(
      id: id is int? ? id : this.id,
      notNullableDecimal: notNullableDecimal ?? this.notNullableDecimal,
      nullableDecimal: nullableDecimal is _i1.Decimal?
          ? nullableDecimal
          : this.nullableDecimal,
      highPrecisionDecimal: highPrecisionDecimal ?? this.highPrecisionDecimal,
    );
  }
}

class ObjectWithDecimalUpdateTable
    extends _i1.UpdateTable<ObjectWithDecimalTable> {
  ObjectWithDecimalUpdateTable(super.table);

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> notNullableDecimal(
    _i1.Decimal value,
  ) => _i1.ColumnValue(
    table.notNullableDecimal,
    value,
  );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> nullableDecimal(
    _i1.Decimal? value,
  ) => _i1.ColumnValue(
    table.nullableDecimal,
    value,
  );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> highPrecisionDecimal(
    _i1.Decimal value,
  ) => _i1.ColumnValue(
    table.highPrecisionDecimal,
    value,
  );
}

class ObjectWithDecimalTable extends _i1.Table<int?> {
  ObjectWithDecimalTable({super.tableRelation})
    : super(tableName: 'object_with_decimal') {
    updateTable = ObjectWithDecimalUpdateTable(this);
    notNullableDecimal = _i1.ColumnDecimal(
      'notNullableDecimal',
      this,
    );
    nullableDecimal = _i1.ColumnDecimal(
      'nullableDecimal',
      this,
    );
    highPrecisionDecimal = _i1.ColumnDecimal(
      'highPrecisionDecimal',
      this,
    );
  }

  late final ObjectWithDecimalUpdateTable updateTable;

  late final _i1.ColumnDecimal notNullableDecimal;

  late final _i1.ColumnDecimal nullableDecimal;

  late final _i1.ColumnDecimal highPrecisionDecimal;

  @override
  List<_i1.Column> get columns => [
    id,
    notNullableDecimal,
    nullableDecimal,
    highPrecisionDecimal,
  ];
}

class ObjectWithDecimalInclude extends _i1.IncludeObject {
  ObjectWithDecimalInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithDecimal.t;
}

class ObjectWithDecimalIncludeList extends _i1.IncludeList {
  ObjectWithDecimalIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithDecimalTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithDecimal.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithDecimal.t;
}

class ObjectWithDecimalRepository {
  const ObjectWithDecimalRepository._();

  /// Returns a list of [ObjectWithDecimal]s matching the given query parameters.
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
  Future<List<ObjectWithDecimal>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDecimalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDecimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDecimalTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithDecimal>(
      where: where?.call(ObjectWithDecimal.t),
      orderBy: orderBy?.call(ObjectWithDecimal.t),
      orderByList: orderByList?.call(ObjectWithDecimal.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithDecimal] matching the given query parameters.
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
  Future<ObjectWithDecimal?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDecimalTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDecimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDecimalTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithDecimal>(
      where: where?.call(ObjectWithDecimal.t),
      orderBy: orderBy?.call(ObjectWithDecimal.t),
      orderByList: orderByList?.call(ObjectWithDecimal.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithDecimal] by its [id] or null if no such row exists.
  Future<ObjectWithDecimal?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithDecimal>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithDecimal]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithDecimal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ObjectWithDecimal>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithDecimal> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithDecimal>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithDecimal] and returns the inserted row.
  ///
  /// The returned [ObjectWithDecimal] will have its `id` field set.
  Future<ObjectWithDecimal> insertRow(
    _i1.DatabaseSession session,
    ObjectWithDecimal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithDecimal>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDecimal]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithDecimal>> update(
    _i1.DatabaseSession session,
    List<ObjectWithDecimal> rows, {
    _i1.ColumnSelections<ObjectWithDecimalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithDecimal>(
      rows,
      columns: columns?.call(ObjectWithDecimal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDecimal]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithDecimal> updateRow(
    _i1.DatabaseSession session,
    ObjectWithDecimal row, {
    _i1.ColumnSelections<ObjectWithDecimalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithDecimal>(
      row,
      columns: columns?.call(ObjectWithDecimal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDecimal] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithDecimal?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithDecimalUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithDecimal>(
      id,
      columnValues: columnValues(ObjectWithDecimal.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDecimal]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithDecimal>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithDecimalUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithDecimalTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDecimalTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithDecimalTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithDecimal>(
      columnValues: columnValues(ObjectWithDecimal.t.updateTable),
      where: where(ObjectWithDecimal.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDecimal.t),
      orderByList: orderByList?.call(ObjectWithDecimal.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithDecimal]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithDecimal>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithDecimal> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithDecimal>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithDecimal].
  Future<ObjectWithDecimal> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithDecimal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithDecimal>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithDecimal>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithDecimalTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithDecimal>(
      where: where(ObjectWithDecimal.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDecimalTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithDecimal>(
      where: where?.call(ObjectWithDecimal.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithDecimal] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithDecimalTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithDecimal>(
      where: where(ObjectWithDecimal.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
