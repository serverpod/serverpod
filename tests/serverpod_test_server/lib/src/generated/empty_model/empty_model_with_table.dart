/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class EmptyModelWithTable
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EmptyModelWithTable._({this.id});

  factory EmptyModelWithTable({int? id}) = _EmptyModelWithTableImpl;

  factory EmptyModelWithTable.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmptyModelWithTable(id: jsonSerialization['id'] as int?);
  }

  static final t = EmptyModelWithTableTable();

  static const db = EmptyModelWithTableRepository._();

  @override
  int? id;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmptyModelWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmptyModelWithTable copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static EmptyModelWithTableInclude include() {
    return EmptyModelWithTableInclude._();
  }

  static EmptyModelWithTableIncludeList includeList({
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    EmptyModelWithTableInclude? include,
  }) {
    return EmptyModelWithTableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelWithTableImpl extends EmptyModelWithTable {
  _EmptyModelWithTableImpl({int? id}) : super._(id: id);

  /// Returns a shallow copy of this [EmptyModelWithTable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmptyModelWithTable copyWith({Object? id = _Undefined}) {
    return EmptyModelWithTable(id: id is int? ? id : this.id);
  }
}

class EmptyModelWithTableTable extends _i1.Table {
  EmptyModelWithTableTable({super.tableRelation})
      : super(tableName: 'empty_model_with_table') {}

  @override
  List<_i1.Column> get columns => [id];
}

class EmptyModelWithTableInclude extends _i1.IncludeObject {
  EmptyModelWithTableInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmptyModelWithTable.t;
}

class EmptyModelWithTableIncludeList extends _i1.IncludeList {
  EmptyModelWithTableIncludeList._({
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmptyModelWithTable.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmptyModelWithTable.t;
}

class EmptyModelWithTableRepository {
  const EmptyModelWithTableRepository._();

  /// Returns a list of [EmptyModelWithTable]s matching the given query parameters.
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
  Future<List<EmptyModelWithTable>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmptyModelWithTable] matching the given query parameters.
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
  Future<EmptyModelWithTable?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmptyModelWithTable] by its [id] or null if no such row exists.
  Future<EmptyModelWithTable?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmptyModelWithTable>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmptyModelWithTable]s in the list and returns the inserted rows.
  ///
  /// The returned [EmptyModelWithTable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmptyModelWithTable>> insert(
    _i1.Session session,
    List<EmptyModelWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmptyModelWithTable>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmptyModelWithTable] and returns the inserted row.
  ///
  /// The returned [EmptyModelWithTable] will have its `id` field set.
  Future<EmptyModelWithTable> insertRow(
    _i1.Session session,
    EmptyModelWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmptyModelWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelWithTable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmptyModelWithTable>> update(
    _i1.Session session,
    List<EmptyModelWithTable> rows, {
    _i1.ColumnSelections<EmptyModelWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmptyModelWithTable>(
      rows,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmptyModelWithTable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmptyModelWithTable> updateRow(
    _i1.Session session,
    EmptyModelWithTable row, {
    _i1.ColumnSelections<EmptyModelWithTableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmptyModelWithTable>(
      row,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmptyModelWithTable]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmptyModelWithTable>> delete(
    _i1.Session session,
    List<EmptyModelWithTable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmptyModelWithTable>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmptyModelWithTable].
  Future<EmptyModelWithTable> deleteRow(
    _i1.Session session,
    EmptyModelWithTable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmptyModelWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmptyModelWithTable>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmptyModelWithTableTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmptyModelWithTable>(
      where: where(EmptyModelWithTable.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
