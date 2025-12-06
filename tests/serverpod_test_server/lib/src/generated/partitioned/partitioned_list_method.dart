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

/// Model with partitionBy using explicit LIST method.
abstract class PartitionedListMethod
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PartitionedListMethod._({
    this.id,
    required this.category,
    required this.name,
    required this.value,
  });

  factory PartitionedListMethod({
    int? id,
    required String category,
    required String name,
    required int value,
  }) = _PartitionedListMethodImpl;

  factory PartitionedListMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedListMethod(
      id: jsonSerialization['id'] as int?,
      category: jsonSerialization['category'] as String,
      name: jsonSerialization['name'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  static final t = PartitionedListMethodTable();

  static const db = PartitionedListMethodRepository._();

  @override
  int? id;

  String category;

  String name;

  int value;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PartitionedListMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedListMethod copyWith({
    int? id,
    String? category,
    String? name,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedListMethod',
      if (id != null) 'id': id,
      'category': category,
      'name': name,
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PartitionedListMethod',
      if (id != null) 'id': id,
      'category': category,
      'name': name,
      'value': value,
    };
  }

  static PartitionedListMethodInclude include() {
    return PartitionedListMethodInclude._();
  }

  static PartitionedListMethodIncludeList includeList({
    _i1.WhereExpressionBuilder<PartitionedListMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedListMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedListMethodTable>? orderByList,
    PartitionedListMethodInclude? include,
  }) {
    return PartitionedListMethodIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedListMethod.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PartitionedListMethod.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedListMethodImpl extends PartitionedListMethod {
  _PartitionedListMethodImpl({
    int? id,
    required String category,
    required String name,
    required int value,
  }) : super._(
         id: id,
         category: category,
         name: name,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedListMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedListMethod copyWith({
    Object? id = _Undefined,
    String? category,
    String? name,
    int? value,
  }) {
    return PartitionedListMethod(
      id: id is int? ? id : this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}

class PartitionedListMethodUpdateTable
    extends _i1.UpdateTable<PartitionedListMethodTable> {
  PartitionedListMethodUpdateTable(super.table);

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> value(int value) => _i1.ColumnValue(
    table.value,
    value,
  );
}

class PartitionedListMethodTable extends _i1.Table<int?> {
  PartitionedListMethodTable({super.tableRelation})
    : super(tableName: 'partitioned_list_method') {
    updateTable = PartitionedListMethodUpdateTable(this);
    category = _i1.ColumnString(
      'category',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    value = _i1.ColumnInt(
      'value',
      this,
    );
  }

  late final PartitionedListMethodUpdateTable updateTable;

  late final _i1.ColumnString category;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt value;

  @override
  List<_i1.Column> get columns => [
    id,
    category,
    name,
    value,
  ];
}

class PartitionedListMethodInclude extends _i1.IncludeObject {
  PartitionedListMethodInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PartitionedListMethod.t;
}

class PartitionedListMethodIncludeList extends _i1.IncludeList {
  PartitionedListMethodIncludeList._({
    _i1.WhereExpressionBuilder<PartitionedListMethodTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PartitionedListMethod.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PartitionedListMethod.t;
}

class PartitionedListMethodRepository {
  const PartitionedListMethodRepository._();

  /// Returns a list of [PartitionedListMethod]s matching the given query parameters.
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
  Future<List<PartitionedListMethod>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedListMethodTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedListMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedListMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PartitionedListMethod>(
      where: where?.call(PartitionedListMethod.t),
      orderBy: orderBy?.call(PartitionedListMethod.t),
      orderByList: orderByList?.call(PartitionedListMethod.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PartitionedListMethod] matching the given query parameters.
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
  Future<PartitionedListMethod?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedListMethodTable>? where,
    int? offset,
    _i1.OrderByBuilder<PartitionedListMethodTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PartitionedListMethodTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PartitionedListMethod>(
      where: where?.call(PartitionedListMethod.t),
      orderBy: orderBy?.call(PartitionedListMethod.t),
      orderByList: orderByList?.call(PartitionedListMethod.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PartitionedListMethod] by its [id] or null if no such row exists.
  Future<PartitionedListMethod?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PartitionedListMethod>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PartitionedListMethod]s in the list and returns the inserted rows.
  ///
  /// The returned [PartitionedListMethod]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PartitionedListMethod>> insert(
    _i1.Session session,
    List<PartitionedListMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PartitionedListMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PartitionedListMethod] and returns the inserted row.
  ///
  /// The returned [PartitionedListMethod] will have its `id` field set.
  Future<PartitionedListMethod> insertRow(
    _i1.Session session,
    PartitionedListMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PartitionedListMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedListMethod]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PartitionedListMethod>> update(
    _i1.Session session,
    List<PartitionedListMethod> rows, {
    _i1.ColumnSelections<PartitionedListMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PartitionedListMethod>(
      rows,
      columns: columns?.call(PartitionedListMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedListMethod]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PartitionedListMethod> updateRow(
    _i1.Session session,
    PartitionedListMethod row, {
    _i1.ColumnSelections<PartitionedListMethodTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PartitionedListMethod>(
      row,
      columns: columns?.call(PartitionedListMethod.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PartitionedListMethod] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PartitionedListMethod?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PartitionedListMethodUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PartitionedListMethod>(
      id,
      columnValues: columnValues(PartitionedListMethod.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PartitionedListMethod]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PartitionedListMethod>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PartitionedListMethodUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PartitionedListMethodTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PartitionedListMethodTable>? orderBy,
    _i1.OrderByListBuilder<PartitionedListMethodTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PartitionedListMethod>(
      columnValues: columnValues(PartitionedListMethod.t.updateTable),
      where: where(PartitionedListMethod.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PartitionedListMethod.t),
      orderByList: orderByList?.call(PartitionedListMethod.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PartitionedListMethod]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PartitionedListMethod>> delete(
    _i1.Session session,
    List<PartitionedListMethod> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PartitionedListMethod>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PartitionedListMethod].
  Future<PartitionedListMethod> deleteRow(
    _i1.Session session,
    PartitionedListMethod row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PartitionedListMethod>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PartitionedListMethod>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PartitionedListMethodTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PartitionedListMethod>(
      where: where(PartitionedListMethod.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PartitionedListMethodTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PartitionedListMethod>(
      where: where?.call(PartitionedListMethod.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
