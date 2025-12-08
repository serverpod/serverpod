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

/// Model with partitionBy using HASH method.
abstract class PartitionedHashMethod
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PartitionedHashMethod._({
    this.id,
    required this.userId,
    required this.data,
  });

  factory PartitionedHashMethod({
    int? id,
    required int userId,
    required String data,
  }) = _PartitionedHashMethodImpl;

  factory PartitionedHashMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedHashMethod(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      data: jsonSerialization['data'] as String,
    );
  }

  static final t = PartitionedHashMethodTable();

  static const db = PartitionedHashMethodRepository._();

  @override
  int? id;

  int userId;

  String data;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PartitionedHashMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedHashMethod copyWith({
    int? id,
    int? userId,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedHashMethod',
      if (id != null) 'id': id,
      'userId': userId,
      'data': data,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PartitionedHashMethod',
      if (id != null) 'id': id,
      'userId': userId,
      'data': data,
    };
  }

  static PartitionedHashMethodInclude include() {
    return PartitionedHashMethodInclude._();
  }

  static PartitionedHashMethodIncludeList includeList({
    _i1.WhereExpressionBuilder<PartitionedHashMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedHashMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedHashMethodTable>? orderByList,
    PartitionedHashMethodInclude? include,
  }) {
    return PartitionedHashMethodIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedHashMethod.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PartitionedHashMethod.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedHashMethodImpl extends PartitionedHashMethod {
  _PartitionedHashMethodImpl({
    int? id,
    required int userId,
    required String data,
  }) : super._(
         id: id,
         userId: userId,
         data: data,
       );

  /// Returns a shallow copy of this [PartitionedHashMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedHashMethod copyWith({
    Object? id = _Undefined,
    int? userId,
    String? data,
  }) {
    return PartitionedHashMethod(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      data: data ?? this.data,
    );
  }
}

class PartitionedHashMethodUpdateTable
    extends _i1.UpdateTable<PartitionedHashMethodTable> {
  PartitionedHashMethodUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> data(String value) => _i1.ColumnValue(
    table.data,
    value,
  );
}

class PartitionedHashMethodTable extends _i1.Table<int?> {
  PartitionedHashMethodTable({super.tableRelation})
    : super(tableName: 'partitioned_hash_method') {
    updateTable = PartitionedHashMethodUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    data = _i1.ColumnString(
      'data',
      this,
    );
  }

  late final PartitionedHashMethodUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString data;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    data,
  ];
}

class PartitionedHashMethodInclude extends _i1.IncludeObject {
  PartitionedHashMethodInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PartitionedHashMethod.t;
}

class PartitionedHashMethodIncludeList extends _i1.IncludeList {
  PartitionedHashMethodIncludeList._({
    _i1.WhereExpressionBuilder<PartitionedHashMethodTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PartitionedHashMethod.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PartitionedHashMethod.t;
}

class PartitionedHashMethodRepository {
  const PartitionedHashMethodRepository._();

  /// Returns a list of [PartitionedHashMethod]s matching the given query parameters.
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
  Future<List<PartitionedHashMethod>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedHashMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedHashMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedHashMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PartitionedHashMethod>(
      where: where?.call(PartitionedHashMethod.t),
      orderBy: orderBy?.call(PartitionedHashMethod.t),
      orderByList: orderByList?.call(PartitionedHashMethod.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PartitionedHashMethod] matching the given query parameters.
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
  Future<PartitionedHashMethod?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedHashMethodTable>? where,
    int? offset,
    _i1.OrderByBuilder<PartitionedHashMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedHashMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PartitionedHashMethod>(
      where: where?.call(PartitionedHashMethod.t),
      orderBy: orderBy?.call(PartitionedHashMethod.t),
      orderByList: orderByList?.call(PartitionedHashMethod.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PartitionedHashMethod] by its [id] or null if no such row exists.
  Future<PartitionedHashMethod?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PartitionedHashMethod>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PartitionedHashMethod]s in the list and returns the inserted rows.
  ///
  /// The returned [PartitionedHashMethod]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PartitionedHashMethod>> insert(
    _i1.Session session,
    List<PartitionedHashMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PartitionedHashMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PartitionedHashMethod] and returns the inserted row.
  ///
  /// The returned [PartitionedHashMethod] will have its `id` field set.
  Future<PartitionedHashMethod> insertRow(
    _i1.Session session,
    PartitionedHashMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PartitionedHashMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedHashMethod]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PartitionedHashMethod>> update(
    _i1.Session session,
    List<PartitionedHashMethod> rows, {
    _i1.ColumnSelections<PartitionedHashMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PartitionedHashMethod>(
      rows,
      columns: columns?.call(PartitionedHashMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedHashMethod]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PartitionedHashMethod> updateRow(
    _i1.Session session,
    PartitionedHashMethod row, {
    _i1.ColumnSelections<PartitionedHashMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PartitionedHashMethod>(
      row,
      columns: columns?.call(PartitionedHashMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedHashMethod] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PartitionedHashMethod?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PartitionedHashMethodUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PartitionedHashMethod>(
      id,
      columnValues: columnValues(PartitionedHashMethod.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedHashMethod]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PartitionedHashMethod>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PartitionedHashMethodUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PartitionedHashMethodTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedHashMethodTable>? orderBy,
    _i1.OrderByListBuilder<PartitionedHashMethodTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PartitionedHashMethod>(
      columnValues: columnValues(PartitionedHashMethod.t.updateTable),
      where: where(PartitionedHashMethod.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedHashMethod.t),
      orderByList: orderByList?.call(PartitionedHashMethod.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PartitionedHashMethod]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PartitionedHashMethod>> delete(
    _i1.Session session,
    List<PartitionedHashMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PartitionedHashMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PartitionedHashMethod].
  Future<PartitionedHashMethod> deleteRow(
    _i1.Session session,
    PartitionedHashMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PartitionedHashMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PartitionedHashMethod>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PartitionedHashMethodTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PartitionedHashMethod>(
      where: where(PartitionedHashMethod.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedHashMethodTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PartitionedHashMethod>(
      where: where?.call(PartitionedHashMethod.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
